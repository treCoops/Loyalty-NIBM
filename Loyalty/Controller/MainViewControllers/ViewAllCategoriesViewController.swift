//
//  ViewAllCategoriesViewController.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/14/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class ViewAllCategoriesViewController: UIViewController {

    @IBOutlet weak var collectionViewCategories: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let refreshControl = UIRefreshControl()
    
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    var progressHUD: ProgressHUD!
    
    //Spacing between items
    let spacing = 10;
    
    var selectedCategoryIndex = 0
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkChecker.delegate = self
        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
        setUpRefreshControl()
        getAllCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkChecker.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        firebaseOP.stopAllOperations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! SingleCategoryViewController
        destVC.category = categories[selectedCategoryIndex]
    }
}

//MARK: - Interface Actions

extension ViewAllCategoriesViewController {
    @IBAction func qrCodePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Class Methods

extension ViewAllCategoriesViewController {
    func getAllCategories(){
        if let categories = DataModelHelper.fetchCategories() {
            self.categories = categories
            collectionViewCategories.reloadData()
        }
    }
    
    func searchCategories(category: String) {
        if let categories = DataModelHelper.searchCategories(category: category) {
            self.categories = categories
            collectionViewCategories.reloadData()
        }
    }
    
    func setUpRefreshControl(){
        // Add Refresh Control to CollectionView
        if #available(iOS 10.0, *) {
            collectionViewCategories.refreshControl = refreshControl
        } else {
            collectionViewCategories.addSubview(refreshControl)
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching categories ...", attributes: .none)
        refreshControl.addTarget(self, action: #selector(refreshCategoryData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshCategoryData(_ sender: Any) {
        if !networkChecker.isReachable {
            self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        firebaseOP.getAllCategories()
    }
}

//MARK: - Searchbar Delegates

extension ViewAllCategoriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            SKToast.show(withMessage: FieldErrorCaptions.searchFieldIsEmptyErrCaption)
            return
        }
        
        self.searchCategories(category: searchBar.text!)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getAllCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - CollectionView Delegates

extension ViewAllCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIBIdentifier.FeaturedCollectionViewCell, for: indexPath) as? CategoryCollectionViewCell {
            cell.configure(imageUrl: categories[indexPath.row].coverImage)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      cell.alpha = 0
      cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      UIView.animate(withDuration: 0.50) {
        cell.alpha = 1
        cell.transform = .identity
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        performSegue(withIdentifier: Seagus.categoryToSingleCategory, sender: self)
    }
}

//MARK: - CollectionView delegate flow layout

extension ViewAllCategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 16
                
        let totalSpacing = (2 * CGFloat(self.spacing)) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
                
        if let collection = self.collectionViewCategories {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}

//MARK: - Firebase Actions delegates

extension ViewAllCategoriesViewController: FirebaseActions {
    func onCategoriesLoaded() {
        progressHUD.dismissProgressHUD()
        refreshControl.endRefreshing()
        if let categories = DataModelHelper.fetchCategories() {
            self.categories = categories
            DispatchQueue.main.async {
                self.collectionViewCategories.reloadData()
            }
        }
    }
    
    func onCategoriesLoadFailedWithError(error: Error) {
        SKToast.show(withMessage: error.localizedDescription)
    }
    
    func onCategoriesLoadFailedWithError(error: String) {
        SKToast.show(withMessage: error)
    }
}

//MARK: - Network listener delegates

extension ViewAllCategoriesViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}

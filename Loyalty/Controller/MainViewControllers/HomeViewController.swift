//
//  HomeViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast
import Kingfisher

class HomeViewController: UIViewController {
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var viewSearchParent: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var tblOffer: UITableView!
    
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    var progressHUD: ProgressHUD!
    
    var categories : [Category] = []
    var offers : [Offer] = []
    
    var isOffersLoaded = false
    var isCategoriesLoaded = false
    
    var selectedIndex: Int = 0
    
    var isTriggeredFromQR = false
    var capturedOffer: Offer?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSearchParent.roundView()
        
        registerNib()
        progressHUD = ProgressHUD(view: view)
        
        if !networkChecker.isReachable {
            displayConnectionLostAlert()
            return
        }
        
        networkChecker.delegate = self
        firebaseOP.delegate = self
        
        //Set gesture recognizers(Tap events) for both profileImage and searchVar
        setupGestureRecognizers()
        progressHUD.displayProgressHUD()
        firebaseOP.getAllCategories()
        firebaseOP.getAllOffers()
        loadUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkChecker.delegate = self
        firebaseOP.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        firebaseOP.stopAllOperations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Seagus.HomeToSingleCategory {
            let destVC = segue.destination as! SingleCategoryViewController
            destVC.category = categories[selectedIndex]
        }
        
        if segue.identifier == Seagus.HomeToViewOffer {
            let destVC = segue.destination as! OfferViewController
            if isTriggeredFromQR {
                destVC.offer = capturedOffer
            } else {
                destVC.offer = offers[selectedIndex]
            }
        }
        
        if segue.identifier == Seagus.HomeToScanQR {
            let destVC = segue.destination as! ScanQRViewController
            destVC.delegate = self
        }
    }
    @IBAction func scanQRPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: Seagus.HomeToScanQR, sender: nil)
    }
}

extension HomeViewController {
    func loadUserInfo() {
        guard let url =  SessionManager.getUserSesion()?.profileImage else {
            return
        }
        imgProfilePic.kf.setImage(with: URL(string: url))
    }
    
    func displayConnectionLostAlert(){
        self.present(self.popupAlerts.displayNetworkLostAlert(actionTitle: "Retry", actionHandler: {
            action in
            if !self.networkChecker.isReachable {
                self.displayConnectionLostAlert()
                return
            }
            self.progressHUD.displayProgressHUD()
            self.firebaseOP.getAllCategories()
            self.firebaseOP.getAllOffers()
            self.loadUserInfo()
        }), animated: true)
    }
    
    func setupGestureRecognizers(){
        //set tap gesture for the seatchBarView [UserInteraction should be enabled]
        let searchGesture = UITapGestureRecognizer(target: self, action:  #selector(self.onSearchClicked))
        let profileGesture = UITapGestureRecognizer(target: self, action:  #selector(self.onProfileClicked))
        self.viewSearchParent.addGestureRecognizer(searchGesture)
        self.imgProfilePic.addGestureRecognizer(profileGesture)
    }
    
    @objc func onSearchClicked(){
        performSegue(withIdentifier: Seagus.HomeToSearch, sender: nil)
    }
    
    @objc func onProfileClicked(){
        performSegue(withIdentifier: Seagus.HomeToProfile, sender: nil)
    }
    
    //Register the customized layout XIB with views and prepare
    func registerNib() {
        categoriesCollectionView?.register(UINib(nibName: FeaturedCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: FeaturedCollectionViewCell.reuseIdentifier)
        
        tblOffer.register(UINib(nibName: XIBIdentifier.XIB_OFFER, bundle: nil), forCellReuseIdentifier: XIBIdentifier.XIB_OFFER_CELL)
        
        if let flowLayout = self.categoriesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
}

extension HomeViewController: FirebaseActions {
    func onOffersLoaded() {
        isOffersLoaded = true
        if isOffersLoaded && isCategoriesLoaded {
            progressHUD.dismissProgressHUD()
        }
        
        if let offers = DataModelHelper.fetchOffers(fetchFeatured: true) {
            self.offers = offers
            DispatchQueue.main.async {
                self.tblOffer.reloadData()
            }
        }
    }
    
    func onOffersLoadFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
    
    func onOffersLoadFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
    func onCategoriesLoaded() {
        isCategoriesLoaded = true
        if isOffersLoaded && isCategoriesLoaded {
            progressHUD.dismissProgressHUD()
        }
        
        if let categories = DataModelHelper.fetchCategories() {
            self.categories = categories
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    
    func onCategoriesLoadFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
    
    func onCategoriesLoadFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
}

extension HomeViewController: QRResultDelegate {
    func onQRInfoProcessed(offer: Offer?) {
        if let offer = offer {
            NSLog("Launching Offer")
            isTriggeredFromQR = true
            self.capturedOffer = offer
            self.performSegue(withIdentifier: Seagus.HomeToViewOffer, sender: nil)
        } else {
            self.present(self.popupAlerts.createAlert(title: FieldErrorCaptions.scannerOfferNotValidTitle, message: FieldErrorCaptions.scannerOfferNotValidDescription).addDefaultAction(title: "OK").displayAlert(), animated: true)
        }
    }
}

extension HomeViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.displayConnectionLostAlert()
            }
        }
    }
}

//TablewView Offer operations
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOffer.dequeueReusableCell(withIdentifier: XIBIdentifier.XIB_OFFER_CELL, for: indexPath) as! OfferTableViewCell
               cell.configXIB(data: offers[indexPath.row])
               
               cell.alpha = 0
               UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                   cell.alpha = 1
               })
               
               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isTriggeredFromQR = false
        selectedIndex = indexPath.row
        performSegue(withIdentifier: Seagus.HomeToViewOffer, sender: nil)
    }
}

//CollectionView Featured operations
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.reuseIdentifier, for: indexPath) as? FeaturedCollectionViewCell {
            cell.configureCell(Data: categories[indexPath.row])
            
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
        selectedIndex = indexPath.row
        performSegue(withIdentifier: Seagus.HomeToSingleCategory, sender: nil)
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: FeaturedCollectionViewCell = Bundle.main.loadNibNamed(FeaturedCollectionViewCell.nibName, owner: self, options: nil)?.first as? FeaturedCollectionViewCell else {
            return CGSize.zero
        }
        
        cell.configureCell(Data: categories[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 65)
    }
    
}

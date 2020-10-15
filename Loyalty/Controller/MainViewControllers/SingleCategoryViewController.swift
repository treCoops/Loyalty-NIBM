//
//  SingleCategoryViewController.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/15/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class SingleCategoryViewController: UIViewController {
    
    @IBOutlet weak var tableViewVendors: UITableView!
    private let refreshControl = UIRefreshControl()
    
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    var progressHUD: ProgressHUD!
    
    var vendors: [Vendor] = []
    
    var category: Category? {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        networkChecker.delegate = self
        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
        setUpRefreshControl()
        registerNib()
        getVendorList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkChecker.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Terminating all firebase operations when moved to another viewController
        firebaseOP.stopAllOperations()
    }
}

extension SingleCategoryViewController {
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func qrCodePressed(_ sender: UIButton) {
        
    }
}

extension SingleCategoryViewController {
    func getVendorList() {
        if let vendors = DataModelHelper.fetchVendors(category: category?.key ?? "", vendorName: nil) {
            self.vendors = vendors
            print(vendors)
            DispatchQueue.main.async {
                self.tableViewVendors.reloadData()
            }
        }
    }
    
    func searchVendors(vendor: String){
        if let vendors = DataModelHelper.fetchVendors(category: category?.key ?? "", vendorName: vendor) {
            self.vendors = vendors
            DispatchQueue.main.async {
                self.tableViewVendors.reloadData()
            }
        }
    }
    
    //setup a pull to refresh control for the collectionview inorder to fetch new data from database
    func setUpRefreshControl(){
        // Add Refresh Control to CollectionView
        if #available(iOS 10.0, *) {
            tableViewVendors.refreshControl = refreshControl
        } else {
            tableViewVendors.addSubview(refreshControl)
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching categories ...", attributes: .none)
        refreshControl.addTarget(self, action: #selector(refreshVendorData(_:)), for: .valueChanged)
    }
    
    //Refresh category data (fetch data from firebase) and later will be loaded from coreCata stack
    @objc private func refreshVendorData(_ sender: Any) {
        if !networkChecker.isReachable {
            self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        firebaseOP.getAllVendors()
    }
    
    //Register the customized layout XIB with views and prepare
    func registerNib() {
        tableViewVendors.register(UINib(nibName: XIBIdentifier.XIB_VENDOR, bundle: nil), forCellReuseIdentifier: XIBIdentifier.XIB_VENDOR_CELL)
    }
}

//MARK: - Searchbar Delegates

extension SingleCategoryViewController: UISearchBarDelegate {
    //Search button clicked on the searchbar keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Search text validation
        if searchBar.text?.count == 0 {
            SKToast.show(withMessage: FieldErrorCaptions.searchFieldIsEmptyErrCaption)
            return
        }
        
        //Searching categories using the entered information
        self.searchVendors(vendor: searchBar.text!)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    //Hiding the keyboard when no text is entered at the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getVendorList()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension SingleCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewVendors.dequeueReusableCell(withIdentifier: XIBIdentifier.XIB_VENDOR_CELL, for: indexPath) as! VendorTableViewCell
               cell.configXIB(data: vendors[indexPath.row])
               
               cell.alpha = 0
               UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                   cell.alpha = 1
               })
               
               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: - Firebase Action Listener Delegates

extension SingleCategoryViewController: FirebaseActions {
    func onVendorsLoaded() {
        refreshControl.endRefreshing()
        getVendorList()
    }
    
    func onVendorsLoadFailedWithError(error: String) {
        SKToast.show(withMessage: error)
    }
    
    func onVendorsLoadFailedWithError(error: Error) {
        SKToast.show(withMessage: error.localizedDescription)
    }
}

//MARK: - Network listener delegates

//listen to data connection changes
extension SingleCategoryViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}

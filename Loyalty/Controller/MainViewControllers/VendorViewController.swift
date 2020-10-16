//
//  VendorViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class VendorViewController: UIViewController {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tableViewVenderOffers: UITableView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategoryLabel: UILabel!
    @IBOutlet weak var lblVendorDescription: UILabel!
    private let refreshControl = UIRefreshControl()
    
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    var progressHUD: ProgressHUD!
    
    var selectedOfferIndex: Int = 0
    
    var vendor: Vendor? {
        didSet {

        }
    }
    
    var offers : [Offer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLogo.squareImageView()
        registerNib()
        networkChecker.delegate = self
        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
        setUpRefreshControl()
        loadVendorData()
        getOfferList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkChecker.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Terminating all firebase operations when moved to another viewController
        firebaseOP.stopAllOperations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Seagus.vendorToViewOffer {
            let destVC = segue.destination as! OfferViewController
            destVC.offer = offers[selectedOfferIndex]
        }
    }
}

//MARK: - Interface Actions

extension VendorViewController {
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Inclass Methods

extension VendorViewController {
    func registerNib(){
        tableViewVenderOffers.register(UINib(nibName: XIBIdentifier.XIB_OFFER, bundle: nil), forCellReuseIdentifier: XIBIdentifier.XIB_OFFER_CELL)
    }
    func loadVendorData(){
        if let logoURL = vendor?.profileImageUrl, let coverURL = vendor?.coverImageUrl {
            imgLogo.kf.setImage(with: URL(string: logoURL))
            imgBanner.kf.setImage(with: URL(string: coverURL))
        }
        lblName.text = vendor?.name
        lblCategoryLabel.text = vendor?.categoryLabel
        lblVendorDescription.text = vendor?.vendor_description
    }
    func getOfferList(){
        if let offers = DataModelHelper.fetchOffers(vendorKey: vendor?.key ?? "") {
            self.offers = offers
            DispatchQueue.main.async {
                self.tableViewVenderOffers.reloadData()
            }
        }
    }
    //setup a pull to refresh control for the tableView inorder to fetch new data from database
    func setUpRefreshControl(){
        // Add Refresh Control to CollectionView
        if #available(iOS 10.0, *) {
            tableViewVenderOffers.refreshControl = refreshControl
        } else {
            tableViewVenderOffers.addSubview(refreshControl)
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching offers ...", attributes: .none)
        refreshControl.addTarget(self, action: #selector(refreshVendorData(_:)), for: .valueChanged)
    }
    
    //Refresh category data (fetch data from firebase) and later will be loaded from coreCata stack
    @objc private func refreshVendorData(_ sender: Any) {
        if !networkChecker.isReachable {
            self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        firebaseOP.getAllOffers()
    }
}

//MARK: - TableView Delegates

extension VendorViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewVenderOffers.dequeueReusableCell(withIdentifier: XIBIdentifier.XIB_OFFER_CELL, for: indexPath) as! OfferTableViewCell
               cell.configXIB(data: offers[indexPath.row])
               
               cell.alpha = 0
               UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                   cell.alpha = 1
               })
               
               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOfferIndex = indexPath.row
        performSegue(withIdentifier: Seagus.vendorToViewOffer, sender: nil)
    }
}

//MARK: - Firebase Action Listener Delegates

extension VendorViewController: FirebaseActions {
    func onOffersLoaded() {
        refreshControl.endRefreshing()
        self.getOfferList()
    }
    func onOffersLoadFailedWithError(error: Error) {
        SKToast.show(withMessage: error.localizedDescription)
    }
    func onOffersLoadFailedWithError(error: String) {
        SKToast.show(withMessage: error)
    }
}

//MARK: - Network listener delegates

//listen to data connection changes
extension VendorViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}

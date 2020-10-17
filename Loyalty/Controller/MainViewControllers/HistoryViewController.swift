//
//  HistoryViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class HistoryViewController: UIViewController {
    
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    lazy var firebaseOP = FirebaseOP.instance
    var progressHUD: ProgressHUD!
    
    var claimedOffers : [Claim] = []
    var user: User!
    
    @IBOutlet weak var tblViewHistory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        networkChecker.delegate = self
        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
        user = SessionManager.getUserSesion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkChecker.delegate = self
        loadClaimedOffers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Terminating all firebase operations when moved to another viewController
        firebaseOP.stopAllOperations()
    }
}

//MARK: - Interface Actions

extension HistoryViewController {
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Inclass Methods

extension HistoryViewController {
    func registerNib() {
        tblViewHistory.register(UINib(nibName: XIBIdentifier.XIB_HISTORY, bundle: nil), forCellReuseIdentifier: XIBIdentifier.XIB_HISTORY_CELL)
    }
    func loadClaimedOffers() {
        if !networkChecker.isReachable {
            self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        
        progressHUD.displayProgressHUD()
        firebaseOP.getClaimedOffers(userID: user.nic ?? "")
    }
}

//MARK: - TablewView delegates

extension HistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return claimedOffers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewHistory.dequeueReusableCell(withIdentifier: XIBIdentifier.XIB_HISTORY_CELL, for: indexPath) as! HistoryTableViewCell
               cell.configXIB(data: claimedOffers[indexPath.row])
               
               cell.alpha = 0
               UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                   cell.alpha = 1
               })
               
               return cell
    }
}

//MARK: - Firebase Action Listener Delegates

extension HistoryViewController: FirebaseActions {
    func onClaimedOffersLoaded(claims: [Claim]?) {
        progressHUD.dismissProgressHUD()
        if let claims = claims {
            self.claimedOffers = claims
            DispatchQueue.main.async {
                self.tblViewHistory.reloadData()
            }
        }
    }
    func onClaimedOffersLoadFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
    func onClaimedOffersLoadFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
}

//MARK: - Network listener delegates

//listen to data connection changes
extension HistoryViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}

//
//  OfferViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class OfferViewController: UIViewController {

    @IBOutlet weak var imgOffer: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnGetOffer: UIButton!
    
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    var firebaseOP = FirebaseOP.instance
    
    var user: User?
    var offer: Offer?
    var progressHUD: ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGetOffer.isHidden = true
        btnGetOffer.isEnabled = false
        progressHUD = ProgressHUD(view: view)
        user = SessionManager.getUserSesion()
        if !networkChecker.isReachable {
            self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        
        progressHUD.displayProgressHUD()
        networkChecker.delegate = self
        firebaseOP.delegate = self
        loadOfferData()
        checkOfferElegilility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkChecker.delegate = self
        firebaseOP.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Seagus.ViewOfferToScanQR {
            let destVC = segue.destination as! ScanQRViewController
            destVC.launchedFromOfferClaim = true
            destVC.offerClaimCallback =  {
                [weak self] result in
                if result {
                    self?.claimOffer()
                } else {
                    SKToast.show(withMessage: FieldErrorCaptions.offerValidationErr)
                }
            }
        }
        
        if segue.identifier == Seagus.ViewOfferToValidationDone {
            let destVC = segue.destination as! OfferValidateDoneViewController
            destVC.user = user
            destVC.offer = offer
        }
    }
}

//MARK: - Interface Actions

extension OfferViewController {
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func getOfferPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Seagus.ViewOfferToScanQR, sender: nil)
    }
}

//MARK: - Inclass methods

extension OfferViewController {
    func claimOffer(){
        
        if !networkChecker.isReachable {
            self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        
        if let offer = offer, let user = user {
            firebaseOP.claimOffer(offer: offer, user: user)
        }
    }
    func checkOfferElegilility() {
        if let nic = user?.nic, let key = self.offer?.key {
            firebaseOP.checkOfferElegibility(offerID: key, nic: nic)
        } else {
            NSLog("Failed to load user session")
            SKToast.show(withMessage: FieldErrorCaptions.generalizeErrCaption)
        }
    }
    func loadOfferData() {
        if let offer = self.offer, let url = offer.image {
            imgOffer.kf.setImage(with: URL(string: url))
            lblTitle.text = offer.title
            lblDescription.text = offer.offer_description
        }
    }
}


//MARK: - Network listener delegates

//listen to data connection changes
extension OfferViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}

//MARK: - Firebase Action delegates

extension OfferViewController: FirebaseActions {
    func onElegililityRecieved(status: Bool) {
        progressHUD.dismissProgressHUD()
        btnGetOffer.isHidden = false
        if status {
            btnGetOffer.isEnabled = true
            btnGetOffer.backgroundColor = #colorLiteral(red: 0.9190844893, green: 0.6535602212, blue: 0, alpha: 1)
        } else {
            btnGetOffer.setTitle("Offer already claimed", for: .disabled)
            btnGetOffer.isEnabled = false
            btnGetOffer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    func onElegililityRecievedFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
    func onElegililityRecievedFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
    
    func onClaimOfferSuccess() {
        progressHUD.dismissProgressHUD()
        btnGetOffer.setTitle("Offer already claimed", for: .disabled)
        btnGetOffer.isEnabled = false
        btnGetOffer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.performSegue(withIdentifier: Seagus.ViewOfferToValidationDone, sender: nil)
    }
    func onClaimOfferFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
    func onClaimOfferFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
}


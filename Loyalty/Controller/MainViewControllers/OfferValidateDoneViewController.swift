//
//  OfferValidateDoneViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import Lottie

class OfferValidateDoneViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewHeading: UIView!
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var lblCongratulate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblStudentID: UILabel!
    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var lblOfferDescription: UILabel!
    @IBOutlet weak var lblClaimedDate: UILabel!
    
    var offer: Offer?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewParent.layer.shadowColor = UIColor.lightGray.cgColor
        viewParent.layer.shadowOpacity = 0.3
        viewParent.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewParent.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.6784313725, blue: 0.431372549, alpha: 1)
        viewParent.layer.borderWidth = 0.8
        viewParent.layer.shadowRadius = 10
        viewParent.layer.cornerRadius = 10
        
        viewHeading.clipsToBounds = true
        viewHeading.layer.cornerRadius = 10
        viewHeading.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        lottieView.loopMode = .loop
        lottieView.play()
        
        loadData()
    
    }
    
    func loadData() {
        if let offer = offer, let user = user {
            lblCongratulate.text = "Hooray!\nEnjoy your offer at \(offer.vendor ?? "")"
            lblUserName.text = user.name ?? ""
            lblStudentID.text = user.studentID ?? ""
            lblVendorName.text = offer.vendor ?? ""
            lblOfferDescription.text = offer.offer_description ?? ""
            lblClaimedDate.text = Date().getCurrentDate()
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

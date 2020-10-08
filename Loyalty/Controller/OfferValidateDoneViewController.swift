//
//  OfferValidateDoneViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class OfferValidateDoneViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewHeading: UIView!
    
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
        

        
        
    
    }
    
}

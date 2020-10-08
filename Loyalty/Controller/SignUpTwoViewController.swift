//
//  SignUpTwoViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class SignUpTwoViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnCheckTerms: UIButton!
    
    var checked : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewParent.roundView()

    }
    
    @IBAction func btnTermsClicked(_ sender: UIButton) {
        
        if checked{
            checked = false
            btnCheckTerms.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }else{
            checked = true
            btnCheckTerms.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
        
        
    }
    
    

}

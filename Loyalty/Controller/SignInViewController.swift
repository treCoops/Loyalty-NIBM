//
//  ViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    
    @IBOutlet weak var txtPassword: RoundedTextField!
    @IBOutlet weak var txtNIC: RoundedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewParent.roundView()
        setTextDelegates()
    
    }

}

extension SignInViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setTextDelegates(){
        txtNIC.delegate = self
        txtPassword.delegate = self
    }
}


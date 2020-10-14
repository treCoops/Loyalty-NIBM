//
//  ViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class SignInViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    
    @IBOutlet weak var txtPassword: RoundedTextField!
    @IBOutlet weak var txtNIC: RoundedTextField!
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    var progressHUD: ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewParent.roundView()
        setTextDelegates()
        networkChecker.delegate = self
        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        firebaseOP.stopAllOperations()
    }
}

//MARK: - InterfaceBuilder Actions

extension SignInViewController {
    @IBAction func signInClicked(_ sender: UIButton) {
        if !InputFieldValidator.isValidNIC(txtNIC.text ?? "") {
            txtNIC.clearText()
            txtNIC.displayInlineError(errorString: FieldErrorCaptions.txtNICErrCaption)
            return
        }
        if !InputFieldValidator.isValidPassword(pass: txtPassword.text ?? "", minLength: 6, maxLength: 20){
            txtPassword.clearText()
            txtPassword.displayInlineError(errorString: FieldErrorCaptions.txtPassErrCaption)
            return
        }
        
        if !networkChecker.isReachable {
            self.present(popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        
        progressHUD.displayProgressHUD()
        
        //Validate the entered nic with NIBM
        UserValidator.validateUser(txtNIC.text!, completion: {
            result in
            self.progressHUD.dismissProgressHUD()
            if result == "true" {
                NSLog("NIC matched with NIBM records")
                self.firebaseOP.signInUser(nic: self.txtNIC.text?.uppercased() ?? "", password: self.txtPassword.text ?? "")
            } else {
                NSLog("NIC not found on NIBM records")
                SKToast.show(withMessage: "Entered NIC not registered with NIBM")
            }
        })
    }
}

//MARK: - Textfile delegates to listen to return events on keyboard

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

//MARK: - Delegate methods to listen firebase operations

extension SignInViewController: FirebaseActions {
    func onUserNotRegistered(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
        self.performSegue(withIdentifier: Seagus.signInToSignUp, sender: nil)
    }
    func onUserSignInSuccess(user: User?) {
        progressHUD.dismissProgressHUD()
        if let user = user {
            self.performSegue(withIdentifier: Seagus.signInToHome, sender: nil)
            SessionManager.saveUserSession(user)
        } else {
            SKToast.show(withMessage: FieldErrorCaptions.generalizeErrCaption)
        }
    }
    func onUserSignInFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
    func onUserSignInFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
}

//MARK: - Network delegate to check network change operations

extension SignInViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            self.popupAlerts.dismissNetworkLostAlert()
            
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}


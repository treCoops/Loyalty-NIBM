//
//  LunchScreenViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class LaunchScreenViewController: UIViewController {

    var progressHUD : ProgressHUD!
    var firebaseOP = FirebaseOP.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressHUD = ProgressHUD(view: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        progressHUD.displayProgressHUD()
        validateUserSession()
    }
}

extension LaunchScreenViewController {
    func validateUserSession(){
        firebaseOP.authenticateDefaultUser(completion: {
            result in
            if result {
                NSLog("Sign-in success for default user")
                self.validateWithNIBM()
            } else {
                self.progressHUD.dismissProgressHUD()
                SKToast.show(withMessage: "Failed initialize the application")
            }
        })
    }
    
    func validateWithNIBM(){
        if SessionManager.authState {
            if let userNIC = SessionManager.getUserSesion()?.nic {
                UserValidator.validateUser(userNIC, completion: {
                    res in
                    self.progressHUD.dismissProgressHUD()
                    if res == "true" {
                        NSLog("User signed in with previous session")
                    } else {
                        self.performSegue(withIdentifier: Seagus.launchScreenToSignUp, sender: nil)
                        NSLog("User session validation failed")
                    }
                })
            } else {
                self.progressHUD.dismissProgressHUD()
                self.performSegue(withIdentifier: Seagus.launchScreenToSignIn, sender: nil)
                NSLog("User session not found")
            }
        } else {
            self.progressHUD.dismissProgressHUD()
            self.performSegue(withIdentifier: Seagus.launchScreenToSignIn, sender: nil)
            NSLog("No previous login sesions found")
        }
    }
}

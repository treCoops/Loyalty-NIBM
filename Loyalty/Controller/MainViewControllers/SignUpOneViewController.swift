//
//  SignUpOneViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class SignUpOneViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var txtFullName: RoundedTextField!
    @IBOutlet weak var txtStudentID: RoundedTextField!
    @IBOutlet weak var txtNIC: RoundedTextField!
    
    var progressHUD : ProgressHUD!
    
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewParent.roundView()
        setTextFieldDelegates()
        progressHUD = ProgressHUD(view: view)
        networkChecker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkChecker.delegate = self
    }
}

//MARK: - Inclass IBActions

extension SignUpOneViewController {
    
    @IBAction func loginPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextPressed(_ sender: UIButton) {
        if !InputFieldValidator.isValidName(txtFullName.text ?? "") {
            txtFullName.clearText()
            txtFullName.displayInlineError(errorString: FieldErrorCaptions.txtNameErrCaption)
            return
        }
        if !InputFieldValidator.checkLength(txtStudentID.text ?? "", 10) {
            txtStudentID.clearText()
            txtStudentID.displayInlineError(errorString: FieldErrorCaptions.txtStudentIDErrCaption)
            return
        }
        if !InputFieldValidator.isValidNIC(txtNIC.text ?? "") {
            txtNIC.clearText()
            txtNIC.displayInlineError(errorString: FieldErrorCaptions.txtNICErrCaption)
            return
        }
        
        if !networkChecker.isReachable {
            self.present(popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        
        progressHUD.displayProgressHUD()
        
        UserValidator.validateUser(txtNIC.text!, completion: {
            result in
            self.progressHUD.dismissProgressHUD()
            if result == "true" {
                NSLog("NIC matched with NIBM records")
                self.performSegue(withIdentifier: Seagus.signUpOneToSignUpTwo, sender: nil)
            } else {
                NSLog("NIC not found on NIBM records")
                self.performSegue(withIdentifier: Seagus.SignUpOneToNotRegistered, sender: nil)
                SKToast.show(withMessage: "Entered NIC not registered with NIBM")
            }
        })
        
    }
}

//MARK: - TextField Delegates

extension SignUpOneViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setTextFieldDelegates(){
        txtFullName.delegate = self
        txtStudentID.delegate = self
        txtNIC.delegate = self
    }
    
    //Prepare to launch the next viewController with setting the user instance
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Seagus.signUpOneToSignUpTwo {
            if let vc = segue.destination as? SignUpTwoViewController {
                //Creating a new user object with using the entered data (partial data)
                let user = User(name: txtFullName.text, studentID: txtStudentID.text, mobile: nil, nic: txtNIC.text?.uppercased(), joinedDate: nil, email: nil, password: nil, profileImage: nil, status: nil, timeStamp: nil)
                //innitialize the user object in the SignUpTwoViewController
                vc.user = user
            }
        }
    }
}

//MARK: - Network listener delegates

extension SignUpOneViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}

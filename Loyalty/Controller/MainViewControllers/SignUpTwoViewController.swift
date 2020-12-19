//
//  SignUpTwoViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import SKToast

class SignUpTwoViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnCheckTerms: UIButton!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    var imagePicker: ImagePicker!
    var progressHUD: ProgressHUD!
    var popupAlert: PopupAlerts!
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    
    //holds the popup which shows when user already exists
    var duplicateUserAlert: UIAlertController!
    
    var termsChecked : Bool = false
    var user : User!
    var pickedImage: UIImage?
    
    var firebaseOP = FirebaseOP.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewParent.roundView()
        setTextFieldDelegates()
        networkChecker.delegate = self
        firebaseOP.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        progressHUD = ProgressHUD(view: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firebaseOP.delegate = self
        networkChecker.delegate = self
        txtName.text = user.name
        //set tap gesture for the UIImageView [UserInteraction should be enabled]
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onPickImageClicked))
        self.imgProfilePic.addGestureRecognizer(gesture)
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        firebaseOP.stopAllOperations()
    }
}

//MARK: - Inclass IBActions

extension SignUpTwoViewController {
    
    @IBAction func btnTermsClicked(_ sender: UIButton) {
        termsChecked = !termsChecked
        btnCheckTerms.setImage(termsChecked ? #imageLiteral(resourceName: "unchecked") : #imageLiteral(resourceName: "checked"), for: .normal)
//        if termsChecked {
//            termsChecked = false
//            btnCheckTerms.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
//        } else {
//            termsChecked = true
//            btnCheckTerms.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
//        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        //sends back to the previous viewController
        self.navigationController?.popToViewController(self.navigationController?.viewControllers[1] as! SignInViewController, animated: true)
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        if !InputFieldValidator.isValidEmail(txtEmailAddress.text ?? ""){
            txtEmailAddress.clearText()
            txtEmailAddress.displayInlineError(errorString: FieldErrorCaptions.txtEmailErrCaption)
            return
        }
        if !InputFieldValidator.isValidMobileNo(mobileNo: txtMobileNumber.text ?? ""){
            txtMobileNumber.clearText()
            txtMobileNumber.displayInlineError(errorString: FieldErrorCaptions.txtContactNoErrCaption)
            return
        }
        if !InputFieldValidator.isValidPassword(pass: txtPassword.text ?? "", minLength: 6, maxLength: 20){
            txtPassword.clearText()
            txtPassword.displayInlineError(errorString: FieldErrorCaptions.txtPassErrCaption)
            return
        }
        if txtPassword.text != txtConfirmPassword.text {
            txtPassword.clearText()
            txtConfirmPassword.clearText()
            txtPassword.displayInlineError(errorString: FieldErrorCaptions.txtConfirmPassErrCaption)
            txtConfirmPassword.displayInlineError(errorString: FieldErrorCaptions.txtConfirmPassErrCaption)
            return
        }
        if !termsChecked {
            SKToast.show(withMessage: "You must agree to our terms!")
            return
        }
        
        //set the data for the user object
        user.email = txtEmailAddress.text
        user.mobile = txtMobileNumber.text
        user.password = txtPassword.text
        
        if !networkChecker.isReachable {
            self.present(popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        
        progressHUD.displayProgressHUD()
        //prepare to sign up the user
        firebaseOP.signUpUser(user: user, image: pickedImage)
    }
}

//MARK: - TextField Delagates

extension SignUpTwoViewController : UITextFieldDelegate {
    
    //dismiss the keyboard when pressed return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setTextFieldDelegates(){
        txtEmailAddress.delegate = self
        txtMobileNumber.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    
    //Open imagepicker menu
    @objc func onPickImageClicked(_ sender: UIImageView){
        self.imagePicker.present(from: sender)
    }
}

//MARK: - ImagePicker Delegate

extension SignUpTwoViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
//        if image == nil {
//            self.imgProfilePic.image = UIImage(systemName: "person.circle.fill")
//            return
//        }
        
        self.imgProfilePic.image = image
        pickedImage = image
    }
}

//MARK: - Protocol Delegates of FirebaseActions

extension SignUpTwoViewController : FirebaseActions {
    //Successful signup
    func isSignUpSuccessful(user: User?) {
        progressHUD.dismissProgressHUD()
        if let user = user {
            SessionManager.saveUserSession(user)
            self.performSegue(withIdentifier: Seagus.signUpTwoToHome, sender: nil)
        } else {
            SKToast.show(withMessage: FieldErrorCaptions.generalizeErrCaption)
        }
    }
    
    //Failed to signup the user
    func isSignUpFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
    
    //Failed to signup the user
    func isSignUpFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
    
    //The entered NIC exists on a different user account
    func isExisitingUser(error: String) {
        progressHUD.dismissProgressHUD()
        //initialize the alertView if not yet initialized
        if duplicateUserAlert == nil {
            duplicateUserAlert = popupAlert.createAlert(title: "User exists", message: error).addAction(title: "OK", handler: {_ in
            }).displayAlert()
        }
        //display alert
        self.present(duplicateUserAlert, animated: true)
    }
}

//MARK: - Network listener delegates

extension SignUpTwoViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}

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
    var duplicateUserAlert: UIAlertController!
    
    var termsChecked : Bool = false
    var user : User!
    var pickedImage: UIImage?
    
    var firebaseOP = FirebaseOP.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewParent.roundView()
        setTextFieldDelegates()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
        popupAlert = PopupAlerts.instance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtName.text = user.name
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onPickImageClicked))
        self.imgProfilePic.addGestureRecognizer(gesture)
    }
}

//MARK: - Inclass IBActions

extension SignUpTwoViewController {
    
    @IBAction func btnTermsClicked(_ sender: UIButton) {
        if termsChecked {
            termsChecked = false
            btnCheckTerms.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        } else {
            termsChecked = true
            btnCheckTerms.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
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
        
        user.email = txtEmailAddress.text
        user.mobile = txtMobileNumber.text
        user.password = txtPassword.text
        
        progressHUD.displayProgressHUD()
        firebaseOP.signUpUser(user: user, image: pickedImage)
    }
}

//MARK: - TextField Delagates

extension SignUpTwoViewController : UITextFieldDelegate {
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
    func isSignUpSuccessful(user: User?) {
        progressHUD.dismissProgressHUD()
        if let user = user {
            SessionManager.saveUserSession(user)
            self.performSegue(withIdentifier: Seagus.signUpTwoToHome, sender: nil)
        } else {
            SKToast.show(withMessage: FieldErrorCaptions.generalizeErrCaption)
        }
    }
    
    func isSignUpFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
    
    func isSignUpFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
    
    func isExisitingUser(error: String) {
        progressHUD.dismissProgressHUD()
        if duplicateUserAlert == nil {
            duplicateUserAlert = popupAlert.createAlert(title: "User exists", message: error).addAction(title: "OK", handler: {_ in
            }).displayAlert()
        }
        self.present(duplicateUserAlert, animated: true)
    }
}

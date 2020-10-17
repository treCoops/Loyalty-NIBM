//
//  EditProfileViewController.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/16/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import Kingfisher
import SKToast

class EditProfileViewController: UIViewController {

    @IBOutlet weak var imgProfile: RoundedImageView!
    @IBOutlet weak var lblStudentID: UILabel!
    @IBOutlet weak var lblNIC: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var txtFullName: RoundedTextField!
    @IBOutlet weak var txtEmailAddress: RoundedTextField!
    @IBOutlet weak var txtCurrentPassword: RoundedTextField!
    @IBOutlet weak var txtNewPassword: RoundedTextField!
    @IBOutlet weak var txtConfirmPassword: RoundedTextField!
    
    var imagePicker: ImagePicker!
    var logoutAlert: UIAlertController!
    
    //used to validate the fields
    lazy var currentPass: String = ""
    lazy var enteredPass: String = ""
    var currentImage: UIImage?
    var isImageUpdated: Bool = false
    var isEmailChanged: Bool = false
    
    var networkChecker = NetworkChecker.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    var progressHUD: ProgressHUD!
    
    var user = SessionManager.getUserSesion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        loadData()
        setTextDelegates()
        networkChecker.delegate = self
        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        firebaseOP.stopAllOperations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkChecker.delegate = self
        //set tap gesture for the UIImageView [UserInteraction should be enabled]
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onPickImageClicked))
        self.imgProfile.addGestureRecognizer(gesture)
    }
}

//MARK: - Interface Actions

extension EditProfileViewController {
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func savePressed(_ sender: UIButton) {
        if !InputFieldValidator.isValidName(txtFullName.text ?? "") {
            txtFullName.clearText()
            txtFullName.displayInlineError(errorString: FieldErrorCaptions.txtNameErrCaption)
            return
        }
        if !InputFieldValidator.isValidEmail(txtEmailAddress.text ?? ""){
            txtEmailAddress.clearText()
            txtEmailAddress.displayInlineError(errorString: FieldErrorCaptions.txtEmailErrCaption)
            return
        }
        
        currentPass = txtCurrentPassword.text ?? ""
        enteredPass = txtNewPassword.text ?? ""
        
        if currentPass.count > 0 || enteredPass.count > 0 {
            if !InputFieldValidator.isValidPassword(pass: txtCurrentPassword.text ?? "", minLength: 6, maxLength: 20){
                txtCurrentPassword.clearText()
                txtCurrentPassword.displayInlineError(errorString: FieldErrorCaptions.txtPassErrCaption)
                return
            }
            if !InputFieldValidator.isValidPassword(pass: txtNewPassword.text ?? "", minLength: 6, maxLength: 20){
                txtNewPassword.clearText()
                txtNewPassword.displayInlineError(errorString: FieldErrorCaptions.txtPassErrCaption)
                return
            }
            if txtNewPassword.text != txtConfirmPassword.text {
                txtNewPassword.clearText()
                txtConfirmPassword.clearText()
                txtNewPassword.displayInlineError(errorString: FieldErrorCaptions.txtConfirmPassErrCaption)
                txtConfirmPassword.displayInlineError(errorString: FieldErrorCaptions.txtConfirmPassErrCaption)
                return
            }
            
            if txtCurrentPassword.text != user?.password {
                txtCurrentPassword.clearText()
                txtCurrentPassword.displayInlineError(errorString: FieldErrorCaptions.currentPasswordErrCaption)
                return
            }
            
            user?.password = txtNewPassword.text
        }
        
        if user?.email != txtEmailAddress.text {
            isEmailChanged = true
        }
        
        user?.email = txtEmailAddress.text
        user?.name = txtFullName.text
        
        if !networkChecker.isReachable {
            self.present(popupAlerts.displayNetworkLostAlert(), animated: true)
            return
        }
        
        progressHUD.displayProgressHUD()
        //prepare to sign up the user
        if let user = user {
            if isImageUpdated {
                firebaseOP.updateUser(user: user, updateEmail: isEmailChanged, profileImage: imgProfile.image)
            } else {
                firebaseOP.updateUser(user: user, updateEmail: isEmailChanged)
            }
        }
    }
    @IBAction func logoutPressed(_ sender: UIButton) {
        displayLogoutAlert()
    }
    @IBAction func aboutPresssed(_ sender: UIButton) {
    }
}

//MARK: - Inclass methods

extension EditProfileViewController {
    //Open imagepicker menu
    @objc func onPickImageClicked(_ sender: UIImageView){
        self.imagePicker.present(from: sender)
    }
    //load and set the user related data
    func loadData() {
        if let url = user?.profileImage {
            imgProfile.kf.setImage(with: URL(string: url))
            currentImage = imgProfile.image
        }
        lblNIC.text = user?.nic
        lblStudentID.text = user?.studentID
        lblMobileNo.text = user?.mobile
        txtFullName.text = user?.name
        txtEmailAddress.text = user?.email
    }
    //displays a alertDialog when user tries to signOut
    func displayLogoutAlert(){
        if logoutAlert == nil {
            logoutAlert = popupAlerts.createAlert(title: "Sign out", message: FieldErrorCaptions.signOutMessage).addAction(title: "Sign out", handler: {
                action in
                SessionManager.clearUserSession()
                self.navigationController?.popToRootViewController(animated: true)
            }).addDefaultAction(title: "Cancel").displayAlert()
        }
        
        self.present(logoutAlert, animated: true)
    }
}

//MARK: - Textfile delegates to listen to return events on keyboard

extension EditProfileViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setTextDelegates(){
        txtFullName.delegate = self
        txtEmailAddress.delegate = self
        txtCurrentPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtNewPassword.delegate = self
    }
}

//MARK: - ImagePicker Delegate

extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if image == nil {
            isImageUpdated = false
            return
        }
        isImageUpdated = true
        self.imgProfile.image = image
    }
}

//MARK: - Delegate methods to listen firebase operations

extension EditProfileViewController: FirebaseActions {
    func onUpdateProfileSuccess(user: User) {
        SKToast.show(withMessage: "Details updated successfully.")
        progressHUD.dismissProgressHUD()
    }
    func onUpdateProfileFailedWithError(error: Error) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error.localizedDescription)
    }
    func onUpdateProfileFailedWithError(error: String) {
        progressHUD.dismissProgressHUD()
        SKToast.show(withMessage: error)
    }
}

//MARK: - Network delegate to check network change operations

extension EditProfileViewController: NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {
        DispatchQueue.main.async {
            if !connected {
                self.present(self.popupAlerts.displayNetworkLostAlert(), animated: true)
            }
        }
    }
}



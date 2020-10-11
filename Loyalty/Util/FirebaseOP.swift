//
//  FirebaseOP.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation
import Firebase

class FirebaseOP {
    
    static var instance = FirebaseOP()
    var delegate: FirebaseActions?
    
    private init() {}
    
    func authenticateDefaultUser(completion: @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: DefaultCredentials.defaultEmail, password: DefaultCredentials.defaultPass, completion: {
            result, error in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        })
    }
    
    func signUpUser(user: User, image: UIImage?){
        
        guard let email = user.email, let pass = user.password, let studentID = user.studentID, let nic = user.nic else {
            self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.generalizeErrCaption)
            return
        }
        
        checkUserExistence(nic: nic, completion: {
            result in
            
            //Checking whether the user exists
            if result {
                NSLog("User already exists")
                self.delegate?.isExisitingUser(error: FieldErrorCaptions.userAlreadyExists)
                return
            }
            NSLog("Creating new user")
            //execute if the user does not exist
            self.setupAuthenticationAccount(email: email, password: pass, completion: {
                authResult in
                //executes if authentication account creation successful
                if authResult {
                    var tempUser = user
                    //executes if the user does not select any profile image
                    if image == nil {
                        tempUser.profileImage = ""
                        //create user on database
                        self.createUser(user: tempUser, completion: {
                            result, error, user in
                            //user created on database
                            if result {
                                self.delegate?.isSignUpSuccessful(user: user)
                            } else {
                                NSLog("Could not create new user on DB")
                                self.delegate?.isSignUpFailedWithError(error: error ?? FieldErrorCaptions.generalizeErrCaption)
                            }
                        })
                        return
                    }
                    
                    //executes when the user selected a profile image
                    //upload the image and retrieve the download URL for the image
                    self.uploadProfileImage(image: image, studentID: studentID, completion: {
                        imageURL in
                        tempUser.profileImage = imageURL
                        //create user on database
                        self.createUser(user: tempUser, completion: {
                            result, error, user in
                            //user created on database
                            if result {
                                self.delegate?.isSignUpSuccessful(user: user)
                            } else {
                                NSLog("Could not create new user on DB")
                                self.delegate?.isSignUpFailedWithError(error: error ?? FieldErrorCaptions.generalizeErrCaption)
                            }
                        })
                    })
                } else {
                    self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.userCreationrrCaption)
                }
            })
            
        })
    }
    
    //MARK: - InClass methods
    
    private func checkUserExistence(nic: String, completion:@escaping (Bool) -> Void) {
        let ref = self.getDBReference()
        ref.child("students").child(nic).observeSingleEvent(of: .value, with: {
            snapshot in
            if snapshot.hasChildren(){
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    private func setupAuthenticationAccount(email: String, password: String, completion: @escaping (Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            result, error in
            if let error = error {
                completion(false)
                NSLog(error.localizedDescription)
            } else {
                completion(true)
                NSLog(result?.description ?? "")
            }
        })
    }
    
    private func createUser(user: User, completion: @escaping (Bool, String?, User?) -> Void){
        let ref = self.getDBReference()
        var user = user
        user.TIMESTAMP = Date().currentTimeMillis()
        user.joinedDate = String(user.TIMESTAMP ?? 0000)
        user.status = 1
        let data = [
            "name": user.name!,
            "studentID": user.studentID!,
            "mobile": user.mobile!,
            "nic": user.nic!,
            "joinedDate": user.joinedDate!,
            "email": user.email!,
            "password": user.password!,
            "profileImage": user.profileImage!,
            "status": user.status!,
            "TIMESTAMP": user.TIMESTAMP!
        ] as [String : Any]
        
        ref.child("students").child(user.nic!).setValue(data) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                completion(false, error.localizedDescription, nil)
                NSLog(error.localizedDescription)
            } else {
                completion(true, nil, user)
            }
        }
    }
    
    private func uploadProfileImage(image: UIImage?, studentID : String, completion: @escaping (String) -> Void) {
        if let uploadData = image?.jpegData(compressionQuality: 0.5) {
            let ref = getStorageReference()
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            //sending the imagedata to firebase storage
            ref.child("studentProfile/").child(Auth.auth().currentUser?.uid ?? studentID).putData(uploadData, metadata: metaData) {
                (meta, error) in
                
                //retrieve the downloadURL
                ref.child("studentProfile/").child(Auth.auth().currentUser?.uid ?? studentID).downloadURL(completion: {
                    (url,error) in
                    
                    //fetching the download URL
                    //Remove all created credentials if failed
                    guard let downloadURL = url else {
                        NSLog("Could not retrieve download URL")
                        let user = Auth.auth().currentUser
                        NSLog("Removing authentication account")
                        user?.delete(completion: {
                            error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        })
                        NSLog("Removing image")
                        ref.child("studentProfile/").child(Auth.auth().currentUser?.uid ?? studentID).delete(completion: {
                            error in
                            print(error?.localizedDescription ?? "")
                        })
                        self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.generalizeErrCaption)
                        return
                    }
                    
                    completion(downloadURL.absoluteString)
                })
            }
        }
    }
    
    //MARK: - Retrieve the realtime database reference
    
    private func getDBReference() -> DatabaseReference{
        return Database.database().reference()
    }
    
    //MARK: - Retrieve the storage reference
    
    private func getStorageReference() -> StorageReference {
        return Storage.storage().reference()
    }
    

}

//MARK: - List of Protocols

protocol FirebaseActions {
    func isSignUpSuccessful(user: User?)
    func isExisitingUser(error: String)
    func isSignUpFailedWithError(error: Error)
    func isSignUpFailedWithError(error: String)
}

//MARK: - Set of Protocol extensions

extension FirebaseActions {
    func isSignUpSuccessful(user: User?){}
    func isExisitingUser(error: String){}
    func isSignUpFailedWithError(error: Error){}
    func isSignUpFailedWithError(error: String){}
}

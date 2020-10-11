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
        
        guard let email = user.email, let pass = user.password, let studentID = user.studentID else {
            self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.generalizeErrCaption)
            return
        }
        
        setupAuthenticationAccount(email: email, password: pass, completion: {
            authResult in
            if authResult {
                var tempUser = user
                if image == nil {
                    tempUser.profileImage = ""
                    self.createUser(user: tempUser, completion: {
                        result, error, user in
                        if result {
                            self.delegate?.isSignUpSuccessful(user: user)
                        } else {
                            self.delegate?.isSignUpFailedWithError(error: error ?? FieldErrorCaptions.generalizeErrCaption)
                        }
                    })
                    return
                }
                
                self.uploadProfileImage(image: image, studentID: studentID, completion: {
                    imageURL in
                    tempUser.profileImage = imageURL
                    self.createUser(user: tempUser, completion: {
                        result, error, user in
                        if result {
                            self.delegate?.isSignUpSuccessful(user: user)
                        } else {
                            self.delegate?.isSignUpFailedWithError(error: error ?? FieldErrorCaptions.generalizeErrCaption)
                        }
                    })
                })
            } else {
                self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.userCreationrrCaption)
            }
        })
    }
    
    //MARK: - InClass methods
    
    private func setupAuthenticationAccount(email: String, password: String, completion: @escaping (Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            result, error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        })
    }
    
    private func createUser(user: User, completion: @escaping (Bool, String?, User?) -> Void){
        let ref = self.getDBReference()
        var user = user
        user.joinedDate = String(Date().currentTimeMillis())
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
            "status": user.status!
        ] as [String : Any]
        
        ref.child("students").child(user.nic!).setValue(data) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                completion(false, error.localizedDescription, nil)
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
            
            ref.child("studentProfile/").child(studentID).putData(uploadData, metadata: metaData) {
                (meta, error) in
                
                ref.child("studentProfile/").child(studentID).downloadURL(completion: {
                    (url,error) in
                    
                    guard let downloadURL = url else {
                        let user = Auth.auth().currentUser
                        
                        user?.delete(completion: {
                            error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
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
    func isSignUpFailedWithError(error: Error)
    func isSignUpFailedWithError(error: String)
}

//MARK: - Set of Protocol extensions

extension FirebaseActions {
    func isSignUpSuccessful(user: User?){}
    func isSignUpFailedWithError(error: Error){}
    func isSignUpFailedWithError(error: String){}
}

//
//  FirebaseOP.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Utility class to perform the firebase operations such as
        - RealtimeDB Operations
        - CloudStorage Operations
        - Firebase Authentication Operations
 */

import Foundation
import Firebase

class FirebaseOP {
    
    //Class instance
    static var instance = FirebaseOP()
    //Class Delegate
    var delegate: FirebaseActions?
    
    var dbRef: DatabaseReference!
    var storageRef: StorageReference!
    var uploadTask: StorageUploadTask?
    
    //Make Singleton
    fileprivate init() {}
    
    //cancel all firebase operation in case of network lost
    func stopAllOperations(){
        if let dbRef = dbRef {
            dbRef.removeAllObservers()
        }
        if let uploadTask = uploadTask {
            uploadTask.cancel()
        }
    }
    
    //Authenticate the default user when launching the application
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
    
    //Perform user sign in with checking the existence on the DB with the correspond access credentials
    func signInUser(nic: String, password: String){
        checkUserExistence(nic: nic, completion: {
            result, data in
            //result = TRUE when user exists in DB
            //data = firebaseSnapshot
            if result {
                //parsing data from snapshot
                if let userData = data.value as? [String: Any] {
                    //validating access credentials
                    if userData["password"] as? String == password {
                        NSLog("Successful sign-in")
                        self.delegate?.onUserSignInSuccess(user: User(
                                                            name: userData["name"] as? String,
                                                            studentID: userData["studentID"] as? String,
                                                            mobile: userData["mobile"] as? String,
                                                            nic: userData["nic"] as? String,
                                                            joinedDate: userData["joinedDate"] as? String,
                                                            email: userData["email"] as? String,
                                                            password: userData["password"] as? String,
                                                            profileImage: userData["profileImage"] as? String,
                                                            status: userData["status"] as? Int,
                                                            TIMESTAMP: userData["TIMESTAMP"] as? Int64))
                    } else {
                        self.delegate?.onUserSignInFailedWithError(error: "Invalid access credentials")
                    }
                } else {
                    NSLog("Unable to serialize user node data")
                    self.delegate?.onUserSignInFailedWithError(error: FieldErrorCaptions.generalizeErrCaption)
                }
            } else {
                NSLog("User not registered")
                self.delegate?.onUserNotRegistered(error: "User not registered with the app.")
            }
        })
    }
    
    /**
        Perform user signUp operations with including
            - Creating an authentication for user
            - Upload image to CloudStorage and retrieve download URL
            - Create the new user in the Realtime Database
     */
    func signUpUser(user: User, image: UIImage?){
        
        //Check the provided User object contains NULL
        guard let email = user.email, let pass = user.password, let studentID = user.studentID, let nic = user.nic else {
            self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.generalizeErrCaption)
            return
        }
        
        //Checking for the existance of the user (Duplicate account)
        checkUserExistence(nic: nic, completion: {
            result, data in
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
    
    //Method to check whether the userrecords exists in the databse
    /**
        Closure returns TRUE if the user record exsists or FALSE if it doesn't
     */
    fileprivate func checkUserExistence(nic: String, completion:@escaping (Bool,DataSnapshot) -> Void) {
        let ref = self.getDBReference()
        ref.child("students").child(nic).observeSingleEvent(of: .value, with: {
            snapshot in
            if snapshot.hasChildren(){
                completion(true,snapshot)
            } else {
                completion(false,snapshot)
            }
        })
    }
    
    //Method to set the authentication account for the user
    fileprivate func setupAuthenticationAccount(email: String, password: String, completion: @escaping (Bool) -> Void){
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
    
    //Method which creates a new User node in the Realtime Database
    fileprivate func createUser(user: User, completion: @escaping (Bool, String?, User?) -> Void){
        let ref = self.getDBReference()
        var user = user
        user.TIMESTAMP = Date().currentTimeMillis()
        user.joinedDate = String(user.TIMESTAMP ?? 0000)
        user.status = 1
        
        //Creating a user DICTIONARY object to store in DB
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
        
        //Saving user node in DB
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
    
    //Method which uploads a imageFile (Profile Image) of user while compressing it by 50%
    fileprivate func uploadProfileImage(image: UIImage?, studentID : String, completion: @escaping (String) -> Void) {
        //0.5 = compression quality
        if let uploadData = image?.jpegData(compressionQuality: 0.5) {
            let ref = getStorageReference()
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            //sending the imagedata to firebase storage
            uploadTask =  ref.child("studentProfile/").child(Auth.auth().currentUser?.uid ?? studentID).putData(uploadData, metadata: metaData) {
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
        guard dbRef != nil else {
            dbRef = Database.database().reference()
            return dbRef
        }
        return dbRef
    }
    
    //MARK: - Retrieve the storage reference
    
    private func getStorageReference() -> StorageReference {
        guard storageRef != nil else {
            storageRef = Storage.storage().reference()
            return storageRef
        }
        return storageRef
    }
    

}

//MARK: - List of Protocols

protocol FirebaseActions {
    func isSignUpSuccessful(user: User?)
    func isExisitingUser(error: String)
    func isSignUpFailedWithError(error: Error)
    func isSignUpFailedWithError(error: String)
    
    func onUserNotRegistered(error: String)
    func onUserSignInSuccess(user: User?)
    func onUserSignInFailedWithError(error: Error)
    func onUserSignInFailedWithError(error: String)
    
    func onOperationsCancelled()
}

//MARK: - Set of Protocol extensions

extension FirebaseActions {
    func isSignUpSuccessful(user: User?){}
    func isExisitingUser(error: String){}
    func isSignUpFailedWithError(error: Error){}
    func isSignUpFailedWithError(error: String){}
    
    func onUserNotRegistered(error: String){}
    func onUserSignInSuccess(user: User?){}
    func onUserSignInFailedWithError(error: Error){}
    func onUserSignInFailedWithError(error: String){}
    
    func onOperationsCancelled(){}
}

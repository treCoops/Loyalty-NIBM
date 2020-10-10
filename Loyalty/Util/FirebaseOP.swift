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
    
}

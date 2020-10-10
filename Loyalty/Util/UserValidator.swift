//
//  UserValidator.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation
import Alamofire

class UserValidator {
    static func validateUser(_ nic: String, completion: @escaping (String) -> Void){
        
        AF.request(NIBMAuth.authUrl+nic).responseString(completionHandler: {
            response in
            guard let response = response.value else {
                return
            }
            completion(response)
        })
    }
}

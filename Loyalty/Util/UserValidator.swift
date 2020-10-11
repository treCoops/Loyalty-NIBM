//
//  UserValidator.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Utility class to check whether the entered NIC is registered with NIBM
 */

import Foundation
import Alamofire

class UserValidator {
    
    //Perform a HTTPRequest to NIBM API and retrieve the result
    //result -> true [NIC is registered at NIBM]
    //result -> false [NIC is not-registered at NIBM]
    static func validateUser(_ nic: String, completion: @escaping (String) -> Void){
        
        //Perform Alamofire request
        AF.request(NIBMAuth.authUrl+nic).responseString(completionHandler: {
            response in
            guard let response = response.value else {
                return
            }
            completion(response)
        })
    }
}

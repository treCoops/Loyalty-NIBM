//
//  InputFieldValidator.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/11/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Utitlity class to validate the inputFields
 */

import Foundation

class InputFieldValidator {
    
    //MARK: - Regular Expressions

    static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let nameRegEx = "[A-Za-z ]{2,100}"
    static let NICRegEx = "^([0-9]{9}[x|X|v|V]|[0-9]{12})$"
    static let mobileRegex = "^(0)?(?:7(0|1|2|5|6|7|8)\\d)\\d{6}$"
    
    //Validate the Email address with Regex
    static func isValidEmail(_ email: String) -> Bool {
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //Validate the Name of a person with Regex
    static func isValidName(_ name: String) -> Bool{
        let compRegex = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return compRegex.evaluate(with: name)
    }
    
    //Validate the NIC no. with Regex
    static func isValidNIC(_ nic: String) -> Bool {
        let NicPred = NSPredicate(format:"SELF MATCHES %@", NICRegEx)
        return NicPred.evaluate(with: nic)
    }
    
    //Validates the passwords and checks it meets the requirements [MIN_LENGTH, MAX_LENGTH]
    static func isValidPassword(pass: String, minLength: Int, maxLength: Int) -> Bool {
        return pass.count >= minLength && pass.count <= maxLength
    }
    
    //Validates the mobile no
    static func isValidMobileNo(mobileNo: String) -> Bool{
        let mobPred = NSPredicate(format:"SELF MATCHES %@", mobileRegex)
        return mobPred.evaluate(with: mobileNo)
    }
    
    //Checks the length matches to the provided requirement
    static func checkLength(_ text: String, _ count: Int) -> Bool{
        return text.count >= count
    }
    
    //Check if the provided data is EMPTY or NULL
    static func isEmptyOrNil(_ text: String?) -> Bool {
        if text == "" || text == nil{
            return true
        }else{
            return false
        }
    }
}

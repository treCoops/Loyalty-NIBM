//
//  InputFieldValidator.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/11/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation

class InputFieldValidator {
    static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let nameRegEx = "[A-Za-z ]{2,100}"
    static let NICRegEx = "^([0-9]{9}[x|X|v|V]|[0-9]{12})$"
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidName(_ name: String) -> Bool{
        let compRegex = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return compRegex.evaluate(with: name)
    }
    
    static func isValidNIC(_ nic: String) -> Bool {
        let NicPred = NSPredicate(format:"SELF MATCHES %@", NICRegEx)
        return NicPred.evaluate(with: nic)
    }
    
    static func isValidPassword(pass: String, minLength: Int, maxLength: Int) -> Bool {
        return pass.count >= minLength && pass.count <= maxLength
    }
    
    static func checkLength(_ text: String, _ count: Int) -> Bool{
        return text.count >= count
    }
    
    static func isEmptyOrNil(_ text: String?) -> Bool {
        if text == "" || text == nil{
            return true
        }else{
            return false
        }
    }
}

//
//  TextFieldUtils.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/11/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Utility class to provide additional functionality to UITextFields
 */

import Foundation
import UIKit

extension UITextField {
    
    //Clear the textfield content
    func clearText(){
        self.text = ""
    }
    
    //Display the ERROR inside the textfield
    func displayInlineError(errorString: String){
        self.attributedPlaceholder = NSAttributedString(string: errorString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
}

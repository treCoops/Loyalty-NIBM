//
//  TextFieldUtils.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/11/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func clearText(){
        self.text = ""
    }
    
    func displayInlineError(errorString: String){
        self.attributedPlaceholder = NSAttributedString(string: errorString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
}

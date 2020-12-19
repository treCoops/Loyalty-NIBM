//
//  RoundedTextField.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Custom UIClass to generate a rounded TextField
 */

import UIKit

class RoundedTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    //Generate round corners
    private func setupButton() {
        layer.cornerRadius  = frame.size.height/5
        layer.borderWidth = 0.4
        layer.borderColor = #colorLiteral(red: 0.4319527149, green: 0.371992439, blue: 0.9981315732, alpha: 1)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

}

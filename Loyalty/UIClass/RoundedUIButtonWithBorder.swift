//
//  RoundedUIButtonWithBorder.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class RoundedUIButtonWithBorder: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
        layer.borderWidth = 0.1
        layer.borderColor = #colorLiteral(red: 0.4319527149, green: 0.371992439, blue: 0.9981315732, alpha: 1)
    }


}

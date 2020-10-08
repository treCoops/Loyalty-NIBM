//
//  RoundedImageView.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

   override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    private func setupView() {

       self.layer.borderWidth = 2
       self.layer.masksToBounds = false
       self.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
       self.layer.cornerRadius = self.frame.height / 2
       self.clipsToBounds = true

    }
}

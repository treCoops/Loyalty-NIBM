//
//  SquareImageView.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

extension UIImageView {

   func squareImageView(){
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
    }

}

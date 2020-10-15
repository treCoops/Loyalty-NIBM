//
//  CategoryCollectionViewCell.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/14/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    func configure(imageUrl: String?) {
        if let url = imageUrl {
            imgLogo.kf.setImage(with: URL(string: url))
        }
    }
}

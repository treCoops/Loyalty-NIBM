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
    @IBOutlet weak var lblCategory: UILabel!
    
    func configure(imageUrl: String?, categoryName: String) {
        if let url = imageUrl {
            imgLogo.kf.setImage(with: URL(string: url))
        }
        lblCategory.text = categoryName
    }
}

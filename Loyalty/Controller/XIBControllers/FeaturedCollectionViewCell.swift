//
//  FeaturedCollectionViewCell.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import Kingfisher

class FeaturedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgLogo.squareImageView()
    }
    
    class var reuseIdentifier: String {
        return XIBIdentifier.FeaturedCellReuseable
    }
    class var nibName: String {
        return "FeaturedCollectionViewCell"
    }
    
    func configureCell(Data: Category) {
        if let url = Data.coverImage {
            imgLogo.kf.setImage(with: URL(string: url))
        }
        lblCategory.text = Data.categoryName
    }

}

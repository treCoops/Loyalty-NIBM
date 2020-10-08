//
//  FeaturedCollectionViewCell.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    
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
    
    func configureCell(Data: XIBFeatured) {
        
    }

}

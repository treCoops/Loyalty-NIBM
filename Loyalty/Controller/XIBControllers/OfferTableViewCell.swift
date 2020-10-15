//
//  OfferTableViewCell.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import Kingfisher

class OfferTableViewCell: UITableViewCell {

    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblOfferTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configXIB(data: Offer){
        viewParent.layer.shadowColor = UIColor.lightGray.cgColor
        viewParent.layer.shadowOpacity = 0.3
        viewParent.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewParent.layer.shadowRadius = 10
        viewParent.layer.cornerRadius = 10
        imgBanner.layer.cornerRadius = 10
        imgLogo.layer.cornerRadius = 10
        
        if let bannerURL = data.image, let logoURL = data.profileImageUrl {
            imgBanner.kf.setImage(with: URL(string: bannerURL))
            imgLogo.kf.setImage(with: URL(string: logoURL))
        }
        
        lblOfferTitle.text = data.title
        lblDescription.text = data.offer_description
    }
    
    
}

//
//  VenderOfferTableViewCell.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class VenderOfferTableViewCell: UITableViewCell {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configXIB(data: Vendor){
           
        viewParent.layer.shadowColor = UIColor.lightGray.cgColor
        viewParent.layer.shadowOpacity = 0.3
        viewParent.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewParent.layer.shadowRadius = 10
        viewParent.layer.cornerRadius = 10
        imgBanner.layer.cornerRadius = 10
        imgLogo.layer.cornerRadius = 10
        
        if let url = data.coverImageUrl {
            imgBanner.kf.setImage(with: URL(string: url))
        }
        
        if let url = data.profileImageUrl {
            imgLogo.kf.setImage(with: URL(string: url))
        }
       
        txtTitle.text = data.name
    }
    
}

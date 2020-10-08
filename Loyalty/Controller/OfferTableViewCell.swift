//
//  OfferTableViewCell.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {

    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var txtCategory: UILabel!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configXIB(data: XIBOffer){
           
        viewParent.layer.shadowColor = UIColor.lightGray.cgColor
        viewParent.layer.shadowOpacity = 0.3
        viewParent.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewParent.layer.shadowRadius = 10
        viewParent.layer.cornerRadius = 10
        imgLogo.layer.cornerRadius = 8
       
       
    }
    
    
}

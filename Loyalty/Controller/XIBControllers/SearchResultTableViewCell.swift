//
//  SearchResultTableViewCell.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/15/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    
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
        imgLogo.layer.cornerRadius = 10

        if let url = data.profileImageUrl {
            imgLogo.kf.setImage(with: URL(string: url))
        }

        lblName.text = data.name
        lblCategory.text = data.categoryLabel
    }
    
}

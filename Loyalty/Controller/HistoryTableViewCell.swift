//
//  HistoryTableViewCell.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var txtCategory: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configXIB(data: XIBHistory){
        
        viewParent.layer.shadowColor = UIColor.lightGray.cgColor
        viewParent.layer.shadowOpacity = 0.3
        viewParent.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewParent.layer.shadowRadius = 10
        viewParent.layer.cornerRadius = 10
        imgLogo.layer.cornerRadius = 8
        
        
    }
    
}

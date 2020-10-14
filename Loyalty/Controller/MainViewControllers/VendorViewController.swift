//
//  VendorViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class VendorViewController: UIViewController {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tableViewVenderOffers: UITableView!
    
    var offers : [XIBVendorOffer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLogo.squareImageView()
        
        tableViewVenderOffers.register(UINib(nibName: XIBIdentifier.XIB_OFFER_VENDOR, bundle: nil), forCellReuseIdentifier: XIBIdentifier.XIB_OFFER_VENDOR_CELL)
        
        offers.append(XIBVendorOffer(bannerImageUrl: "", title: "", status: true, Id: ""))
        offers.append(XIBVendorOffer(bannerImageUrl: "", title: "", status: true, Id: ""))
        offers.append(XIBVendorOffer(bannerImageUrl: "", title: "", status: true, Id: ""))
        offers.append(XIBVendorOffer(bannerImageUrl: "", title: "", status: true, Id: ""))
        offers.append(XIBVendorOffer(bannerImageUrl: "", title: "", status: true, Id: ""))
        offers.append(XIBVendorOffer(bannerImageUrl: "", title: "", status: true, Id: ""))
        offers.append(XIBVendorOffer(bannerImageUrl: "", title: "", status: true, Id: ""))
        offers.append(XIBVendorOffer(bannerImageUrl: "", title: "", status: true, Id: ""))

    }


}


extension VendorViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewVenderOffers.dequeueReusableCell(withIdentifier: XIBIdentifier.XIB_OFFER_VENDOR_CELL, for: indexPath) as! VenderOfferTableViewCell
               cell.configXIB(data: offers[indexPath.row])
               
               cell.alpha = 0
               UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                   cell.alpha = 1
               })
               
               return cell
    }
    
    
}

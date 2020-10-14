//
//  SearchViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var Promotions : [XIBPromotion] = []
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tblPromotions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.roundView()
        
        tblPromotions.register(UINib(nibName: XIBIdentifier.XIB_PROMOTION, bundle: nil), forCellReuseIdentifier: XIBIdentifier.XIB_PROMOTION_CELL)
        
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        Promotions.append(XIBPromotion(logoUrl: "" , title: "", category: ""))
        
    }
    

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Promotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPromotions.dequeueReusableCell(withIdentifier: XIBIdentifier.XIB_PROMOTION_CELL, for: indexPath) as! PromotionTableViewCell
               cell.configXIB(data: Promotions[indexPath.row])
               
               cell.alpha = 0
               UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                   cell.alpha = 1
               })
               
               return cell
    }
    
    
}

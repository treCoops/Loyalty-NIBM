//
//  HistoryViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var Histories : [XIBHistory] = []
    
    @IBOutlet weak var tblViewHistory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewHistory.register(UINib(nibName: XIBIdentifier.XIB_HISTORY, bundle: nil), forCellReuseIdentifier: XIBIdentifier.XIB_HISTORY_CELL)
        
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
        Histories.append(XIBHistory(logoUrl: "", title: "", category: "", date: "", status: false))
    }
    


}

extension HistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewHistory.dequeueReusableCell(withIdentifier: XIBIdentifier.XIB_HISTORY_CELL, for: indexPath) as! HistoryTableViewCell
               cell.configXIB(data: Histories[indexPath.row])
               
               cell.alpha = 0
               UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                   cell.alpha = 1
               })
               
               return cell
    }
    
    
}

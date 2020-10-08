//
//  ResetPasswordViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewParent.roundView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    


}

//
//  LunchScreenViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class LunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        performSegue(withIdentifier: Seagus.lunchScreenToSignIn, sender: nil)
    }

}

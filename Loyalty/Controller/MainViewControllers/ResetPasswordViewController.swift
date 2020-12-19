//
//  ResetPasswordViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import Lottie

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var lottieView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottieView.contentMode = .scaleToFill
        lottieView.loopMode = .loop
        lottieView.play()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

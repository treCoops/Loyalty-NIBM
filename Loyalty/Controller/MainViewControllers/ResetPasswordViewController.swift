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
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewParent.roundView()
        lottieView.loopMode = .loop
        lottieView.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    @IBAction func resetPressed(_ sender: UIButton) {
    }
    
}

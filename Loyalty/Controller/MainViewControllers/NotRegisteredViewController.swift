//
//  NotRegisteredViewController.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/23/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import Lottie

class NotRegisteredViewController: UIViewController {
    
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
    
    @IBAction func gotoWeb(_ sender: UIButton) {
        guard let url = URL(string: "https://www.nibm.lk") else { return }
        UIApplication.shared.open(url)
    }
}

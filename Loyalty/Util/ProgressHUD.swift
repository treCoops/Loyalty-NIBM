//
//  ProgressHUD.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation
import UIKit

class ProgressHUD {
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    let view : UIView
    
    init(view : UIView) {
        self.view = view
        activityIndicator.backgroundColor = UIColor.systemGray4
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
    }
    
    func displayProgressHUD(){
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
    }
    
    func dismissProgressHUD() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}

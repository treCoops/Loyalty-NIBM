//
//  ProgressHUD.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Display a progressView when ongoing networking process
 */

import Foundation
import UIKit

class ProgressHUD {
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    let view : UIView
    
    //Constructer to innitialize progressView
    init(view : UIView) {
        self.view = view
        activityIndicator.backgroundColor = UIColor.systemGray4
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
    }
    
    //Display progress HUD at center of screen
    func displayProgressHUD(){
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
    }
    
    //Dismiss progress HUD
    func dismissProgressHUD() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}

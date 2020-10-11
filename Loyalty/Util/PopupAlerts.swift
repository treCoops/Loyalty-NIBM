//
//  PopupAlerts.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/11/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation
import UIKit

class PopupAlerts {
    
    var alert: UIAlertController!
    static var instance = PopupAlerts()
    
    private init() {}
    
    func createAlert(title: String, message : String) -> Self {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return self
    }
    
    func addAction(title: String, handler: @escaping (UIAlertAction) -> Void) -> Self {
        self.alert.addAction(UIAlertAction(title: title, style: .default, handler: handler))
        return self
    }
    
    func displayAlert() -> UIAlertController {
        return self.alert
    }
}

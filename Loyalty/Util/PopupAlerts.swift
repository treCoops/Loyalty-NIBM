//
//  PopupAlerts.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/11/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Utility class to display simple popup dialogs including networkLost popup dialog
 */

import Foundation
import UIKit

class PopupAlerts {
    
    var alert: UIAlertController!
    var networkLostAlert: UIAlertController!
    //Class instance
    static var instance = PopupAlerts()
    
    //Make Singleton
    fileprivate init() {}
    
    //Create an alert with providing title and body
    func createAlert(title: String, message : String) -> Self {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return self
    }
    
    //Add an action button to the alertview
    func addAction(title: String, handler: @escaping (UIAlertAction) -> Void) -> Self {
        self.alert.addAction(UIAlertAction(title: title, style: .default, handler: handler))
        return self
    }
    
    //Returns and display the alert
    func displayAlert() -> UIAlertController {
        return self.alert
    }
    
    func displayNetworkLostAlert() -> UIAlertController {
        guard networkLostAlert != nil else {
            self.networkLostAlert = UIAlertController(title: FieldErrorCaptions.noConnectionTitle, message: FieldErrorCaptions.noConnectionMessage, preferredStyle: .alert)
            self.networkLostAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.networkLostAlert
        }
        
        return self.networkLostAlert
    }
    
    func dismissNetworkLostAlert(){
        guard networkLostAlert != nil else {
            return
        }
        self.networkLostAlert.dismiss(animated: true, completion: nil)
    }
}

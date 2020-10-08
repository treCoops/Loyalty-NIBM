//
//  SignUpOneViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class SignUpOneViewController: UIViewController {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var txtFullName: RoundedTextField!
    @IBOutlet weak var txtStudentID: RoundedTextField!
    @IBOutlet weak var txtNIC: RoundedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewParent.roundView()
        

    
    }
    

}

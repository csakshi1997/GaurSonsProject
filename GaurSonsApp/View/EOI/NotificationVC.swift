//
//  NotificationVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 28/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet var notificationBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        notificationBtn?.layer.cornerRadius = 22.5
    }
    

    @IBAction func homeAction() {
        Utility.gotoTabbar()
    }

}

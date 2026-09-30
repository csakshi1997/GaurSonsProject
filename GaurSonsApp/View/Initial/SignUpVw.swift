//
//  SignUpVw.swift
//  GaurSonsApp
//
//  Created by Sakshi on 06/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import WebKit

class SignUpVw: UIViewController {
    @IBOutlet weak var wkWebView: WKWebView?
    @IBOutlet weak var topVw: UIView?
    @IBOutlet weak var backBtn: UIButton?
    @IBOutlet var topText: UILabel?
    @IBOutlet var topViewHeight: NSLayoutConstraint?
    var urlString : String = EMPTY
    var headingLbl : String = EMPTY
    var isSignupTrue: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitialUI()
        print("URL =", urlString)

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            wkWebView?.load(request)
        }
    }
    
    func InitialUI() {
//        if isSignupTrue {
            topViewHeight?.constant = 110
            topVw?.backgroundColor = ColorConstant.primary
            topText?.text = headingLbl
//        } else {
//            topViewHeight?.constant = 0
//        }
        
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

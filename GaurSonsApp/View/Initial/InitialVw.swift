//
//  InitialVw.swift
//  GaurSonsApp
//
//  Created by Sakshi on 06/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import SalesforceSDKCore

class InitialVw: UIViewController {
    @IBOutlet var loginBtn: UIButton?
    @IBOutlet var createNewAccountBtn: UIButton?
    @IBOutlet var privacyPolicyLbl: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupPrivacyLabel()
    }
    
    func setupPrivacyLabel() {
        let fullText = "By continuing you agree to our\nTerms & Conditions and Privacy Policy"

        let attributedString = NSMutableAttributedString(string: fullText)
        let greenColor = ColorConstant.primary

        let termsRange = (fullText as NSString).range(of: "Terms & Conditions")
        let privacyRange = (fullText as NSString).range(of: "Privacy Policy")

        attributedString.addAttribute(.foregroundColor, value: greenColor, range: termsRange)
        attributedString.addAttribute(.foregroundColor, value: greenColor, range: privacyRange)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4

        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: fullText.count))

        privacyPolicyLbl?.attributedText = attributedString
        privacyPolicyLbl?.numberOfLines = 0
        privacyPolicyLbl?.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        privacyPolicyLbl?.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let text = label.attributedText?.string else { return }
        
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedText(in: label, inRange: termsRange) {
            print("Terms clicked")
            termConditionTapped()
        } else if gesture.didTapAttributedText(in: label, inRange: privacyRange) {
            print("Privacy clicked")
            privacyPolicyTapped()
        }
    }
    
    func setUpUI() {
        createNewAccountBtn?.backgroundColor = ColorConstant.buttonBackgroundLightColor
        loginBtn?.borderWidth = 1
        loginBtn?.borderColor = ColorConstant.buttonBorderColor
        loginBtn?.layer.cornerRadius = 8
        createNewAccountBtn?.layer.cornerRadius = 8
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        UserAccountManager.shared.loginHost = kLoginHost
        
        print(UserAccountManager.shared.loginHost)
        print("🔹 Login button clicked, showing Salesforce login...")
        
        AuthHelper.loginIfRequired {
            print("✅ Login completed")
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.setupRootViewController()
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        if let signupVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVw") as? SignUpVw {
            signupVC.urlString = "https://nosoftware-page-2575--dev.sandbox.my.site.com/s/registration"
            signupVC.isSignupTrue = true
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
   func privacyPolicyTapped() {
        if let privacyPolicy = storyboard?.instantiateViewController(withIdentifier: "SignUpVw") as? SignUpVw {
            privacyPolicy.urlString = "https://www.gaursonsindia.com/pdfs/Privacy-Policy-For-Mobile-App.pdf"
            privacyPolicy.isSignupTrue = false
            self.navigationController?.pushViewController(privacyPolicy, animated: true)
        }
    }
    
    func termConditionTapped() {
        if let termCondition = storyboard?.instantiateViewController(withIdentifier: "SignUpVw") as? SignUpVw {
            termCondition.urlString = "https://www.gaursonsindia.com/pdfs/Terms-and-Conditions-For-Mobile-App.pdf"
            termCondition.isSignupTrue = false
            self.navigationController?.pushViewController(termCondition, animated: true)
        }
    }
}


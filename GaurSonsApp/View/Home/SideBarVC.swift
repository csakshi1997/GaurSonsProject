//
//  SideBarVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 12/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit

class SideBarVC: UIViewController {
    @IBOutlet var vw: UIView?
    @IBOutlet var BottomVw: UIView?
    @IBOutlet var profileVw: UIView?
    @IBOutlet var profileIconBtn: UIButton?
    @IBOutlet var userNameLbl: UILabel?
    @IBOutlet var subHeadingLbl: UILabel?
    @IBOutlet var menuCrossBtn: UIButton?
    @IBOutlet var homeBtn: UIButton?
    @IBOutlet var eoiBtn: UIButton?
    @IBOutlet var inventoryBtn: UIButton?
    @IBOutlet var helpBtn: UIButton?
    @IBOutlet var privacyBtn: UIButton?
    @IBOutlet var termBtn: UIButton?
    @IBOutlet var versionLbl: UILabel?
    var tabBarView: TabbarView?
    var inventoryVCView: InventoryVC?
    var qrView: QR?
    var signup: SignUpVw?
    var profileVC: ProfileVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
            statusBarView.backgroundColor = ColorConstant.screensBackgroundColor
            view.addSubview(statusBarView)
        }
    }
    
    func setUpUI() {
        vw?.backgroundColor = ColorConstant.screensBackgroundColor
        BottomVw?.backgroundColor = ColorConstant.screensBackgroundColor
        userNameLbl?.textColor = ColorConstant.textColor
        userNameLbl?.text = Defaults.name
//        subHeadingLbl?.text = Defaults.networkName
        profileVw?.layer.cornerRadius = 8
        profileIconBtn?.layer.cornerRadius = 22.5
        profileIconBtn?.setImage(UIImage(named: "profile_redish"), for: .normal)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
        versionLbl?.text = "App Version - v\(appVersion) (\(buildNumber))"
        
    }
    
    func checkInternetConnection(storyBoardName : UIViewController) {
        if InternetConnectionManager.isConnectedToNetwork(){
            navigationController?.pushViewController(storyBoardName, animated: true)
        }else{
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func menuCrossbtnTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.x = -self.view.frame.width
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func homebtnTapped(_ sender: UIButton) {
        self.dismiss(animated: false)
        Utility.gotoTabbar()
    }
    
    @IBAction func eoiebtnTapped() {
        self.dismiss(animated: false)
        Utility.gotoEoi()
    }
    
    @IBAction func InventoryTapped() {
        self.dismiss(animated: false)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Inventory", bundle:nil)
        inventoryVCView = storyBoard.instantiateViewController(withIdentifier: "InventoryVC") as? InventoryVC
        SceneDelegate.getSceneDelegate().navigationController = UINavigationController(rootViewController: inventoryVCView ?? InventoryVC())
        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true
        SceneDelegate.getSceneDelegate().window!.rootViewController = SceneDelegate.getSceneDelegate().navigationController
    }
    
    @IBAction func qrTapped() {
        self.dismiss(animated: false)
        let storyBoard : UIStoryboard = UIStoryboard(name: "QR", bundle:nil)
        qrView = storyBoard.instantiateViewController(withIdentifier: "QR") as? QR
        SceneDelegate.getSceneDelegate().navigationController = UINavigationController(rootViewController: qrView ?? QR())
        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true
        SceneDelegate.getSceneDelegate().window!.rootViewController = SceneDelegate.getSceneDelegate().navigationController
    }
    
    @IBAction func customerbtnTapped() {
        self.dismiss(animated: false)
        Utility.gotoCustomers()
    }
    
    @IBAction func termbtnTapped() {

        self.dismiss(animated: false)

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpVw") as? SignUpVw {

            signup.urlString = "https://www.gaursonsindia.com/pdfs/Terms-and-Conditions-For-Mobile-App.pdf"
            signup.isSignupTrue = false
            signup.headingLbl = "Term & Conditions"

            SceneDelegate.getSceneDelegate().navigationController?.pushViewController(signup, animated: true)
        }
    }

    @IBAction func  btnTapped() {

        self.dismiss(animated: false)

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpVw") as? SignUpVw {

            signup.urlString = "https://www.gaursonsindia.com/pdfs/Privacy-Policy-For-Mobile-App.pdf"
            signup.isSignupTrue = false
            signup.headingLbl = "Privacy Policy"

            SceneDelegate.getSceneDelegate().navigationController?.pushViewController(signup, animated: true)
        }
    }
    
    
    @IBAction func helpbtnTapped() {
       
    }
    
    @IBAction func editProfileAction() {
        self.dismiss(animated: false)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
        profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
        SceneDelegate.getSceneDelegate().navigationController = UINavigationController(rootViewController: profileVC ?? ProfileVC())
        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true
        SceneDelegate.getSceneDelegate().window!.rootViewController = SceneDelegate.getSceneDelegate().navigationController
    }
    
    @IBAction func logoutTapped() {
        let comingSoonAlert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        self.present(comingSoonAlert, animated: true, completion: nil)
        comingSoonAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            Utility.logoutAction()
        }))
    }

}

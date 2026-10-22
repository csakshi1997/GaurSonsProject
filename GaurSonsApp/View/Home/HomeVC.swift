//
//  HomeVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 12/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.


import UIKit
import SideMenu
import SalesforceSDKCore
import FSPagerView
import SDWebImage

class HomeVC: UIViewController {
    @IBOutlet var mainVw: UIView?
    @IBOutlet var topView: UIView?
    @IBOutlet var menuBtn: UIButton?
    @IBOutlet var notificationBtn: UIButton?
    @IBOutlet var backgroundView: UIView?
    @IBOutlet var BottomVw: UIView?
    @IBOutlet var profileVw: UIView?
    @IBOutlet var profileIconBtn: UIButton?
    @IBOutlet var editIconBtn: UIButton?
    @IBOutlet var userNameLbl: UILabel?
    @IBOutlet var subHeadingLbl: UILabel?
    @IBOutlet var bannerImg: UIImageView?
    @IBOutlet var eoiStatusHeadingLbl: UILabel?
    @IBOutlet var eoiStatusVw: UIView?
    @IBOutlet var totalEoiDigitLbl: UILabel?
    @IBOutlet var totalEoiLbl: UILabel?
    @IBOutlet var EoiInProgessTextLbl: UILabel?
    @IBOutlet var eoiInProgessVw: UIView?
    @IBOutlet var EoiInProgessDigitLbl: UILabel?
    @IBOutlet var EoiInCompletedTextLbl: UILabel?
    @IBOutlet var EoiInCompletedDigitLbl: UILabel?
    @IBOutlet var eoiInCompletedVw: UIView?
    @IBOutlet var EoiInCancelledTextLbl: UILabel?
    @IBOutlet var eoiInCancelledVw: UIView?
    @IBOutlet var EoiInCancelledDigitLbl: UILabel?
    @IBOutlet var totalRegisterVw: UIView?
    @IBOutlet var totalRegisterDigitLbl: UILabel?
    @IBOutlet var totalRegisterLbl: UILabel?
    @IBOutlet var totalBookingVw: UIView?
    @IBOutlet var ttotalBookingDigitLbl: UILabel?
    @IBOutlet var totalBookingLbl: UILabel?
    @IBOutlet weak var pagerView: FSPagerView!
    var imageNames = ["Banner1", "Banner2", "Banner3"]
    var sideMenuVC: SideBarVC?
    var userWebService = UserWebService()
    var eOIWebServices = EOIWebServices()
    var accountWebServices = AccountWebServices()
    var registerCount: String = EMPTY
    var bookedCount: String = EMPTY
    var totalCustomerCount: String = EMPTY
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Instance URL::: \(Defaults.instanceUrl ?? "")")

        // Fetch the logged-in Salesforce user's details.
        userWebService.fetchCurrentSalesforceUserDetails { [weak self] error, response, statusCode in

            guard let self = self else { return }

            if statusCode == .success {
                let responseDict = response ?? [:]

                Defaults.name = responseDict["Name"] as? String
                Defaults.userEmail = responseDict["Email"] as? String
                Defaults.userName = responseDict["Username"] as? String

                DispatchQueue.main.async {
                    self.setUpUI()
                }
            }
        }

        accountWebServices.getUserAccId(
            ApplicantId: Defaults.userId ?? EMPTY
        ) { [weak self] error, response, status in

            guard let self = self else { return }

            guard status == .success else {
                print("Failed to fetch User Account ID: \(error ?? "Unknown error")")
                return
            }

            guard let response = response,
                  let records = response["records"] as? [[String: Any]],
                  let firstRecord = records.first,
                  let account = firstRecord["Account"] as? [String: Any],
                  let accountId = account["Id"] as? String else {

                print("Account ID not found in API response")
                return
            }

            // Save Account ID
            Defaults.userAccountId = accountId

            print("Saved Account ID: \(Defaults.userAccountId ?? EMPTY)")

            // Call dashboard APIs after saving Account ID
            DispatchQueue.main.async {
                self.fetchHomeDashboardData()
            }
        }

        // Configure banner pager.
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(
            FSPagerViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3.0
        pagerView.interitemSpacing = -20
        pagerView.itemSize = CGSize(
            width: pagerView.frame.width * 0.75,
            height: pagerView.frame.height * 0.9
        )
        pagerView.transformer = FSPagerViewTransformer(type: .linear)

        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Defaults.type = EMPTY
        Defaults.isIndividualEnable = false
        Defaults.opportunityId = EMPTY
        OpportunityManager.shared.applicants.removeAll()
        fetchUserDetails()
        pagerView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
            statusBarView.backgroundColor = ColorConstant.screensBackgroundColor
            view.addSubview(statusBarView)
        }
    }
    
    private func fetchHomeDashboardData() {

        // 1. Fetch Networks
        eOIWebServices.getNetworks { error, networks, status in

            if status == .success, let networks = networks {
                if let firstNetwork = networks.first {
                    Defaults.networkId = firstNetwork.Id
                    Defaults.networkName = firstNetwork.Name

                    print("Network ID: \(firstNetwork.Id)")
                    print("Network Name: \(firstNetwork.Name)")
                }
            } else {
                print("Error fetching networks: \(error ?? "Unknown")")
            }
        }

        // 2. Fetch Total EOI Count
        eOIWebServices.getTotalEOICount { [weak self] errorMsg, count, status in

            DispatchQueue.main.async {
                switch status {
                case .success:
                    if let count = count {
                        self?.totalEoiDigitLbl?.text = "\(count)"
                    }

                case .error, .tokenExpired:
                    print("Total EOI Error: \(errorMsg ?? "Unknown error")")

                default:
                    break
                }
            }
        }

        // 3. Fetch In-Progress EOI Count
        eOIWebServices.getProgressEOICount { [weak self] errorMsg, count, status in

            DispatchQueue.main.async {
                switch status {
                case .success:
                    if let count = count {
                        self?.EoiInProgessDigitLbl?.text = "\(count)"
                    }

                case .error, .tokenExpired:
                    print("In-Progress EOI Error: \(errorMsg ?? "Unknown error")")

                default:
                    break
                }
            }
        }

        // 4. Fetch Completed EOI Count
        eOIWebServices.getCompletedEOICount { [weak self] errorMsg, count, status in

            DispatchQueue.main.async {
                switch status {
                case .success:
                    if let count = count {
                        self?.EoiInCompletedDigitLbl?.text = "\(count)"
                    }

                case .error, .tokenExpired:
                    print("Completed EOI Error: \(errorMsg ?? "Unknown error")")

                default:
                    break
                }
            }
        }

        // 5. Fetch Cancelled EOI Count
        eOIWebServices.getCancelledEOICount { [weak self] errorMsg, count, status in

            DispatchQueue.main.async {
                switch status {
                case .success:
                    if let count = count {
                        self?.EoiInCancelledDigitLbl?.text = "\(count)"
                    }

                case .error, .tokenExpired:
                    print("Cancelled EOI Error: \(errorMsg ?? "Unknown error")")

                default:
                    break
                }
            }
        }

        // 6. Fetch Registered Customers Count
        eOIWebServices.getRegisteredCount { [weak self] errorMsg, count, status in

            DispatchQueue.main.async {
                switch status {
                case .success:
                    if let count = count {
                        self?.totalRegisterDigitLbl?.text = "\(count)"
                        self?.registerCount = "\(count)"
                    }

                case .error, .tokenExpired:
                    print("Registered Customers Error: \(errorMsg ?? "Unknown error")")

                default:
                    break
                }
            }
        }

        // 7. Fetch Booked Customers Count
        eOIWebServices.getBookedCustomersCount { [weak self] errorMsg, count, status in

            DispatchQueue.main.async {
                switch status {
                case .success:
                    if let count = count {
                        self?.ttotalBookingDigitLbl?.text = "\(count)"
                        self?.bookedCount = "\(count)"
                    }

                case .error, .tokenExpired:
                    print("Booked Customers Error: \(errorMsg ?? "Unknown error")")

                default:
                    break
                }
            }
        }
        
        eOIWebServices.getAllCustomersCount { [weak self] errorMsg, count, status in

            DispatchQueue.main.async {
                switch status {
                case .success:
                    if let count = count {
                        self?.totalCustomerCount = "\(count)"
                    }

                case .error, .tokenExpired:
                    print("Booked Customers Error: \(errorMsg ?? "Unknown error")")

                default:
                    break
                }
            }
        }
    }
    
    func fetchUserDetails() {
        if let user = UserAccountManager.shared.currentUserAccount {
            print(user)
            let credentials = user.credentials
            print("Access Token::: \(credentials.accessToken ?? "")")
            print("USer Id::: \(Defaults.userId ?? "")")
            Defaults.accessToken = credentials.accessToken
            Defaults.refreshToken = credentials.refreshToken
            Defaults.instanceUrl = credentials.instanceUrl?.absoluteString
            Defaults.userId = credentials.userId
            Defaults.domain = credentials.domain
            if let issuedAtDate = credentials.issuedAt {
                let formatter = ISO8601DateFormatter()
                Defaults.issuedAt = formatter.string(from: issuedAtDate)
            }
            Defaults.organizationId = credentials.organizationId ?? ""
        }
    }
    
    func setUpUI() {
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        BottomVw?.backgroundColor = ColorConstant.screensBackgroundColor
        userNameLbl?.textColor = ColorConstant.textColor
        userNameLbl?.text = "Welcome! \(Defaults.name ?? EMPTY)"
        subHeadingLbl?.textColor = ColorConstant.textColor
//        subHeadingLbl?.text = Defaults.networkName
        eoiStatusHeadingLbl?.textColor = ColorConstant.textColor
        totalEoiDigitLbl?.textColor = ColorConstant.textColor
        totalEoiLbl?.textColor = ColorConstant.textColor
        EoiInProgessTextLbl?.textColor = ColorConstant.textColor
        EoiInProgessDigitLbl?.textColor = ColorConstant.textColor
        EoiInCompletedTextLbl?.textColor = ColorConstant.textColor
        EoiInCompletedDigitLbl?.textColor = ColorConstant.textColor
        EoiInCancelledTextLbl?.textColor = ColorConstant.textColor
        EoiInCancelledDigitLbl?.textColor = ColorConstant.textColor
        totalBookingLbl?.textColor = ColorConstant.textColor
        ttotalBookingDigitLbl?.textColor = ColorConstant.textColor
        totalRegisterLbl?.textColor = ColorConstant.textColor
        totalRegisterDigitLbl?.textColor = ColorConstant.textColor
        profileVw?.layer.cornerRadius = 8
        eoiStatusVw?.cornerRadius = 5
        eoiInProgessVw?.cornerRadius = 5
        eoiInCompletedVw?.cornerRadius = 5
        eoiInCancelledVw?.cornerRadius = 5
        profileIconBtn?.layer.cornerRadius = 20
        profileIconBtn?.setImage(UIImage(named: "profile_redish"), for: .normal)
        print("Auth token \(Defaults.accessToken ?? EMPTY)")
    }

    @IBAction func notificationAction() {
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let SchemeListVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(SchemeListVC, animated: true)
    }
    
    @IBAction func editProfileAction() {
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "Profile", bundle: storyboardBundle)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func addCustomersAction() {
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "QR", bundle: storyboardBundle)
        let QRVC = storyboard.instantiateViewController(withIdentifier: "QR") as! QR
        self.navigationController?.pushViewController(QRVC, animated: true)
    }
    
    @IBAction func inventoryAction() {
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "Inventory", bundle: storyboardBundle)
        let InventoryVC = storyboard.instantiateViewController(withIdentifier: "InventoryVC") as! InventoryVC
        self.navigationController?.pushViewController(InventoryVC, animated: true)
    }
    
//    @IBAction func registeredCustomerAction() {
//        Utility.gotoCustomers()
//    }
//    
//    @IBAction func bookedCustomerAction() {
//        Utility.gotoCustomers()
//    }
    
    @IBAction func registeredCustomerAction() {
        Utility.gotoCustomers(summaryFilter: .registered, count: registerCount)
    }

    @IBAction func bookedCustomerAction() {
        let alert = UIAlertController(
            title: "Access Restricted",
            message: "Channel Partner (CP) users do not have permission to view booked customer details.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
    
//    @IBAction func totalEOIAction() {
//        Utility.gotoEoi()
//    }
//    
//    @IBAction func EOICompletedAction() {
//        Utility.gotoEoi()
//    }
//    
//    @IBAction func EOIInProgressAction() {
//        Utility.gotoEoi()
//    }
//    
//    @IBAction func EOICancelledAction() {
//        Utility.gotoEoi()
//    }
    
    @IBAction func totalEOIAction() {
        Utility.gotoEoi(summaryFilter: .total)
    }

    @IBAction func EOICompletedAction() {
        Utility.gotoEoi(summaryFilter: .completed)
    }

    @IBAction func EOIInProgressAction() {
        Utility.gotoEoi(summaryFilter: .inProgress)
    }

    @IBAction func EOICancelledAction() {
        Utility.gotoEoi(summaryFilter: .cancelled)
    }
    
    func presentFromLeft80Percent(_ vc: UIViewController) {
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = .clear 
        
        let screenWidth = UIScreen.main.bounds.width
        vc.view.frame = CGRect(x: -screenWidth * 0.8,
                               y: 0,
                               width: screenWidth * 0.8,
                               height: UIScreen.main.bounds.height)
        
        present(vc, animated: false) {
            UIView.animate(withDuration: 0.3) {
                vc.view.frame.origin.x = 0
            }
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        if let sideMenuVC = storyboard?.instantiateViewController(withIdentifier: "SideBarVC") as? SideBarVC {
            presentFromLeft80Percent(sideMenuVC)
        }
    }
}

extension HomeVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: imageNames[index])
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        print("Tapped on banner at index: \(index)")
    }
}

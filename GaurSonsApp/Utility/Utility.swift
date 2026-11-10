//
//  Utility.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import UIKit
import AssetsLibrary
import AVFoundation
import SalesforceSDKCore

class Utility {
    static var eoiView: EOIVC?
    static var inventoryView: InventoryVC?
    static var tabbarView: TabbarView?
    static var profileView: ProfileVC?
    static var customerView: CustomersVC?
    static var isMenuOpen : Bool = false
    static var isFromHome : Bool = false
    static var fromOtherScreen : Bool = false
    static var button = UIButton()
    static var containerController : UIViewController?
    static var presentController : UIViewController?
    
    func getActualValue(key : String, dict : [String : Any]) -> String {
        if dict[key] is String {
            return dict[key] as! String
        } else if dict[key] is Int {
            return String(dict[key] as! Int)
        } else if dict[key] is Float {
            return String(format: "%.2f", dict[key] as! Float)
        } else if dict[key] is Double {
            return String(format: "%.2f", dict[key] as! Double)
        } else if dict[key] is Bool {
            return String(dict[key] as! Bool)
        } else {
            return EMPTY
        }
    }
    
    static func getConvertedPoint(_ targetView: UIView, baseView: UIView?) -> CGPoint {
        var pnt = targetView.frame.origin
        if nil == targetView.superview {
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView {
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview {
                break
            } else {
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
    
//    static func gotoTabbar() {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Tabbar", bundle:nil)
//        tabbarView = storyBoard.instantiateViewController(withIdentifier: "TabbarView") as? TabbarView
//        SceneDelegate.getSceneDelegate().navigationController = UINavigationController(rootViewController: tabbarView ?? TabbarView())
//        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true
//        SceneDelegate.getSceneDelegate().window!.rootViewController = SceneDelegate.getSceneDelegate().navigationController
//    }
    
    static func gotoTabbar() {
        DispatchQueue.main.async {

            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)

            guard let tabbarVC = storyboard.instantiateViewController(
                withIdentifier: "TabbarView"
            ) as? TabbarView else {
                print("❌ Unable to instantiate TabbarView")
                return
            }

            guard let sceneDelegate = UIApplication.shared.connectedScenes
                .compactMap({ $0.delegate as? SceneDelegate })
                .first,
                  let window = sceneDelegate.window else {
                print("❌ SceneDelegate window not found")
                return
            }

            let navigationController = UINavigationController(
                rootViewController: tabbarVC
            )

            navigationController.isNavigationBarHidden = true

            sceneDelegate.navigationController = navigationController
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
//    static func gotoEoi() {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Tabbar", bundle:nil)
//        tabbarView = storyBoard.instantiateViewController(withIdentifier: "TabbarView") as? TabbarView
//        tabbarView?.isFromEOI = true
//        SceneDelegate.getSceneDelegate().navigationController = UINavigationController(rootViewController: tabbarView ?? TabbarView())
//        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true
//        SceneDelegate.getSceneDelegate().window!.rootViewController = SceneDelegate.getSceneDelegate().navigationController
//    }
    
    static func gotoEoi(summaryFilter: EOISummaryFilter = .total) {
        let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)

        tabbarView = storyBoard.instantiateViewController(
            withIdentifier: "TabbarView"
        ) as? TabbarView

        tabbarView?.isFromEOI = true
        tabbarView?.eoiSummaryFilter = summaryFilter
        tabbarView?.isEOISummaryFilterApplied = true

        SceneDelegate.getSceneDelegate().navigationController =
            UINavigationController(
                rootViewController: tabbarView ?? TabbarView()
            )

        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true

        SceneDelegate.getSceneDelegate().window?.rootViewController =
            SceneDelegate.getSceneDelegate().navigationController
    }
    
    static func gotoProfile() {
        if let nav = SceneDelegate.getSceneDelegate().navigationController {
            let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
            if let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
                nav.pushViewController(profileVC, animated: true)
            }
        }
    }
    
//    static func gotoCustomers() {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Tabbar", bundle:nil)
//        tabbarView = storyBoard.instantiateViewController(withIdentifier: "TabbarView") as? TabbarView
//        tabbarView?.isFromCustomer = true
//        SceneDelegate.getSceneDelegate().navigationController = UINavigationController(rootViewController: tabbarView ?? TabbarView())
//        SceneDelegate.getSceneDelegate().navigationController?.isNavigationBarHidden = true
//        SceneDelegate.getSceneDelegate().window!.rootViewController = SceneDelegate.getSceneDelegate().navigationController
//    }
    
    static func gotoCustomers(
        summaryFilter: CustomerSummaryFilter = .registered,
        count: String
    ) {
        let storyBoard = UIStoryboard(
            name: "Tabbar",
            bundle: nil
        )

        tabbarView = storyBoard.instantiateViewController(
            withIdentifier: "TabbarView"
        ) as? TabbarView

        tabbarView?.isFromCustomer = true
        tabbarView?.customerSummaryFilter = summaryFilter
        SceneDelegate.getSceneDelegate().navigationController =
            UINavigationController(
                rootViewController: tabbarView ?? TabbarView()
            )

        SceneDelegate.getSceneDelegate()
            .navigationController?
            .isNavigationBarHidden = true

        SceneDelegate.getSceneDelegate()
            .window?
            .rootViewController =
            SceneDelegate.getSceneDelegate().navigationController
    }
    
//    static func logoutAction(isRedirectedToLogin: Bool = true) {
//        if let currentUser = UserAccountManager.shared.currentUserAccount {
//            Defaults.isCheckIn = false
//            UserAccountManager.shared.logout(currentUser)
//        }
//    }
    
    static func logoutAction(isRedirectedToLogin: Bool = true) {
        if let currentUser = UserAccountManager.shared.currentUserAccount {
            Defaults.isCheckIn = false
            UserAccountManager.shared.logout(currentUser)
            Defaults.type = EMPTY
            Defaults.isIndividualEnable = false
            Defaults.isOpportunityIDPresent = false
            Defaults.opportunityId = EMPTY
            OpportunityManager.shared.applicants.removeAll()
        }
        
        if isRedirectedToLogin {
            DispatchQueue.main.async {
                if let window = UIApplication.shared.keyWindow {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialVC = storyboard.instantiateViewController(withIdentifier: "InitialVw")
                    window.rootViewController = initialVC
                    window.makeKeyAndVisible()
                    
                    let options: UIView.AnimationOptions = .transitionFlipFromLeft
                    UIView.transition(with: window, duration: 0.5, options: options, animations: {}, completion: nil)
                }
            }
        }
    }
    
    static func getAllEOIRecordsForAll(outerClosure: @escaping ((Bool) -> ())) -> () {
        let eOIWebServices = EOIWebServices()
        eOIWebServices.getAllEOIForAll {error, response, status in
            if status == .success {
                GlobalData.allEOIModelForAll.removeAll()
                let dict = response ?? [:]
                let EOIDictArray = dict["records"] as? [[String : Any]] ?? []
                for EOIDict in EOIDictArray {
                    GlobalData.allEOIModelForAll.append(EOIModel(dict: EOIDict))
                }
                outerClosure(true)
            } else {
                outerClosure(false)
            }
        }
    }
    
    static func getAllEOIRecords(
        pageNumber: Int,
        summaryFilter: EOISummaryFilter,
        filterType: FilterTypeForEOI,
        outerClosure: @escaping ((Bool) -> ())
    ) {
        
        let eOIWebServices = EOIWebServices()
        
        eOIWebServices.getAllEOI(
            pageNumber: pageNumber,
            summaryFilter: summaryFilter,
            filterType: filterType,
            outerClosure: { error, response, status in
                
                if status == .success {
                    
                    GlobalData.allEOIModel.removeAll()
                    
                    let dict = response ?? [:]
                    let EOIDictArray = dict["records"] as? [[String: Any]] ?? []
                    
                    for EOIDict in EOIDictArray {
                        GlobalData.allEOIModel.append(
                            EOIModel(dict: EOIDict)
                        )
                    }
                    
                    outerClosure(true)
                    
                } else {
                    
                    outerClosure(false)
                }
            }
        )
    }
    
    
    static func getAllApprovalRecords(oppId: String, outerClosure: @escaping ((Bool) -> ())) -> () {
        let paymentWebService = PaymentWebService()
        paymentWebService.getAllApprovalList(oppId: oppId) { error, response, status in
            if status == .success {
                GlobalData.allApprovalModel.removeAll()
                let dict = response ?? [:]
                let approvalDictArray = dict["records"] as? [[String : Any]] ?? []
                for approvalDict in approvalDictArray {
                    GlobalData.allApprovalModel.append(ApprovalModel(dict: approvalDict))
                }
                outerClosure(true)
            } else {
                outerClosure(false)
            }
        }
    }
    
    static func getAllPropertyRecords(oppId: String,
                                       outerClosure: @escaping ((Bool) -> ())) {
        
        let webService = PropertyWebService()
        
        webService.getAllPropertyList(oppId: oppId) { error, response, status in
            
            if status == .success {
                
                GlobalData.allPropertyModel.removeAll()
                
                let dict = response ?? [:]
                let records = dict["records"] as? [[String: Any]] ?? []
                
                for item in records {
                    GlobalData.allPropertyModel.append(PropertyModel(dict: item))
                }
                
                outerClosure(true)
                
            } else {
                outerClosure(false)
            }
        }
    }
    
//    static func getAllCustomerRecords(pageNumber: Int, outerClosure: @escaping ((Bool) -> ())) -> () {
//        let customersWebService = CustomersWebService()
//        customersWebService.getAllCustomers(pageNumber: pageNumber, outerClosure: {error, response, status in
//            if status == .success {
//                GlobalData.allCustomerModel.removeAll()
//                let dict = response ?? [:]
//                let EOIDictArray = dict["records"] as? [[String : Any]] ?? []
//                for EOIDict in EOIDictArray {
//                    GlobalData.allCustomerModel.append(CustomerModel(dict: EOIDict))
//                }
//                outerClosure(true)
//            } else {
//                outerClosure(false)
//            }
//        })
//    }
//
    
    
    static func getAllCustomerRecords(
        pageNumber: Int,
        soqlFilter: String? = nil,
        summaryFilter: CustomerSummaryFilter? = nil,
        outerClosure: @escaping ((Bool) -> ())
    ) {

        let customersWebService = CustomersWebService()

        customersWebService.getAllCustomers(
            pageNumber: pageNumber,
            soqlFilter: soqlFilter,
            summaryFilter: summaryFilter
        ) { error, response, status in

            if status == .success {

                let dict = response ?? [:]
                let customerDictArray =
                    dict["records"] as? [[String: Any]] ?? []

                let newCustomers = customerDictArray.map {
                    CustomerModel(dict: $0)
                }

                if pageNumber == 1 {
                    GlobalData.allCustomerModel.removeAll()
                }

                GlobalData.allCustomerModel.append(contentsOf: newCustomers)

                outerClosure(true)

            } else {

                outerClosure(false)
            }
        }
    }
    
    
    static func getAllInventoryProject(outerClosure: @escaping ((Bool) -> ())) -> () {
        let projectWebServices = ProjectWebServices()
        projectWebServices.getInventoryProjects {error, response, status in
            if status == .success {
                GlobalData.allInventoryProjects.removeAll()
                let dict = response ?? [:]
                let projectArray = dict["records"] as? [[String : Any]] ?? []
                for projectDict in projectArray {
                    GlobalData.allInventoryProjects.append(InventoryProjectModel(dict: projectDict))
                }
                outerClosure(true)
            } else {
                outerClosure(false)
            }
        }
    }
    
    static func getAllProjectDetails(projectId: String,
                                     outerClosure: @escaping ((Bool) -> ())) {
        
        let projectWebServices = ProjectWebServices()
        
        projectWebServices.getProjectDetail(projectId: projectId) { error, response, status in
            
            if status == .success {
                
                GlobalData.allInventoryProjects.removeAll()
                
                let dict = response ?? [:]
                let unitArray = dict["records"] as? [[String: Any]] ?? []
                
                for unitDict in unitArray {
                    GlobalData.allInventoryProjects.append(InventoryProjectModel(dict: unitDict))
                }
                
                outerClosure(true)
                
            } else {
                outerClosure(false)
            }
        }
    }
    
    static func getAllApplicantRecords(oppId: String, outerClosure: @escaping ((Bool) -> ())) -> () {
        let applicantWebService = ApplicantWebService()
        applicantWebService.getApplicantList(oppId: oppId, outerClosure: {error, response, status in
            if status == .success {
                GlobalData.allApplicantRecord.removeAll()
                let dict = response ?? [:]
                let applicantDictArray = dict["records"] as? [[String : Any]] ?? []
                for applicantDict in applicantDictArray {
                    GlobalData.allApplicantRecord.append(ApplicantRecord(dict: applicantDict))
                }
                outerClosure(true)
            } else {
                outerClosure(false)
            }
        })
    }
    
    static func getAllApplicantDetails(applicantId: String, outerClosure: @escaping ((Bool) -> ())) {
        let applicantWebService = ApplicantWebService()
        applicantWebService.getApplicantDetails(ApplicantId: applicantId, outerClosure: { error, response, status in
            if status == .success {
                let dict = response ?? [:]
                let applicantDetailsDictArray = dict["records"] as? [[String: Any]] ?? []
                
                if let firstApplicantDict = applicantDetailsDictArray.first {
                    GlobalData.allApplicantDetailsModel = ApplicantDetailsModel(dict: firstApplicantDict)
                    outerClosure(true)
                } else {
                    outerClosure(false)
                }
            } else {
                outerClosure(false)
            }
        })
    }
    
    static func getAllAccountDetails(outerClosure: @escaping ((Bool) -> ())) {
        let accountWebServices = AccountWebServices()
        accountWebServices.getAccountDetails(ApplicantId: Defaults.userId ?? EMPTY, outerClosure: { error, response, status in
            if status == .success {
                let dict = response ?? [:]
                let accountDetailsDictArray = dict["records"] as? [[String: Any]] ?? []
                
                if let firstAccountDict = accountDetailsDictArray.first {
                    GlobalData.allAccountDetailModel = AccountDetailModel(dict: firstAccountDict)
                    outerClosure(true)
                } else {
                    outerClosure(false)
                }
            } else {
                outerClosure(false)
            }
        })
    }

    
    static func handleSalesforceError(
        _ error: Error,
        completion: @escaping (String?, ResponseStatus) -> Void
    ) {
        
        print("Salesforce API Error:", error)
        
        if let restError = error as? RestClientError {
            
            if case let .apiFailed(response, _, urlResponse) = restError {
                
                // 🔹 Session Expired
                if let httpResponse = urlResponse as? HTTPURLResponse,
                   httpResponse.statusCode == 401 {
                    
                    DispatchQueue.main.async {
                        Utility.logoutAction()
                        completion("Session expired. Please login again.", .tokenExpired)
                    }
                    return
                }
                
                // 🔹 Parse Salesforce Error Message
                if let data = response as? Data {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                       let firstError = json.first,
                       let message = firstError["message"] as? String {
                        
                        DispatchQueue.main.async {
                            completion(message, .error)
                        }
                        return
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(restError.localizedDescription, .error)
            }
            
        } else {
            
            DispatchQueue.main.async {
                completion(error.localizedDescription, .error)
            }
        }
    }
    
    static func handleSalesforceErrorForPayment(
        _ error: Error,
        completion: @escaping (String?, ResponseStatus) -> Void
    ) {
        var errorMessage: String?

        // Extract the actual Salesforce SDK error.
        if let restError = error as? RestClientError {
            switch restError {
            case let .apiFailed(response, underlyingError, _):

                // First, try to extract the message from the underlying error.
                // Extract the actual message from the underlying Salesforce error.
                let underlyingNSError = underlyingError as NSError

                if let message = underlyingNSError.userInfo["message"] as? String,
                   !message.isEmpty {
                    errorMessage = message
                }

                // If unavailable, inspect the response body.
                if errorMessage == nil,
                   let responseObject = response as? Data,
                   let json = try? JSONSerialization.jsonObject(
                       with: responseObject,
                       options: []
                   ) as? [String: Any],
                   let message = json["message"] as? String {
                    errorMessage = message
                }

            default:
                break
            }
        }

        // Fallback: inspect NSError details.
        if errorMessage == nil {
            let nsError = error as NSError

            if let message = nsError.userInfo["message"] as? String,
               !message.isEmpty {
                errorMessage = message
            }
        }

        // Clean the message for the UI.
        let finalMessage: String

        if let message = errorMessage, !message.isEmpty {
            finalMessage = cleanSalesforceMessage(message)
        } else {
            print("Unable to extract Salesforce error:", error)
            finalMessage = "Unable to create payment. Please try again."
        }

        DispatchQueue.main.async {
            completion(finalMessage, .error)
        }
    }

    private static func cleanSalesforceMessage(_ message: String) -> String {
        let prefixes = [
            "Internal Server Error : Error while creating Payment Details:",
            "Internal Server Error:"
        ]

        var result = message.trimmingCharacters(in: .whitespacesAndNewlines)

        for prefix in prefixes where result.hasPrefix(prefix) {
            result = String(result.dropFirst(prefix.count))
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Make approval-process errors easier for users to understand.
        if result.contains("ALREADY_IN_PROCESS") {
            return "This record is already in an approval process. You cannot create another payment while the approval process is in progress. Please contact your administrator for assistance."
        }

        return result
    }
    
    static func showAlert(message: String) {
        
        DispatchQueue.main.async {
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootVC = windowScene.windows.first?.rootViewController else {
                return
            }
            
            let alert = UIAlertController(title: "Alert",
                                          message: message,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            rootVC.present(alert, animated: true)
        }
    }
    
    static func getAllPaymentRecord(oppId: String, outerClosure: @escaping ((Bool) -> ())) -> () {
        let paymentWebService = PaymentWebService()
        paymentWebService.getAllPaymentList(oppId: oppId, outerClosure: {error, response, status in
            if status == .success {
                GlobalData.allPaymentRecord.removeAll()
                let dict = response ?? [:]
                let paymentDictArray = dict["records"] as? [[String : Any]] ?? []
                for paymentDict in paymentDictArray {
                    GlobalData.allPaymentRecord.append(PaymentModel(dict: paymentDict))
                }
                outerClosure(true)
            } else {
                outerClosure(false)
            }
        })
    }
    
    static func getVersionData(contentDocId: String, outerClosure: @escaping ((Bool) -> ())) -> () {
        let fileWebService = FileWebService()
        fileWebService.getVersionDataViaContentDocId(contentDocId: contentDocId, outerClosure: {error, response, status in
            if status == .success {
                let dict = response ?? [:]
                print(dict)
                let versiondataDictArray = dict["records"] as? [[String: Any]] ?? []
                
                if let firstVersionDict = versiondataDictArray.first {
                    GlobalData.allVersionDataModel = VersionDataModel(dict: firstVersionDict)
                    outerClosure(true)
                } else {
                    outerClosure(false)
                }
            } else {
                outerClosure(false)
            }
        })
    }
    
    
    
    static func getAllContentDoc(oppId: String, outerClosure: @escaping ((Bool) -> ())) -> () {
        let fileWebService = FileWebService()
        fileWebService.getContentDoc(oppId: oppId, outerClosure: {error, response, status in
            if status == .success {
                GlobalData.allContentDocModel.removeAll()
                let dict = response ?? [:]
                print(dict)
                let contentDictArray = dict["records"] as? [[String : Any]] ?? []
                for contentDict in contentDictArray {
                    GlobalData.allContentDocModel.append(ContentDocModel(dict: contentDict))
                }
                outerClosure(true)
            } else {
                outerClosure(false)
            }
        })
    }
    
    static func getFileData(contentVersionId: String,
                            outerClosure: @escaping (Data?) -> ()) {
        let fileWebService = FileWebService()
        fileWebService.getFileDataViaVersionId(contentVersionId: contentVersionId) { error, fileData, status in
            if status == .success {
                outerClosure(fileData)
            } else {
                print("File fetch error: \(error ?? "Unknown error")")
                outerClosure(nil)
            }
        }
    }
    
    static func getAllCountries(outerClosure: @escaping ((Bool) -> ())) {
        let locationWS = LocationWebService()
        locationWS.getAllCountries { error, response, status in
            if status == .success, let responseDict = response {
                GlobalData.allCountries.removeAll()

                if let records = responseDict["records"] as? [[String: Any]] {
                    for record in records {
                        let country = LocationModel(dict: record, keyName: "Country__c")
                        GlobalData.allCountries.append(country)
                    }
                }
                outerClosure(true)
            } else {
                print("Error fetching countries: \(error ?? "Unknown")")
                outerClosure(false)
            }
        }
    }
    
    static func getAllStates(country: String, outerClosure: @escaping ((Bool) -> ())) {
        let locationWS = LocationWebService()
        locationWS.getStates(country: country, outerClosure: { error, response, status in
            if status == .success, let responseDict = response {
                GlobalData.allCountries.removeAll()
                
                if let records = responseDict["records"] as? [[String: Any]] {
                    for record in records {
                        let country = LocationModel(dict: record, keyName: "State__c")
                        GlobalData.allCountries.append(country)
                    }
                }
                outerClosure(true)
            } else {
                print("Error fetching countries: \(error ?? "Unknown")")
                outerClosure(false)
            }
        })
    }
    
    static func getAllCities(city: String, outerClosure: @escaping ((Bool) -> ())) {
        let locationWS = LocationWebService()
        locationWS.getCities(state: city, outerClosure: { error, response, status in
            if status == .success, let responseDict = response {
                GlobalData.allCountries.removeAll()
                
                if let records = responseDict["records"] as? [[String: Any]] {
                    for record in records {
                        let country = LocationModel(dict: record, keyName: "City__c")
                        GlobalData.allCountries.append(country)
                    }
                }
                outerClosure(true)
            } else {
                print("Error fetching countries: \(error ?? "Unknown")")
                outerClosure(false)
            }
        })
    }
    
    static func getRecordType(type: String, outerClosure: @escaping ((String?) -> ())) {
        let locationWS = LocationWebService()
        locationWS.getRecordType(type: type, outerClosure: { error, response, status in
            if status == .success, let responseDict = response {
                if let records = responseDict["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let recordId = firstRecord["Id"] as? String {
                    print("✅ RecordType Id: \(recordId)")
                    outerClosure(recordId)
                } else {
                    print("⚠️ RecordType Id not found in response")
                    outerClosure(nil)
                }
            } else {
                print("❌ Error fetching RecordType: \(error ?? "Unknown")")
                outerClosure(nil)
            }
        })
    }
    
    static func getUniqueName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    
    static func getStatus(responseCode: Int) -> ResponseStatus {
        switch responseCode {
        case 200, 201, 203, 204:
            return ResponseStatus.success
        case 409:
            return ResponseStatus.alreadyRegister
        case 500:
            return ResponseStatus.error
        case 401:
            return ResponseStatus.tokenExpired
        case 400:
            return ResponseStatus.badRequest
        default:
            return ResponseStatus.error
        }
    }
    
    static func setRightViewController(containerController: UIViewController, childViewController : UIViewController, isAnimated : Bool, fromOtherSCreen : Bool = false ) {
        self.fromOtherScreen = fromOtherSCreen
        presentController = childViewController
        removeAllChildController(containerController: containerController)
        let navigationController = UINavigationController(rootViewController: childViewController)
        navigationController.isNavigationBarHidden = true
        containerController.addChild(navigationController)
        containerController.view.addSubview(navigationController.view)
        navigationController.view.dropShadow(color: UIColor.black, opacity: 1.0, offSet: CGSize(width: -1, height: 1), radius:0.0, scale: true)
        navigationController.didMove(toParent: containerController)
        isMenuOpen = false
        if isAnimated {
            navigationController.view.frame.origin.x = getSideMenuWidth()
            UIView.animate(withDuration: 0.2, animations: {
                navigationController.view.frame.origin.x = 0
            })
        }
    }
    
    static func tokenExpiredAction() {
        
    }
    
    static func removeAllChildController(containerController: UIViewController) {
        for(_, controller) in containerController.children.enumerated() {
            controller.removeFromParent()
            controller.view.removeFromSuperview()
        }
    }
    
    static var overlayView: UIView?
//    static var sideBarVC: SideBarViewController?

//    static func gotoSideMenu(containerController: UIViewController, isFromHome: Bool = false) {
//        fromOtherScreen = false
//        self.containerController = containerController
//        self.isFromHome = isFromHome
//        if isMenuOpen && !isFromHome {
//            UIView.animate(withDuration: 0.3, animations: {
//                sideBarVC?.view.frame.origin.x = -getSideMenuWidth()
//                overlayView?.alpha = 0
//            }) { _ in
//                sideBarVC?.view.removeFromSuperview()
//                sideBarVC?.removeFromParent()
//                overlayView?.removeFromSuperview()
//                overlayView = nil
//                self.isMenuOpen = false
//            }
//        } else {
//            overlayView = UIView(frame: containerController.view.bounds)
//            overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            overlayView?.alpha = 0
//            containerController.view.addSubview(overlayView!)
//            let storyboard = UIStoryboard(name: "Home", bundle: nil)
//            guard let sideMenu = storyboard.instantiateViewController(withIdentifier: "SideBarViewController") as? SideBarViewController else {
//                print("Failed to load SideBarViewController")
//                return
//            }
//            self.sideBarVC = sideMenu
//            sideMenu.view.frame = CGRect(x: -getSideMenuWidth(), y: 35, width: getSideMenuWidth(), height: containerController.view.frame.height)
//            containerController.addChild(sideMenu)
//            containerController.view.addSubview(sideMenu.view)
//            sideMenu.didMove(toParent: containerController)
//            UIView.animate(withDuration: 0.3, animations: {
//                sideMenu.view.frame.origin.x = 0
//                overlayView?.alpha = 1
//            })
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu))
//            overlayView?.addGestureRecognizer(tapGesture)
//
//            self.isMenuOpen = true
//        }
//    }

//    @objc static func dismissSideMenu() {
//        if !fromOtherScreen {
//            guard containerController != nil else { return }
//            
//            UIView.animate(withDuration: 0.3, animations: {
//                sideBarVC?.view.frame.origin.x = -getSideMenuWidth()
//                overlayView?.alpha = 0
//            }) { _ in
//                sideBarVC?.view.removeFromSuperview()
//                sideBarVC?.removeFromParent()
//                overlayView?.removeFromSuperview()
//                overlayView = nil
//                self.isMenuOpen = false
//            }
//        }
//    }

    static func getSideMenuWidth() -> CGFloat {
        return 250.0
    }

    
}

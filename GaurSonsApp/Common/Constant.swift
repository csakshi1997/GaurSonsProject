//
//  Constant.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import UIKit

var DeviceId : String = UIDevice.current.identifierForVendor!.uuidString
var applicationID = 6740630208
let AppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String
let BundleID = Bundle.main.bundleIdentifier
var Device_Token : String = EMPTY
var selectedTabIndex : Int = 0
var currentVisitId: String = ""
var currentSelectedVisitId: String = ""
var chcekInDate: String = ""
var chcekintime: String = ""
var savedCurrentDate: String = ""
var savedCurrentTime: String = ""

var offTrade : String = "SELECT Value,Label,IsActive FROM PicklistValueInfo WHERE EntityParticle.EntityDefinition.QualifiedApiName = 'Account' AND EntityParticle.QualifiedApiName ='Off_Trade__c'"
var onTrade : String = "SELECT Value,Label,IsActive FROM PicklistValueInfo WHERE EntityParticle.EntityDefinition.QualifiedApiName = 'Account' AND EntityParticle.QualifiedApiName ='On_Trade_Institution__c'"

#if DEBUG
//let kLoginHost = "nosoftware-page-2575--dev.sandbox.my.site.com/GaurBrokerPortal"
let kLoginHost = "gaursons--uat.sandbox.my.site.com/GaurBrokerPortal"
//UAT Key
//let ApiKey = "c8ef3d2a8f654ca2b67c24e9256c51df"
let ApiKey = "def3c18bb9d6746771f3dcd333f985c8"
let applictionId = "gaursonsindiaprivatelimited_user_1"
//UAT Key
//let generateLinkUrl = "https://in-digilocker.staging-signdesk.com/api/generateUrl"
let generateLinkUrl = "https://in-digilocker.signdesk.com/api/generateUrl"
//let getAadhaarDetailsUrl = "https://in-digilocker.staging-signdesk.com/api/getAadhaarDetails"
//let getAadhaarDetailsApiUrl = "https://in-doc-verify.staging-signdesk.com/documentVerification"
let getAadhaarDetailsUrl = "https://in-digilocker.signdesk.com/api/getAadhaarDetails"
let getAadhaarDetailsApiUrl = "https://in-doc-verify.signdesk.com/documentVerification"
let EaseBuzzKEY = "74OMNUVJ5"
let EaseBuzzSALT = "BPWKORHZR"
let EaseBuzzsub_merchant_id = "S134574YUPC"
let EaseBuzzpaymentModeForAction = "test"
let setPaymentLinK = "https://gaursons--dev2.sandbox.my.salesforce.com/services/apexrest/sendPaymentLink/v1/"
let verifyPayment = "https://gaursons--dev2.sandbox.my.salesforce.com/services/apexrest/verifyPayment/v1/"


#else
let kLoginHost = "gaursons.my.site.com/GaurBrokerPortal"
//let kLoginHost = "gaursons.my.site.com/GaurBrokerPortal/s"
let ApiKey = "def3c18bb9d6746771f3dcd333f985c8"
let applictionId = "gaursonsindiaprivatelimited_user_1"
let generateLinkUrl = "https://in-digilocker.signdesk.com/api/generateUrl"
let getAadhaarDetailsUrl = "https://in-digilocker.signdesk.com/api/getAadhaarDetails"
let getAadhaarDetailsApiUrl = "https://in-doc-verify.signdesk.com/documentVerification"
let EaseBuzzKEY = "1CDASNCH52"
let EaseBuzzSALT = "MISEDJROVW"
let EaseBuzzsub_merchant_id = ""
let EaseBuzzpaymentModeForAction = "production"
let setPaymentLinK = ""
let verifyPayment = ""

#endif

#if arch(i386) || arch(x86_64)
let IsSimulator = true
#else
let IsSimulator = false
#endif


// MARK: Date Format Type
let twelveHoursTimeFormat = "hh:mm a"
let twentyFourHoursTimeFormat = "HH:mm:ss"
let dateFormatOneType = "yyyy-MM-dd"
let dateFormatTwoType = "MMMM yyyy"
let dateFormatThreeType = "dd/MM/yyyy"
var dateTimeFormat = "yyyy-MM-dd HH:mm:ss"

// TextFeild error color code
let colorForError: String = "#FF3B30"
let borderColorForError: String = "#FF3B30"
let textColor: String = "#722F37"
let buttonColor: String = "#722F37"


func getSideMenuWidth() -> CGFloat {
    if DeviceType.IS_IPHONE_5 {
        return 250.0
    } else {
        return 290.0
    }
}






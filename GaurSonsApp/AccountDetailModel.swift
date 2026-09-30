//
//  AccountDetailModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 11/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct AccountDetailModel {
    var id: String?
    var isPortalEnabled: Bool?
    var name: String?
    var attributes: Attributes?
    var account: Account?

    struct Attributes {
        var type: String?
        var url: String?

        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }

    struct Account {
        var id: String?
        var name: String?
        var owner: Owner?
        var attributes: Attributes?
        var aadhaarNumber: String?
        var accountNamef: String?
        var accountNumber: String?
        var accountSource: String?
        var active: String?
        var address: String?
        var annualRevenue: String?
        var approvalStatus: String?
        var bankAccountNumber: String?
        var bankIFSCCode: String?
        var bankName: String?
        var billingAddress: String?
        var billingCity: String?
        var billingCountry: String?
        var billingGeocodeAccuracy: String?
        var billingLatitude: String?
        var billingLongitude: String?
        var billingPostalCode: String?
        var billingState: String?
        var billingStreet: String?
        var brDeclaration: Bool?
        var branchCode: String?
        var branchName: String?
        var brokerCPBRPersonEmail: String?
        var brokerCPBRPersonMobile: String?
        var brokerCPBRPersonName: String?
        var brokerCPCompanyOwnerName: String?
        var brokerCPCompanyRERARegistration: String?
        var brokerCPOwnerEmail: String?
        var brokerCPOwnerPhone: String?
        var brokerCPUniqueID: String?
        var brokerRegistrationLink: String?
        var city: String?
        var communicationMobileWhatsapp: String?
        var companyEmail: String?
        var companyFirmType: String?
        var companyPhone: String?
        var country: String?
        var state: String?
        var cpFarvisionID: String?
        var createdDate: String?
        var customerPriority: String?
        var description: String?
        var email: String?
        var firstName: String?
        var gstApplicable: String?
        var gstDate: String?
        var gstNumber: String?
        var gstState: String?
        var gstValidUpto: String?
        var industry: String?
        var isActive: Bool?
        var isCustomerPortal: Bool?
        var isPersonAccount: Bool?
        var lastName: String?
        var msme: String?
        var msmeNumber: String?
        var msmeRegistrationStatus: String?
        var msmeSelfDeclaration: Bool?
        var opportunityStatus: String?
        var panNumber: String?
        var personEmail: String?
        var phone: String?
        var pincode: String?
        var rating: String?
        var recordTypeName: String?
        var reraDate: String?
        var reraNumber: String?
        var reraValidUpto: String?
        var selfDeclarationCheckbox: Bool?
        var upiID: String?
        var website: String?

        struct Owner {
            var id: String?
            var name: String?
            var phone: String?
            var mobilePhone: String?
            var attributes: Attributes?

            init(dict: [String: Any]) {
                self.id = dict["Id"] as? String
                self.name = dict["Name"] as? String
                self.phone = dict["Phone"] as? String
                self.mobilePhone = dict["MobilePhone"] as? String
                if let attributesDict = dict["attributes"] as? [String: Any] {
                    self.attributes = Attributes(dict: attributesDict)
                }
            }
        }

        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
            self.aadhaarNumber = dict["Aadhaar_Number__c"] as? String
            self.accountNamef = dict["Account_Namef__c"] as? String
            self.accountNumber = dict["AccountNumber"] as? String
            self.accountSource = dict["AccountSource"] as? String
            self.active = dict["Active__c"] as? String
            self.address = dict["Address__c"] as? String
            self.annualRevenue = dict["AnnualRevenue"] as? String
            self.approvalStatus = dict["Approval_Status__c"] as? String
            self.bankAccountNumber = dict["Bank_Account_Number__c"] as? String
            self.bankIFSCCode = dict["Bank_IFSC_Code__c"] as? String
            self.bankName = dict["Bank_Name__c"] as? String
            self.billingAddress = dict["BillingAddress"] as? String
            self.billingCity = dict["BillingCity"] as? String
            self.billingCountry = dict["BillingCountry"] as? String
            self.billingGeocodeAccuracy = dict["BillingGeocodeAccuracy"] as? String
            self.billingLatitude = dict["BillingLatitude"] as? String
            self.billingLongitude = dict["BillingLongitude"] as? String
            self.billingPostalCode = dict["BillingPostalCode"] as? String
            self.billingState = dict["BillingState"] as? String
            self.billingStreet = dict["BillingStreet"] as? String
            self.brDeclaration = dict["BR_Declaration__c"] as? Bool
            self.branchCode = dict["Branch_Code__c"] as? String
            self.branchName = dict["Branch_Name__c"] as? String
            self.brokerCPBRPersonEmail = dict["Broker_CP_BR_person_Email_ID__c"] as? String
            self.brokerCPBRPersonMobile = dict["Broker_CP_BR_person_Mobile_Number__c"] as? String
            self.brokerCPBRPersonName = dict["Broker_CP_BR_person_Name__c"] as? String
            self.brokerCPCompanyOwnerName = dict["Broker_CP_Company_Owner_Name__c"] as? String
            self.brokerCPCompanyRERARegistration = dict["Broker_CP_Company_RERA_Registration__c"] as? String
            self.brokerCPOwnerEmail = dict["Broker_CP_Owner_Email_Id__c"] as? String
            self.brokerCPOwnerPhone = dict["Broker_CP_Owner_Phone_Number__c"] as? String
            self.brokerCPUniqueID = dict["Broker_CP_Unique_ID__c"] as? String
            self.brokerRegistrationLink = dict["Broker_Registration_Link__c"] as? String
            self.city = dict["City__c"] as? String
            self.communicationMobileWhatsapp = dict["Communication_Mobile_WhatsApp_Number__c"] as? String
            self.companyEmail = dict["Company_Email__c"] as? String
            self.companyFirmType = dict["Company_Firm_Type__c"] as? String
            self.companyPhone = dict["Company_Phone__c"] as? String
            self.country = dict["Country__c"] as? String
            self.state = dict["State__c"] as? String
            self.cpFarvisionID = dict["CP_Farvision_ID__c"] as? String
            self.createdDate = dict["CreatedDate"] as? String
            self.customerPriority = dict["CustomerPriority__c"] as? String
            self.description = dict["Description"] as? String
            self.email = dict["Email__c"] as? String
            self.firstName = dict["FirstName"] as? String
            self.gstApplicable = dict["GST_Applicable__c"] as? String
            self.gstDate = dict["GST_Date__c"] as? String
            self.gstNumber = dict["GST_Number__c"] as? String
            self.gstState = dict["GST_State__c"] as? String
            self.gstValidUpto = dict["GST_Valid_Up_To__c"] as? String
            self.industry = dict["Industry"] as? String
            self.isActive = dict["IsActive__c"] as? Bool
            self.isCustomerPortal = dict["IsCustomerPortal"] as? Bool
            self.isPersonAccount = dict["IsPersonAccount"] as? Bool
            self.lastName = dict["LastName"] as? String
            self.msme = dict["MSME__c"] as? String
            self.msmeNumber = dict["MSME_Number__c"] as? String
            self.msmeRegistrationStatus = dict["MSME_Registration_Status__c"] as? String
            self.msmeSelfDeclaration = dict["MSME_Self_Decalarion__c"] as? Bool
            self.opportunityStatus = dict["Opportunity_Status__c"] as? String
            self.panNumber = dict["PAN_Number__c"] as? String
            self.personEmail = dict["PersonEmail"] as? String
            self.phone = dict["Phone"] as? String
            self.pincode = dict["Pincode__c"] as? String
            self.rating = dict["Rating"] as? String
            self.recordTypeName = dict["Record_Type_Name__c"] as? String
            self.reraDate = dict["RERA_Date__c"] as? String
            self.reraNumber = dict["RERA_Number__c"] as? String
            self.reraValidUpto = dict["RERA_Valid_Up_To__c"] as? String
            self.selfDeclarationCheckbox = dict["Self_Declaration_Checkbox__c"] as? Bool
            self.upiID = dict["UPI_ID__c"] as? String
            self.website = dict["Website"] as? String

            if let attributesDict = dict["attributes"] as? [String: Any] {
                self.attributes = Attributes(dict: attributesDict)
            }
            if let ownerDict = dict["Owner"] as? [String: Any] {
                self.owner = Owner(dict: ownerDict)
            }
        }
    }

    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String
        self.isPortalEnabled = dict["IsPortalEnabled"] as? Bool
        self.name = dict["Name"] as? String
        if let attributesDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attributesDict)
        }
        if let accountDict = dict["Account"] as? [String: Any] {
            self.account = Account(dict: accountDict)
        }
    }
}

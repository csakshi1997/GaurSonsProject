//
//  EOIModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 28/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

//
//  EOIModel.swift
//  GaurSonsApp
//

import Foundation

struct EOIModel {
    
    var id: String?
    var name: String?
    var opportunityId: String?
    
    var recordTypeId: String?
    var recordTypeName: String?
    
    var email: String?
    var mobilePhone: String?
    var applicationNumber: String?
    var carpetArea: String?
    var priorityNumber: String?
    
    var totalPaymentAmount: Double?
    var eoiPaymentSubmissionDate: String?
    var terraceArea: String?
    var totalPriceListAmount: Double?
    var totalPaymentDetail: Double?
    var totalAmountInclGST: Double?
    
    var booked: Bool?
    var isOfflineEOIForm: Bool?
    var paymentNotApproved: Bool?
    var paymentPlanDeviated: Bool?
    var priceListDeviated: Bool?
    
    var eoiTentativePriceRange: String?
    var eoiSaleableArea: String?
    
    var stage: String?
    var createdDate: String?
    var applicantType: String?
    
    var approvalStatus: String?
    var approvalStage: String?
    var approvalCondition: String?
    
    var applicationDate: String?
    var bookingDate: String?
    var bookingNumber: String?
    var bookingStatus: String?
    
    var submittedBy: String?
    
    var firstPreference: String?
    var secondPreference: String?
    var thirdPreference: String?
    
    var documentId: String?
    var documentNumber: String?
    
    var nriStatus: String?
    
    var company: String?
    var companyName: String?
    var companyEmailId: String?
    var companyMobileNumber: String?
    var companyGSTNumber: String?
    var companyRegistrationNumber: String?
    
    var panNumber: String?
    var cinNumber: String?
    var tanNumber: String?
    var tinNumber: String?
    var cstNumber: String?
    
    var channelPartner: String?
    var channelPartnerAgentName: String?
    var channelPartnerMobileNo: String?
    
    var eventURL: String?
    var eventVenue: String?
    var eventDate: String?
    
    var superArea: String?
    var buildUpArea: String?
    var plotArea: String?
    
    var towerBlockName: String?
    var floorNumber: Double?
    
    var tentativeBudgetAmount: Double?
    var tentativeBudget: Double?
    
    var leadSource: String?
    var leadSubSource: String?
    
    var inventoryStatus: String?
    var projectId: String?
    
    var Unit_Hold_Date_Time__c: String?
    
    var attributes: Attributes?
    var project: Project?
    var createdBy: CreatedBy?
    var rmDetails: RMDetails?
    
    // MARK: - Attributes
    struct Attributes {
        var type: String?
        var url: String?
        
        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }
    
    // MARK: - Project
    struct Project {
        var id: String?
        var name: String?
        var channelPartnerVisible: Bool?
        var createdDate: String?
        var easebuzzSubMerchantId: String?
        var minutesToReleaseUnits: Double?
        var attributes: Attributes?
        
        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
            self.channelPartnerVisible = dict["Channel_Partner_Visible__c"] as? Bool
            self.createdDate = dict["CreatedDate"] as? String
            self.easebuzzSubMerchantId = dict["Easebuzz_Sub_Merchant_Id__c"] as? String
            self.minutesToReleaseUnits = dict["Minutes_to_Release_Units__c"] as? Double
            
            if let attrDict = dict["attributes"] as? [String: Any] {
                self.attributes = Attributes(dict: attrDict)
            }
        }
    }
    
    // MARK: - CreatedBy
    struct CreatedBy {
        var id: String?
        var name: String?
        var attributes: Attributes?
        
        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
            
            if let attrDict = dict["attributes"] as? [String: Any] {
                self.attributes = Attributes(dict: attrDict)
            }
        }
    }
    
    // MARK: - RMDetails
    struct RMDetails {
        var id: String?
        var name: String?
        var attributes: Attributes?
        
        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
            
            if let attrDict = dict["attributes"] as? [String: Any] {
                self.attributes = Attributes(dict: attrDict)
            }
        }
    }
    
    // MARK: - INIT
    init(dict: [String: Any]) {
        
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        self.opportunityId = dict["Opportunity_ID__c"] as? String
        
        self.email = dict["Email__c"] as? String
        self.mobilePhone = dict["MobilePhone__c"] as? String
        self.applicationNumber = dict["Application_Number__c"] as? String
        
        self.carpetArea = "\(dict["Carpet_Area__c"] ?? "")"
        self.terraceArea = "\(dict["Terrace_Area__c"] ?? "")"
        
        self.priorityNumber = dict["Priority_Number_R__c"] as? String
        
        self.totalPaymentAmount = dict["Total_Payment_Amount__c"] as? Double
        self.totalPriceListAmount = dict["Total_Price_List_Amount__c"] as? Double
        self.totalPaymentDetail = dict["Total_Payment_Detail__c"] as? Double
        self.totalAmountInclGST = dict["Total_Amount_InclGST__c"] as? Double
        
        self.booked = dict["Booked__c"] as? Bool
        self.isOfflineEOIForm = dict["IsOfflineEOIForm__c"] as? Bool
        self.paymentNotApproved = dict["Payment_Not_Approved__c"] as? Bool
        self.paymentPlanDeviated = dict["Is_Deviated__c"] as? Bool
        self.priceListDeviated = dict["Price_List_Deviated__c"] as? Bool
        
        self.eoiPaymentSubmissionDate = dict["EOI_Payment_Submission_Date__c"] as? String
        self.eoiTentativePriceRange = dict["EOI_Tentative_Price_Range__c"] as? String
        self.eoiSaleableArea = dict["EOI_Saleable_Area__c"] as? String
        
        self.stage = dict["Stage__c"] as? String
        self.createdDate = dict["CreatedDate"] as? String
        self.applicantType = dict["Applicant_Type__c"] as? String
        
        self.approvalStatus = dict["Approval_Status__c"] as? String
        self.approvalStage = dict["Approval_Stage__c"] as? String
        self.approvalCondition = dict["Approval_Condition__c"] as? String
        
        self.applicationDate = dict["Application_Date__c"] as? String
        self.bookingDate = dict["Booking_Date__c"] as? String
        self.bookingNumber = dict["Booking_Number__c"] as? String
        self.bookingStatus = dict["Booking_Status__c"] as? String
        
        self.submittedBy = dict["Submitted_By__c"] as? String
        
        self.firstPreference = dict["First_Preference__c"] as? String
        self.secondPreference = dict["Second_Preference__c"] as? String
        self.thirdPreference = dict["third_Preference__c"] as? String
        
        self.documentId = dict["Document_Id__c"] as? String
        self.documentNumber = dict["Priority_Number__c"] as? String
        
        self.nriStatus = dict["NRI_Status__c"] as? String
        
        self.company = dict["Company__c"] as? String
        self.companyName = dict["Company_Name__c"] as? String
        self.companyEmailId = dict["Company_Email_ID__c"] as? String
        self.companyMobileNumber = "\(dict["Company_Mobile_Number__c"] ?? "")"
        self.companyGSTNumber = dict["Company_GST_Number__c"] as? String
        self.companyRegistrationNumber = dict["Company_Registration_Number__c"] as? String
        
        self.panNumber = dict["PAN_Number__c"] as? String
        self.cinNumber = dict["CIN_Number__c"] as? String
        self.tanNumber = dict["TAN_Number__c"] as? String
        self.tinNumber = dict["TIN_Number__c"] as? String
        self.cstNumber = dict["CST_Number__c"] as? String
        
        self.channelPartner = dict["Channel_Partner__c"] as? String
        self.channelPartnerAgentName = dict["Channel_Partner_Agent_Name__c"] as? String
        self.channelPartnerMobileNo = dict["Channel_Partner_Mobile_No__c"] as? String
        
        self.eventURL = dict["Event_URL__c"] as? String
        self.eventVenue = dict["Event_Venue__c"] as? String
        self.eventDate = dict["Event_Date__c"] as? String
        
        self.superArea = dict["Super_Area__c"] as? String
        self.buildUpArea = dict["Build_Up_Area__c"] as? String
        self.plotArea = dict["Plot_Area__c"] as? String
        
        self.towerBlockName = dict["Tower_Block_Name__c"] as? String
        self.floorNumber = dict["Floor_Number__c"] as? Double
        
        self.tentativeBudgetAmount = dict["Tentative_Budget_Amount__c"] as? Double
        self.tentativeBudget = dict["Budget__c"] as? Double
        
        self.leadSource = dict["Lead_Source__c"] as? String
        self.leadSubSource = dict["Lead_Sub_Source__c"] as? String
        
        self.inventoryStatus = dict["Inventory_Status__c"] as? String
        self.projectId = dict["Project__c"] as? String
        self.Unit_Hold_Date_Time__c = dict["Unit_Hold_Date_Time__c"] as? String
        
        if let attrDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attrDict)
        }
        
        if let projectDict = dict["Project__r"] as? [String: Any] {
            self.project = Project(dict: projectDict)
        }
        
        if let createdByDict = dict["CreatedBy"] as? [String: Any] {
            self.createdBy = CreatedBy(dict: createdByDict)
        }
        
        if let rmDict = dict["RM_Name__r"] as? [String: Any] {
            self.rmDetails = RMDetails(dict: rmDict)
        }
                
        if let recordTypeDict = dict["RecordType"] as? [String: Any] {
            self.recordTypeId = recordTypeDict["Id"] as? String
            self.recordTypeName = recordTypeDict["Name"] as? String
        }
    }
}

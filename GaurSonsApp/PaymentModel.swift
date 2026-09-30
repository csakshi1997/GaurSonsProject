//
//  PaymentModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 15/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

//struct PaymentModel {
//    var id: String?
//    var name: String?
//    var opportunity: Bool?
//    var opportunityName: String?
//    var eoiAmount: Double?
//    var chequeUTRNumber: String?
//    var chequeUTRDate: String?
//    var upiId: String?
//    var transactionId: String?
//    var paymentMode: String?
//    var transactionalMessage: String?
//    var paymentDateTime: String?
//    var utrNumber: String?
//    var bankAccountNumber: String?
//    var ifscCode: String?
//    var paymentReferenceNumber: String?
//    var paymentDate: String?
//    var drawnBank: String?
//    var paymentURL: String?
//    var notes: String?
//    var declaration: Bool?
//    var attributes: Attributes?
//
//    struct Attributes {
//        var type: String?
//        var url: String?
//
//        init(dict: [String: Any]) {
//            self.type = dict["type"] as? String
//            self.url = dict["url"] as? String
//        }
//    }
//
//    init(dict: [String: Any]) {
//        self.id = dict["Id"] as? String
//        self.name = dict["Name"] as? String
//        self.opportunity = dict["Opportunity__c"] as? Bool
//        self.opportunityName = dict["Opportunity_Name__c"] as? String
//        self.eoiAmount = dict["EOI_Amount__c"] as? Double
//        self.chequeUTRNumber = dict["Cheque_UTR_Number__c"] as? String
//        self.chequeUTRDate = dict["Cheque_UTR_Date__c"] as? String
//        self.upiId = dict["UPI_Id__c"] as? String
//        self.transactionId = dict["Transaction_Id__c"] as? String
//        self.paymentMode = dict["Payment_Mode__c"] as? String
//        self.transactionalMessage = dict["Transactional_Message__c"] as? String
//        self.paymentDateTime = dict["Payment_Date_TIme__c"] as? String
//        self.utrNumber = dict["UTR_Number__c"] as? String
//        self.bankAccountNumber = dict["Bank_Account_Number__c"] as? String
//        self.ifscCode = dict["IFSC_Code__c"] as? String
//        self.paymentReferenceNumber = dict["Payment_Reference_Number__c"] as? String
//        self.paymentDate = dict["Payment_Date__c"] as? String
//        self.drawnBank = dict["Drawn_Bank__c"] as? String
//        self.paymentURL = dict["Payment_URL__c"] as? String
//        self.notes = dict["Notes__c"] as? String
//        self.declaration = dict["Declaration__c"] as? Bool
//
//        if let attributesDict = dict["attributes"] as? [String: Any] {
//            self.attributes = Attributes(dict: attributesDict)
//        }
//    }
//}

struct PaymentModel {
    var id: String?
    var name: String?
    var opportunityId: String?
    var opportunityName: String?
    var recordTypeId: String?
    var receiptType: String?
    var approvalStatus: String?
    var chequeStatus: String?
    var eoiStatus: String?
    var eoiAmount: Double?
    var chequeUTRNumber: String?
    var chequeUTRDate: String?
    var upiId: String?
    var transactionId: String?
    var paymentMode: String?
    var transactionalMessage: String?
    var paymentDateTime: String?
    var utrNumber: String?
    var bankAccountNumber: String?
    var ifscCode: String?
    var paymentMethod: String?
    var paymentResponse: String?
    var chequeClearingDate: String?
    var paymentReferenceNumber: String?
    var paymentDate: String?
    var drawnBank: String?
    var paymentURL: String?
    var notes: String?
    var rejectReason: String?
    var declaration: Bool?
    var createdDate: String?
    var attributes: Attributes?

    struct Attributes {
        var type: String?
        var url: String?

        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }

    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        self.opportunityId = dict["Opportunity__c"] as? String
        self.opportunityName = dict["Opportunity_Name__c"] as? String
        self.recordTypeId = dict["RecordTypeId"] as? String
        self.receiptType = dict["Receipt_Type__c"] as? String
        self.approvalStatus = dict["Approval_Status__c"] as? String
        self.chequeStatus = dict["Cheque_Status__c"] as? String
        self.eoiStatus = dict["EOI_Status__c"] as? String
        self.eoiAmount = dict["EOI_Amount__c"] as? Double
        self.chequeUTRNumber = dict["Cheque_UTR_Number__c"] as? String
        self.chequeUTRDate = dict["Cheque_UTR_Date__c"] as? String
        self.upiId = dict["UPI_Id__c"] as? String
        self.transactionId = dict["Transaction_Id__c"] as? String
        self.paymentMode = dict["Payment_Mode__c"] as? String
        self.transactionalMessage = dict["Transactional_Message__c"] as? String
        self.paymentDateTime = dict["Payment_Date_TIme__c"] as? String
        self.utrNumber = dict["UTR_Number__c"] as? String
        self.bankAccountNumber = dict["Bank_Account_Number__c"] as? String
        self.ifscCode = dict["IFSC_Code__c"] as? String
        self.paymentMethod = dict["Payment_Method__c"] as? String
        self.paymentResponse = dict["Payment_Response__c"] as? String
        self.chequeClearingDate = dict["Cheque_Clearing_Date__c"] as? String
        self.paymentReferenceNumber = dict["Payment_Reference_Number__c"] as? String
        self.paymentDate = dict["Payment_Date__c"] as? String
        self.drawnBank = dict["Drawn_Bank__c"] as? String
        self.paymentURL = dict["Payment_URL__c"] as? String
        self.notes = dict["Notes__c"] as? String
        self.rejectReason = dict["Reject_Reason__c"] as? String
        self.declaration = dict["Declaration__c"] as? Bool
        self.createdDate = dict["CreatedDate"] as? String

        if let attributesDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attributesDict)
        }
    }
}

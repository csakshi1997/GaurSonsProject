//
//  CustomerModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 15/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct CustomerModel {
    var id: String?
    var name: String?
    var email: String?
    var mobile: String?
    var convertedToEOI: Bool?
    var recordTypeId: String?
    var brokerType: String?
    var verificationType: String?
    var aadhaarName: String?
    var aadhaarEnding: String?
    var gender: String?
    var dateOfBirth: String?
    var careOf: String?
    var house: String?
    var landmark: String?
    var street: String?
    var vtc: String?
    var district: String?
    var subdist: String?
    var pincode: String?
    var postOffice: String?
    var country: String?
    var state: String?
    var completeAddress: String?
    var declaration: String?
    var status: String?
    var createdDate: String?
    var attributes: Attributes?
    var project: Project?
    var owner: Owner?
    var createdBy: CreatedBy?
    var maskedData: MaskedData?

    struct Attributes {
        var type: String?
        var url: String?

        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }

    struct Project {
        var id: String?
        var name: String?
        var channelPartnerVisible: Bool?
        var eoiDeclaration: Bool?
        var attributes: Attributes?

        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
            self.channelPartnerVisible = dict["Channel_Partner_Visible__c"] as? Bool
            self.eoiDeclaration = dict["EOI_Declaration__c"] as? Bool

            if let attrDict = dict["attributes"] as? [String: Any] {
                self.attributes = Attributes(dict: attrDict)
            }
        }
    }

    struct Owner {
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
    
    struct MaskedData {
        var mobile: MaskedField?
        var email: MaskedField?

        init(dict: [String: Any]) {

            if let mobileDict = dict["Mobile"] as? [String: Any] {
                self.mobile = MaskedField(dict: mobileDict)
            }

            if let emailDict = dict["Email"] as? [String: Any] {
                self.email = MaskedField(dict: emailDict)
            }
        }
    }

    struct MaskedField {
        var defaultValue: String?

        init(dict: [String: Any]) {
            self.defaultValue = dict["Default"] as? String
        }
    }

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
    init(dict: [String: Any]) {

        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        self.email = dict["Email__c"] as? String
        self.mobile = dict["Mobile__c"] as? String
        self.convertedToEOI = dict["Converted_to_EOI__c"] as? Bool
        self.brokerType = dict["Broker_Type__c"] as? String
        self.verificationType = dict["Verification_Type__c"] as? String

        self.aadhaarName = dict["Aadhaar_Name__c"] as? String
        self.aadhaarEnding = dict["Aadhaar_Ending__c"] as? String
        self.gender = dict["Gender__c"] as? String
        self.dateOfBirth = dict["Date_Of_Birth__c"] as? String

        self.careOf = dict["Care_Of__c"] as? String
        self.house = "\(dict["House__c"] ?? "")"
        self.landmark = dict["Landmark__c"] as? String
        self.street = dict["Street__c"] as? String
        self.vtc = dict["VTC__c"] as? String
        self.district = dict["District__c"] as? String
        self.subdist = dict["Subdist__c"] as? String
        self.pincode = "\(dict["Pincode__c"] ?? "")"
        self.postOffice = dict["Post_Office__c"] as? String
        self.country = dict["Country__c"] as? String
        self.state = dict["State__c"] as? String
        self.completeAddress = dict["Complete_Address__c"] as? String
        self.declaration = dict["Declaration__c"] as? String
        self.status = dict["Status__c"] as? String
        self.createdDate = dict["CreatedDate"] as? String

        // Debug
        print("================================")
        print("Customer:", self.name ?? "")
        print("Broker Type:", self.brokerType ?? "NIL")
        print("Verification Type:", self.verificationType ?? "NIL")
        print("Raw Broker:", dict["Broker_Type__c"] ?? "NIL")
        print("Raw Verification:", dict["Verification_Type__c"] ?? "NIL")
        print("================================")

        if let attrDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attrDict)
        }

        if let projectDict = dict["Project__r"] as? [String: Any] {
            self.project = Project(dict: projectDict)
        }

        if let ownerDict = dict["Owner"] as? [String: Any] {
            self.owner = Owner(dict: ownerDict)
        }

        if let createdByDict = dict["CreatedBy"] as? [String: Any] {
            self.createdBy = CreatedBy(dict: createdByDict)
        }

        if let maskedDictString = dict["Masked_Data__c"] as? String,
           let data = maskedDictString.data(using: .utf8) {

            do {
                if let maskedDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    self.maskedData = MaskedData(dict: maskedDict)
                }
            } catch {
                print("❌ Failed to parse Masked_Data__c:", error.localizedDescription)
            }
        }
    }
}


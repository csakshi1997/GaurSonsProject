//
//  User.swift
//  GaurSonsApp
//
//  Created by Sakshi on 06/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var name: String
    var mobileNumber: String
    var email: String
    var billingCity: String
    var billingState: String
    var billingPostalCode: String
    var billingCountry: String
    var attributes: Attributes?
    
    struct Attributes {
        var type: String
        var url: String
        
        init(dict: [String: Any]) {
            self.type = dict["type"] as? String ?? ""
            self.url = dict["url"] as? String ?? ""
        }
    }
    
    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String ?? ""
        self.name = dict["Name"] as? String ?? ""
        self.mobileNumber = dict["PH_Mobile_Number__c"] as? String ?? ""
        self.email = dict["Email__c"] as? String ?? ""
        self.billingCity = dict["BillingCity"] as? String ?? ""
        self.billingState = dict["BillingState"] as? String ?? ""
        self.billingPostalCode = dict["BillingPostalCode"] as? String ?? ""
        self.billingCountry = dict["BillingCountry"] as? String ?? ""
        
        if let attrDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attrDict)
        }
    }
}


//
//  File.swift
//  GaurSonsApp
//
//  Created by Sakshi on 06/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct ProjectModel {
    var id: String?
    var name: String?
    var ownerId: String?
    var ownerName: String?
    
    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        
        if let ownerDict = dict["Owner"] as? [String: Any] {
            self.ownerId = ownerDict["Id"] as? String
            self.ownerName = ownerDict["Name"] as? String
        }
    }
}

struct RMUserModel {
    var id: String?
    var name: String?

    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
    }
}

struct ProjectPreferenceModel {
    var id: String?
    var name: String?
    
    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
    }
}

struct NetworkModel {
    let Id: String
    let Name: String
    
    init(dict: [String: Any]) {
        self.Id = dict["Id"] as? String ?? ""
        self.Name = dict["Name"] as? String ?? ""
    }
}

struct ProjectModelSold {
    let id: String
    let name: String
    let eoiCutoffDate: String?

    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String ?? ""
        self.name = dict["Name"] as? String ?? ""
        
        if let date = dict["EOI_Cutoff_Date__c"] as? String, !date.isEmpty {
            self.eoiCutoffDate = date
        } else {
            self.eoiCutoffDate = nil
        }
    }
}

struct ProjectModelUnsold {
    let id: String
    let name: String
    let channelPartnerVisible: Bool
    let advanceAccess: Bool

    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String ?? ""
        self.name = dict["Name"] as? String ?? ""
        
        self.channelPartnerVisible = dict["Channel_Partner_Visible__c"] as? Bool ?? false
        self.advanceAccess = dict["Advance_Access__c"] as? Bool ?? false
    }
}

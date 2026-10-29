//
//  ProjectModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 26/03/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct InventoryProjectModel {
    
    var id: String?
    var name: String?
    var attributes: Attributes?
    
    var projectType: String?
    var projectStatus: String?
    var projectCode: String?
    var totalUnits: Int?
    var totalTowers: Int?
    var createdDate: String?
    var createdBy: CreatedBy?
    
    var floorNumber: String?
    var unitType: String?
    var unitStatus: String?
    var unitNumber: String?
    var unitTypology: String?
    var facing: String?
    var builtupArea: Double?
    var unitOfMeasurement: String?
    var propertyType: String?
    var sellableArea: Double?
    
    var tower: Tower?
    var floor: Floor?
    
    struct Attributes {
        var type: String?
        var url: String?

        init(dict: [String: Any]) {
            self.type = dict["attributes"] as? String
            self.url = dict["url"] as? String
        }
    }
    
    struct CreatedBy {
        var id: String?
        var name: String?

        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
        }
    }
    
    struct Tower {
        var id: String?
        var name: String?

        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
        }
    }
    
    struct Floor {
        var id: String?
        var name: String?

        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
        }
    }
    
    init(dict: [String: Any]) {
        print(dict)
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        
        if let attrDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attrDict)
        }
        
        self.projectType = dict["Project_Type__c"] as? String
        self.projectStatus = dict["Project_Status__c"] as? String
        self.projectCode = dict["Project_Code__c"] as? String
        self.createdDate = dict["CreatedDate"] as? String
        
        if let units = dict["Total_No_of_Units__c"] as? Int {
            self.totalUnits = units
        } else if let units = dict["Total_No_of_Units__c"] as? Double {
            self.totalUnits = Int(units)
        }
        
        if let towers = dict["Total_No_of_Towers__c"] as? Int {
            self.totalTowers = towers
        } else if let towers = dict["Total_No_of_Towers__c"] as? Double {
            self.totalTowers = Int(towers)
        }
        
        if let createdByDict = dict["CreatedBy"] as? [String: Any] {
            self.createdBy = CreatedBy(dict: createdByDict)
        }
        
        self.floorNumber = dict["Floor_Number__c"] as? String
        self.unitType = dict["Unit_Type__c"] as? String
        self.unitStatus = dict["Unit_Status__c"] as? String
        self.unitNumber = dict["Unit_Number__c"] as? String
        self.unitTypology = dict["Unit_Typology__c"] as? String
        self.facing = dict["Facing__c"] as? String
        self.unitOfMeasurement = dict["Unit_of_Measurement__c"] as? String
        self.propertyType = dict["Property_Type__c"] as? String
        
        if let area = dict["Builtup_Area__c"] as? Double {
            self.builtupArea = area
        } else if let area = dict["Builtup_Area__c"] as? Int {
            self.builtupArea = Double(area)
        }
        
        if let towerDict = dict["Tower_Code__r"] as? [String: Any] {
            self.tower = Tower(dict: towerDict)
        }
        
        if let floorDict = dict["Floor_Number__r"] as? [String: Any] {
            self.floor = Floor(dict: floorDict)
        }
        if let area = dict["Sellable_Area__c"] as? Double {
            self.sellableArea = area
        } else if let area = dict["Sellable_Area__c"] as? Int {
            self.sellableArea = Double(area)
        } else if let area = dict["Sellable_Area__c"] as? String {
            self.sellableArea = Double(area)
        }
    }
}

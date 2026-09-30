//
//  PropertyModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 12/05/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct PropertyModel {
    
    var id: String?
    var name: String?
    
    var floorNumber: String?
    var unitType: String?
    var unitStatus: String?
    var unitNumber: String?
    var unitTypology: String?
    var facing: String?
    
    var builtupArea: Double?
    var ecpaArea: Double?
    var carpetArea: Double?
    var sellableArea: Double?
    var basementArea: Double?
    var roofArea: Double?
    
    var unitMeasurement: String?
    var propertyType: String?
    
    var bookingDate: String?
    
    var projectId: String?
    var projectName: String?
    
    var towerId: String?
    var towerName: String?
    
    var floorId: String?
    var floorName: String?
    
    init(dict: [String: Any]) {
        
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        
        self.floorNumber = dict["Floor_Number__c"] as? String
        self.unitType = dict["Unit_Type__c"] as? String
        self.unitStatus = dict["Unit_Status__c"] as? String
        self.unitNumber = dict["Unit_Number__c"] as? String
        self.unitTypology = dict["Unit_Typology__c"] as? String
        self.facing = dict["Facing__c"] as? String
        
        self.builtupArea = (dict["Builtup_Area__c"] as? NSNumber)?.doubleValue
        self.ecpaArea = (dict["ECPA_Area__c"] as? NSNumber)?.doubleValue
        self.carpetArea = (dict["Carpet_Area__c"] as? NSNumber)?.doubleValue
        self.sellableArea = (dict["Sellable_Area__c"] as? NSNumber)?.doubleValue
        self.basementArea = (dict["Basement_Area_del__c"] as? NSNumber)?.doubleValue
        self.roofArea = (dict["Roof_Area__c"] as? NSNumber)?.doubleValue
        
        self.unitMeasurement = dict["Unit_of_Measurement__c"] as? String
        self.propertyType = dict["Property_Type__c"] as? String
        
        self.bookingDate = dict["Unit_Booking_DateTime__c"] as? String
        
        // Project
        if let projectDict = dict["Project__r"] as? [String: Any] {
            self.projectId = projectDict["Id"] as? String
            self.projectName = projectDict["Name"] as? String
        }
        
        // Tower
        if let towerDict = dict["Tower_Code__r"] as? [String: Any] {
            self.towerId = towerDict["Id"] as? String
            self.towerName = towerDict["Name"] as? String
        }
        
        // Floor relationship
        if let floorDict = dict["Floor_Number__r"] as? [String: Any] {
            self.floorId = floorDict["Id"] as? String
            self.floorName = floorDict["Name"] as? String
        }
    }
}

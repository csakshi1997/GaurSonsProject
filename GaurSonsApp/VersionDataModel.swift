//
//  VersionDataModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 17/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct VersionDataModel {
    var Id: String?
    var attribute: Attributes?
    var VersionData: String?
    
    struct Attributes {
        var type: String?
        var url: String?
        
        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }
    
    init(dict: [String: Any]) {
        self.Id = dict["Id"] as? String
        
        if let attrDict = dict["attributes"] as? [String: Any] {
            self.attribute = Attributes(dict: attrDict)
        }
        
        if let docDict = dict["ContentDocument"] as? [String: Any] {
            self.VersionData = dict["VersionData"] as? String
        }
    }
}


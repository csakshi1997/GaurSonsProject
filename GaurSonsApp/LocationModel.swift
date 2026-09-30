//
//  LocationModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 03/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct LocationModel {
    var id: String?
    var name: String?   
    var attributes: Attributes?

    struct Attributes {
        var type: String?
        var url: String?

        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }

    init(dict: [String: Any], keyName: String) {
        self.id = dict["Id"] as? String
        self.name = dict[keyName] as? String

        if let attributesDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attributesDict)
        }
    }
}

//
//  Files.swift
//  GaurSonsApp
//
//  Created by Sakshi on 06/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct Files {
    var title: String?
    
    var pathOnClient: String?
    
    var versionData: String?
    
    var firstPublishLocationId: String?
    
    var networkId: String?
    
    init(title: String?, fileExtension: String?, versionData: String?, linkedRecordId: String?, networkId: String? = nil) {
        self.title = title
        self.pathOnClient = "\(title ?? "Document").\(fileExtension ?? "jpg")"
        self.versionData = versionData
        self.firstPublishLocationId = linkedRecordId
        self.networkId = networkId
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [
            "Title": title ?? "",
            "PathOnClient": pathOnClient ?? "",
            "VersionData": versionData ?? ""
        ]
        
        if let firstPublishLocationId = firstPublishLocationId {
            dict["FirstPublishLocationId"] = firstPublishLocationId
        }
        
        if let networkId = networkId {
            dict["NetworkId"] = networkId
        }
        
        return dict
    }
}

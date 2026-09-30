//
//  ApprovalModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 11/05/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct ApprovalModel {
    
    var id: String?
    var stepStatus: String?
    var comments: String?
    var createdDate: String?
    var stepNodeId: String?
    
    var actorName: String?
    var originalActorName: String?
    
    var attributes: Attributes?
    var actor: Actor?
    var originalActor: OriginalActor?
    
    struct Attributes {
        var type: String?
        var url: String?
        
        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }
    
    struct Actor {
        var name: String?
        
        init(dict: [String: Any]) {
            self.name = dict["Name"] as? String
        }
    }
    
    struct OriginalActor {
        var name: String?
        
        init(dict: [String: Any]) {
            self.name = dict["Name"] as? String
        }
    }
    
    init(dict: [String: Any]) {
        
        self.id = dict["Id"] as? String
        self.stepStatus = dict["StepStatus"] as? String
        self.comments = dict["Comments"] as? String
        self.createdDate = dict["CreatedDate"] as? String
        self.stepNodeId = dict["StepNodeId"] as? String
        
        if let actorDict = dict["Actor"] as? [String: Any] {
            self.actor = Actor(dict: actorDict)
            self.actorName = actorDict["Name"] as? String
        }
        
        if let originalActorDict = dict["OriginalActor"] as? [String: Any] {
            self.originalActor = OriginalActor(dict: originalActorDict)
            self.originalActorName = originalActorDict["Name"] as? String
        }
        
        if let attributesDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attributesDict)
        }
    }
}

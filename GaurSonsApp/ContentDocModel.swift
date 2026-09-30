//
//  ContentDocModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 16/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct ContentDocModel {
    var contentDocumentId: String?
    var attributes: Attributes?
    var contentDocument: ContentDocument?

    struct Attributes {
        var type: String?
        var url: String?

        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }

    struct ContentDocument {
        var attributes: Attributes?
        var title: String?
        var parentId: String?

        init(dict: [String: Any]) {
            self.title = dict["Title"] as? String
            self.parentId = dict["ParentId"] as? String

            if let attrDict = dict["attributes"] as? [String: Any] {
                self.attributes = Attributes(dict: attrDict)
            }
        }
    }

    init(dict: [String: Any]) {
        self.contentDocumentId = dict["ContentDocumentId"] as? String

        if let attrDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attrDict)
        }

        if let docDict = dict["ContentDocument"] as? [String: Any] {
            self.contentDocument = ContentDocument(dict: docDict)
        }
    }
}

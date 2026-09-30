//
//  BaseWebService.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import Foundation
import UIKit
//import Alamofire
import SalesforceSDKCore


struct EndPoints {
    var SEND_ATTENDANCE = "/services/data/v63.0/sobjects/Attendance__c"
    var GET_ALL_CUSTOMERS = "SELECT Id, Name, ParentId, Type, PI_Payment_Terms__c, RE_Price_Book__r.Id, RE_Price_Book__r.Name, BillingAddress FROM Account ORDER BY Name ASC NULLS LAST"
    var GET_ALL_PASSBOOKS = "SELECT Id, Name FROM Price_Book__c"
    var GET_ALL_ZONE = "/services/data/v59.0/query/?q=SELECT Id, Name FROM Zone__c"
    var CREATE_SALES_ORDER = "/services/data/v59.0/composite/tree/Sales_Order__c"
    var CREATE_TASK = "/services/data/v63.0/sobjects/Task"
    var GET_PARENT_ACCOUNT_ID = "/services/data/v59.0/query/?q=SELECT Id, Name FROM Account"
}

enum ContentType: String {
    case multipart = "multipart/form-data"
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
    case none = ""
}

let tokenExpiredErrorMessage = "Session expired or invalid"

class BaseWebService {
    let validation = Validation()
    let reachabilityManager = NetworkReachabilityManager()
    func setLoader() {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        config.foregroundColor = .black
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config: config)
    }
    
    func getHeader(contentType: ContentType = .json) ->  [String: String] {
        var header: [String: String] = [:]
        if !(Defaults.accessToken ?? "").isEmpty {
            header["Authorization"] = "Bearer \(Defaults.accessToken ?? "")"
        }
        if contentType == .multipart {
            header["Content-Type"] = "multipart/form-data"
        } else if contentType == .json  {
            header["Content-Type"] = "application/json"
            header["accept"] = "application/json"
        } else if contentType == .urlEncoded  {
            header["Content-Type"] = "application/x-www-form-urlencoded"
        } else if contentType == .none {
        }
        return header
    }
    
    func sfPostRequest(path: String, body: [String: Any]) async throws -> RestResponse {
        let request = RestRequest(method: .POST, path: path, queryParams: nil)
        request.setCustomRequestBodyDictionary(body, contentType: "application/json")
        return try await RestClient.shared.send(request: request, <#(Result<RestResponse, RestClientError>) -> Void#>)
    }
    
    func sfGetRequest(path: String, parameters: [String: Any]? = nil) async throws -> RestResponse {
        let request = RestRequest(method: .GET, path: path, queryParams: parameters)
        return try await RestClient.shared.send(request: request)
    }
    
    func sfPutRequest(path: String, body: [String: Any]) async throws -> RestResponse {
        let request = RestRequest(method: .PUT, path: path, queryParams: nil)
        request.setCustomRequestBodyDictionary(body, contentType: "application/json")
        return try await RestClient.shared.send(request: request)
    }
    
    func sfDeleteRequest(path: String) async throws -> RestResponse {
        let request = RestRequest(method: .DELETE, path: path, queryParams: nil)
        return try await RestClient.shared.send(request: request)
    }
    
    func sfPatchRequest(path: String, body: [String: Any]) async throws -> RestResponse {
        let request = RestRequest(method: .PATCH, path: path, queryParams: nil)
        request.setCustomRequestBodyDictionary(body, contentType: "application/json")
        return try await RestClient.shared.send(request: request)
    }
}


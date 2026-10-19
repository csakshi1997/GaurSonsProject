//
//  SalesforceWebService.swift
//  GaurSonsApp
//
//  Created by Sakshi on 07/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//


import Foundation
import SalesforceSDKCore

struct EndPoints {
    var SEND_ATTENDANCE = "/services/data/\(RestClient.shared.apiVersion)/sobjects/Attendance__c"
    var SEND_EOI_REQUEST = "/services/data/\(RestClient.shared.apiVersion)/composite/tree/Applicant_Details__c"
    var SEND_APPLICANT_COMPOSITE = "/services/data/\(RestClient.shared.apiVersion)/composite/tree/Applicant_Details__c"
    var SEND_CUSTOMERS_COMPOSITE = "/services/data/\(RestClient.shared.apiVersion)/sobjects/Customer__c/"
    var GENERATE_PAYMENT_URL = "/services/apexrest/sendPaymentLink/v1/"
    var CREATE_PAYMENT = "/services/apexrest/payment/create"
}
    
final class SalesforceWebService {
    func get(path: String, parameters: [String: Any]? = nil) async throws -> RestResponse {
        let request = RestRequest(method: .GET, path: path, queryParams: parameters)
        return try await RestClient.shared.send(request: request)
    }
    
    func post(path: String, body: [String: Any]) async throws -> RestResponse {
        let request = RestRequest(method: .POST, path: path, queryParams: nil)
        request.setCustomRequestBodyDictionary(body, contentType: "application/json")
        return try await RestClient.shared.send(request: request)
    }
    
    func put(path: String, body: [String: Any]) async throws -> RestResponse {
        let request = RestRequest(method: .PUT, path: path, queryParams: nil)
        request.setCustomRequestBodyDictionary(body, contentType: "application/json")
        return try await RestClient.shared.send(request: request)
    }
    
    func delete(path: String) async throws -> RestResponse {
        let request = RestRequest(method: .DELETE, path: path, queryParams: nil)
        return try await RestClient.shared.send(request: request)
    }
    
    func patch(path: String, body: [String: Any]) async throws -> RestResponse {
        let request = RestRequest(method: .PATCH, path: path, queryParams: nil)
        request.setCustomRequestBodyDictionary(body, contentType: "application/json")
        return try await RestClient.shared.send(request: request)
    }
    
}

//
//  PaymentWebService.swift
//  GaurSonsApp
//
//  Created by Sakshi on 15/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class PaymentWebService {
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()
    
    func getAllPaymentList(oppId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT Id, Name, Opportunity__c, Opportunity_Name__c, RecordTypeId, Receipt_Type__c, Approval_Status__c, Cheque_Status__c, EOI_Status__c, EOI_Amount__c, Cheque_UTR_Number__c, Cheque_UTR_Date__c,
            UPI_Id__c, Transaction_Id__c, Payment_Mode__c, Transactional_Message__c, Payment_Date_TIme__c, UTR_Number__c,
            Bank_Account_Number__c, IFSC_Code__c, Payment_Method__c, Payment_Response__c, Cheque_Clearing_Date__c, Payment_Reference_Number__c, Payment_Date__c, Drawn_Bank__c, Payment_URL__c,
            Notes__c, Reject_Reason__c, Declaration__c, CreatedDate
            FROM Payment_Detail__c
            WHERE Opportunity_Name__c = '\(oppId)'
            ORDER BY CreatedDate DESC
            """
            
            guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let fullUrl = "\(instanceUrl)/services/data/v62.0/query/?q=\(encodedQuery)"
            print("Request URL: \(fullUrl)")
            
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v62.0")
            
            do {
                let response = try await RestClient.shared.send(request: request)
                if let urlResponse = response.urlResponse as? HTTPURLResponse {
                    let statusCode = urlResponse.statusCode
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                }
                
                if let jsonObject = try response.asJson() as? [String: Any] {
                    DispatchQueue.main.async {
                        outerClosure(nil, jsonObject, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format", nil, .error)
                    }
                }
                
            } catch {
                print("API Error:", error)

                if let apiError = error as? RestClientError {
                    
                    if case let .apiFailed(response, _, urlResponse) = apiError {
                        
                        // 🔹 Check session expired
                        if let httpResponse = urlResponse as? HTTPURLResponse,
                           httpResponse.statusCode == 401 {
                            
                            DispatchQueue.main.async {
                                Utility.logoutAction()
                                outerClosure("Session expired. Please login again.", nil, .tokenExpired)
                            }
                            return
                        }
                        
                        // 🔹 Parse Salesforce error
                        if let data = response as? Data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                                   let firstError = json.first,
                                   let message = firstError["message"] as? String {
                                    
                                    DispatchQueue.main.async {
                                        outerClosure(message, nil, .error)
                                    }
                                    return
                                }
                            } catch {
                                print("Error parsing Salesforce error")
                            }
                        }
                    }
                }

                DispatchQueue.main.async {
                    outerClosure(error.localizedDescription, nil, .error)
                }
            }
        }
    }
    

    func getAllApprovalList(oppId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            
            let soqlQuery = 
            """
             SELECT
                Id,
                StepStatus,
                Comments,
                Actor.Name,
                OriginalActor.Name,
                CreatedDate,
                StepNodeId
             FROM ProcessInstanceStep
             WHERE ProcessInstance.TargetObjectId = '\(oppId)'
            """
            guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let fullUrl = "\(instanceUrl)/services/data/v62.0/query/?q=\(encodedQuery)"
            print("Request URL: \(fullUrl)")
            
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v62.0")
            
            do {
                let response = try await RestClient.shared.send(request: request)
                
                if let urlResponse = response.urlResponse as? HTTPURLResponse {
                    let statusCode = urlResponse.statusCode
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                }
                
                if let jsonObject = try response.asJson() as? [String: Any] {
                    DispatchQueue.main.async {
                        outerClosure(nil, jsonObject, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format", nil, .error)
                    }
                }
                
            } catch {
                print("API Error:", error)

                if let apiError = error as? RestClientError {
                    
                    if case let .apiFailed(response, _, urlResponse) = apiError {
                        
                        if let httpResponse = urlResponse as? HTTPURLResponse,
                           httpResponse.statusCode == 401 {
                            
                            DispatchQueue.main.async {
                                Utility.logoutAction()
                                outerClosure("Session expired. Please login again.", nil, .tokenExpired)
                            }
                            return
                        }
                        
                        if let data = response as? Data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                                   let firstError = json.first,
                                   let message = firstError["message"] as? String {
                                    
                                    DispatchQueue.main.async {
                                        outerClosure(message, nil, .error)
                                    }
                                    return
                                }
                            } catch {
                                print("Error parsing Salesforce error")
                            }
                        }
                    }
                }

                DispatchQueue.main.async {
                    outerClosure(error.localizedDescription, nil, .error)
                }
            }
        }
    }
        
    func createPayment(
        payload: [String: Any],
        outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())
    ) {
        guard let instanceUrl = Defaults.instanceUrl else {
            outerClosure("Invalid instance URL", nil, .error)
            return
        }
        print("\(Defaults.instanceUrl ?? EMPTY)\(endPoint.CREATE_PAYMENT)")
        Task {
            do {
                let response = try await webRequest.post(
                    path: "\(Defaults.instanceUrl ?? EMPTY)\(endPoint.CREATE_PAYMENT)",
                    body: payload
                )
                
                if let jsonObject = try response.asJson() as? [String: Any] {
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, jsonObject, .success)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format", nil, .error)
                    }
                }
                
            } catch {
                
                Utility.handleSalesforceErrorForPayment(error) { message, status in
                    print(message)
                    DispatchQueue.main.async {
                        outerClosure(message, nil, status)
                    }
                }
            }
        }
    }
    
    func sendPaymentLink(param: [String: Any],
                         outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        
        guard let instanceUrl = Defaults.instanceUrl else {
            outerClosure("Invalid instance URL", nil, .error)
            return
        }

        let absoluteUrl = "\(instanceUrl)/services/apexrest/sendPaymentLink/v1/"
        print("📤 Sending request to: \(absoluteUrl)")

        guard let url = URL(string: absoluteUrl) else {
            outerClosure("Invalid URL", nil, .error)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken = Defaults.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
            print("📦 Request Body:", param)
        } catch {
            outerClosure("Invalid parameters", nil, .error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {

                // 🔴 Network error
                if let error = error {
                    print("❌ Network Error:", error.localizedDescription)
                    outerClosure(error.localizedDescription, nil, .error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    outerClosure("Invalid response from server", nil, .error)
                    return
                }

                print("📡 Status Code:", httpResponse.statusCode)

                // 🔐 Session expired
                if httpResponse.statusCode == 401 {
                    Utility.logoutAction()
                    outerClosure("Session expired. Please login again.", nil, .tokenExpired)
                    return
                }

                guard let data = data else {
                    outerClosure("No response data", nil, .error)
                    return
                }

                // Debug raw response
                if let raw = String(data: data, encoding: .utf8) {
                    print("📩 Raw Response:", raw)
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data)

                    // ✅ Success response
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {

                        if let jsonObject = json as? [String: Any] {
                            outerClosure(nil, jsonObject, .success)
                        } else {
                            outerClosure("Invalid JSON format", nil, .error)
                        }

                    } else {

                        // 🔴 Salesforce error array
                        if let errorArray = json as? [[String: Any]],
                           let firstError = errorArray.first,
                           let message = firstError["message"] as? String {

                            outerClosure(message, nil, .error)
                            return
                        }

                        // 🔴 Apex error object
                        if let errorDict = json as? [String: Any],
                           let message = errorDict["message"] as? String {

                            outerClosure(message, nil, .error)
                            return
                        }

                        outerClosure("Request failed with status code \(httpResponse.statusCode)", nil, .error)
                    }

                } catch {
                    print("❌ JSON Parsing Error:", error.localizedDescription)
                    outerClosure("Failed to parse server response", nil, .error)
                }
            }

        }.resume()
    }
    
    func verifyPaymentAPI(param: [String: Any],
                          outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        
        guard let instanceUrl = Defaults.instanceUrl else {
            outerClosure("Invalid instance URL", nil, .error)
            return
        }

        let absoluteUrl = "\(instanceUrl)/services/apexrest/verifyPayment/v1/"
        print("📤 Sending request to:", absoluteUrl)

        guard let url = URL(string: absoluteUrl) else {
            outerClosure("Invalid URL", nil, .error)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken = Defaults.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
            print("📦 Request body:", param)
        } catch {
            outerClosure("Invalid parameters", nil, .error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {

                // 🔴 Network error
                if let error = error {
                    print("❌ Network Error:", error.localizedDescription)
                    outerClosure(error.localizedDescription, nil, .error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    outerClosure("Invalid response from server", nil, .error)
                    return
                }

                print("📡 Status Code:", httpResponse.statusCode)

                // 🔐 Session expired
                if httpResponse.statusCode == 401 {
                    Utility.logoutAction()
                    outerClosure("Session expired. Please login again.", nil, .tokenExpired)
                    return
                }

                guard let data = data else {
                    outerClosure("No response data", nil, .error)
                    return
                }

                // Debug raw response
                if let raw = String(data: data, encoding: .utf8) {
                    print("📩 Raw Response:", raw)
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data)

                    // ✅ Success case
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {

                        if let jsonObject = json as? [String: Any] {
                            outerClosure(nil, jsonObject, .success)
                        } else {
                            outerClosure("Invalid JSON format", nil, .error)
                        }

                    } else {

                        // 🔴 Salesforce error array
                        if let errorArray = json as? [[String: Any]],
                           let firstError = errorArray.first,
                           let message = firstError["message"] as? String {

                            outerClosure(message, nil, .error)
                            return
                        }

                        // 🔴 Apex error object
                        if let errorDict = json as? [String: Any],
                           let message = errorDict["message"] as? String {

                            outerClosure(message, nil, .error)
                            return
                        }

                        outerClosure("Request failed with status code \(httpResponse.statusCode)", nil, .error)
                    }

                } catch {
                    print("❌ JSON Parsing Error:", error.localizedDescription)
                    outerClosure("Failed to parse server response", nil, .error)
                }
            }

        }.resume()
    }
    
    
    func checkTimmerStatus(
        oppId: String,
        outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())
    ) {

        Task {

            let soqlQuery =
            """
            SELECT Id, Stage__c, CountPaymentDetailRec__c
            FROM Opportunity__c
            WHERE Id = '\(oppId)'
            """

            guard let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid instance URL", nil, .error)
                return
            }

            let request = RestClient.shared.request(
                forQuery: soqlQuery,
                apiVersion: "v62.0"
            )

            print("SOQL Query:", soqlQuery)

            do {

                let response = try await RestClient.shared.send(
                    request: request
                )

                if let urlResponse = response.urlResponse as? HTTPURLResponse {

                    let statusCode = urlResponse.statusCode

                    print("HTTP Status Code:", statusCode)

                    if statusCode == 401 {

                        DispatchQueue.main.async {
                            Utility.logoutAction()

                            outerClosure(
                                "Unauthorized. Redirecting to login.",
                                nil,
                                .tokenExpired
                            )
                        }

                        return
                    }
                }

                if let jsonObject = try response.asJson() as? [String: Any] {

                    print("Opportunity Response:", jsonObject)

                    DispatchQueue.main.async {
                        outerClosure(nil, jsonObject, .success)
                    }

                } else {

                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format", nil, .error)
                    }
                }

            } catch {

                print("API Error:", error)

                if let apiError = error as? RestClientError {

                    if case let .apiFailed(response, _, urlResponse) = apiError {

                        if let httpResponse = urlResponse as? HTTPURLResponse,
                           httpResponse.statusCode == 401 {

                            DispatchQueue.main.async {
                                Utility.logoutAction()

                                outerClosure(
                                    "Session expired. Please login again.",
                                    nil,
                                    .tokenExpired
                                )
                            }

                            return
                        }

                        if let data = response as? Data {

                            do {

                                if let json = try JSONSerialization.jsonObject(
                                    with: data
                                ) as? [[String: Any]],
                                   let firstError = json.first,
                                   let message = firstError["message"] as? String {

                                    DispatchQueue.main.async {
                                        outerClosure(message, nil, .error)
                                    }

                                    return
                                }

                            } catch {
                                print("Error parsing Salesforce error")
                            }
                        }
                    }
                }

                DispatchQueue.main.async {
                    outerClosure(error.localizedDescription, nil, .error)
                }
            }
        }
    }
    
}

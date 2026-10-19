//
//  CreateRequestWebService.swift
//  GaurSonsApp
//
//  Created by Sakshi on 06/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class CreateRequestWebService {
    static let shared = CreateRequestWebService()
    let endPoint = EndPoints()
    var picklistOptionsDict: [String: [(label: String, value: String)]] = [:]
    
    func createRecord(
        ofType objectType: String,
        withFields payload: [String: Any],
        onSuccess: ((String) -> Void)? = nil,
        onFailure: ((String) -> Void)? = nil
    ) async {
        let request = RestClient.shared.requestForCreate(withObjectType: objectType, fields: payload, apiVersion: nil)
        
        do {
            let response = try await RestClient.shared.send(request: request)
            if let resultDict = try response.asJson() as? [String: Any],
               let recordId = resultDict["id"] as? String {
                onSuccess?(recordId)
            } else {
                onFailure?("Failed to parse response.")
            }
        } catch {
            if let restError = error as? RestClientError {
                switch restError {
                case .apiFailed(_, let underlying, _):
                    if let underlying = underlying as NSError?,
                       let errors = underlying.userInfo["error"] as? [[String: Any]],
                       let firstError = errors.first,
                       let message = firstError["message"] as? String {
                        onFailure?(message)
                        return
                    }
                    onFailure?(underlying.localizedDescription)
                    
                default:
                    onFailure?(restError.localizedDescription)
                }
            } else {
                onFailure?(error.localizedDescription)
            }
        }
    }
    
    func createRecordForFile(ofType objectType: String, withFields payload: [String: Any]) async throws -> String {
        let request = RestClient.shared.requestForCreate(withObjectType: objectType, fields: payload, apiVersion: nil)
        
        do {
            let response = try await RestClient.shared.send(request: request)
            
            guard let resultDict = try response.asJson() as? [String: Any],
                  let recordId = resultDict["id"] as? String else {
                throw NSError(domain: "CreateRecordError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
            }
            
            return recordId
            
        } catch {
            if let restError = error as? RestClientError {
                switch restError {
                case .apiFailed(_, let underlying, _):
                    if let underlying = underlying as NSError?,
                       let errors = underlying.userInfo["error"] as? [[String: Any]],
                       let firstError = errors.first,
                       let message = firstError["message"] as? String {
                        throw NSError(domain: "CreateRecordError", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
                    }
                    throw underlying
                default:
                    throw restError
                }
            } else {
                throw error
            }
        }
    }
    
    func updateRecordForFile(endPoint: String, param: [String: Any], outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        guard let instanceUrl = Defaults.instanceUrl else {
            outerClosure("Invalid instance URL", nil, .error)
            return
        }
        let fullUrl = instanceUrl + endPoint
           print("Final URL being called: \(fullUrl)")
        let request = RestRequest(method: .PATCH, path: endPoint, queryParams: nil)
        
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: param, options: [])
            request.setCustomRequestBodyData(bodyData, contentType: "application/json")
        } catch {
            outerClosure("Invalid parameters", nil, .error)
            return
        }
        
        Task {
            do {
                let response = try await RestClient.shared.send(request: request)
                if let httpResponse = response.urlResponse as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }

                if let httpResponse = response.urlResponse as? HTTPURLResponse, httpResponse.statusCode == 204 {
                    DispatchQueue.main.async {
                        outerClosure(nil, nil, .success)
                    }
                    return
                }

                let data = response.asData()
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        outerClosure(nil, jsonObject, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid response data", nil, .error)
                    }
                }

            } catch let error as RestClientError {
                print(error)
                if case .apiFailed(_, let underlying, _) = error,
                   let underlying = underlying as NSError?,
                   let errors = underlying.userInfo["error"] as? [[String: Any]],
                   let firstError = errors.first,
                   let message = firstError["message"] as? String {
                    DispatchQueue.main.async {
                        print(message)
                        outerClosure(message, nil, .error)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        outerClosure(error.localizedDescription, nil, .error)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    outerClosure(error.localizedDescription, nil, .error)
                }
            }
        }
    }
    
    func queryRecordsAsync(soqlQuery: String) async throws -> [String: Any] {
        let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: nil)
        let response = try await RestClient.shared.send(request: request)
        guard let json = try response.asJson() as? [String: Any] else {
            throw NSError(domain: "QueryError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse query response"])
        }
        return json
    }
    
    
    func sendCompositeRequest(param: [String: Any], outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        guard let instanceUrl = Defaults.instanceUrl else {
            outerClosure("Invalid instance URL", nil, .error)
            return
        }

        let path = endPoint.SEND_APPLICANT_COMPOSITE
        print("📤 Sending request to: \(instanceUrl)\(path)")

        let request = RestRequest(method: .POST, path: path, queryParams: nil)

        do {
            let bodyData = try JSONSerialization.data(withJSONObject: param, options: [])
            request.setCustomRequestBodyData(bodyData, contentType: "application/json")
        } catch {
            outerClosure("Invalid parameters", nil, .error)
            return
        }

        Task {
            do {
                let response = try await RestClient.shared.send(request: request)
                let urlResponse = response.urlResponse

                if let httpResponse = urlResponse as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("✅ HTTP Status Code: \(statusCode)")

                    if statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                } else {
                    print("⚠️ Could not cast URLResponse to HTTPURLResponse.")
                }

                let data = response.asData()
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("✅ Response JSON: \(jsonObject)")
                        DispatchQueue.main.async {
                            outerClosure(nil, jsonObject, .success)
                        }
                    } else {
                        DispatchQueue.main.async {
                            outerClosure("Invalid response format", nil, .error)
                        }
                    }
                } catch {
                    print("❌ JSON parsing error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        outerClosure("JSON parsing error: \(error.localizedDescription)", nil, .error)
                    }
                }

            } catch {
                    print("❌ Error sending composite request: \(error)")
                    if let nsError = error as NSError? {
                        print("🔍 NSError domain: \(nsError.domain)")
                        print("🔍 NSError code: \(nsError.code)")
                        print("🔍 NSError userInfo: \(nsError.userInfo)")
                    }
                    DispatchQueue.main.async {
                        outerClosure(error.localizedDescription, nil, .error)
                    }
                }
        }
    }
    
}
    

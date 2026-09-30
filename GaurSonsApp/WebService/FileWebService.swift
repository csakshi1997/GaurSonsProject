//
//  FileWebService.swift
//  GaurSonsApp
//
//  Created by Sakshi on 16/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class FileWebService {
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()
    
    func getContentDoc(oppId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = '\(oppId)'
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
    
    func getVersionDataViaContentDocId(contentDocId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
    SELECT ID, VersionData FROM ContentVersion where ContentDocumentId = '\(contentDocId)'
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
    
    func getFileDataViaVersionId(contentVersionId: String,
                                 outerClosure: @escaping (String?, Data?, ResponseStatus) -> ()) {
        Task {
            guard let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid instance URL", nil, .error)
                return
            }

            // Direct file download URL for VersionData
            let fullUrl = "\(instanceUrl)/services/data/v62.0/sobjects/ContentVersion/\(contentVersionId)/VersionData"
            print("File URL: \(fullUrl)")

            var request = RestRequest(method: .GET, path: fullUrl, queryParams: nil)
            request.parseResponse = false // 🔑 Expect raw file data

            do {
                let response = try await RestClient.shared.send(request: request)

                if let httpResponse = response.urlResponse as? HTTPURLResponse,
                   httpResponse.statusCode == 401 {
                    DispatchQueue.main.async {
                        Utility.logoutAction()
                        outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                    }
                    return
                }

                // ✅ Get raw file data (already binary, not Base64)
                let fileData = response.asData()
                DispatchQueue.main.async {
                    outerClosure(nil, fileData, .success)
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
}
    



//
//  UserWebService.swift
//  GaurSonsApp
//
//  Created by Sakshi on 06/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class UserWebService {
    let endPoint = EndPoints()
    var contactId: String = EMPTY
    
    func getUsers(outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = "SELECT Id, Name FROM User"
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v59.0")
            
            do {
                let response: RestResponse = try await RestClient.shared.send(request: request)
                
                if let urlResponse = response.urlResponse as? HTTPURLResponse {
                    let statusCode = urlResponse.statusCode
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                        }
                        outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        return
                    }
                }
                
                if let jsonObject = try response.asJson() as? [String: Any] {
                    outerClosure(nil, jsonObject, .success)
                } else {
                    outerClosure("Invalid JSON format", nil, .error)
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
    
    func getLoggedInUserContactId(completion: @escaping (String?) -> Void) {
        guard let userId = Defaults.userId, !userId.isEmpty else {
                completion(nil)
                return
            }
        
        let soql = "SELECT ContactId FROM User WHERE Id = '\(userId)'"
        
        let request = RestClient.shared.request(forQuery: soql, apiVersion: "v59.0")
        
        Task {
            do {
                let response = try await RestClient.shared.send(request: request)
                
                if let json = try response.asJson() as? [String: Any],
                   let records = json["records"] as? [[String: Any]],
                   let first = records.first,
                   let contactId = first["ContactId"] as? String {
                    
                    completion(contactId)
                    
                } else {
                    completion(nil)
                }
                
            } catch {
                print("Error:", error)
                completion(nil)
            }
        }
    }
    
    func getContactDetails(contactId: String,
                           completion: @escaping (String?, String?) -> Void) {
        
        let soql = """
        SELECT AccountId, Account.Channel_Partner_Status__c
        FROM Contact
        WHERE Id = '\(contactId)'
        """
        
        let request = RestClient.shared.request(forQuery: soql, apiVersion: "v59.0")
        
        Task {
            do {
                let response = try await RestClient.shared.send(request: request)
                
                if let json = try response.asJson() as? [String: Any],
                   let records = json["records"] as? [[String: Any]],
                   let first = records.first {
                    
                    let accountId = first["AccountId"] as? String
                    
                    let account = first["Account"] as? [String: Any]
                    let status = account?["Channel_Partner_Status__c"] as? String
                    
                    completion(accountId, status)
                    
                } else {
                    completion(nil, nil)
                }
                
            } catch {
                print("Error:", error)
                completion(nil, nil)
            }
        }
    }
    
    func fetchCurrentSalesforceUserDetails(outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            guard let userAccount = UserAccountManager.shared.currentUserAccount,
                  let userId = userAccount.credentials.userId else {
                outerClosure("⚠️ No logged-in Salesforce user", nil, .error)
                return
            }
            
//            let soqlQuery = "SELECT Id, UserRoleId, UserRole.Name, Name, FirstName, LastName, Username, Email FROM User WHERE Id = '\(userId)'"
            let soqlQuery = "SELECT Id, Name, Email, FirstName, LastName, Username FROM User WHERE Id = '\(userId)'"
            print("SOQL Query: \(soqlQuery)")
            
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v62.0")
            
            do {
                let response: RestResponse = try await RestClient.shared.send(request: request)
                
                if let urlResponse = response.urlResponse as? HTTPURLResponse,
                   urlResponse.statusCode == 401 {
                    DispatchQueue.main.async {
                        Utility.logoutAction()
                    }
                    outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                    return
                }
                
                if let jsonObject = try response.asJson() as? [String: Any],
                   let records = jsonObject["records"] as? [[String: Any]],
                   let userDict = records.first {
                    print(userDict)
                    GlobalData.user = User(dict: userDict)
                    outerClosure(nil, userDict, .success)
                } else {
                    outerClosure("Invalid JSON format", nil, .error)
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


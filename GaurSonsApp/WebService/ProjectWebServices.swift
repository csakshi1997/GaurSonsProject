//
//  ProjectWebServices.swift
//  GaurSonsApp
//
//  Created by Sakshi on 26/03/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class ProjectWebServices {
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()
    func getInventoryProjects(outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        
        Task {
            let soqlQuery = """
        SELECT Id, Name, Project_Type__c, Project_Status__c, Project_Code__c,
        Total_No_of_Units__c, Total_No_of_Towers__c,
        CreatedDate, CreatedBy.Id, CreatedBy.Name
        FROM Project__c
        WHERE Channel_Partner_Visible__c = true
        ORDER BY CreatedDate DESC
        """
            
//            let soqlQuery = """
//                SELECT Id, Name, Project_Type__c, Project_Status__c, Project_Code__c,
//                Total_No_of_Units__c, Total_No_of_Towers__c, Sellable_Area__c,
//                CreatedDate, CreatedBy.Id, CreatedBy.Name
//                FROM Project__c
//                WHERE Channel_Partner_Visible__c = true
//                ORDER BY CreatedDate DESC
//                """
            
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
                        
                        // 🔹 Session expired
                        if let httpResponse = urlResponse as? HTTPURLResponse,
                           httpResponse.statusCode == 401 {
                            
                            DispatchQueue.main.async {
                                Utility.logoutAction()
                                outerClosure("Session expired. Please login again.", nil, .tokenExpired)
                            }
                            return
                        }
                        
                        // 🔹 Salesforce error parsing
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
   
    func updateRecord(
        objectName: String,
        recordId: String,
        body: [String: Any],
        completion: @escaping (Bool, String?) -> Void
    ) {

        Task {

            let request = RestClient.shared.requestForUpdate(
                withObjectType: objectName,
                objectId: recordId,
                fields: body,
                apiVersion: "v62.0"
            )

            do {

                let response = try await RestClient.shared.send(request: request)

                print("UPDATE RESPONSE:", response)

                DispatchQueue.main.async {

                    if let httpResponse = response.urlResponse as? HTTPURLResponse {

                        print("UPDATE STATUS:", httpResponse.statusCode)

                        if httpResponse.statusCode == 204 {

                            completion(true, nil)

                        } else {

                            completion(
                                false,
                                "Update failed with status code \(httpResponse.statusCode)"
                            )
                        }

                    } else {

                        completion(false, "No response received from server")
                    }
                }

            } catch {

                print("UPDATE ERROR:", error)

                if let apiError = error as? RestClientError {

                    if case let .apiFailed(response, _, urlResponse) = apiError {

                        if let httpResponse = urlResponse as? HTTPURLResponse {

                            print("STATUS CODE:", httpResponse.statusCode)

                            if httpResponse.statusCode == 401 {

                                DispatchQueue.main.async {

                                    Utility.logoutAction()

                                    completion(false, "Session expired")
                                }

                                return
                            }
                        }

                        if let data = response as? Data {

                            do {

                                let responseString = String(
                                    data: data,
                                    encoding: .utf8
                                )

                                print("SALESFORCE ERROR:", responseString ?? "")

                                if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                                   let firstError = json.first,
                                   let message = firstError["message"] as? String {

                                    DispatchQueue.main.async {
                                        completion(false, message)
                                    }

                                    return
                                }

                            } catch {

                                print("Error parsing Salesforce error")

                                DispatchQueue.main.async {
                                    completion(false, "Salesforce parsing error")
                                }

                                return
                            }
                        }
                    }
                }

                DispatchQueue.main.async {

                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    func getProjectDetail(projectId: String,
                          outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        
        Task {
            
//            let soqlQuery = """
//            SELECT Id, Name, Floor_Number__c, Unit_Type__c, Unit_Status__c,
//            Unit_Number__c, Unit_Typology__c, Facing__c, Builtup_Area__c,
//            Unit_of_Measurement__c, Property_Type__c,
//            Tower_Code__r.Id, Tower_Code__r.Name,
//            Floor_Number__r.Id, Floor_Number__r.Name
//            FROM Unit_Inventory__c
//            WHERE Project__c = '\(projectId)'
//            AND Unit_Status__c IN ('Available', 'Released', 'Hold')
//            """
            
            let soqlQuery = """
                SELECT Id, Name, Floor_Number__c, Unit_Type__c, Unit_Status__c,
                Unit_Number__c, Unit_Typology__c, Facing__c, Builtup_Area__c,
                Sellable_Area__c, Unit_of_Measurement__c, Property_Type__c,
                Tower_Code__r.Id, Tower_Code__r.Name,
                Floor_Number__r.Id, Floor_Number__r.Name
                FROM Unit_Inventory__c
                WHERE Project__c = '\(projectId)'
                AND Unit_Status__c IN ('Available', 'Released', 'Hold')
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
                        
                        // 🔹 Session expired
                        if let httpResponse = urlResponse as? HTTPURLResponse,
                           httpResponse.statusCode == 401 {
                            
                            DispatchQueue.main.async {
                                Utility.logoutAction()
                                outerClosure("Session expired. Please login again.", nil, .tokenExpired)
                            }
                            return
                        }
                        
                        // 🔹 Salesforce error parsing
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

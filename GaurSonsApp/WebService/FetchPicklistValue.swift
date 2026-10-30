//
//  FetchPicklistValue.swift
//  GaurSonsApp
//
//  Created by Sakshi on 16/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

struct DropDownDTOII {
    var id: String
    var value: String
}

class FetchPicklistValue {
    
    static let shared = FetchPicklistValue()
    
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()
    
    var picklistOptionsDict: [String: [(label: String, value: String)]] = [:]
        
//    func fetchPicklistValues(objectName: String, fieldNames: [String]) async {
//        
//        let request = RestClient.shared.requestForDescribe(withObjectType: objectName, apiVersion: nil)
//        
//        do {
//            print(request)
//            let response = try await RestClient.shared.send(request: request)
//            
//            if let resultDict = try response.asJson() as? [String: Any],
//               let fields = resultDict["fields"] as? [[String: Any]] {
//                
//                for fieldName in fieldNames {
//                    
//                    if let targetField = fields.first(where: { ($0["name"] as? String) == fieldName }),
//                       let picklistValues = targetField["picklistValues"] as? [[String: Any]] {
//                        
//                        let values = picklistValues.compactMap { item -> (label: String, value: String)? in
//                            
//                            if let label = item["label"] as? String,
//                               let value = item["value"] as? String {
//                                return (label, value)
//                            }
//                            
//                            return nil
//                        }
//                        
//                        self.picklistOptionsDict[fieldName] = values
//                        
//                    } else {
//                        print("Field not found: \(fieldName)")
//                    }
//                }
//                
//            } else {
//                print("Invalid response format")
//            }
//            
//        } catch {
//            guard InternetConnectionManager.isConnectedToNetwork() else {
//                return
//            }
//            handleSalesforceError(error)
//        }
//    }
    
    
    func fetchPicklistValues(objectName: String, fieldNames: [String]) async {

        let request = RestClient.shared.requestForDescribe(
            withObjectType: objectName,
            apiVersion: nil
        )

        do {
            print("\n========== SALESFORCE DESCRIBE REQUEST ==========")
            print("Object Name: \(objectName)")
            print("Requested Fields: \(fieldNames)")
            print("Request: \(request)")
            print("=================================================\n")

            let response = try await RestClient.shared.send(request: request)

            let responseDict = try response.asJson() as? [String: Any]

            guard let resultDict = responseDict,
                  let fields = resultDict["fields"] as? [[String: Any]] else {
                print("❌ Invalid Describe API response")
                print("Response: \(String(describing: responseDict))")
                return
            }

            print("\n========== SALESFORCE DESCRIBE RESPONSE ==========")

            for fieldName in fieldNames {

                if let targetField = fields.first(where: {
                    ($0["name"] as? String) == fieldName
                }) {

                    print("\n✅ Field Found: \(fieldName)")
                    print("Field Type: \(targetField["type"] ?? "Unknown")")

                    let picklistValues = targetField["picklistValues"] as? [[String: Any]] ?? []

                    print("Picklist Count: \(picklistValues.count)")

                    let values = picklistValues.compactMap {
                        item -> (label: String, value: String)? in

                        guard let label = item["label"] as? String,
                              let value = item["value"] as? String else {
                            return nil
                        }

                        print("Label: \(label) | Value: \(value)")

                        return (label, value)
                    }

                    self.picklistOptionsDict[fieldName] = values

                } else {
                    print("\n❌ Field Not Found: \(fieldName)")
                }
            }

            print("\nAvailable Salesforce Fields:")
            print(fields.compactMap { $0["name"] as? String })

            print("==================================================\n")

        } catch {
            guard InternetConnectionManager.isConnectedToNetwork() else {
                return
            }

            print("❌ Describe API Error: \(error)")
            handleSalesforceError(error)
        }
    }
        
    func fetchCountries() async -> [DropDownDTOII] {
        
        let query = """
        SELECT Id, Country__c
        FROM Country_State_and_City__mdt
        WHERE Active__c = true
        """
        
        return await executeQuery(query: query, fieldName: "Country__c")
    }
        
    func fetchStates(country: String) async -> [DropDownDTOII] {
        
        let query = """
        SELECT Id, State__c
        FROM Country_State_and_City__mdt
        WHERE Active__c = true
        AND Country__c = '\(country)'
        ORDER BY State__c
        """
        
        let states = await executeQuery(query: query, fieldName: "State__c")
        
        var uniqueStates: [DropDownDTOII] = []
        var addedValues: Set<String> = []
        
        for item in states {
            
            if !addedValues.contains(item.value) {
                
                uniqueStates.append(item)
                addedValues.insert(item.value)
            }
        }
        
        return uniqueStates
    }
        
    func fetchCities(state: String) async -> [DropDownDTOII] {
        
        let query = """
        SELECT Id, City__c
        FROM Country_State_and_City__mdt
        WHERE Active__c = true
        AND State__c = '\(state)'
        ORDER BY City__c
        """
        
        return await executeQuery(query: query, fieldName: "City__c")
    }
        
    func executeQuery(query: String, fieldName: String) async -> [DropDownDTOII] {
        
        var dropDownList: [DropDownDTOII] = []
        
        do {
            
            let request = RestClient.shared.request(forQuery: query, apiVersion: nil)
            
            let response = try await RestClient.shared.send(request: request)
            
            guard let resultDict = try response.asJson() as? [String: Any] else {
                return []
            }
            
            if let records = resultDict["records"] as? [[String: Any]] {
                
                for obj in records {
                    
                    let id = obj["Id"] as? String ?? ""
                    let value = obj[fieldName] as? String ?? ""
                    
                    if !value.isEmpty {
                        
                        let item = DropDownDTOII(id: id, value: value)
                        dropDownList.append(item)
                    }
                }
            }
            
            var isDone = resultDict["done"] as? Bool ?? true
            var nextRecordsUrl = resultDict["nextRecordsUrl"] as? String
            
            while !isDone {
                
                guard let nextUrl = nextRecordsUrl else {
                    break
                }
                
                print("Fetching Next Records:", nextUrl)
                
                let nextRequest = RestRequest(
                    method: .GET,
                    path: nextUrl,
                    queryParams: nil
                )
                
                let nextResponse = try await RestClient.shared.send(request: nextRequest)
                
                if let nextResultDict = try nextResponse.asJson() as? [String: Any] {
                    
                    if let records = nextResultDict["records"] as? [[String: Any]] {
                        
                        for obj in records {
                            
                            let id = obj["Id"] as? String ?? ""
                            let value = obj[fieldName] as? String ?? ""
                            
                            if !value.isEmpty {
                                
                                let item = DropDownDTOII(id: id, value: value)
                                dropDownList.append(item)
                            }
                        }
                    }
                    
                    isDone = nextResultDict["done"] as? Bool ?? true
                    nextRecordsUrl = nextResultDict["nextRecordsUrl"] as? String
                }
            }
            
            var uniqueValues = Set<String>()
            
            let uniqueList = dropDownList.filter { item in
                
                if uniqueValues.contains(item.value) {
                    return false
                } else {
                    uniqueValues.insert(item.value)
                    return true
                }
            }
            
            return uniqueList.sorted { $0.value < $1.value }
            
        } catch {
            
            handleSalesforceError(error)
        }
        
        return []
    }
        
    func handleSalesforceError(_ error: Error) {
        
        print("Salesforce API Error:", error)
        
        if let apiError = error as? RestClientError {
            
            if case let .apiFailed(response, _, urlResponse) = apiError {
                
                if let httpResponse = urlResponse as? HTTPURLResponse,
                   httpResponse.statusCode == 401 {
                    
                    DispatchQueue.main.async {
                        Utility.logoutAction()
                    }
                    
                    return
                }
                
                if let responseData = response as? Data {
                    
                    do {
                        
                        if let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]],
                           let firstError = jsonObject.first,
                           let message = firstError["message"] as? String {
                            
                            print("Salesforce Error:", message)
                            
                            DispatchQueue.main.async {
                                Utility.showAlert(message: message)
                            }
                            
                            return
                        }
                        
                    } catch {
                        print("Error parsing Salesforce error:", error.localizedDescription)
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            Utility.showAlert(message: error.localizedDescription)
        }
    }
}

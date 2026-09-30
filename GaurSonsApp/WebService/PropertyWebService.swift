//
//  PropertyWebService.swift
//  GaurSonsApp
//
//  Created by Sakshi on 19/05/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class PropertyWebService {
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()
    func getAllPropertyList(oppId: String,
                            outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        
        Task {
            let soqlQuery = """
            SELECT
                Id,
                Name,
                Floor_Number__c,
                Unit_Type__c,
                Unit_Status__c,
                Unit_Number__c,
                Unit_Typology__c,
                Facing__c,
                Builtup_Area__c,
                Unit_of_Measurement__c,
                Property_Type__c,
                Unit_Booking_DateTime__c,
                ECPA_Area__c,
                Carpet_Area__c,
                Sellable_Area__c,
                Basement_Area_del__c,
                Roof_Area__c,
                
                Project__r.Id,
                Project__r.Name,
                
                Tower_Code__r.Id,
                Tower_Code__r.Name,
                
                Floor_Number__r.Id,
                Floor_Number__r.Name

            FROM Unit_Inventory__c
            WHERE Opportunity__c = '\(oppId)'
            ORDER BY CreatedDate DESC
            """
            
            guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v62.0")
            
            do {
                let response = try await RestClient.shared.send(request: request)
                
                if let urlResponse = response.urlResponse as? HTTPURLResponse,
                   urlResponse.statusCode == 401 {
                    
                    DispatchQueue.main.async {
                        Utility.logoutAction()
                        outerClosure("Session expired", nil, .tokenExpired)
                    }
                    return
                }
                
                if let json = try response.asJson() as? [String: Any] {
                    DispatchQueue.main.async {
                        outerClosure(nil, json, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid response format", nil, .error)
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    outerClosure(error.localizedDescription, nil, .error)
                }
            }
        }
    }
}

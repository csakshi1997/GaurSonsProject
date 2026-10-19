//
//  AccountWebServices.swift
//  GaurSonsApp
//
//  Created by Sakshi on 11/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class AccountWebServices {
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()

    func getAccountDetails(ApplicantId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT Id, IsPortalEnabled, Name,
            Account.Id, Account.Name, Account.Owner.Id, Account.Owner.Name, Account.Owner.Phone, Account.Owner.MobilePhone, Account.Aadhaar_Number__c, Account.Account_Namef__c, Account.AccountNumber, Account.AccountSource, Account.Active__c, Account.Address__c,
            Account.AnnualRevenue, Account.Approval_Status__c, Account.Bank_Account_Number__c, Account.Bank_IFSC_Code__c, Account.Bank_Name__c,
            Account.BillingAddress, Account.BillingCity, Account.BillingCountry, Account.BillingGeocodeAccuracy, Account.BillingLatitude, Account.BillingLongitude,
            Account.BillingPostalCode, Account.BillingState, Account.BillingStreet, Account.BR_Declaration__c, Account.Branch_Code__c, Account.Branch_Name__c,
            Account.Broker_CP_BR_person_Email_ID__c, Account.Broker_CP_BR_person_Mobile_Number__c, Account.Broker_CP_BR_person_Name__c,
            Account.Broker_CP_Company_Owner_Name__c, Account.Broker_CP_Company_RERA_Registration__c, Account.Broker_CP_Owner_Email_Id__c,
            Account.Broker_CP_Owner_Phone_Number__c, Account.Broker_CP_Unique_ID__c, Account.Broker_Registration_Link__c, Account.City__c, Account.Communication_Mobile_WhatsApp_Number__c, Account.Company_Email__c,
            Account.Company_Firm_Type__c, Account.Company_Phone__c, Account.Country__c, Account.State__c, Account.CP_Farvision_ID__c, Account.CreatedDate, Account.CustomerPriority__c,
            Account.Description, Account.Email__c, Account.GST_Applicable__c, Account.GST_Date__c, Account.GST_Number__c, Account.GST_State__c,
            Account.GST_Valid_Up_To__c, Account.Industry, Account.IsActive__c, Account.IsCustomerPortal,
            Account.MSME__c, Account.MSME_Number__c, Account.MSME_Registration_Status__c, Account.MSME_Self_Decalarion__c, Account.Opportunity_Status__c,
            Account.PAN_Number__c, Account.Phone, Account.Pincode__c, Account.Rating, Account.Record_Type_Name__c, Account.RERA_Date__c, Account.RERA_Number__c,
            Account.RERA_Valid_Up_To__c, Account.Self_Declaration_Checkbox__c, Account.UPI_ID__c, Account.Website
            FROM User
            WHERE Id = '\(Defaults.userId ?? "")'
            """
            
            guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let fullUrl = "\(instanceUrl)/services/data/v63.0/query/?q=\(encodedQuery)"
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
    
    func getUserAccId(ApplicantId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT Id, Name, Account.Id, Account.Channel_Partner_Status__c FROM USER WHERE Id = '\(Defaults.userId ?? "")'
            """
            
            guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let fullUrl = "\(instanceUrl)/services/data/v63.0/query/?q=\(encodedQuery)"
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
}
    

//
//  ApplicantWebService.swift
//  GaurSonsApp
//
//  Created by Sakshi on 09/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class ApplicantWebService {
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()
    
    func getApplicantList(oppId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
//            let soqlQuery = """
//    SELECT Id, Name, Applicant_Mobile_Number__c, Applicant_Email_ID__c, Primary__c, Resident_Type__c, Opportunity__r.Id, Opportunity__r.Name, Opportunity__r.Applicant_Type__c FROM Applicant_Details__c Where Opportunity__c = '\(oppId)'
//"""
            
            let soqlQuery = """
            SELECT
                Id,
                Name,
                Age__c,
                Sequence__c,
                RecordTypeId,
                Masked_Data__c,

                Opportunity__r.Id,
                Opportunity__r.Name,
                Opportunity__r.Applicant_Type__c,

                IsEOI__c,
                Is_Active__c,
                Primary__c,

                Name_of_Company_Firm_LLP__c,
                Date_of_Incorporation__c,
                Name_of_the_authorized_contact_person__c,
                Authorized_contact_person_Phone__c,
                Authorized_contact_person_Email__c,

                Project_Name__c,
                Project_Name__r.Id,
                Project_Name__r.Name,
                Project_Name__r.Channel_Partner_Visible__c,

                Phone_Number_Home__c,
                Phone_Number_Work__c,
                Phone_Number_Any_other__c,
                Applicant_Mobile_Number__c,
                Applicant_Email_ID__c,

                Board_of_Resolution_Date__c,

                PAN_Number__c,
                Aadhaar_Number__c,
                Passport_Number__c,
                Passport_Validity__c,

                Son_of_Daughter_of_Wife_of__c,
                Marital_Status__c,
                Gender__c,
                Nationality__c,
                D_O_B__c,
                Salutation__c,
                Salutation_for_Relative__c,
                Salutation_for_Authorised_Signatory__c,
                Relation__c,
                Occupation__c,

                Company_Firm_LLP_PAN__c,
                Corporate_LLP_Identification_Number__c,
                Company_LLP_Identification_Number_CIN_L__c,
                Director_Designated_Partner_Iden_No__c,

                Prior_Investment_in_Gaurs_Group_Project__c,
                Prior_investment_in_the_existing_Project__c,

                Unit_Number__c,

                Self_Owned__c,
                Rented__c,

                Correspondence_Address__c,
                Correspondence_Country__c,
                Correspondence_State__c,
                Correspondence_City__c,
                Correspondence_Pincode__c,

                Registered_Self_Owned__c,
                Registered_Rented__c,
                Registered_Address__c,
                Registered_Country__c,
                Registered_States__c,
                Registered_City__c,
                Registered_Pincode__c,

                Permanent_Self_Owned__c,
                Permanent_Rented__c,
                Permanent_Address__c,
                Permanent_Country__c,
                Permanent_State__c,
                Permanent_City__c,
                Permanent_Pincode__c,

                Permanent_Address_is_Same_as_Corresponde__c,
                Registered_Address_is_Same_as_Correspond__c,

                Employment_Type__c,
                Profession_Job_Title__c,
                Company_Name__c,

                Bank_Name__c,
                Bank_Account_Number__c,
                Bank_IFSC_Code__c,
                Branch_Code__c,
                Branch_Name__c,
                UPI_ID__c,

                Resident_Type__c,

                GST_No__c,
                Authorisation_Letter_Date__c,
                Registration_State__c,
                Partnership_LLP_HUF_Deed_Date__c,
                Registration_No__c,

                PAN_of_Authorized_Signatory__c,
                Aadhaar_of_Authorized_Signatory__c,

                Profile_Image__c,
                Note__c,

                CreatedDate

            FROM Applicant_Details__c
            WHERE Opportunity__c = '\(oppId)'
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
    
    func getApplicantDetails(ApplicantId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT Id, Name, Age__c, Sequence__c, Salutation_for_Relative__c,
            Salutation_for_Authorised_Signatory__c, RecordTypeId, Masked_Data__c,
            Opportunity__r.Id, Opportunity__r.Name, Opportunity__r.Applicant_Type__c,
            IsEOI__c, Is_Active__c, Primary__c,
            Name_of_Company_Firm_LLP__c, Date_of_Incorporation__c,
            Name_of_the_authorized_contact_person__c,
            Authorized_contact_person_Phone__c,
            Authorized_contact_person_Email__c,
            Project_Name__c, Project_Name__r.Id, Project_Name__r.Name,
            Project_Name__r.Channel_Partner_Visible__c,
            Phone_Number_Home__c, Phone_Number_Work__c,
            Phone_Number_Any_other__c, Applicant_Mobile_Number__c,
            Applicant_Email_ID__c, Board_of_Resolution_Date__c,
            PAN_Number__c, Aadhaar_Number__c, Passport_Number__c,
            Passport_Validity__c, Son_of_Daughter_of_Wife_of__c,
            Marital_Status__c, Gender__c, Nationality__c,
            D_O_B__c, Salutation__c, Relation__c, Occupation__c,
            Company_Firm_LLP_PAN__c,
            Corporate_LLP_Identification_Number__c,
            Company_LLP_Identification_Number_CIN_L__c,
            Director_Designated_Partner_Iden_No__c,
            Prior_Investment_in_Gaurs_Group_Project__c,
            Prior_investment_in_the_existing_Project__c,
            Unit_Number__c,
            Self_Owned__c, Rented__c,
            Correspondence_Address__c, Correspondence_Country__c,
            Correspondence_State__c, Correspondence_City__c,
            Correspondence_Pincode__c,
            Registered_Self_Owned__c,
            PAN_of_Authorized_Signatory__c,
            Aadhaar_of_Authorized_Signatory__c,
            Registered_Rented__c, Registered_Address__c,
            Registered_Country__c, Registered_States__c,
            Registered_City__c, Registered_Pincode__c,
            Permanent_Self_Owned__c, Permanent_Rented__c,
            Permanent_Address__c, Permanent_Country__c,
            Permanent_State__c, Permanent_City__c,
            Permanent_Pincode__c,
            Permanent_Address_is_Same_as_Corresponde__c,
            Registered_Address_is_Same_as_Correspond__c,
            Employment_Type__c, Profession_Job_Title__c,
            Company_Name__c, Bank_Name__c,
            Bank_Account_Number__c, Bank_IFSC_Code__c,
            Branch_Code__c, Branch_Name__c,
            UPI_ID__c, Resident_Type__c,
            GST_No__c, Authorisation_Letter_Date__c,
                            Note__c,
            Registration_State__c,
            Partnership_LLP_HUF_Deed_Date__c,
            Registration_No__c
            FROM Applicant_Details__c
            WHERE Id = '\(ApplicantId)'
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
    
}




//
//  EOIWebServices.swift
//  GaurSonsApp
//
//  Created by Sakshi on 09/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class EOIWebServices {
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()
    
    func getAllEOIForAll( outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = "SELECT Id, Name, Opportunity_ID__c, RecordTypeId, RecordType.Id, RecordType.Name, Applicant_Type__c, Email__c, MobilePhone__c, Application_Number__c, Carpet_Area__c, Priority_Number__c, Priority_Number_R__c, Total_Payment_Amount__c, EOI_Payment_Submission_Date__c, Terrace_Area__c, Total_Price_List_Amount__c, Total_Payment_Detail__c, Total_Amount_InclGST__c, Booked__c, IsOfflineEOIForm__c, Payment_Not_Approved__c, Is_Deviated__c, Price_List_Deviated__c, EOI_Tentative_Price_Range__c, EOI_Saleable_Area__c, Project__c, First_Preference__c, Second_Preference__c, third_Preference__c, Submitted_By__c, Channel_Partner__c, Channel_Partner_Agent_Name__c, Channel_Partner_Mobile_No__c, Approval_Status__c, Approval_Stage__c, Approval_Condition__c, Application_Date__c, Booking_Date__c, Booking_Number__c, Booking_Status__c, Document_Id__c, NRI_Status__c, Company__c, Company_Name__c, Company_Email_ID__c, Company_Mobile_Number__c, Company_GST_Number__c, Company_Registration_Number__c, PAN_Number__c, CIN_Number__c, TAN_Number__c, TIN_Number__c, CST_Number__c, Event_URL__c, Event_Venue__c, Event_Date__c, Super_Area__c, Build_Up_Area__c, Plot_Area__c, Tower_Block_Name__c, Floor_Number__c, Tentative_Budget_Amount__c, Budget__c, Lead_Source__c, Lead_Sub_Source__c, Inventory_Status__c, Stage__c, CreatedDate,Unit_Hold_Date_Time__c, RM_Name__c, RM_Name__r.Id, RM_Name__r.Name, Project__r.Id, Project__r.Name, Project__r.CreatedDate, Project__r.Minutes_to_Release_Units__c, Project__r.Easebuzz_Sub_Merchant_Id__c, Project__r.Channel_Partner_Visible__c, CreatedBy.Id, CreatedBy.Name FROM Opportunity__c ORDER BY CreatedDate DESC"
            guard let instanceUrl = Defaults.instanceUrl,
                  let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let fullUrl = "\(instanceUrl)/services/data/v62.0/query/?q=\(encodedQuery)"
            print("Final URL: \(fullUrl)")
            
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
    
    
    func getEOIDetails(
        opportunityId: String,
        outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())
    ) {
        Task {
            let soqlQuery = """
            SELECT Id, Name, Opportunity_ID__c, RecordTypeId, RecordType.Id, RecordType.Name,
            Applicant_Type__c, Email__c, MobilePhone__c, Application_Number__c,
            Carpet_Area__c, Priority_Number__c, Priority_Number_R__c,
            Total_Payment_Amount__c, EOI_Payment_Submission_Date__c, Terrace_Area__c,
            Total_Price_List_Amount__c, Total_Payment_Detail__c, Total_Amount_InclGST__c,
            Booked__c, IsOfflineEOIForm__c, Payment_Not_Approved__c, Is_Deviated__c,
            Price_List_Deviated__c, EOI_Tentative_Price_Range__c, EOI_Saleable_Area__c,
            Project__c, First_Preference__c, Second_Preference__c, third_Preference__c,
            Submitted_By__c, Channel_Partner__c, Channel_Partner_Agent_Name__c,
            Channel_Partner_Mobile_No__c, Approval_Status__c, Approval_Stage__c,
            Approval_Condition__c, Application_Date__c, Booking_Date__c,
            Booking_Number__c, Booking_Status__c, Document_Id__c, NRI_Status__c,
            Company__c, Company_Name__c, Company_Email_ID__c, Company_Mobile_Number__c,
            Company_GST_Number__c, Company_Registration_Number__c, PAN_Number__c,
            CIN_Number__c, TAN_Number__c, TIN_Number__c, CST_Number__c, Event_URL__c,
            Event_Venue__c, Event_Date__c, Super_Area__c, Build_Up_Area__c, Plot_Area__c,
            Tower_Block_Name__c, Floor_Number__c, Tentative_Budget_Amount__c, Budget__c,
            Lead_Source__c, Lead_Sub_Source__c, Inventory_Status__c, Stage__c,
            CreatedDate, Unit_Hold_Date_Time__c, RM_Name__c, RM_Name__r.Id, RM_Name__r.Name,
            Project__r.Id, Project__r.Name, Project__r.CreatedDate,
            Project__r.Minutes_to_Release_Units__c,
            Project__r.Easebuzz_Sub_Merchant_Id__c,
            Project__r.Channel_Partner_Visible__c,
            CreatedBy.Id, CreatedBy.Name
            FROM Opportunity__c
            WHERE Id = '\(opportunityId)'
            ORDER BY CreatedDate DESC
            """

            guard let instanceUrl = Defaults.instanceUrl else {
                DispatchQueue.main.async {
                    outerClosure("Invalid instance URL", nil, .error)
                }
                return
            }

            let request = RestClient.shared.request(
                forQuery: soqlQuery,
                apiVersion: "v62.0"
            )

            do {
                let response = try await RestClient.shared.send(request: request)

                if let urlResponse = response.urlResponse as? HTTPURLResponse {
                    let statusCode = urlResponse.statusCode
                    print("HTTP Status Code: \\(statusCode)")

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

                if let apiError = error as? RestClientError,
                   case let .apiFailed(_, _, urlResponse) = apiError,
                   let httpResponse = urlResponse as? HTTPURLResponse,
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

                DispatchQueue.main.async {
                    outerClosure(error.localizedDescription, nil, .error)
                }
            }
        }
    }
    
    
    func getAllEOI(
        pageNumber: Int,
        summaryFilter: EOISummaryFilter,
        filterType: FilterTypeForEOI = .none,
        outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())
    ) {
        print("Received Filter =", filterType)
        Task {
            
            let summaryWhereClause: String
            
            switch summaryFilter {
                
            case .total:
                summaryWhereClause = """
                IsCommunityPortalUser__c = true
                """
                
            case .completed:
                summaryWhereClause = """
                IsCommunityPortalUser__c = true
                AND Stage__c IN ('Booking')
                """
                
            case .inProgress:
                summaryWhereClause = """
                IsCommunityPortalUser__c = true
                AND Stage__c NOT IN ('Booking', 'Not Converted')
                """
                
            case .cancelled:
                summaryWhereClause = """
                IsCommunityPortalUser__c = true
                AND Stage__c IN ('Not Converted')
                """
            }
            
            var filterWhereClause = ""
            var orderByClause = "ORDER BY CreatedDate DESC"

            switch filterType {

            case .today:
                filterWhereClause = "AND CreatedDate = TODAY"

            case .digital:
                filterWhereClause = "AND RecordType_Name__c = 'Digital'"

            case .directSales:
                filterWhereClause = "AND RecordType_Name__c = 'Direct_Sales'"

            case .launchEvent:
                filterWhereClause = "AND RecordType_Name__c = 'EOI'"

            case .legacy:
                filterWhereClause = "AND RecordType_Name__c = 'Legacy'"

            case .unsold:
                filterWhereClause = "AND RecordType_Name__c = 'Unsold'"

            case .none:
                break
            }
            
            let soqlQuery = """
            SELECT Id, Name, Opportunity_ID__c, RecordTypeId, RecordType.Id, RecordType.Name,
            Applicant_Type__c, Email__c, MobilePhone__c, Application_Number__c,
            Carpet_Area__c, Priority_Number__c, Priority_Number_R__c,
            Total_Payment_Amount__c, EOI_Payment_Submission_Date__c, Terrace_Area__c,
            Total_Price_List_Amount__c, Total_Payment_Detail__c, Total_Amount_InclGST__c,
            Booked__c, IsOfflineEOIForm__c, Payment_Not_Approved__c, Is_Deviated__c,
            Price_List_Deviated__c, EOI_Tentative_Price_Range__c, EOI_Saleable_Area__c,
            Project__c, First_Preference__c, Second_Preference__c, third_Preference__c,
            Submitted_By__c, Channel_Partner__c, Channel_Partner_Agent_Name__c,
            Channel_Partner_Mobile_No__c, Approval_Status__c, Approval_Stage__c,
            Approval_Condition__c, Application_Date__c, Booking_Date__c,
            Booking_Number__c, Booking_Status__c, Document_Id__c, NRI_Status__c,
            Company__c, Company_Name__c, Company_Email_ID__c, Company_Mobile_Number__c,
            Company_GST_Number__c, Company_Registration_Number__c, PAN_Number__c,
            CIN_Number__c, TAN_Number__c, TIN_Number__c, CST_Number__c, Event_URL__c,
            Event_Venue__c, Event_Date__c, Super_Area__c, Build_Up_Area__c, Plot_Area__c,
            Tower_Block_Name__c, Floor_Number__c, Tentative_Budget_Amount__c, Budget__c,
            Lead_Source__c, Lead_Sub_Source__c, Inventory_Status__c, Stage__c,
            CreatedDate, Unit_Hold_Date_Time__c, RM_Name__c, RM_Name__r.Id, RM_Name__r.Name,
            Project__r.Id, Project__r.Name, Project__r.CreatedDate,
            Project__r.Minutes_to_Release_Units__c,
            Project__r.Easebuzz_Sub_Merchant_Id__c,
            Project__r.Channel_Partner_Visible__c,
            CreatedBy.Id, CreatedBy.Name
            
            FROM Opportunity__c
            
            WHERE \(summaryWhereClause)
            \(filterWhereClause)
            
            ORDER BY CreatedDate DESC
            
            LIMIT 10
            OFFSET \((pageNumber - 1) * 10)
            """
            print(soqlQuery)
            guard let instanceUrl = Defaults.instanceUrl,
                  let encodedQuery = soqlQuery.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                  ) else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let fullUrl = "\(instanceUrl)/services/data/v62.0/query/?q=\(encodedQuery)"
            print("Final URL: \(fullUrl)")
            
            let request = RestClient.shared.request(
                forQuery: soqlQuery,
                apiVersion: "v62.0"
            )
            
            do {
                let response = try await RestClient.shared.send(request: request)
                
                if let urlResponse = response.urlResponse as? HTTPURLResponse {
                    
                    let statusCode = urlResponse.statusCode
                    
                    print("HTTP Status Code: \(statusCode)")
                    
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
                    DispatchQueue.main.async {
                        outerClosure(nil, jsonObject, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure(
                            "Invalid JSON format",
                            nil,
                            .error
                        )
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
                    outerClosure(
                        error.localizedDescription,
                        nil,
                        .error
                    )
                }
            }
        }
    }
    
    
    
    
    func getProjects(outerClosure: @escaping ((String?, [ProjectModel]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT Id, Name, Owner.Id, Owner.Name 
            FROM Project__c 
            WHERE EOI_Cutoff_Date__c >= TODAY 
            AND EOI_Cutoff_Date__c != null 
            ORDER BY EOI_Cutoff_Date__c DESC
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
                
                if let jsonObject = try response.asJson() as? [String: Any],
                   let records = jsonObject["records"] as? [[String: Any]] {
                    
                    let projects = records.map { ProjectModel(dict: $0) }
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, projects, .success)
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
    
    func getProjectsSold(searchKey: String,
                     outerClosure: @escaping ((String?, [ProjectModelSold]?, ResponseStatus) -> ())) {
        
        Task {
            
            let key = "%\(searchKey)%"
            
            let soqlQuery = """
            SELECT Id, Name, EOI_Cutoff_Date__c
            FROM Project__c
            WHERE Channel_Partner_Visible__c = false
            AND (EOI_Cutoff_Date__c = null OR EOI_Cutoff_Date__c >= TODAY)
            AND Name LIKE '\(key)'
            ORDER BY Name
            LIMIT 10
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
                
                if let jsonObject = try response.asJson() as? [String: Any],
                   let records = jsonObject["records"] as? [[String: Any]] {
                    
                    let projects = records.map { ProjectModelSold(dict: $0) }
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, projects, .success)
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
    
    func getProjectsUnSold(searchKey: String,
                         outerClosure: @escaping ((String?, [ProjectModelUnsold]?, ResponseStatus) -> ())) {
        
        Task {
            
            let key = "%\(searchKey)%"
            
            let soqlQuery = """
            SELECT Id, Name, Channel_Partner_Visible__c, Advance_Access__c
            FROM Project__c
            WHERE Channel_Partner_Visible__c = true
            AND Name LIKE '\(key)'
            ORDER BY Name
            LIMIT 50
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
                
                if let jsonObject = try response.asJson() as? [String: Any],
                   let records = jsonObject["records"] as? [[String: Any]] {
                    
                    let projects = records.map { ProjectModelUnsold(dict: $0) }
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, projects, .success)
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
    
    func getProjectConfiguration(projectId: String, outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT Id, Name, Sellable_Area__c, Price_Range__c, Project__r.Name 
            FROM Project_Area_Configuration__c 
            WHERE Project__c = '\(projectId)' LIMIT 1
            """
            
            guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v62.0")
            
            do {
                let response = try await RestClient.shared.send(request: request)
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
    
    func getActiveRMUsers(outerClosure: @escaping ((String?, [RMUserModel]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = "SELECT Id, Name FROM User WHERE IsActive = true"
            
            guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let instanceUrl = Defaults.instanceUrl else {
                outerClosure("Invalid query or instance URL", nil, .error)
                return
            }
            
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v62.0")
            
            do {
                let response = try await RestClient.shared.send(request: request)
                if let jsonObject = try response.asJson() as? [String: Any],
                   let records = jsonObject["records"] as? [[String: Any]] {
                    
                    let users = records.map { RMUserModel(dict: $0) }
                    DispatchQueue.main.async {
                        outerClosure(nil, users, .success)
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
    
    func getPreferences(projectId: String, outerClosure: @escaping ((String?, [ProjectPreferenceModel]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT Id, Name FROM Project_Preference__c WHERE Project__c = '\(projectId)' ORDER BY Name ASC LIMIT 3
            """
            
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v62.0")
            
            do {
                let response = try await RestClient.shared.send(request: request)
                if let jsonObject = try response.asJson() as? [String: Any],
                   let records = jsonObject["records"] as? [[String: Any]] {
                    
                    let preferences = records.map { ProjectPreferenceModel(dict: $0) }
                    outerClosure(nil, preferences, .success)
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
    
    func getNetworks(outerClosure: @escaping ((String?, [NetworkModel]?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = "SELECT Id, Name FROM Network"
            
            let request = RestClient.shared.request(forQuery: soqlQuery, apiVersion: "v62.0")
            
            do {
                let response = try await RestClient.shared.send(request: request)
                
                if let jsonObject = try response.asJson() as? [String: Any],
                   let records = jsonObject["records"] as? [[String: Any]] {
                    
                    let networks = records.map { NetworkModel(dict: $0) }
                    outerClosure(nil, networks, .success)
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
    
    func getTotalEOICount(outerClosure: @escaping ((String?, Int?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = "SELECT Count(Id) FROM Opportunity__c WHERE IsCommunityPortalUser__c = true"
            
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
                    print("HTTP Status Code: \(urlResponse.statusCode)")
                    
                    if urlResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                }
                
                if let json = try response.asJson() as? [String: Any],
                   let records = json["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let count = firstRecord["expr0"] as? Int {
                    
                    print("✅ Count Value: \(count)")
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, count, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format or missing expr0", nil, .error)
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
    
    func getProgressEOICount(outerClosure: @escaping ((String?, Int?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT COUNT(Id) FROM Opportunity__c 
            WHERE IsCommunityPortalUser__c = true 
            AND Stage__c NOT IN ('Booking', 'Not Converted')
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
                    print("HTTP Status Code: \(urlResponse.statusCode)")
                    
                    if urlResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                }
                
                if let json = try response.asJson() as? [String: Any],
                   let records = json["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let count = firstRecord["expr0"] as? Int {
                    
                    print("✅ Count Value: \(count)")
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, count, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format or missing expr0", nil, .error)
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
    
    func getCompletedEOICount(outerClosure: @escaping ((String?, Int?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT COUNT(Id) FROM Opportunity__c WHERE IsCommunityPortalUser__c = true AND Stage__c IN ('Booking')
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
                    print("HTTP Status Code: \(urlResponse.statusCode)")
                    
                    if urlResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                }
                
                if let json = try response.asJson() as? [String: Any],
                   let records = json["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let count = firstRecord["expr0"] as? Int {
                    
                    print("✅ Count Value: \(count)")
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, count, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format or missing expr0", nil, .error)
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
    
    func getCancelledEOICount(outerClosure: @escaping ((String?, Int?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT COUNT(Id) FROM Opportunity__c WHERE IsCommunityPortalUser__c = true AND Stage__c IN ('Not Converted')
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
                    print("HTTP Status Code: \(urlResponse.statusCode)")
                    
                    if urlResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                }
                
                if let json = try response.asJson() as? [String: Any],
                   let records = json["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let count = firstRecord["expr0"] as? Int {
                    
                    print("✅ Count Value: \(count)")
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, count, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format or missing expr0", nil, .error)
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
    
    func getRegisteredCount(outerClosure: @escaping ((String?, Int?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
            SELECT COUNT(Id) FROM Customer__c Where Converted_to_EOI__c = true
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
                    print("HTTP Status Code: \(urlResponse.statusCode)")
                    
                    if urlResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                }
                
                if let json = try response.asJson() as? [String: Any],
                   let records = json["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let count = firstRecord["expr0"] as? Int {
                    
                    print("✅ Count Value: \(count)")
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, count, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format or missing expr0", nil, .error)
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
    
    func getBookedCustomersCount(
        outerClosure: @escaping (String?, Int?, ResponseStatus) -> Void
    ) {
        Task {
            guard let instanceUrl = Defaults.instanceUrl else {
                DispatchQueue.main.async {
                    outerClosure(
                        "Invalid instance URL",
                        nil,
                        .error
                    )
                }
                return
            }

            let endpoint = "\(instanceUrl)/services/apexrest/v1/booking/bookedcustomer"

            // Replace this with the actual Channel Partner Account ID.
            let channelPartnerId = Defaults.userAccountId ?? EMPTY

            let requestBody: [String: Any] = [
                "channelPartner": channelPartnerId
            ]

            do {
                var request = URLRequest(url: URL(string: endpoint)!)
                request.httpMethod = "POST"
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                request.httpBody = try JSONSerialization.data(
                    withJSONObject: requestBody
                )

                // Use the active Salesforce session.
                let accessToken = Defaults.accessToken ?? EMPTY

                request.setValue(
                    "Bearer \(accessToken)",
                    forHTTPHeaderField: "Authorization"
                )

                let (data, response) = try await URLSession.shared.data(
                    for: request
                )

                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        outerClosure(
                            "Invalid server response",
                            nil,
                            .error
                        )
                    }
                    return
                }

                if httpResponse.statusCode == 401 {
                    DispatchQueue.main.async {
//                        Utility.logoutAction()
                        outerClosure(
                            "Session expired. Please login again.",
                            nil,
                            .tokenExpired
                        )
                    }
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    let message = String(data: data, encoding: .utf8)
                        ?? "Request failed with status \(httpResponse.statusCode)"

                    DispatchQueue.main.async {
                        outerClosure(message, nil, .error)
                    }
                    return
                }

                let json = try JSONSerialization.jsonObject(
                    with: data
                ) as? [String: Any]

                guard
                    let json = json,
                    let success = json["success"] as? Bool,
                    success,
                    let count = (json["count"] as? NSNumber)?.intValue
                else {
                    let message = json?["message"] as? String
                        ?? "Invalid API response"

                    DispatchQueue.main.async {
                        outerClosure(message, nil, .error)
                    }
                    return
                }

                DispatchQueue.main.async {
                    outerClosure(nil, count, .success)
                }

            } catch {
                DispatchQueue.main.async {
                    outerClosure(
                        error.localizedDescription,
                        nil,
                        .error
                    )
                }
            }
        }
    }
    
    func getAllCustomersCount(outerClosure: @escaping ((String?, Int?, ResponseStatus) -> ())) {
        Task {
            let soqlQuery = """
                SELECT COUNT()
                FROM Customer__c
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
                print(response)
                if let urlResponse = response.urlResponse as? HTTPURLResponse {
                    print("HTTP Status Code: \(urlResponse.statusCode)")
                    
                    if urlResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            Utility.logoutAction()
                            outerClosure("Unauthorized. Redirecting to login.", nil, .tokenExpired)
                        }
                        return
                    }
                }
                
                if let json = try response.asJson() as? [String: Any],
                  
                   let records = json["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let count = firstRecord["expr0"] as? Int {
                    print(records)

                    
                    print("✅ Total customer Count Value: \(count)")
                    
                    DispatchQueue.main.async {
                        outerClosure(nil, count, .success)
                    }
                } else {
                    DispatchQueue.main.async {
                        outerClosure("Invalid JSON format or missing expr0", nil, .error)
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



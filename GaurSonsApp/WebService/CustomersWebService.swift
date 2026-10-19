//
//  CustomersWebService.swift
//  GaurSonsApp
//
//  Created by Sakshi on 15/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class CustomersWebService {
    let webRequest = SalesforceWebService()
    let endPoint = EndPoints()
    
    func getAllCustomers(
        pageNumber: Int,
        soqlFilter: String? = nil,
        summaryFilter: CustomerSummaryFilter? = nil,
        outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())
    ) {

        Task {

            var whereClause = ""

            if let soqlFilter = soqlFilter,
               !soqlFilter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

                // Existing custom query supplied by caller
                let query = soqlFilter

                await executeCustomerQuery(
                    soqlQuery: query,
                    outerClosure: outerClosure
                )

                return
            }

            if let summaryFilter = summaryFilter {

                switch summaryFilter {

                case .registered:

                    whereClause = """
                    WHERE Converted_to_EOI__c = true
                    """

                case .booked:

                    whereClause = """
                    WHERE Id IN (
                        SELECT Customer__c
                        FROM Opportunity__c
                        WHERE Booked__c = true
                    )
                    """
                }
            }

            let soqlQuery = """
            SELECT Id, Name, Email__c, Mobile__c,
            Masked_Data__c, Converted_to_EOI__c,
            Project__r.Id, Project__r.Name,
            Project__r.Channel_Partner_Visible__c,
            Project__r.EOI_Declaration__c,
            Owner.Id, Owner.Name,
            RecordTypeId, Broker_Type__c,
            Verification_Type__c, Aadhaar_Name__c,
            Aadhaar_Ending__c, Gender__c,
            Date_Of_Birth__c, Care_Of__c,
            House__c, Landmark__c, Street__c,
            VTC__c, District__c, Subdist__c,
            Pincode__c, Post_Office__c,
            Country__c, State__c,
            Complete_Address__c,
            Declaration__c, Status__c,
            CreatedDate,
            CreatedBy.Id, CreatedBy.Name
            FROM Customer__c
            \(whereClause)
            ORDER BY CreatedDate DESC
            LIMIT 10
            OFFSET \((pageNumber - 1) * 10)
            """

            await executeCustomerQuery(
                soqlQuery: soqlQuery,
                outerClosure: outerClosure
            )
        }
    }
    
    private func executeCustomerQuery(
        soqlQuery: String,
        outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())
    ) async {

        print("Customer Query:")
        print(soqlQuery)

        guard let encodedQuery =
                soqlQuery.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                ),
              let instanceUrl = Defaults.instanceUrl else {

            await MainActor.run {
                outerClosure(
                    "Invalid query or instance URL",
                    nil,
                    .error
                )
            }

            return
        }

        let fullUrl =
            "\(instanceUrl)/services/data/v62.0/query/?q=\(encodedQuery)"

        print("Request URL: \(fullUrl)")

        let request = RestClient.shared.request(
            forQuery: soqlQuery,
            apiVersion: "v62.0"
        )

        do {

            let response = try await RestClient.shared.send(
                request: request
            )

            if let urlResponse =
                response.urlResponse as? HTTPURLResponse {

                let statusCode = urlResponse.statusCode

                print("HTTP Status Code: \(statusCode)")

                if statusCode == 401 {

                    await MainActor.run {

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

            if let jsonObject =
                try response.asJson() as? [String: Any] {

                await MainActor.run {

                    outerClosure(
                        nil,
                        jsonObject,
                        .success
                    )
                }

            } else {

                await MainActor.run {

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

                if case let .apiFailed(
                    response,
                    _,
                    urlResponse
                ) = apiError {

                    if let httpResponse =
                        urlResponse as? HTTPURLResponse,
                       httpResponse.statusCode == 401 {

                        await MainActor.run {

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

                            if let json =
                                try JSONSerialization.jsonObject(
                                    with: data
                                ) as? [[String: Any]],

                               let firstError = json.first,

                               let message =
                                firstError["message"] as? String {

                                await MainActor.run {

                                    outerClosure(
                                        message,
                                        nil,
                                        .error
                                    )
                                }

                                return
                            }

                        } catch {

                            print(
                                "Error parsing Salesforce error"
                            )
                        }
                    }
                }
            }

            await MainActor.run {

                outerClosure(
                    error.localizedDescription,
                    nil,
                    .error
                )
            }
        }
    }
    
    func getFilteredCustomers(soqlQuery: String,
                              outerClosure: @escaping ((String?, [String: Any]?, ResponseStatus) -> ())) {

        Task {

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

                    if statusCode == 401 {

                        DispatchQueue.main.async {

                            Utility.logoutAction()

                            outerClosure("Unauthorized", nil, .tokenExpired)
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

                DispatchQueue.main.async {

                    outerClosure(error.localizedDescription, nil, .error)
                }
            }
        }
    }
}


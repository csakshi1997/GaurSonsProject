//
//  DigilockerAPI.swift
//  GaurSonsApp
//
//  Created by Sakshi on 03/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

final class DigilockerService {
    
    private func makeRequest(url: String, body: [String: Any]) -> URLRequest? {
        guard let requestURL = URL(string: url) else { return nil }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(applictionId, forHTTPHeaderField: "x-parse-application-id")
        request.addValue(ApiKey, forHTTPHeaderField: "x-parse-rest-api-key")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        return request
    }
    
    func generateReferenceId() -> String {
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return String(uuid.prefix(16)) // take first 16 chars
    }
    
//    func generateDigilockerLink(referenceId: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
//        let urlString = generateLinkUrl
//        guard let url = URL(string: urlString) else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(applictionId, forHTTPHeaderField: "x-parse-application-id")
//        request.setValue(ApiKey, forHTTPHeaderField: "x-parse-rest-api-key")
//        
//        let body: [String: Any] = [
//            "reference_id": referenceId,
//            "source": "AADHAAR"
//        ]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "NoData", code: -1)))
//                return
//            }
//            
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                    print("API Response: \(json)")
//                    
////                    if let status = json["status"] as? String, status == "success",
////                       let result = json["result"] as? [String: Any],
////                       let link = result["link"] as? String,
////                       let txnId = json["transaction_id"] as? String {
////                        completion(.success((link, txnId)))
////                    } else {
////                        completion(.failure(NSError(domain: "InvalidResponse", code: -2)))
////                    }
//                    if let status = json["status"] as? String {
//
//                        if status.lowercased() == "success",
//                           let result = json["result"] as? [String: Any],
//                           let link = result["link"] as? String,
//                           let txnId = json["transaction_id"] as? String {
//
//                            completion(.success((link, txnId)))
//
//                        } else {
//
//                            let errorMessage = json["error"] as? String
//                                ?? json["message"] as? String
//                                ?? "Something went wrong. Please try again."
//
//                            let errorCode = json["error_code"] as? String ?? ""
//
//                            completion(.failure(
//                                NSError(
//                                    domain: "Digilocker",
//                                    code: -2,
//                                    userInfo: [
//                                        NSLocalizedDescriptionKey: errorMessage,
//                                        "error_code": errorCode
//                                    ]
//                                )
//                            ))
//                        }
//
//                    } else {
//
//                        completion(.failure(
//                            NSError(
//                                domain: "Digilocker",
//                                code: -2,
//                                userInfo: [
//                                    NSLocalizedDescriptionKey: "Invalid response received from server."
//                                ]
//                            )
//                        ))
//                    }
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
    
    func generateDigilockerLink(
        referenceId: String,
        completion: @escaping (Result<(String, String), Error>) -> Void
    ) {
        
        let urlString = generateLinkUrl
        
        guard let url = URL(string: urlString) else {
            completion(.failure(
                NSError(
                    domain: "Digilocker",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Invalid DigiLocker URL."
                    ]
                )
            ))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        request.setValue(
            applictionId,
            forHTTPHeaderField: "x-parse-application-id"
        )
        
        request.setValue(
            ApiKey,
            forHTTPHeaderField: "x-parse-rest-api-key"
        )
        
        let body: [String: Any] = [
            "reference_id": referenceId,
            "source": "AADHAAR"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: body,
                options: []
            )
        } catch {
            completion(.failure(error))
            return
        }
        
        // MARK: - Request Logs
        
        print("========== DIGILOCKER REQUEST ==========")
        print("URL:", url.absoluteString)
        print("Method:", request.httpMethod ?? "")
        print("Headers:", request.allHTTPHeaderFields ?? [:])
        print("Body:", body)
        
        if let httpBody = request.httpBody {
            print(
                "Request JSON:",
                String(data: httpBody, encoding: .utf8) ?? ""
            )
        }
        
        print("========================================")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // MARK: - Network Error
            
            if let error = error {
                print("❌ Network Error:", error)
                
                completion(.failure(error))
                return
            }
            
            // MARK: - HTTP Response
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                completion(.failure(
                    NSError(
                        domain: "Digilocker",
                        code: -2,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "Invalid HTTP response."
                        ]
                    )
                ))
                
                return
            }
            
            print("========== DIGILOCKER RESPONSE ==========")
            print("Status Code:", httpResponse.statusCode)
            print("Headers:", httpResponse.allHeaderFields)
            
            // MARK: - Response Data
            
            guard let data = data else {
                
                print("❌ Response Data is NIL")
                
                completion(.failure(
                    NSError(
                        domain: "Digilocker",
                        code: -3,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "No response data received."
                        ]
                    )
                ))
                
                return
            }
            
            print("Response Data Count:", data.count)
            
            let responseString =
                String(data: data, encoding: .utf8) ?? ""
            
            print("Response String:", responseString)
            
            print("========================================")
            
            // MARK: - Empty Response
            
            guard !data.isEmpty else {
                
                completion(.failure(
                    NSError(
                        domain: "Digilocker",
                        code: -4,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "Server returned an empty response."
                        ]
                    )
                ))
                
                return
            }
            
            // MARK: - Parse JSON
            
            do {
                
                let jsonObject = try JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                
                print("JSON Object:", jsonObject)
                
                guard let json = jsonObject as? [String: Any] else {
                    
                    completion(.failure(
                        NSError(
                            domain: "Digilocker",
                            code: -5,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "Invalid JSON response format."
                            ]
                        )
                    ))
                    
                    return
                }
                
                print("JSON Dictionary:", json)
                
                // MARK: - Status
                
                guard let status = json["status"] as? String else {
                    
                    completion(.failure(
                        NSError(
                            domain: "Digilocker",
                            code: -6,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "Status is missing from DigiLocker response."
                            ]
                        )
                    ))
                    
                    return
                }
                
                // MARK: - Success
                
                if status.lowercased() == "success" {
                    
                    guard
                        let result = json["result"] as? [String: Any],
                        let link = result["link"] as? String,
                        let txnId = json["transaction_id"] as? String
                    else {
                        
                        print("❌ Success response but required fields are missing")
                        print("JSON:", json)
                        
                        completion(.failure(
                            NSError(
                                domain: "Digilocker",
                                code: -7,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Invalid success response."
                                ]
                            )
                        ))
                        
                        return
                    }
                    
                    print("✅ DigiLocker Link:", link)
                    print("✅ Transaction ID:", txnId)
                    
                    completion(.success((link, txnId)))
                    
                } else {
                    
                    // MARK: - API Error
                    
                    let errorMessage =
                        json["error"] as? String ??
                        json["message"] as? String ??
                        "DigiLocker verification failed."
                    
                    let errorCode =
                        json["error_code"] as? String ?? ""
                    
                    print("❌ DigiLocker Error:", errorMessage)
                    print("❌ Error Code:", errorCode)
                    
                    completion(.failure(
                        NSError(
                            domain: "Digilocker",
                            code: -8,
                            userInfo: [
                                NSLocalizedDescriptionKey: errorMessage,
                                "error_code": errorCode
                            ]
                        )
                    ))
                }
                
            } catch {
                
                print("❌ JSON Parsing Error:", error)
                
                print(
                    "Raw Response:",
                    String(data: data, encoding: .utf8) ?? "Unable to decode response"
                )
                
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    func getAadhaarDetails(referenceId: String, transactionId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let body: [String: Any] = [
            "reference_id": referenceId,
            "transaction_id": transactionId
        ]
        
        guard let request = makeRequest(url: getAadhaarDetailsUrl, body: body) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "ParseError", code: -1)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

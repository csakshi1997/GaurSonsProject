//
//  OpportunityManager.swift
//  GaurSonsApp
//
//  Created by Sakshi on 01/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

class OpportunityManager {
    static let shared = OpportunityManager()
    private init() {}

    var applicants: [SaveModel] = []

    func addApplicant(_ applicant: SaveModel) {
        applicants.append(applicant)
    }

    func updateApplicant(at index: Int, with applicant: SaveModel) {
        guard index >= 0 && index < applicants.count else { return }
        applicants[index] = applicant
    }

    func getApplicant(at index: Int) -> SaveModel? {
        guard index >= 0 && index < applicants.count else { return nil }
        return applicants[index]
    }
}

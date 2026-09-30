//
//  GlobalData.swift
//  FieldBlaze
//
//  Created by Sakshi on 20/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation
import UIKit

class GlobalData: NSObject {
    static var allEOIModel = [EOIModel]()
    static var allEOIModelForAll = [EOIModel]()
    static var allCustomerModel = [CustomerModel]()
    static var allApplicantRecord = [ApplicantRecord]()
    static var allApplicantDetailsModel = ApplicantDetailsModel(dict: [:])
    static var allAccountDetailModel = AccountDetailModel(dict: [:])
    static var allPaymentRecord = [PaymentModel]()
    static var allContentDocModel = [ContentDocModel]()
    static var allVersionDataModel = VersionDataModel(dict: [:])
    static var allCountries: [LocationModel] = []
    static var allStates: [LocationModel] = []
    static var allCities: [LocationModel] = []
    static var user = User(dict: [:])
    static var currentSaveModel = SaveModel(dict: [:])
    static var allInventoryProjects = [InventoryProjectModel]()
    static var allApprovalModel = [ApprovalModel]()
    static var allPropertyModel: [PropertyModel] = []
}

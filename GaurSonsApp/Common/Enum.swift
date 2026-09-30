//
//  Enum.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import Foundation
import UIKit

enum ResponseStatus: Int {
    case success
    case alreadyRegister
    case tokenExpired
    case error
    case badRequest
}

enum PaymentStep {
    case sendLink
    case verifyPayment
    case submit
}

enum FilterType {
    case all
    case eoiConverted
    case eoiNotConverted
    case recentlyViewed
    case thisMonth
    case today
}

enum CustomerDetails: String, CaseIterable {
    case details = "DETAILS"
    case contacts = "CONTACTS"
    case orders = "ORDERS"
    case beatPlan = "BEAT PLAN"
    case visits = "VISITS"
    case stocks = "STOCKS"
    case returns = "RETURNS"
}

enum SchemeDiscountType: String {
    case flat = "Flat"
    case percentage = "%"
    case quantity = "Quantity"
}

enum UploadField: String {
    case aadhaar = "Aadhaar Upload"
    case pan = "PAN Upload"
    case passport = "Passport Upload"
    case applicantPhoto = "applicantPhoto"
}

let customDateFormatter1 = CustomDateFormatter()
let todayDateString1 = customDateFormatter1.getTodayDateString()

enum EOISummaryFilter {
    case total
    case completed
    case inProgress
    case cancelled
}

enum CustomerSummaryFilter {
    case registered
    case booked
}

enum FilterTypeForEOI {
    case none
    case today
    case digital
    case directSales
    case launchEvent
    case legacy
    case unsold
}

enum EmptyState {
    case noInternet
    case noResults
}

enum ProfileDocumentType {
    case cancelledCheque
    case pan
    case aadhaar
    case gst
    case reraCertificate
    case logo
    case profilePhoto
}







//
//  ApplicantDetailsModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 09/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

//struct ApplicantDetailsModel {
//    var id: String?
//    var name: String?
//    var recordTypeId: String?
//    
//    var opportunityId: String?
//    var opportunityName: String?
//    var applicantType: String?
//    
//    var isEOI: Bool?
//    var isActive: Bool?
//    var primary: Bool?
//    
//    var nameOfCompanyFirm: String?
//    var dateOfIncorporation: String?
//    var authorizedContactPerson: String?
//    var authorizedContactPhone: String?
//    var authorizedContactEmail: String?
//    
//    var phoneHome: String?
//    var phoneWork: String?
//    var phoneOther: String?
//    var mobileNumber: String?
//    var email: String?
//    
//    var panNumber: String?
//    var aadhaarNumber: String?
//    var fatherSpouseName: String?
//    var maritalStatus: String?
//    var gender: String?
//    var nationality: String?
//    var dob: String?
//    var occupation: String?
//    
//    var companyIdentificationNumber: String?
//    var directorIdNumber: String?
//    var priorInvestmentInGaurs: Bool?
//    
//    var selfOwned: Bool?
//    var correspondenceAddress: String?
//    var correspondenceCountry: String?
//    var correspondenceState: String?
//    var correspondenceCity: String?
//    var correspondencePincode: String?
//    
//    var registeredSelfOwned: Bool?
//    var registeredAddress: String?
//    var registeredCountry: String?
//    var registeredState: String?
//    var registeredCity: String?
//    var registeredPincode: String?
//    
//    var permanentSelfOwned: Bool?
//    var permanentAddress: String?
//    var permanentCountry: String?
//    var permanentState: String?
//    var permanentCity: String?
//    var permanentPincode: String?
//    var permanentSameAsCorrespondence: Bool?
//    var registeredSameAsCorrespondence: Bool?
//    
//    var employmentType: String?
//    var professionTitle: String?
//    var companyName: String?
//    
//    var notes: String?
//    
//    var bankName: String?
//    var bankAccountNumber: String?
//    var bankIfsc: String?
//    var branchCode: String?
//    var branchName: String?
//    var upiId: String?
//    
//    var residentType: String?
//    
//    var salutationForRelative: String?
//    var salutationForAuthorisedSignatory: String?
//    var relation: String?
//
//    var panOfAuthorizedSignatory: String?
//    var aadhaarOfAuthorizedSignatory: String?
//
//    var rented: Bool?
//    var registeredRented: Bool?
//
//    var gstNo: String?
//    var authorisationLetterDate: String?
//    var registrationState: String?
//    var partnershipLLPHUFDeedDate: String?
//    var registrationNo: String?
//
//    var priorInvestmentExistingProject: Bool?
//    var unitNumber: String?
//
//    var projectId: String?
//    var projectName: String?
//    var channelPartnerVisible: Bool?
//
//    var corporateLLPIdentificationNumber: String?
//    var maskedData: MaskedData?
//    
//    struct MaskedField {
//        var defaultValue: String?
//
//        init(dict: [String: Any]) {
//            self.defaultValue = dict["Default"] as? String
//        }
//    }
//    
//    struct MaskedData {
//        var mobile: MaskedField?
//        var email: MaskedField?
//
//        init(dict: [String: Any]) {
//
//            if let mobileDict = dict["Mobile"] as? [String: Any] {
//                self.mobile = MaskedField(dict: mobileDict)
//            }
//
//            if let emailDict = dict["Email"] as? [String: Any] {
//                self.email = MaskedField(dict: emailDict)
//            }
//        }
//    }
//    
//    // MARK: Init from dictionary
//    init(dict: [String: Any]) {
//        self.id = dict["Id"] as? String
//        self.name = dict["Name"] as? String
//        self.recordTypeId = dict["RecordTypeId"] as? String
//        
//        self.opportunityId = (dict["Opportunity__r"] as? [String: Any])?["Id"] as? String
//        self.opportunityName = (dict["Opportunity__r"] as? [String: Any])?["Name"] as? String
//        self.applicantType = (dict["Opportunity__r"] as? [String: Any])?["Applicant_Type__c"] as? String
//        
//        self.isEOI = dict["IsEOI__c"] as? Bool
//        self.isActive = dict["Is_Active__c"] as? Bool
//        self.primary = dict["Primary__c"] as? Bool
//        
//        self.nameOfCompanyFirm = dict["Name_of_Company_Firm_LLP__c"] as? String
//        self.dateOfIncorporation = dict["Date_of_Incorporation__c"] as? String
//        self.authorizedContactPerson = dict["Name_of_the_authorized_contact_person__c"] as? String
//        self.authorizedContactPhone = dict["Authorized_contact_person_Phone__c"] as? String
//        self.authorizedContactEmail = dict["Authorized_contact_person_Email__c"] as? String
//        
//        self.phoneHome = dict["Phone_Number_Home__c"] as? String
//        self.phoneWork = dict["Phone_Number_Work__c"] as? String
//        self.phoneOther = dict["Phone_Number_Any_other__c"] as? String
//        self.mobileNumber = dict["Applicant_Mobile_Number__c"] as? String
//        self.email = dict["Applicant_Email_ID__c"] as? String
//        
//        self.panNumber = dict["PAN_Number__c"] as? String
//        self.aadhaarNumber = dict["Aadhaar_Number__c"] as? String
//        self.fatherSpouseName = dict["Son_of_Daughter_of_Wife_of__c"] as? String
//        self.maritalStatus = dict["Marital_Status__c"] as? String
//        self.gender = dict["Gender__c"] as? String
//        self.nationality = dict["Nationality__c"] as? String
//        self.dob = dict["D_O_B__c"] as? String
//        self.occupation = dict["Occupation__c"] as? String
//        
//        self.companyIdentificationNumber = dict["Company_LLP_Identification_Number_CIN_L__c"] as? String
//        self.directorIdNumber = dict["Director_Designated_Partner_Iden_No__c"] as? String
//        self.priorInvestmentInGaurs = dict["Prior_Investment_in_Gaurs_Group_Project__c"] as? Bool
//        
//        self.selfOwned = dict["Self_Owned__c"] as? Bool
//        self.correspondenceAddress = dict["Correspondence_Address__c"] as? String
//        self.correspondenceCountry = dict["Correspondence_Country__c"] as? String
//        self.correspondenceState = dict["Correspondence_State__c"] as? String
//        self.correspondenceCity = dict["Correspondence_City__c"] as? String
//        self.correspondencePincode = dict["Correspondence_Pincode__c"] as? String
//        
//        self.registeredSelfOwned = dict["Registered_Self_Owned__c"] as? Bool
//        self.registeredAddress = dict["Registered_Address__c"] as? String
//        self.registeredCountry = dict["Registered_Country__c"] as? String
//        self.registeredState = dict["Registered_States__c"] as? String
//        self.registeredCity = dict["Registered_City__c"] as? String
//        self.registeredPincode = dict["Registered_Pincode__c"] as? String
//        
//        self.permanentSelfOwned = dict["Permanent_Self_Owned__c"] as? Bool
//        self.permanentAddress = dict["Permanent_Address__c"] as? String
//        self.permanentCountry = dict["Permanent_Country__c"] as? String
//        self.permanentState = dict["Permanent_State__c"] as? String
//        self.permanentCity = dict["Permanent_City__c"] as? String
//        self.permanentPincode = dict["Permanent_Pincode__c"] as? String
//        self.permanentSameAsCorrespondence = dict["Permanent_Address_is_Same_as_Corresponde__c"] as? Bool
//        self.registeredSameAsCorrespondence = dict["Registered_Address_is_Same_as_Correspond__c"] as? Bool
//        
//        self.employmentType = dict["Employment_Type__c"] as? String
//        self.professionTitle = dict["Profession_Job_Title__c"] as? String
//        self.companyName = dict["Company_Name__c"] as? String
//        
//        self.notes = dict["Note__c"] as? String
//        
//        self.bankName = dict["Bank_Name__c"] as? String
//        self.bankAccountNumber = dict["Bank_Account_Number__c"] as? String
//        self.bankIfsc = dict["Bank_IFSC_Code__c"] as? String
//        self.branchCode = dict["Branch_Code__c"] as? String
//        self.branchName = dict["Branch_Name__c"] as? String
//        self.upiId = dict["UPI_ID__c"] as? String
//        
//        self.residentType = dict["Resident_Type__c"] as? String
//        
//        self.salutationForRelative = dict["Salutation_for_Relative__c"] as? String
//        self.salutationForAuthorisedSignatory = dict["Salutation_for_Authorised_Signatory__c"] as? String
//        self.relation = dict["Relation__c"] as? String
//
//        self.panOfAuthorizedSignatory = dict["PAN_of_Authorized_Signatory__c"] as? String
//        self.aadhaarOfAuthorizedSignatory = dict["Aadhaar_of_Authorized_Signatory__c"] as? String
//
//        self.rented = dict["Rented__c"] as? Bool
//        self.registeredRented = dict["Registered_Rented__c"] as? Bool
//
//        self.gstNo = dict["GST_No__c"] as? String
//        self.authorisationLetterDate = dict["Authorisation_Letter_Date__c"] as? String
//        self.registrationState = dict["Registration_State__c"] as? String
//        self.partnershipLLPHUFDeedDate = dict["Partnership_LLP_HUF_Deed_Date__c"] as? String
//        self.registrationNo = dict["Registration_No__c"] as? String
//
//        self.priorInvestmentExistingProject = dict["Prior_investment_in_the_existing_Project__c"] as? Bool
//        self.unitNumber = dict["Unit_Number__c"] as? String
//
//        self.projectId = (dict["Project_Name__r"] as? [String: Any])?["Id"] as? String
//        self.projectName = (dict["Project_Name__r"] as? [String: Any])?["Name"] as? String
//        self.channelPartnerVisible = (dict["Project_Name__r"] as? [String: Any])?["Channel_Partner_Visible__c"] as? Bool
//
//        self.corporateLLPIdentificationNumber = dict["Corporate_LLP_Identification_Number__c"] as? String
//        
//        if let maskedDictString = dict["Masked_Data__c"] as? String,
//           let data = maskedDictString.data(using: .utf8) {
//
//            do {
//
//                if let maskedDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//
//                    self.maskedData = MaskedData(dict: maskedDict)
//                }
//
//            } catch {
//
//                print("❌ Failed to parse Masked_Data__c:", error.localizedDescription)
//            }
//        }
//        
//    }
//}


struct ApplicantDetailsModel {
    
    // MARK: - Basic Details
    
    var id: String?
    var name: String?
    var age: String?
    var sequence: String?
    var recordTypeId: String?
    
    // MARK: - Opportunity Details
    
    var opportunityId: String?
    var opportunityName: String?
    var applicantType: String?
    
    // MARK: - EOI / Status
    
    var isEOI: Bool?
    var isActive: Bool?
    var primary: Bool?
    
    // MARK: - Company Details
    
    var nameOfCompanyFirm: String?
    var dateOfIncorporation: String?
    var boardOfResolutionDate: String?
    var authorizedContactPerson: String?
    var authorizedContactPhone: String?
    var authorizedContactEmail: String?
    var companyFirmLLPPan: String?
    var corporateLLPIdentificationNumber: String?
    var companyIdentificationNumber: String?
    var directorIdNumber: String?
    
    
    // MARK: - Applicant Contact Details
    
    var phoneHome: String?
    var phoneWork: String?
    var phoneOther: String?
    var mobileNumber: String?
    var email: String?
    
    // MARK: - Applicant Personal Details
    
    var panNumber: String?
    var aadhaarNumber: String?
    var passportNumber: String?
    var passportValidity: String?
    var fatherSpouseName: String?
    var maritalStatus: String?
    var gender: String?
    var nationality: String?
    var dob: String?
    var salutation: String?
    var occupation: String?
    
    // MARK: - Investment Details
    
    var priorInvestmentInGaurs: Bool?
    var priorInvestmentExistingProject: String?
    var unitNumber: Int?
    
    // MARK: - Correspondence Address
    
    var selfOwned: Bool?
    var rented: Bool?
    
    var correspondenceAddress: String?
    var correspondenceCountry: String?
    var correspondenceState: String?
    var correspondenceCity: String?
    var correspondencePincode: String?
    
    // MARK: - Registered Address
    
    var registeredSelfOwned: Bool?
    var registeredRented: Bool?
    var registeredAddress: String?
    var registeredCountry: String?
    var registeredState: String?
    var registeredCity: String?
    var registeredPincode: String?
    
    // MARK: - Permanent Address
    
    var permanentSelfOwned: Bool?
    var permanentRented: Bool?
    var permanentAddress: String?
    var permanentCountry: String?
    var permanentState: String?
    var permanentCity: String?
    var permanentPincode: String?
    
    var permanentSameAsCorrespondence: Bool?
    var registeredSameAsCorrespondence: Bool?
    
    // MARK: - Employment Details
    
    var employmentType: String?
    var professionTitle: String?
    var companyName: String?
    
    // MARK: - Other
    
    var notes: String?
    
    // MARK: - Bank Details
    
    var bankName: String?
    var bankAccountNumber: String?
    var bankIfsc: String?
    var branchCode: String?
    var branchName: String?
    var upiId: String?
    
    // MARK: - Other Applicant Details
    
    var residentType: String?
    
    var salutationForRelative: String?
    var salutationForAuthorisedSignatory: String?
    var relation: String?
    
    var panOfAuthorizedSignatory: String?
    var aadhaarOfAuthorizedSignatory: String?
    
    // MARK: - Registration Details
    
    var gstNo: String?
    var authorisationLetterDate: String?
    var registrationState: String?
    var partnershipLLPHUFDeedDate: String?
    var registrationNo: String?
    
    // MARK: - Project Details
    
    var projectId: String?
    var projectName: String?
    var channelPartnerVisible: Bool?
    
    // MARK: - Masked Data
    
    var maskedData: MaskedData?
    
    // MARK: - Masked Field
    
    struct MaskedField {
        var defaultValue: String?
        
        init(dict: [String: Any]) {
            self.defaultValue = dict["Default"] as? String
        }
    }
    
    // MARK: - Masked Data
    
    struct MaskedData {
        var mobile: MaskedField?
        var email: MaskedField?
        
        init(dict: [String: Any]) {
            
            if let mobileDict = dict["Mobile"] as? [String: Any] {
                self.mobile = MaskedField(dict: mobileDict)
            }
            
            if let emailDict = dict["Email"] as? [String: Any] {
                self.email = MaskedField(dict: emailDict)
            }
        }
    }
    
    // MARK: - Init from Dictionary
    
    init(dict: [String: Any]) {
        
        // MARK: Basic Details
        
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        self.age = dict["Age__c"] as? String
        self.sequence = dict["Sequence__c"] as? String
        self.recordTypeId = dict["RecordTypeId"] as? String
        
        // MARK: Opportunity
        
        if let opportunity = dict["Opportunity__r"] as? [String: Any] {
            self.opportunityId = opportunity["Id"] as? String
            self.opportunityName = opportunity["Name"] as? String
            self.applicantType = opportunity["Applicant_Type__c"] as? String
        }
        
        // MARK: EOI / Status
        
        self.isEOI = dict["IsEOI__c"] as? Bool
        self.isActive = dict["Is_Active__c"] as? Bool
        self.primary = dict["Primary__c"] as? Bool
        
        // MARK: Company Details
        
        self.nameOfCompanyFirm =
            dict["Name_of_Company_Firm_LLP__c"] as? String
        
        self.dateOfIncorporation =
            dict["Date_of_Incorporation__c"] as? String
        
        self.boardOfResolutionDate =
            dict["Board_of_Resolution_Date__c"] as? String
        
        self.authorizedContactPerson =
            dict["Name_of_the_authorized_contact_person__c"] as? String
        
        self.authorizedContactPhone =
            dict["Authorized_contact_person_Phone__c"] as? String
        
        self.authorizedContactEmail =
            dict["Authorized_contact_person_Email__c"] as? String
        
        self.companyFirmLLPPan =
            dict["Company_Firm_LLP_PAN__c"] as? String
        
        self.corporateLLPIdentificationNumber =
            dict["Corporate_LLP_Identification_Number__c"] as? String
        
        self.companyIdentificationNumber =
            dict["Company_LLP_Identification_Number_CIN_L__c"] as? String
        
        self.directorIdNumber =
            dict["Director_Designated_Partner_Iden_No__c"] as? String
        
        // MARK: Contact Details
        
        self.phoneHome =
            dict["Phone_Number_Home__c"] as? String
        
        self.phoneWork =
            dict["Phone_Number_Work__c"] as? String
        
        self.phoneOther =
            dict["Phone_Number_Any_other__c"] as? String
        
        self.mobileNumber =
            dict["Applicant_Mobile_Number__c"] as? String
        
        self.email =
            dict["Applicant_Email_ID__c"] as? String
        
        // MARK: Personal Details
        
        self.panNumber =
            dict["PAN_Number__c"] as? String
        
        self.aadhaarNumber =
            dict["Aadhaar_Number__c"] as? String
        
        self.passportNumber =
            dict["Passport_Number__c"] as? String
        
        self.passportValidity =
            dict["Passport_Validity__c"] as? String
        
        self.fatherSpouseName =
            dict["Son_of_Daughter_of_Wife_of__c"] as? String
        
        self.maritalStatus =
            dict["Marital_Status__c"] as? String
        
        self.gender =
            dict["Gender__c"] as? String
        
        self.nationality =
            dict["Nationality__c"] as? String
        
        self.dob =
            dict["D_O_B__c"] as? String
        
        self.salutation =
            dict["Salutation__c"] as? String
        
        self.occupation =
            dict["Occupation__c"] as? String
        
        // MARK: Investment
        
        // MARK: Investment

        if let value = dict["Prior_Investment_in_Gaurs_Group_Project__c"] {
            if let boolValue = value as? Bool {
                self.priorInvestmentInGaurs = boolValue
            } else {
                let stringValue = String(describing: value).lowercased()
                self.priorInvestmentInGaurs = (stringValue == "yes" || stringValue == "true" || stringValue == "1")
            }
        } else {
            self.priorInvestmentInGaurs = nil
        }

        self.priorInvestmentExistingProject =
            dict["Prior_investment_in_the_existing_Project__c"] as? String

        if let value = dict["Unit_Number__c"] {
            if let intValue = value as? Int {
                self.unitNumber = intValue
            } else if let stringValue = value as? String {
                self.unitNumber = Int(stringValue)
            } else if let doubleValue = value as? Double {
                self.unitNumber = Int(doubleValue)
            } else {
                self.unitNumber = nil
            }
        } else {
            self.unitNumber = nil
        }
        
        self.panOfAuthorizedSignatory =

            dict["PAN_of_Authorized_Signatory__c"] as? String

        self.aadhaarOfAuthorizedSignatory =

            dict["Aadhaar_of_Authorized_Signatory__c"] as? String
        
        self.selfOwned =
            dict["Self_Owned__c"] as? Bool
        
        self.rented =
            dict["Rented__c"] as? Bool
        
        self.correspondenceAddress =
            dict["Correspondence_Address__c"] as? String
        
        self.correspondenceCountry =
            dict["Correspondence_Country__c"] as? String
        
        self.correspondenceState =
            dict["Correspondence_State__c"] as? String
        
        self.correspondenceCity =
            dict["Correspondence_City__c"] as? String
        
        self.correspondencePincode =
            dict["Correspondence_Pincode__c"] as? String
        
        // MARK: Registered Address
        
        self.registeredSelfOwned =
            dict["Registered_Self_Owned__c"] as? Bool
        
        self.registeredRented =
            dict["Registered_Rented__c"] as? Bool
        
        self.registeredAddress =
            dict["Registered_Address__c"] as? String
        
        self.registeredCountry =
            dict["Registered_Country__c"] as? String
        
        self.registeredState =
            dict["Registered_States__c"] as? String
        
        self.registeredCity =
            dict["Registered_City__c"] as? String
        
        self.registeredPincode =
            dict["Registered_Pincode__c"] as? String
        
        // MARK: Permanent Address
        
        self.permanentSelfOwned =
            dict["Permanent_Self_Owned__c"] as? Bool
        
        self.permanentAddress =
            dict["Permanent_Address__c"] as? String
        
        self.permanentCountry =
            dict["Permanent_Country__c"] as? String
        
        self.permanentState =
            dict["Permanent_State__c"] as? String
        
        self.permanentCity =
            dict["Permanent_City__c"] as? String
        
        self.permanentPincode =
            dict["Permanent_Pincode__c"] as? String
        
        self.permanentSameAsCorrespondence =
            dict["Permanent_Address_is_Same_as_Corresponde__c"] as? Bool
        
        self.registeredSameAsCorrespondence =
            dict["Registered_Address_is_Same_as_Correspond__c"] as? Bool
        
        // MARK: Employment
        
        self.employmentType =
            dict["Employment_Type__c"] as? String
        
        self.professionTitle =
            dict["Profession_Job_Title__c"] as? String
        
        self.companyName =
            dict["Company_Name__c"] as? String
        
        // MARK: Notes
        
        self.notes =
            dict["Note__c"] as? String
        
        // MARK: Bank Details
        
        self.bankName =
            dict["Bank_Name__c"] as? String
        
        self.bankAccountNumber =
            dict["Bank_Account_Number__c"] as? String
        
        self.bankIfsc =
            dict["Bank_IFSC_Code__c"] as? String
        
        self.branchCode =
            dict["Branch_Code__c"] as? String
        
        self.branchName =
            dict["Branch_Name__c"] as? String
        
        self.upiId =
            dict["UPI_ID__c"] as? String
        
        // MARK: Other
        
        self.residentType =
            dict["Resident_Type__c"] as? String
        
        self.salutationForRelative =
            dict["Salutation_for_Relative__c"] as? String
        
        self.salutationForAuthorisedSignatory =
            dict["Salutation_for_Authorised_Signatory__c"] as? String
        
        self.relation =
            dict["Relation__c"] as? String
        
        self.panOfAuthorizedSignatory =
            dict["PAN_of_Authorized_Signatory__c"] as? String
        
        self.aadhaarOfAuthorizedSignatory =
            dict["Aadhaar_of_Authorized_Signatory__c"] as? String
        
        // MARK: Registration
        
        self.gstNo =
            dict["GST_No__c"] as? String
        
        self.authorisationLetterDate =
            dict["Authorisation_Letter_Date__c"] as? String
        
        self.registrationState =
            dict["Registration_State__c"] as? String
        
        self.partnershipLLPHUFDeedDate =
            dict["Partnership_LLP_HUF_Deed_Date__c"] as? String
        
        self.registrationNo =
            dict["Registration_No__c"] as? String
        
        // MARK: Project
        
        if let project = dict["Project_Name__r"] as? [String: Any] {
            
            self.projectId =
                project["Id"] as? String
            
            self.projectName =
                project["Name"] as? String
            
            self.channelPartnerVisible =
                project["Channel_Partner_Visible__c"] as? Bool
        }
        
        // MARK: Masked Data
        
        self.maskedData = nil
        
        if let maskedDictString = dict["Masked_Data__c"] as? String,
           let data = maskedDictString.data(using: .utf8) {
            
            do {
                
                if let maskedDict =
                    try JSONSerialization.jsonObject(
                        with: data,
                        options: []
                    ) as? [String: Any] {
                    
                    self.maskedData = MaskedData(dict: maskedDict)
                }
                
            } catch {
                
                print(
                    "❌ Failed to parse Masked_Data__c:",
                    error.localizedDescription
                )
            }
        }
    }
}

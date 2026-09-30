//
//  SaveModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 01/10/25.
//

import Foundation
import UIKit

//struct SaveModel {
//    var id: String?
//    var name: String?
//    var recordTypeId: String?
//    var firstApplicant: String?
//    var secondApplicant: String?
//    var age: Double?
//    var applicantType: String?
//    var createdTime: String?
//    var mobileNumber: String?
//    var priorityNumber: String?
//    var projectName1: String?
//    var lastHourCheck: Bool?
//    var aadhaarNumber: String?
//    var aadhaarOfAuthorizedSignatory: String?
//    var aadharEmail: String?
//    var aadharMobile: String?
//    
//    var panNumber: String?
//    var panOfAuthorizedSignatory: String?
//    
//    var passportNumber: String?
//    var passportValidity: String?
//    
//    var driversLicense: String?
//    var voterId: String?
//        
//    var applicantCode: String?
//    var applicantEmail: String?
//    var applicantMobile: String?
//    
//    var salutation: String?
//    var salutationForAuthorisedSignatory: String?
//    var salutationForRelative: String?
//    
//    var gender: String?
//    var maritalStatus: String?
//    var nationality: String?
//    
//    var dob: String?
//    
//    var occupation: String?
//    var profession: String?
//    var employmentType: String?
//    
//    var relation: String?
//    var relationType: String?
//    
//    var note: String?
//        
//    var relativeName: String?
//        
//    var companyName: String?
//    var companyAddress: String?
//    var companyEmail: String?
//    
//    var companyPANNumber: String?
//    var companyRegistrationNumber: Int?
//    
//    var nameOfCompanyFirmLLP: String?
//    var dateOfIncorporation: String?
//    
//    var companyFirmLLPPAN: String?
//    
//    var companyLLPIdentificationNumber: String?
//    var corporateLLPIdentificationNumber: String?
//    
//    var directorDesignatedPartnerIdentifica: String?
//    var directorDesignatedPartnerIdenNo: String?
//    
//    var nameOfAuthorizedContactPerson: String?
//    var authorizedContactPersonPhone: String?
//    var authorizedContactPersonEmail: String?
//    
//    var authorisationLetterDate: String?
//    
//    var boardResolutionDate: String?
//    
//    var partnershipLLPHUFDeedDate: String?
//        
//    var gstAddress: String?
//    var gstNo: String?
//    var gstRegistrationNo: String?
//        
//    var bankAccount: String?
//    var bankIFSC: String?
//    var bankName: String?
//    var branchCode: String?
//    var branchName: String?
//    var upiId: String?
//        
//    var correspondenceAddress: String?
//    var correspondenceCity: String?
//    var correspondenceCountry: String?
//    var correspondencePincode: String?
//    var correspondenceState: String?
//        
//    var permanentAddress: String?
//    var permanentCity: String?
//    var permanentCountry: String?
//    var permanentPincode: String?
//    var permanentState: String?
//    
//    var permanentAddressIsSameAsCorrespondence: Bool?
//    
//    var permanentSelfOwned: Bool?
//    var permanentRented: Bool?
//        
//    var registeredAddress: String?
//    var registeredCountry: String?
//    var registeredStates: String?
//    var registeredCity: String?
//    var registeredPincode: String?
//    
//    var registeredAddressIsSameAsCorrespond: Bool?
//    
//    var registeredSelfOwned: Bool?
//    var registeredRented: Bool?
//        
//    var rented: Bool?
//    var selfOwned: Bool?
//    var residentType: String?
//        
//    var phoneOther: String?
//    var phoneHome: String?
//    var phoneWork: String?
//        
//    var priorInvestmentInGaursGroupProject: String?
//    var priorInvestmentInExistingProject: String?
//    var priorProjectName: String?
//    
//    var ownershipPercentage: Int?
//        
//    var accountId: String?
//    var bookingId: String?
//    var clonedApplicantDetailsId: String?
//    var opportunityId: String?
//    var projectNameId: String?
//    
//    var ownerId: String?
//    var createdById: String?
//    var lastModifiedById: String?
//    var rmNameId: String?
//        
//    var address: String?
//    var addressC: String?
//    
//    var registrationNo: String?
//    var registrationState: String?
//    
//    var sequence: String?
//    var sapCode: String?
//    
//    var unitNumber: Int?
//    
//    var verificationType: String?
//    var verifiedByAdhaar: Bool?
//    
//    var useCustomerData: Bool?
//    
//    var encryptedValues: String?
//    var maskedData: String?
//    
//    var eoiSubmittedBy: String?
//        
//    var primary: Bool?
//    var isActive: Bool?
//    var isCloned: Bool?
//    var isEOI: Bool?
//        
//    var profileImage: String?
//        
//    var panUploadFileName: String?
//    var aadhaarUploadFileName: String?
//    var passportUploadFileName: String?
//    var cinUploadFileName: String?
//    var dinUploadFileName: String?
//    var coiUploadFileName: String?
//    var gstUploadFileName: String?
//    var resolutionUploadFileName: String?
//    var authorizationLetterFileName: String?
//    var partnershipFileName: String?
//    var registrationCertificateFileName: String?
//    var cancelledChequeFileName: String?
//    var applicantPhotoFileName:String?
//    var authorizationPanUploadFileName: String?
//    var authorizationAadhaarUploadFileName: String?
//    
////    var personalSalutation:String?
////    var personalRelativeSalutation:String?
////    var personalRelativeName:String?
//        
//    var attributes: Attributes?
//        
//    var uploadedFiles: [FileUploadModel] = []
//    
//    struct Attributes {
//        var referenceId: String?
//        var type: String?
//        
//        init(dict: [String: Any]) {
//            self.referenceId = dict["referenceId"] as? String
//            self.type = dict["type"] as? String
//        }
//    }
//    
//    init(dict: [String: Any]) {
//        
//        self.id = dict["Id"] as? String
//        self.name = dict["Name"] as? String
//        self.recordTypeId = dict["RecordTypeId"] as? String
//        
//        self.firstApplicant = dict["X1st_Applicant__c"] as? String
//        self.secondApplicant = dict["X2nd_Applicant__c"] as? String
//        
//        self.aadhaarNumber = dict["Aadhaar_Number__c"] as? String
//        self.aadhaarOfAuthorizedSignatory = dict["Aadhaar_of_Authorized_Signatory__c"] as? String
//        
//        self.aadharEmail = dict["Aadhar_Email__c"] as? String
//        self.aadharMobile = dict["Aadhar_Mobile__c"] as? String
//        
//        self.address = dict["Address__c"] as? String
//        self.addressC = dict["Address_c__c"] as? String
//        
//        self.age = dict["Age__c"] as? Double
//        
//        self.applicantCode = dict["Applicant_Code__c"] as? String
//        self.applicantEmail = dict["Applicant_Email_ID__c"] as? String
//        self.applicantMobile = dict["Applicant_Mobile_Number__c"] as? String
//        
//        self.authorisationLetterDate = dict["Authorisation_Letter_Date__c"] as? String
//        
//        self.bankAccount = dict["Bank_Account_Number__c"] as? String
//        self.bankIFSC = dict["Bank_IFSC_Code__c"] as? String
//        self.bankName = dict["Bank_Name__c"] as? String
//        
//        self.branchCode = dict["Branch_Code__c"] as? String
//        self.branchName = dict["Branch_Name__c"] as? String
//        
//        self.companyName = dict["Company_Name__c"] as? String
//        self.companyAddress = dict["Company_Address__c"] as? String
//        self.companyEmail = dict["Company_Email__c"] as? String
//        
//        self.companyPANNumber = dict["Company_PAN_Number__c"] as? String
//        
//        self.companyFirmLLPPAN = dict["Company_Firm_LLP_PAN__c"] as? String
//        
//        self.companyLLPIdentificationNumber = dict["Company_LLP_Identification_Number_CIN_L__c"] as? String
//        
//        self.corporateLLPIdentificationNumber = dict["Corporate_LLP_Identification_Number__c"] as? String
//        
//        self.correspondenceAddress = dict["Correspondence_Address__c"] as? String
//        self.correspondenceCity = dict["Correspondence_City__c"] as? String
//        self.correspondenceCountry = dict["Correspondence_Country__c"] as? String
//        self.correspondencePincode = dict["Correspondence_Pincode__c"] as? String
//        self.correspondenceState = dict["Correspondence_State__c"] as? String
//        
//        self.createdTime = dict["Created_Time__c"] as? String
//        
//        self.dob = dict["D_O_B__c"] as? String
//        
//        self.dateOfIncorporation = dict["Date_of_Incorporation__c"] as? String
//        
//        self.directorDesignatedPartnerIdenNo = dict["Director_Designated_Partner_Iden_No__c"] as? String
//        
//        self.driversLicense = dict["Driver_s_License__c"] as? String
//        
//        self.employmentType = dict["Employment_Type__c"] as? String
//        
//        self.gender = dict["Gender__c"] as? String
//        
//        self.gstNo = dict["GST_No__c"] as? String
//        self.gstRegistrationNo = dict["GST_Registration_No__c"] as? String
//        
//        self.maritalStatus = dict["Marital_Status__c"] as? String
//        
//        self.nameOfAuthorizedContactPerson = dict["Name_of_the_authorized_contact_person__c"] as? String
//        
//        self.nameOfCompanyFirmLLP = dict["Name_of_Company_Firm_LLP__c"] as? String
//        
//        self.nationality = dict["Nationality__c"] as? String
//        
//        self.note = dict["Note__c"] as? String
//        
//        self.occupation = dict["Occupation__c"] as? String
//        
//        self.opportunityId = dict["Opportunity__c"] as? String
//        
//        self.panNumber = dict["PAN_Number__c"] as? String
//        
//        self.passportNumber = dict["Passport_Number__c"] as? String
//        
//        self.permanentAddress = dict["Permanent_Address__c"] as? String
//        self.permanentCity = dict["Permanent_City__c"] as? String
//        self.permanentCountry = dict["Permanent_Country__c"] as? String
//        self.permanentPincode = dict["Permanent_Pincode__c"] as? String
//        self.permanentState = dict["Permanent_State__c"] as? String
//        
//        self.phoneHome = dict["Phone_Number_Home__c"] as? String
//        self.phoneWork = dict["Phone_Number_Work__c"] as? String
//        self.phoneOther = dict["Phone_Number_Any_other__c"] as? String
//        
//        self.primary = dict["Primary__c"] as? Bool
//        
//        self.priorInvestmentInGaursGroupProject = dict["Prior_Investment_in_Gaurs_Group_Project__c"] as? String
//        
//        self.profession = dict["Profession_Job_Title__c"] as? String
//        
//        self.registeredAddress = dict["Registered_Address__c"] as? String
//        self.registeredCity = dict["Registered_City__c"] as? String
//        self.registeredCountry = dict["Registered_Country__c"] as? String
//        self.registeredStates = dict["Registered_States__c"] as? String
//        self.registeredPincode = dict["Registered_Pincode__c"] as? String
//        
//        self.registeredRented = dict["Registered_Rented__c"] as? Bool
//        self.registeredSelfOwned = dict["Registered_Self_Owned__c"] as? Bool
//        
//        self.rented = dict["Rented__c"] as? Bool
//        
//        self.residentType = dict["Resident_Type__c"] as? String
//        
//        self.selfOwned = dict["Self_Owned__c"] as? Bool
//        
//        self.upiId = dict["UPI_ID__c"] as? String
//        
//        if let attributesDict = dict["attributes"] as? [String: Any] {
//            self.attributes = Attributes(dict: attributesDict)
//        }
//    }
//}

struct SaveModel {

    // MARK: - Basic
    var id: String?
    var name: String?
    var recordTypeId: String?
    var sequence: String?
    var age: Double?

    // MARK: - Applicant
    var firstApplicant: String?
    var secondApplicant: String?
    var applicantType: String?
    var createdTime: String?
    var mobileNumber: String?
    var priorityNumber: String?
    var projectName1: String?
    var lastHourCheck: Bool?

    var applicantCode: String?
    var applicantEmail: String?
    var applicantMobile: String?

    // MARK: - Identification
    var aadhaarNumber: String?
    var aadhaarOfAuthorizedSignatory: String?
    var aadharEmail: String?
    var aadharMobile: String?

    var panNumber: String?
    var panOfAuthorizedSignatory: String?

    var passportNumber: String?
    var passportValidity: String?

    var driversLicense: String?
    var voterId: String?

    // MARK: - Salutation / Personal
    var salutation: String?
    var salutationForAuthorisedSignatory: String?
    var salutationForRelative: String?

    var gender: String?
    var maritalStatus: String?
    var nationality: String?
    var dob: String?

    var occupation: String?
    var profession: String?
    var employmentType: String?
    var residentType: String?

    var relation: String?
    var relationType: String?

    var note: String?
    var relativeName: String?

    // MARK: - Company
    var companyName: String?
    var companyAddress: String?
    var companyEmail: String?

    var companyPANNumber: String?
    var companyRegistrationNumber: Int?

    var nameOfCompanyFirmLLP: String?
    var dateOfIncorporation: String?

    var companyFirmLLPPAN: String?

    var companyLLPIdentificationNumber: String?
    var corporateLLPIdentificationNumber: String?

    var directorDesignatedPartnerIdentifica: String?
    var directorDesignatedPartnerIdenNo: String?

    var nameOfAuthorizedContactPerson: String?
    var authorizedContactPersonPhone: String?
    var authorizedContactPersonEmail: String?

    // MARK: - Company Documents / Dates
    var authorisationLetterDate: String?
    var boardResolutionDate: String?
    var partnershipLLPHUFDeedDate: String?

    // MARK: - GST
    var gstAddress: String?
    var gstNo: String?
    var gstRegistrationNo: String?

    // MARK: - Bank
    var bankAccount: String?
    var bankIFSC: String?
    var bankName: String?
    var branchCode: String?
    var branchName: String?
    var upiId: String?

    // MARK: - Correspondence Address
    var correspondenceAddress: String?
    var correspondenceCity: String?
    var correspondenceCountry: String?
    var correspondencePincode: String?
    var correspondenceState: String?

    var selfOwned: Bool?
    var rented: Bool?

    // MARK: - Permanent Address
    var permanentAddress: String?
    var permanentCity: String?
    var permanentCountry: String?
    var permanentPincode: String?
    var permanentState: String?

    var permanentAddressIsSameAsCorrespondence: Bool?
    var permanentSelfOwned: Bool?
    var permanentRented: Bool?

    // MARK: - Registered Address
    var registeredAddress: String?
    var registeredCountry: String?
    var registeredStates: String?
    var registeredCity: String?
    var registeredPincode: String?

    var registeredAddressIsSameAsCorrespond: Bool?
    var registeredSelfOwned: Bool?
    var registeredRented: Bool?

    // MARK: - Contact
    var phoneOther: String?
    var phoneHome: String?
    var phoneWork: String?

    // MARK: - Investment
    var priorInvestmentInGaursGroupProject: String?
    var priorInvestmentInExistingProject: String?
    var priorProjectName: String?
    var ownershipPercentage: Int?

    // MARK: - Salesforce Relationships
    var accountId: String?
    var bookingId: String?
    var clonedApplicantDetailsId: String?
    var opportunityId: String?
    var opportunityName: String?
    var projectNameId: String?
    var projectId: String?
    var channelPartnerVisible: Bool?

    var ownerId: String?
    var createdById: String?
    var lastModifiedById: String?
    var rmNameId: String?

    // MARK: - Address
    var address: String?
    var addressC: String?

    // MARK: - Registration
    var registrationNo: String?
    var registrationState: String?

    // MARK: - Unit
    var unitNumber: String?

    // MARK: - Verification
    var verificationType: String?
    var verifiedByAdhaar: Bool?
    var useCustomerData: Bool?

    // MARK: - Data
    var encryptedValues: String?
    var maskedData: String?

    // MARK: - EOI
    var eoiSubmittedBy: String?

    var primary: Bool?
    var isActive: Bool?
    var isCloned: Bool?
    var isEOI: Bool?

    var profileImage: String?

    // MARK: - Files
    var panUploadFileName: String?
    var aadhaarUploadFileName: String?
    var passportUploadFileName: String?
    var cinUploadFileName: String?
    var dinUploadFileName: String?
    var coiUploadFileName: String?
    var gstUploadFileName: String?
    var resolutionUploadFileName: String?
    var authorizationLetterFileName: String?
    var partnershipFileName: String?
    var registrationCertificateFileName: String?
    var cancelledChequeFileName: String?
    var applicantPhotoFileName: String?
    var authorizationPanUploadFileName: String?
    var authorizationAadhaarUploadFileName: String?

    // MARK: - Salesforce Attributes
    var attributes: Attributes?

    var uploadedFiles: [FileUploadModel] = []

    struct Attributes {
        var referenceId: String?
        var type: String?

        init(dict: [String: Any]) {
            self.referenceId = dict["referenceId"] as? String
            self.type = dict["type"] as? String
        }
    }

    // MARK: - Init
    init(dict: [String: Any]) {

        // MARK: Basic
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        self.recordTypeId = dict["RecordTypeId"] as? String
        self.sequence = dict["Sequence__c"] as? String
        self.age = dict["Age__c"] as? Double

        // MARK: Applicant
        self.firstApplicant = dict["X1st_Applicant__c"] as? String
        self.secondApplicant = dict["X2nd_Applicant__c"] as? String

        self.applicantType =
            (dict["Opportunity__r"] as? [String: Any])?["Applicant_Type__c"] as? String

        self.createdTime = dict["Created_Time__c"] as? String
        self.mobileNumber = dict["Applicant_Mobile_Number__c"] as? String

        self.applicantCode = dict["Applicant_Code__c"] as? String
        self.applicantEmail = dict["Applicant_Email_ID__c"] as? String
        self.applicantMobile = dict["Applicant_Mobile_Number__c"] as? String

        // MARK: Identification
        self.aadhaarNumber = dict["Aadhaar_Number__c"] as? String
        self.aadhaarOfAuthorizedSignatory =
            dict["Aadhaar_of_Authorized_Signatory__c"] as? String

        self.aadharEmail = dict["Aadhar_Email__c"] as? String
        self.aadharMobile = dict["Aadhar_Mobile__c"] as? String

        self.panNumber = dict["PAN_Number__c"] as? String
        self.panOfAuthorizedSignatory =
            dict["PAN_of_Authorized_Signatory__c"] as? String

        self.passportNumber = dict["Passport_Number__c"] as? String
        self.passportValidity = dict["Passport_Validity__c"] as? String

        self.driversLicense = dict["Driver_s_License__c"] as? String
        self.voterId = dict["Voter_ID__c"] as? String

        // MARK: Salutation / Personal
        self.salutation = dict["Salutation__c"] as? String

        self.salutationForAuthorisedSignatory =
            dict["Salutation_for_Authorised_Signatory__c"] as? String

        self.salutationForRelative =
            dict["Salutation_for_Relative__c"] as? String

        self.gender = dict["Gender__c"] as? String
        self.maritalStatus = dict["Marital_Status__c"] as? String
        self.nationality = dict["Nationality__c"] as? String
        self.dob = dict["D_O_B__c"] as? String

        self.occupation = dict["Occupation__c"] as? String
        self.profession = dict["Profession_Job_Title__c"] as? String
        self.employmentType = dict["Employment_Type__c"] as? String

        self.relation = dict["Relation__c"] as? String
        self.note = dict["Note__c"] as? String

        // MARK: Company
        self.companyName = dict["Company_Name__c"] as? String
        self.companyAddress = dict["Company_Address__c"] as? String
        self.companyEmail = dict["Company_Email__c"] as? String

        self.companyPANNumber = dict["Company_PAN_Number__c"] as? String

        self.nameOfCompanyFirmLLP =
            dict["Name_of_Company_Firm_LLP__c"] as? String

        self.dateOfIncorporation =
            dict["Date_of_Incorporation__c"] as? String

        self.companyFirmLLPPAN =
            dict["Company_Firm_LLP_PAN__c"] as? String

        self.companyLLPIdentificationNumber =
            dict["Company_LLP_Identification_Number_CIN_L__c"] as? String

        self.corporateLLPIdentificationNumber =
            dict["Corporate_LLP_Identification_Number__c"] as? String

        self.directorDesignatedPartnerIdenNo =
            dict["Director_Designated_Partner_Iden_No__c"] as? String

        self.nameOfAuthorizedContactPerson =
            dict["Name_of_the_authorized_contact_person__c"] as? String

        self.authorizedContactPersonPhone =
            dict["Authorized_contact_person_Phone__c"] as? String

        self.authorizedContactPersonEmail =
            dict["Authorized_contact_person_Email__c"] as? String

        // MARK: Dates / Documents
        self.authorisationLetterDate =
            dict["Authorisation_Letter_Date__c"] as? String

        self.boardResolutionDate =
            dict["Board_of_Resolution_Date__c"] as? String

        self.partnershipLLPHUFDeedDate =
            dict["Partnership_LLP_HUF_Deed_Date__c"] as? String

        // MARK: GST
        self.gstAddress = dict["GST_Address__c"] as? String
        self.gstNo = dict["GST_No__c"] as? String
        self.gstRegistrationNo = dict["GST_Registration_No__c"] as? String

        // MARK: Bank
        self.bankAccount =
            dict["Bank_Account_Number__c"] as? String

        self.bankIFSC =
            dict["Bank_IFSC_Code__c"] as? String

        self.bankName =
            dict["Bank_Name__c"] as? String

        self.branchCode =
            dict["Branch_Code__c"] as? String

        self.branchName =
            dict["Branch_Name__c"] as? String

        self.upiId =
            dict["UPI_ID__c"] as? String

        // MARK: Correspondence
        self.correspondenceAddress =
            dict["Correspondence_Address__c"] as? String

        self.correspondenceCity =
            dict["Correspondence_City__c"] as? String

        self.correspondenceCountry =
            dict["Correspondence_Country__c"] as? String

        self.correspondencePincode =
            dict["Correspondence_Pincode__c"] as? String

        self.correspondenceState =
            dict["Correspondence_State__c"] as? String

        // MARK: Ownership
        self.selfOwned = dict["Self_Owned__c"] as? Bool
        self.rented = dict["Rented__c"] as? Bool

        // MARK: Permanent
        self.permanentAddress =
            dict["Permanent_Address__c"] as? String

        self.permanentCity =
            dict["Permanent_City__c"] as? String

        self.permanentCountry =
            dict["Permanent_Country__c"] as? String

        self.permanentPincode =
            dict["Permanent_Pincode__c"] as? String

        self.permanentState =
            dict["Permanent_State__c"] as? String

        self.permanentAddressIsSameAsCorrespondence =
            dict["Permanent_Address_is_Same_as_Corresponde__c"] as? Bool

        self.permanentSelfOwned =
            dict["Permanent_Self_Owned__c"] as? Bool

        self.permanentRented =
            dict["Permanent_Rented__c"] as? Bool

        // MARK: Registered
        self.registeredAddress =
            dict["Registered_Address__c"] as? String

        self.registeredCountry =
            dict["Registered_Country__c"] as? String

        self.registeredStates =
            dict["Registered_States__c"] as? String

        self.registeredCity =
            dict["Registered_City__c"] as? String

        self.registeredPincode =
            dict["Registered_Pincode__c"] as? String

        self.registeredAddressIsSameAsCorrespond =
            dict["Registered_Address_is_Same_as_Correspond__c"] as? Bool

        self.registeredSelfOwned =
            dict["Registered_Self_Owned__c"] as? Bool

        self.registeredRented =
            dict["Registered_Rented__c"] as? Bool

        // MARK: Contact
        self.phoneHome =
            dict["Phone_Number_Home__c"] as? String

        self.phoneWork =
            dict["Phone_Number_Work__c"] as? String

        self.phoneOther =
            dict["Phone_Number_Any_other__c"] as? String

        // MARK: Investment
        self.priorInvestmentInGaursGroupProject =
            dict["Prior_Investment_in_Gaurs_Group_Project__c"] as? String

        self.priorInvestmentInExistingProject =
            dict["Prior_investment_in_the_existing_Project__c"] as? String

        // MARK: Relationships
        self.opportunityId =
            (dict["Opportunity__r"] as? [String: Any])?["Id"] as? String

        self.opportunityName =
            (dict["Opportunity__r"] as? [String: Any])?["Name"] as? String

        self.projectId =
            (dict["Project_Name__r"] as? [String: Any])?["Id"] as? String

        self.projectNameId =
            (dict["Project_Name__r"] as? [String: Any])?["Id"] as? String

        self.projectName1 =
            (dict["Project_Name__r"] as? [String: Any])?["Name"] as? String

        self.channelPartnerVisible =
            (dict["Project_Name__r"] as? [String: Any])?["Channel_Partner_Visible__c"] as? Bool

        // MARK: Registration
        self.registrationNo =
            dict["Registration_No__c"] as? String

        self.registrationState =
            dict["Registration_State__c"] as? String

        // MARK: Unit
        if let unit = dict["Unit_Number__c"] as? String {
            self.unitNumber = unit
        } else if let unitString = dict["Unit_Number__c"] as? String {
            self.unitNumber = unitString
        }

        // MARK: Status
        self.primary = dict["Primary__c"] as? Bool
        self.isActive = dict["Is_Active__c"] as? Bool
        self.isEOI = dict["IsEOI__c"] as? Bool

        // MARK: Masked Data
        if let maskedData = dict["Masked_Data__c"] as? String {
            self.maskedData = maskedData
        }

        // MARK: Salesforce Attributes
        if let attributesDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attributesDict)
        }
    }
}

struct FileUploadModel {
    var title: String
    var pathOnClient: String
    var fileType: String   
    var networkId: String?
    var versionData: Data?

    var base64Encoded: String? {
        guard let versionData = versionData else { return nil }
        return versionData.base64EncodedString(options: .lineLength64Characters)
    }

    static func from(image: UIImage, title: String, fileType: String, fileExtension: String = "png") -> FileUploadModel {
        let imageData = image.pngData()
        let filename = "\(title).\(fileExtension)"
        return FileUploadModel(
            title: title,
            pathOnClient: filename,
            fileType: fileType,
            networkId: nil,
            versionData: imageData
        )
    }

    static func from(fileURL: URL, fileType: String) -> FileUploadModel {
        let fileName = fileURL.deletingPathExtension().lastPathComponent
        let fileExtension = fileURL.pathExtension
        let data = try? Data(contentsOf: fileURL)
        return FileUploadModel(
            title: fileName,
            pathOnClient: "\(fileName).\(fileExtension)",
            fileType: fileType,
            networkId: nil,
            versionData: data
        )
    }
}

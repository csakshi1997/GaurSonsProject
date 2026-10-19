//
//  ApplicantListModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 09/09/25.
//

import Foundation

struct ApplicantRecord {
    
    // MARK: - Basic
    
    var id: String?
    var name: String?
    var age: Double?
    var sequence: Double?
    var recordTypeId: String?
    
    // MARK: - Applicant
    
    var applicantMobileNumber: String?
    var applicantEmailID: String?
    var applicantType: String?
    
    var primary: Bool?
    var isEOI: Bool?
    var isActive: Bool?
    
    var residentType: String?
    var maskedData: MaskedData?
    
    // MARK: - Personal
    
    var salutation: String?
    var salutationForRelative: String?
    var salutationForAuthorisedSignatory: String?
    
    var gender: String?
    var maritalStatus: String?
    var nationality: String?
    var dob: String?
    
    var relation: String?
    var occupation: String?
    var employmentType: String?
    var professionJobTitle: String?
    
    var fatherOrSpouseName: String?
    
    // MARK: - Identity
    
    var panNumber: String?
    var aadhaarNumber: String?
    var passportNumber: String?
    var passportValidity: String?
    
    var panOfAuthorizedSignatory: String?
    var aadhaarOfAuthorizedSignatory: String?
    
    // MARK: - Company
    
    var nameOfCompanyFirmLLP: String?
    var dateOfIncorporation: String?
    
    var companyFirmLLPPAN: String?
    var corporateLLPIdentificationNumber: String?
    var companyLLPIdentificationNumber: String?
    var directorDesignatedPartnerIdenNo: String?
    
    var authorizedContactPersonName: String?
    var authorizedContactPersonPhone: String?
    var authorizedContactPersonEmail: String?
    
    // MARK: - Investment
    
    var priorInvestmentInGaursGroupProject: Bool?
    var priorInvestmentExistingProject: String?
    var unitNumber: Int?
    
    // MARK: - Address
    
    var correspondenceAddress: String?
    var correspondenceCountry: String?
    var correspondenceState: String?
    var correspondenceCity: String?
    var correspondencePincode: String?
    
    var registeredAddress: String?
    var registeredCountry: String?
    var registeredStates: String?
    var registeredCity: String?
    var registeredPincode: String?
    
    var permanentAddress: String?
    var permanentCountry: String?
    var permanentState: String?
    var permanentCity: String?
    var permanentPincode: String?
    
    var permanentAddressIsSameAsCorrespondence: Bool?
    var registeredAddressIsSameAsCorrespondence: Bool?
    
    var selfOwned: Bool?
    var rented: Bool?
    
    var registeredSelfOwned: Bool?
    var registeredRented: Bool?
    
    var permanentSelfOwned: Bool?
    var permanentRented: Bool?
    
    // MARK: - Employment
    
    var companyName: String?
    
    // MARK: - Banking
    
    var bankName: String?
    var bankAccountNumber: String?
    var bankIFSCCode: String?
    var branchCode: String?
    var branchName: String?
    var upiId: String?
    
    // MARK: - GST
    
    var gstNo: String?
    
    // MARK: - Registration
    
    var registrationNo: String?
    var registrationState: String?
    
    // MARK: - Dates
    
    var authorisationLetterDate: String?
    var boardOfResolutionDate: String?
    var partnershipLLPHUFDeedDate: String?
    
    // MARK: - Contact
    
    var phoneNumberHome: String?
    var phoneNumberWork: String?
    var phoneNumberOther: String?
    
    // MARK: - Project
    
    var projectName: String?
    var projectId: String?
    var projectChannelPartnerVisible: Bool?
    
    // MARK: - Other
    
    var profileImage: String?
    var note: String?
    
    var createdTime: String?
    var createdDate: String?
    
    // MARK: - Attributes
    
    var attributes: Attributes?
    
    struct Attributes {
        var type: String?
        var url: String?
        
        init(dict: [String: Any]) {
            self.type = dict["type"] as? String
            self.url = dict["url"] as? String
        }
    }
    
    struct MaskedData {
        var mobile: MaskedField?
        var email: MaskedField?

        init(dict: [String: Any]) {
print(dict)
            if let mobileDict = dict["Mobile"] as? [String: Any] {
                self.mobile = MaskedField(dict: mobileDict)
            }

            if let emailDict = dict["Email"] as? [String: Any] {
                self.email = MaskedField(dict: emailDict)
            }
        }
    }

    struct MaskedField {
        var defaultValue: String?

        init(dict: [String: Any]) {
            self.defaultValue = dict["Default"] as? String
        }
    }
    
    // MARK: - Opportunity
    
    var opportunity: Opportunity?
    
    struct Opportunity {
        var id: String?
        var name: String?
        var applicantType: String?
        var attributes: Attributes?
        
        init(dict: [String: Any]) {
            self.id = dict["Id"] as? String
            self.name = dict["Name"] as? String
            self.applicantType = dict["Applicant_Type__c"] as? String
            
            if let attributesDict = dict["attributes"] as? [String: Any] {
                self.attributes = Attributes(dict: attributesDict)
            }
        }
    }
    
    // MARK: - Init
    
    init(dict: [String: Any]) {
        
        // MARK: Basic
        
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        self.age = dict["Age__c"] as? Double
        self.sequence = dict["Sequence__c"] as? Double
        self.recordTypeId = dict["RecordTypeId"] as? String
        
        // MARK: Applicant
        
        self.applicantMobileNumber =
            dict["Applicant_Mobile_Number__c"] as? String
        
        self.applicantEmailID =
            dict["Applicant_Email_ID__c"] as? String
        
        self.primary =
            dict["Primary__c"] as? Bool
        
        self.isEOI =
            dict["IsEOI__c"] as? Bool
        
        self.isActive =
            dict["Is_Active__c"] as? Bool
        
        self.residentType =
            dict["Resident_Type__c"] as? String
        
        if let maskedDictString = dict["Masked_Data__c"] as? String,
           let data = maskedDictString.data(using: .utf8) {

            do {
                if let maskedDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(maskedDict)
                    self.maskedData = MaskedData(dict: maskedDict)
                    print(maskedData)
                    
                }
            } catch {
                print("❌ Failed to parse Masked_Data__c:", error.localizedDescription)
            }
        }
        
        // MARK: Personal
        
        self.salutation =
            dict["Salutation__c"] as? String
        
        self.salutationForRelative =
            dict["Salutation_for_Relative__c"] as? String
        
        self.salutationForAuthorisedSignatory =
            dict["Salutation_for_Authorised_Signatory__c"] as? String
        
        self.gender =
            dict["Gender__c"] as? String
        
        self.maritalStatus =
            dict["Marital_Status__c"] as? String
        
        self.nationality =
            dict["Nationality__c"] as? String
        
        self.dob =
            dict["D_O_B__c"] as? String
        
        self.relation =
            dict["Relation__c"] as? String
        
        self.occupation =
            dict["Occupation__c"] as? String
        
        self.employmentType =
            dict["Employment_Type__c"] as? String
        
        self.professionJobTitle =
            dict["Profession_Job_Title__c"] as? String
        
        self.fatherOrSpouseName =
            dict["Son_of_Daughter_of_Wife_of__c"] as? String
        
        // MARK: Identity
        
        self.panNumber =
            dict["PAN_Number__c"] as? String
        
        self.aadhaarNumber =
            dict["Aadhaar_Number__c"] as? String
        
        self.passportNumber =
            dict["Passport_Number__c"] as? String
        
        self.passportValidity =
            dict["Passport_Validity__c"] as? String
        
        self.panOfAuthorizedSignatory =
            dict["PAN_of_Authorized_Signatory__c"] as? String
        
        self.aadhaarOfAuthorizedSignatory =
            dict["Aadhaar_of_Authorized_Signatory__c"] as? String
        
        // MARK: Company
        
        self.nameOfCompanyFirmLLP =
            dict["Name_of_Company_Firm_LLP__c"] as? String
        
        self.dateOfIncorporation =
            dict["Date_of_Incorporation__c"] as? String
        
        self.companyFirmLLPPAN =
            dict["Company_Firm_LLP_PAN__c"] as? String
        
        self.corporateLLPIdentificationNumber =
            dict["Corporate_LLP_Identification_Number__c"] as? String
        
        self.companyLLPIdentificationNumber =
            dict["Company_LLP_Identification_Number_CIN_L__c"] as? String
        
        self.directorDesignatedPartnerIdenNo =
            dict["Director_Designated_Partner_Iden_No__c"] as? String
        
        self.authorizedContactPersonName =
            dict["Name_of_the_authorized_contact_person__c"] as? String
        
        self.authorizedContactPersonPhone =
            dict["Authorized_contact_person_Phone__c"] as? String
        
        self.authorizedContactPersonEmail =
            dict["Authorized_contact_person_Email__c"] as? String
        
        // MARK: Investment
        
        // MARK: Investment

        if let priorInvestment = dict["Prior_Investment_in_Gaurs_Group_Project__c"] {
            if let boolValue = priorInvestment as? Bool {
                self.priorInvestmentInGaursGroupProject = boolValue
            } else {
                self.priorInvestmentInGaursGroupProject =
                    String(describing: priorInvestment).lowercased() == "yes"
            }
        } else {
            self.priorInvestmentInGaursGroupProject = nil
        }

        self.priorInvestmentExistingProject =
            dict["Prior_investment_in_the_existing_Project__c"] as? String

        if let unitValue = dict["Unit_Number__c"] {
            if let intValue = unitValue as? Int {
                self.unitNumber = intValue
            } else if let stringValue = unitValue as? String {
                self.unitNumber = Int(stringValue)
            } else if let doubleValue = unitValue as? Double {
                self.unitNumber = Int(doubleValue)
            } else {
                self.unitNumber = nil
            }
        } else {
            self.unitNumber = nil
        }
        
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
        
        self.registeredStates =
            dict["Registered_States__c"] as? String
        
        self.registeredCity =
            dict["Registered_City__c"] as? String
        
        self.registeredPincode =
            dict["Registered_Pincode__c"] as? String
        
        // MARK: Permanent Address
        
        self.permanentSelfOwned =
            dict["Permanent_Self_Owned__c"] as? Bool
        
        self.permanentRented =
            dict["Permanent_Rented__c"] as? Bool
        
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
        
        self.permanentAddressIsSameAsCorrespondence =
            dict["Permanent_Address_is_Same_as_Corresponde__c"] as? Bool
        
        self.registeredAddressIsSameAsCorrespondence =
            dict["Registered_Address_is_Same_as_Correspond__c"] as? Bool
        
        // MARK: Employment
        
        self.companyName =
            dict["Company_Name__c"] as? String
        
        // MARK: Banking
        
        self.bankName =
            dict["Bank_Name__c"] as? String
        
        self.bankAccountNumber =
            dict["Bank_Account_Number__c"] as? String
        
        self.bankIFSCCode =
            dict["Bank_IFSC_Code__c"] as? String
        
        self.branchCode =
            dict["Branch_Code__c"] as? String
        
        self.branchName =
            dict["Branch_Name__c"] as? String
        
        self.upiId =
            dict["UPI_ID__c"] as? String
        
        // MARK: GST
        
        self.gstNo =
            dict["GST_No__c"] as? String
        
        // MARK: Registration
        
        self.registrationNo =
            dict["Registration_No__c"] as? String
        
        self.registrationState =
            dict["Registration_State__c"] as? String
        
        // MARK: Dates
        
        self.authorisationLetterDate =
            dict["Authorisation_Letter_Date__c"] as? String
        
        self.boardOfResolutionDate =
            dict["Board_of_Resolution_Date__c"] as? String
        
        self.partnershipLLPHUFDeedDate =
            dict["Partnership_LLP_HUF_Deed_Date__c"] as? String
        
        // MARK: Contact
        
        self.phoneNumberHome =
            dict["Phone_Number_Home__c"] as? String
        
        self.phoneNumberWork =
            dict["Phone_Number_Work__c"] as? String
        
        self.phoneNumberOther =
            dict["Phone_Number_Any_other__c"] as? String
        
        // MARK: Project
        
        self.projectName =
            dict["Project_Name__c"] as? String
        
        self.projectId = nil
        self.projectChannelPartnerVisible = nil
        
        if let projectDict = dict["Project_Name__r"] as? [String: Any] {
            
            self.projectId =
                projectDict["Id"] as? String
            
            // Prefer relationship Name if available
            if self.projectName == nil {
                self.projectName =
                    projectDict["Name"] as? String
            }
            
            self.projectChannelPartnerVisible =
                projectDict["Channel_Partner_Visible__c"] as? Bool
        }
        
        // MARK: Other
        
        self.profileImage =
            dict["Profile_Image__c"] as? String
        
        self.note =
            dict["Note__c"] as? String
        
        self.createdTime =
            dict["Created_Time__c"] as? String
        
        self.createdDate =
            dict["CreatedDate"] as? String
        
        // MARK: Attributes
        
        if let attributesDict = dict["attributes"] as? [String: Any] {
            self.attributes = Attributes(dict: attributesDict)
        } else {
            self.attributes = nil
        }
        
        // MARK: Opportunity
        
        if let opportunityDict = dict["Opportunity__r"] as? [String: Any] {
            self.opportunity = Opportunity(dict: opportunityDict)
            
            // In case these weren't already populated
            if self.applicantType == nil {
                self.applicantType =
                    opportunityDict["Applicant_Type__c"] as? String
            }
        } else {
            self.opportunity = nil
        }
    }
}

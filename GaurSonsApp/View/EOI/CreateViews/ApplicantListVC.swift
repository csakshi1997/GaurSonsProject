//
//  ApplicantListVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 01/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit

class ApplicantListVC: UIViewController {
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var proceedBtn: UIButton?
    @IBOutlet var addMoreBtn: UIButton?
    @IBOutlet var tablevw: UITableView?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    var saveModel = SaveModel(dict: [:])
    var recordTypeId: String = EMPTY
    var applicantId: String = EMPTY
    var isFromCustomers: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var isForEditing: Bool = false
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var applicantIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        addMoreBtn?.borderWidth = 1
        addMoreBtn?.borderColor = UIColor(hex: "DFE1E0")
        addMoreBtn?.layer.cornerRadius = 6
        proceedBtn?.layer.cornerRadius = 6
        OutOfPageNumber?.text = "6"
        OutOfPageNumber?.text = "7"
        Utility.getRecordType(type: Defaults.type ?? EMPTY) { recordTypeId in
            if let id = recordTypeId {
                self.recordTypeId = id
            }
        }
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        print(OpportunityManager.shared.applicants)
        if Defaults.isIndividualEnable ?? false {
            pageNumberLbl?.text = "6"
            OutOfPageNumber?.text = "7"
        } else if Defaults.isPartnerShip ?? false {
            pageNumberLbl?.text = "7"
            OutOfPageNumber?.text = "8"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tablevw?.reloadData()
        print("Applicants Count:",

                  OpportunityManager.shared.applicants.count)
    }
    
    func sendApplicantsComposite() {
        let applicants = OpportunityManager.shared.applicants
        guard !applicants.isEmpty else {
            print("⚠️ No applicants to send")
            return
        }
        
        var recordsArray: [[String: Any]] = []
        
        for index in 0..<applicants.count {
            OpportunityManager.shared.applicants[index].attributes = SaveModel.Attributes(dict: [
                "type": "Applicant_Details__c",
                "referenceId": "ref\(index + 1)"
            ])
            let record: [String: Any] = [
                "attributes": [
                    "type": "Applicant_Details__c",
                    "referenceId": "ref\(index + 1)"
                ],
                "Opportunity__c": Defaults.opportunityId ?? EMPTY,
                "RecordTypeId": recordTypeId,
                "Name": OpportunityManager.shared.applicants[index].name ?? "",
                "Primary__c": OpportunityManager.shared.applicants[index].primary ?? false,
                "D_O_B__c": Helper.dateOrNull(OpportunityManager.shared.applicants[index].dob),
                "Resident_Type__c": OpportunityManager.shared.applicants[index].residentType ?? "",
                "Gender__c": OpportunityManager.shared.applicants[index].gender ?? "",
                "Marital_Status__c": OpportunityManager.shared.applicants[index].maritalStatus ?? "",
                "Nationality__c": OpportunityManager.shared.applicants[index].nationality ?? "",
                "Phone_Number_Home__c": OpportunityManager.shared.applicants[index].phoneHome ?? "",
                "Applicant_Email_ID__c": OpportunityManager.shared.applicants[index].applicantEmail ?? "",
                "Phone_Number_Work__c": OpportunityManager.shared.applicants[index].phoneWork ?? "",
                "Applicant_Mobile_Number__c": OpportunityManager.shared.applicants[index].applicantMobile ?? "",
                "Phone_Number_Any_Other__c": OpportunityManager.shared.applicants[index].phoneOther ?? "",
                "Permanent_Address__c": OpportunityManager.shared.applicants[index].permanentAddress ?? "",
                "Permanent_Country__c": OpportunityManager.shared.applicants[index].permanentCountry ?? "",
                "Permanent_State__c": OpportunityManager.shared.applicants[index].permanentState ?? "",
                "Permanent_City__c": OpportunityManager.shared.applicants[index].permanentCity ?? "",
                "Permanent_Pincode__c": OpportunityManager.shared.applicants[index].permanentPincode ?? "",
                "Permanent_Self_Owned__c": OpportunityManager.shared.applicants[index].permanentSelfOwned ?? false,
                "Permanent_Rented__c": OpportunityManager.shared.applicants[index].permanentRented ?? false,
                "Correspondence_Address__c": OpportunityManager.shared.applicants[index].correspondenceAddress ?? "",
                "Correspondence_City__c": OpportunityManager.shared.applicants[index].correspondenceCity ?? "",
                "Correspondence_Country__c": OpportunityManager.shared.applicants[index].correspondenceCountry ?? "",
                "Correspondence_Pincode__c": OpportunityManager.shared.applicants[index].correspondencePincode ?? "",
                "Correspondence_State__c": OpportunityManager.shared.applicants[index].correspondenceState ?? "",
                "Self_Owned__c": OpportunityManager.shared.applicants[index].selfOwned ?? false,
                "Rented__c": OpportunityManager.shared.applicants[index].rented ?? false,
                "Profession_Job_Title__c": OpportunityManager.shared.applicants[index].profession ?? "",
                "Company_Name__c": OpportunityManager.shared.applicants[index].companyName ?? "",
                "Employment_Type__c": OpportunityManager.shared.applicants[index].employmentType ?? "",
                "Bank_Name__c": OpportunityManager.shared.applicants[index].bankName ?? "",
                "Branch_Code__c": OpportunityManager.shared.applicants[index].branchCode ?? "",
                "Bank_Account_Number__c": OpportunityManager.shared.applicants[index].bankAccount ?? "",
                "UPI_ID__c": OpportunityManager.shared.applicants[index].upiId ?? "",
                "Bank_IFSC_Code__c": OpportunityManager.shared.applicants[index].bankIFSC ?? "",
                "Branch_Name__c": OpportunityManager.shared.applicants[index].branchName ?? "",
                "Note__c": OpportunityManager.shared.applicants[index].note ?? "",
                "Salutation_for_Authorised_Signatory__c": OpportunityManager.shared.applicants[index].salutationForAuthorisedSignatory ?? EMPTY,
                "Name_of_the_authorized_contact_person__c": OpportunityManager.shared.applicants[index].nameOfAuthorizedContactPerson ?? EMPTY,
                "Relation__c": OpportunityManager.shared.applicants[index].relation ?? EMPTY,
                "Salutation_for_Relative__c": OpportunityManager.shared.applicants[index].salutationForRelative ?? EMPTY,
                "Son_of_Daughter_of_Wife_of__c": OpportunityManager.shared.applicants[index].relativeName ?? EMPTY,
                "PAN_of_Authorized_Signatory__c": OpportunityManager.shared.applicants[index].panOfAuthorizedSignatory ?? EMPTY,
                "Aadhaar_of_Authorized_Signatory__c": OpportunityManager.shared.applicants[index].aadhaarOfAuthorizedSignatory ?? EMPTY,
                "Passport_Number__c": OpportunityManager.shared.applicants[index].passportNumber ?? EMPTY,
                "Passport_Validity__c": Helper.dateOrNull(
                    OpportunityManager.shared.applicants[index].passportValidity
                ),
                "Aadhaar_Number__c": OpportunityManager.shared.applicants[index].aadhaarNumber ?? EMPTY,
                "Verification_Type__c": OpportunityManager.shared.applicants[index].verificationType ?? EMPTY,
                "Verified_By_Adhaar__c": OpportunityManager.shared.applicants[index].verifiedByAdhaar ?? false,
                "PAN_Number__c": OpportunityManager.shared.applicants[index].panNumber ?? EMPTY,
                "Salutation__c": OpportunityManager.shared.applicants[index].salutation ?? EMPTY,
                "Occupation__c": OpportunityManager.shared.applicants[index].occupation ?? EMPTY,
                "Permanent_Address_is_Same_as_Corresponde__c":
                    OpportunityManager.shared.applicants[index].permanentAddressIsSameAsCorrespondence ?? false,            ]
            recordsArray.append(record)
        }
        
        let compositePayload: [String: Any] = ["records": recordsArray]
        
        CreateRequestWebService.shared.sendCompositeRequest(param: compositePayload) { errorMsg, response, status in
            switch status {
            case .success:
                print("✅ Composite applicants created successfully")
                if let response = response,
                   let results = response["results"] as? [[String: Any]] {
                    
                    let applicants = OpportunityManager.shared.applicants
                    for result in results {
                        if let referenceId = result["referenceId"] as? String,
                           let id = result["id"] as? String {
                            if let index = applicants.firstIndex(where: { $0.attributes?.referenceId == referenceId }) {
                                OpportunityManager.shared.applicants[index].id = id
                                print("✅ Applicant \(applicants[index].name ?? "") mapped to Salesforce Id: \(id)")
                            }
                        }
                    }
                    Task {
                        for applicant in OpportunityManager.shared.applicants {
                            if !applicant.uploadedFiles.isEmpty {
                                print(applicant)
                                await self.uploadAttachmentsForApplicant(applicant)
                            } else {
                                DispatchQueue.main.async {
                                    SceneDelegate.getSceneDelegate().window?.makeToast(OPPORTUNITY_ATTACHMENT_UPLOADED)
                                    Utility.gotoTabbar()
                                }
                            }
                        }
                    }
                }
            case .alreadyRegister:
                print("⚠️ Token expired. Logging out.")
            case .tokenExpired:
                print("⚠️ Token expired. Logging out.")
            case .error:
                print("❌ Failed to create applicants: \(errorMsg ?? "Unknown error")")
            case .badRequest:
                print("❌ Failed to create applicants: \(errorMsg ?? "Bad request")")
            }
        }
    }
    
    func uploadAttachmentsForApplicant(_ applicant: SaveModel) async {
        for file in applicant.uploadedFiles {
            guard let data = file.versionData else { continue }
            let base64Data = data.base64EncodedString()
            let contentVersionBody: [String: Any] = [
                "Title": file.title,
                "PathOnClient": file.pathOnClient,
                "NetworkId": Defaults.networkId ?? "",
                "VersionData": base64Data
            ]
            
            do  {
                let contentVersionId = try await CreateRequestWebService.shared.createRecordForFile(
                    ofType: "ContentVersion",
                    withFields: contentVersionBody
                )
                print("✅ ContentVersion created: \(file.title) - \(contentVersionId)")
                
                let soqlQuery = "SELECT ContentDocumentId FROM ContentVersion WHERE Id = '\(contentVersionId)'"
                let queryResponse = try await CreateRequestWebService.shared.queryRecordsAsync(soqlQuery: soqlQuery)
                
                if let records = queryResponse["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let contentDocumentId = firstRecord["ContentDocumentId"] as? String {
                    
                    let contentDocumentLinkBody: [String: Any] = [
                        "ContentDocumentId": contentDocumentId,
                        "LinkedEntityId": applicant.id ?? EMPTY,
                        "ShareType": "V"
                    ]
                    let _ = try await CreateRequestWebService.shared.createRecordForFile(
                        ofType: "ContentDocumentLink",
                        withFields: contentDocumentLinkBody
                    )
                    DispatchQueue.main.async {
                        SceneDelegate.getSceneDelegate().window?.makeToast(OPPORTUNITY_ATTACHMENT_UPLOADED)
                        Utility.gotoTabbar()
                    }
                    print("✅ Linked \(file.title) to applicant \(applicant.name ?? "")")
                }
            } catch {
                print("❌ Failed to upload \(file.title): \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func proceedBtnAction() {
//        let hasPrimary = OpportunityManager.shared.applicants.contains { $0.primary == true }
//        
//        if !hasPrimary {
//            let alert = UIAlertController(
//                title: "Primary Applicant Required",
//                message: "Please mark one applicant as Primary or add a new applicant with Primary = Yes before proceeding.",
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true)
//            return
//        }
//        if Defaults.isOpportunityIDPresent ?? false {
//            sendApplicantsComposite()
//        } else {
//            let storyboardBundle = Bundle.main
//            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
//            if let miscellaneousEOIScreenVCScreen = storyboard.instantiateViewController(withIdentifier: "miscellaneousEOIScreenVC") as? miscellaneousEOIScreenVC {
//                miscellaneousEOIScreenVCScreen.isFromCustomers = isFromCustomers
//                miscellaneousEOIScreenVCScreen.cuatomerDetailsDict = cuatomerDetailsDict
//                self.navigationController?.pushViewController(miscellaneousEOIScreenVCScreen, animated: true)
//            }
//        }
//    }
    
    @IBAction func proceedBtnAction() {

        let applicants = OpportunityManager.shared.applicants
        
        guard !applicants.isEmpty else {

            Utility.showAlert(message: "No applicants available")

            return

        }

        // Check if any applicant is already Primary

        let hasPrimary = applicants.contains {

            $0.primary == true

        }


        if !hasPrimary {

            OpportunityManager.shared.applicants[0].primary = true

            print("✅ No Primary applicant found. First applicant marked as Primary.")

        }

        // ✅ Continue existing flow

        if Defaults.isOpportunityIDPresent ?? false {

            sendApplicantsComposite()

        } else {

            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)

            if let miscellaneousEOIScreenVCScreen =
                storyboard.instantiateViewController(
                    withIdentifier: "miscellaneousEOIScreenVC"
                ) as? miscellaneousEOIScreenVC {

                miscellaneousEOIScreenVCScreen.isFromCustomers = isFromCustomers
                miscellaneousEOIScreenVCScreen.cuatomerDetailsDict = cuatomerDetailsDict

                self.navigationController?.pushViewController(
                    miscellaneousEOIScreenVCScreen,
                    animated: true
                )
            }
        }
    }
    
//    @IBAction func addMoreBtnAction() {
//        if let navController = self.navigationController {
//            for controller in navController.viewControllers {
//
//                if let personalVC = controller as? PersonalEOIScreenVC {
//
//                    personalVC.applicantIndex = nil
//                    personalVC.isForEditing = false
//
//                    navController.popToViewController(personalVC, animated: true)
//                    break
//                }
//            }
//        }
//    }
    
//    @IBAction func addMoreBtnAction() {
//
//        guard let navController = self.navigationController else { return }
//
//        let storyboard = UIStoryboard(name: "EOI", bundle: Bundle.main)
//
//        // 🔵 CREATE NEW APPLICANT
//        let newApplicant = SaveModel(dict: [:])
//        OpportunityManager.shared.applicants.append(newApplicant)
//
//        let newIndex = OpportunityManager.shared.applicants.count - 1
//
//        // 🔵 UPDATE INDEX
//        self.applicantIndex = newIndex
//        self.isForEditing = false
//
//        // 🔥 ROUTE BASED ON TYPE
//        if Defaults.isIndividualEnable ?? false {
//
//            let vc = storyboard.instantiateViewController(withIdentifier: "PersonalEOIScreenVC") as! PersonalEOIScreenVC
//            vc.applicantIndex = newIndex
//            vc.isForEditing = false
//            vc.isFromCustomers = self.isFromCustomers
//            vc.cuatomerDetailsDict = self.cuatomerDetailsDict
//
//            navController.popToViewController(vc, animated: true)
//
//        } else {
//
//            let vc = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
//            vc.applicantIndex = newIndex
//            vc.isForEditing = false
//            vc.isFromCustomers = self.isFromCustomers
//            vc.cuatomerDetailsDict = self.cuatomerDetailsDict
//
//            navController.popToViewController(vc, animated: true)
//        }
//    }
    
//    @IBAction func addMoreBtnAction() {
//
//        let storyboard = UIStoryboard(name: "EOI", bundle: nil)
//        let navController = self.navigationController!
//
//        let newApplicant = SaveModel(dict: [:])
//        OpportunityManager.shared.applicants.append(newApplicant)
//
//        let newIndex = OpportunityManager.shared.applicants.count - 1
//
//        if Defaults.isIndividualEnable ?? false {
//
//            let vc = storyboard.instantiateViewController(withIdentifier: "PersonalEOIScreenVC") as! PersonalEOIScreenVC
//            vc.applicantIndex = newIndex
//            vc.isLocalEdit = false
//
//            navController.pushViewController(vc, animated: true)
//
//        } else {
//
//            let vc = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
//            vc.applicantIndex = newIndex
//            vc.isLocalEdit = false
//
//            navController.pushViewController(vc, animated: true)
//        }
//    }
    
    @IBAction func addMoreBtnAction() {

        let storyboard = UIStoryboard(name: "EOI", bundle: nil)

        let newApplicant = SaveModel(dict: [:])

        OpportunityManager.shared.applicants.append(newApplicant)

        let newIndex = OpportunityManager.shared.applicants.count - 1

        if Defaults.isIndividualEnable ?? false {

            let vc = storyboard.instantiateViewController(
                withIdentifier: "PersonalEOIScreenVC"
            ) as! PersonalEOIScreenVC

            vc.applicantIndex = newIndex
            vc.isLocalEdit = false
            vc.isAddingNewApplicant = true
            vc.isFromCustomers = isFromCustomers
            vc.cuatomerDetailsDict = cuatomerDetailsDict

            navigationController?.pushViewController(
                vc,
                animated: true
            )

        } else {

            let vc = storyboard.instantiateViewController(
                withIdentifier: "CompanyDetailsEOIScreenVC"
            ) as! CompanyDetailsEOIScreenVC

            vc.applicantIndex = newIndex
            vc.isLocalEdit = false
            vc.isAddingNewApplicant = true
            vc.isFromCustomers = isFromCustomers
            vc.cuatomerDetailsDict = cuatomerDetailsDict

            navigationController?.pushViewController(
                vc,
                animated: true
            )
        }
    }
}

extension ApplicantListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OpportunityManager.shared.applicants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ApplicantListCell = tableView.dequeueReusableCell(withIdentifier: "ApplicantListCell", for: indexPath) as! ApplicantListCell
        let EOIDict = OpportunityManager.shared.applicants[indexPath.row]
        if Defaults.isIndividualEnable ?? false {
            if let primaryData = EOIDict.primary {
                cell.primaryLbl?.text = primaryData ? "Yes" : "No"
            } else {
                cell.primaryLbl?.text = "-"
            }
            cell.residentTypeLblHeading?.text = "Resident Type"
            cell.applicantNameLbl?.text = EOIDict.name
            cell.residentTypeLbl?.text = EOIDict.residentType
            cell.mobileLbl?.text = EOIDict.applicantMobile
            cell.emailLbl?.text = EOIDict.applicantEmail
        } else {
            if indexPath.row == 0 {
                cell.primaryLbl?.text = "Yes"
            } else {
                cell.primaryLbl?.text = "No"
            }
            cell.applicantNameLbl?.text = EOIDict.nameOfCompanyFirmLLP
            cell.mobileLbl?.text = EOIDict.authorizedContactPersonPhone
            cell.emailLbl?.text = EOIDict.authorizedContactPersonEmail
            cell.residentTypeLbl?.text = EMPTY
            cell.residentTypeLblHeading?.text = EMPTY
        }
//        cell.onEditTapped = { [weak self] in
//
//            guard let self = self else { return }
//
//            let selectedIndex = indexPath.row
//
//            let storyboard = UIStoryboard(name: "EOI", bundle: nil)
//
//            if Defaults.isIndividualEnable ?? false {
//
//                let vc = storyboard.instantiateViewController(
//                    withIdentifier: "PersonalEOIScreenVC"
//                ) as! PersonalEOIScreenVC
//
//                vc.applicantIndex = selectedIndex
//                vc.isFromCustomers = self.isFromCustomers
//                vc.cuatomerDetailsDict = self.cuatomerDetailsDict
//                vc.isLocalEdit = true
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            } else {
//
//                let vc = storyboard.instantiateViewController(
//                    withIdentifier: "CompanyDetailsEOIScreenVC"
//                ) as! CompanyDetailsEOIScreenVC
//
//                vc.applicantIndex = selectedIndex
//                vc.isFromCustomers = self.isFromCustomers
//                vc.cuatomerDetailsDict = self.cuatomerDetailsDict
//                vc.isLocalEdit = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        cell.onEditTapped = { [weak self] in

            guard let self = self else { return }

            let selectedIndex = indexPath.row
            let selectedApplicant = OpportunityManager.shared.applicants[selectedIndex]
            let selectedApplicantType = (selectedApplicant.applicantType ?? Defaults.type ?? EMPTY)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let isIndividualApplicant = selectedApplicantType.caseInsensitiveCompare("Individual") == .orderedSame

            let storyboard = UIStoryboard(name: "EOI", bundle: nil)
            Defaults.type = selectedApplicantType
            Defaults.isIndividualEnable = isIndividualApplicant

            if isIndividualApplicant {

                let vc = storyboard.instantiateViewController(
                    withIdentifier: "PersonalEOIScreenVC"
                ) as! PersonalEOIScreenVC

                vc.applicantIndex = selectedIndex
                vc.isFromCustomers = self.isFromCustomers
                vc.cuatomerDetailsDict = self.cuatomerDetailsDict
                vc.isLocalEdit = true

                navigationController?.pushViewController(
                    vc,
                    animated: true
                )

            } else {

                let vc = storyboard.instantiateViewController(
                    withIdentifier: "CompanyDetailsEOIScreenVC"
                ) as! CompanyDetailsEOIScreenVC

                vc.applicantIndex = selectedIndex
                vc.isFromCustomers = self.isFromCustomers
                vc.cuatomerDetailsDict = self.cuatomerDetailsDict
                vc.isLocalEdit = true

                navigationController?.pushViewController(
                    vc,
                    animated: true
                )
            }
        }
        return cell
    }
}

class ApplicantListCell: UITableViewCell {
    @IBOutlet var vw: UIView?
    @IBOutlet var primaryLbl: UILabel?
    @IBOutlet var applicantNameLbl: UILabel?
    @IBOutlet var residentTypeLbl: UILabel?
    @IBOutlet var residentTypeLblHeading: UILabel?
    @IBOutlet var mobileLbl: UILabel?
    @IBOutlet var emailLbl: UILabel?
    @IBOutlet var createdByLbl: UILabel?
    @IBOutlet var createdByLblHeading: UILabel?
    @IBOutlet var editApplicantBtn: UIButton?
    var onEditTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
        editApplicantBtn?.borderWidth = 1
        editApplicantBtn?.borderColor = UIColor("#D4D8D6")
        editApplicantBtn?.cornerRadius = 8
        editApplicantBtn?.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @objc private func editButtonTapped() {
        onEditTapped?()
    }
}


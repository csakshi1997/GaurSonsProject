//
//  NotesEOIScreenVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 28/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import SalesforceSDKCore
import Toast_Swift

class NotesEOIScreenVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    @IBOutlet var companyNameAddresstxtVw: UITextView?
    @IBOutlet var resetBtn: UIButton?
    @IBOutlet var saveApplicantBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    @IBOutlet var editBtn: UIButton?
    var validation = Validation()
    var applicantIndex: Int?
    var applicantWebService = ApplicantWebService()
    var isFromCustomers: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var isForEditing: Bool = false
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var loaderContainer: UIView?
    var loaderView: UIActivityIndicatorView?
    var loaderLabel: UILabel?
    var recordTypeId: String = EMPTY
    var applicantId: String = EMPTY
    var createRequestWebService = CreateRequestWebService()
    var isLocalEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
        Utility.getRecordType(type: Defaults.type ?? EMPTY) { recordTypeId in
            if let id = recordTypeId {
                self.recordTypeId = id
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
            statusBarView.backgroundColor = ColorConstant.screensBackgroundColor
            view.addSubview(statusBarView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let textView = companyNameAddresstxtVw?.viewWithTag(101) as? UITextView {
            textView.delegate = self
        }
    }
    
    func setUpInitialUI() {
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        if Defaults.isIndividualEnable ?? false {
            pageNumberLbl?.text = "5"
            OutOfPageNumber?.text = "7"
        } else if Defaults.isPartnerShip ?? false {
            pageNumberLbl?.text = "6"
            OutOfPageNumber?.text = "8"
        } else {
            pageNumberLbl?.text = "6"
            OutOfPageNumber?.text = "7"
        }
        if isForEditing {
            saveApplicantBtn?.isHidden = true
            nextBtn?.isHidden = true
            editBtn?.isHidden = false
        } else {
            if (Defaults.isIndividualEnable ?? false) {
                saveApplicantBtn?.isHidden = false
                nextBtn?.isHidden = true
                editBtn?.isHidden = true
            } else if Defaults.type == "Partnership" {
                saveApplicantBtn?.isHidden = false
                nextBtn?.isHidden = true
                editBtn?.isHidden = true
            } else {
                saveApplicantBtn?.isHidden = true
                nextBtn?.isHidden = false
                editBtn?.isHidden = true
            }
        }
        companyNameAddresstxtVw?.delegate = self
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        resetBtn?.borderWidth = 1
        resetBtn?.borderColor = UIColor(hex: "DFE1E0")
        resetBtn?.layer.cornerRadius = 6
        nextBtn?.layer.cornerRadius = 6
        saveApplicantBtn?.layer.cornerRadius = 6
        companyNameAddresstxtVw?.dropShadow()
//        if !isForEditing {
            companyNameAddresstxtVw?.placeholder = "Enter Notes"
//        }
        companyNameAddresstxtVw?.textColor = .darkGray
        companyNameAddresstxtVw?.textContainerInset = UIEdgeInsets(top: 13, left: 10, bottom: 10, right: 13)
//        if isForEditing {
//            companyNameAddresstxtVw?.text = applicantDetailsModel.notes
//
//            if let text = companyNameAddresstxtVw?.text,
//               !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                companyNameAddresstxtVw?.removePlaceholder()
//            } else {
//                companyNameAddresstxtVw?.setPlaceholder("Enter Notes")
//            }
//
//        }
        if isForEditing {

            DispatchQueue.main.async {
                self.companyNameAddresstxtVw?.text = self.applicantDetailsModel.notes
            }

            if let notes = applicantDetailsModel.notes,
               !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                DispatchQueue.main.async {
                    self.companyNameAddresstxtVw?.removePlaceholder()
                }

            } else {

//                companyNameAddresstxtVw?.setPlaceholder("Enter Notes")
            }
        }
        else if isLocalEdit,
                  let index = applicantIndex,
                  index < OpportunityManager.shared.applicants.count {

            let applicant = OpportunityManager.shared.applicants[index]
            companyNameAddresstxtVw?.text = applicant.note

            if let text = companyNameAddresstxtVw?.text,
               !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                companyNameAddresstxtVw?.removePlaceholder()
            } else {
//                companyNameAddresstxtVw?.setPlaceholder("Enter Notes")
            }
        }
    }
    
    private func updateNotesPlaceholder() {

        let text = companyNameAddresstxtVw?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if text.isEmpty {
            companyNameAddresstxtVw?.setPlaceholder("Enter Notes")
        } else {
            companyNameAddresstxtVw?.removePlaceholder()
        }
    }
    
    func clearAllFields() {
        companyNameAddresstxtVw?.text = ""
    }
    
    func showLoader(with message: String) {
        DispatchQueue.main.async {
            if self.loaderContainer == nil {
                self.loaderContainer = UIView(frame: self.view.bounds)
                self.loaderContainer?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                
                self.loaderView = UIActivityIndicatorView(style: .large)
                self.loaderView?.center = self.view.center
                self.loaderView?.startAnimating()
                
                self.loaderLabel = UILabel(frame: CGRect(x: 0, y: self.view.center.y + 40, width: self.view.frame.width, height: 30))
                self.loaderLabel?.textAlignment = .center
                self.loaderLabel?.textColor = .white
                self.loaderLabel?.font = .boldSystemFont(ofSize: 16)
                
                if let loader = self.loaderView, let label = self.loaderLabel {
                    self.loaderContainer?.addSubview(loader)
                    self.loaderContainer?.addSubview(label)
                }
                self.view.addSubview(self.loaderContainer!)
            }
            self.loaderLabel?.text = message
            self.loaderContainer?.isHidden = false
            self.loaderView?.startAnimating()
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.loaderView?.stopAnimating()
            self.loaderContainer?.isHidden = true
        }
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == companyNameAddresstxtVw {
            let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = size.height
                }
            }
            //            let currentCount = textView.text.count
            //            countLbl?.text = "\(currentCount)"
            if textView.text.isEmpty {
                textView.setPlaceholder("Enter Company Name & Address")
            } else {
                textView.removePlaceholder()
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let updatedTextLength = currentText.count - range.length + text.count
        return updatedTextLength <= 212
    }
    
    @IBAction func resetAction() {
        clearAllFields()
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveEditAction() {
        editCompanyData()
    }
    
    func editCompanyData() {
        guard let applicant = OpportunityManager.shared.applicants.first else {
            print("⚠️ No applicant data available.")
            return
        }
        
        showLoader(with: "Saving Applicant Records...")
        var formPayload: [String: Any] = [:]
        if Defaults.type == "Individual" {
            formPayload = [
                "Opportunity__c": Defaults.opportunityId ?? EMPTY,
                "RecordTypeId": recordTypeId,
                "Name": applicant.name ?? "",
                "Primary__c": applicant.primary ?? false,
                "D_O_B__c": Helper.dateOrNull(applicant.dob),
                "Resident_Type__c": applicant.residentType ?? "",
                "Gender__c": applicant.gender ?? "",
                "Marital_Status__c": applicant.maritalStatus ?? "",
                "Nationality__c": applicant.nationality ?? "",
                "Phone_Number_Home__c": applicant.phoneHome ?? "",
                "Applicant_Email_ID__c": applicant.applicantEmail ?? "",
                "Phone_Number_Work__c": applicant.phoneWork ?? "",
                "Applicant_Mobile_Number__c": applicant.applicantMobile ?? "",
                "Phone_Number_Any_Other__c": applicant.phoneOther ?? "",
                "Permanent_Address__c": applicant.permanentAddress ?? "",
                "Permanent_Country__c": applicant.permanentCountry ?? "",
                "Permanent_State__c": applicant.permanentState ?? "",
                "Permanent_City__c": applicant.permanentCity ?? "",
                "Permanent_Pincode__c": applicant.permanentPincode ?? "",
                "Permanent_Self_Owned__c": applicant.permanentSelfOwned ?? false,
                "Permanent_Rented__c": applicant.permanentRented ?? false,
                "Correspondence_Address__c": applicant.correspondenceAddress ?? "",
                "Correspondence_City__c": applicant.correspondenceCity ?? "",
                "Correspondence_Country__c": applicant.correspondenceCountry ?? "",
                "Correspondence_Pincode__c": applicant.correspondencePincode ?? "",
                "Correspondence_State__c": applicant.correspondenceState ?? "",
                "Self_Owned__c": applicant.selfOwned ?? false,
                "Rented__c": applicant.rented ?? false,
                "Profession_Job_Title__c": applicant.profession ?? "",
                "Company_Name__c": applicant.companyName ?? "",
                "Employment_Type__c": applicant.employmentType ?? "",
                "Bank_Name__c": applicant.bankName ?? "",
                "Branch_Code__c": applicant.branchCode ?? "",
                "Bank_Account_Number__c": applicant.bankAccount ?? "",
                "UPI_ID__c": applicant.upiId ?? "",
                "Bank_IFSC_Code__c": applicant.bankIFSC ?? "",
                "Branch_Name__c": applicant.branchName ?? "",
                "Note__c": companyNameAddresstxtVw?.text ?? "",
                "Salutation_for_Authorised_Signatory__c": applicant.salutationForAuthorisedSignatory ?? EMPTY,
                "Name_of_the_authorized_contact_person__c": applicant.nameOfAuthorizedContactPerson ?? EMPTY,
                "Relation__c": applicant.relation ?? EMPTY,
                "Salutation_for_Relative__c": applicant.salutationForRelative ?? EMPTY,
                "Son_of_Daughter_of_Wife_of__c": applicant.relativeName ?? EMPTY,
                "PAN_of_Authorized_Signatory__c": applicant.panOfAuthorizedSignatory ?? EMPTY,
                "Aadhaar_of_Authorized_Signatory__c": applicant.aadhaarOfAuthorizedSignatory ?? EMPTY,
                "Passport_Number__c": applicant.passportNumber ?? EMPTY,
                "Passport_Validity__c": Helper.dateOrNull(applicant.passportValidity),
                "Aadhaar_Number__c": applicant.aadhaarNumber ?? EMPTY,
                "Verification_Type__c": applicant.verificationType ?? EMPTY,
                "Verified_By_Adhaar__c": applicant.verifiedByAdhaar ?? false,
                "PAN_Number__c": applicant.panNumber ?? EMPTY,
                "Salutation__c": applicant.salutation ?? EMPTY,
                "Occupation__c": applicant.occupation ?? EMPTY,
                "Permanent_Address_is_Same_as_Corresponde__c":
                    applicant.permanentAddressIsSameAsCorrespondence ?? false,
            ]
        } else {
            formPayload = [
                "Opportunity__c": Defaults.opportunityId ?? EMPTY,
                "RecordTypeId": recordTypeId,
                "Primary__c": applicant.primary ?? EMPTY,
                "Name_of_Company_Firm_LLP__c": applicant.nameOfCompanyFirmLLP ?? EMPTY,
                "Date_of_Incorporation__c": Helper.dateOrNull(applicant.dateOfIncorporation),
                "Name_of_the_authorized_contact_person__c": applicant.nameOfAuthorizedContactPerson ?? EMPTY,
                "Authorized_contact_person_Phone__c": applicant.authorizedContactPersonPhone ?? EMPTY,
                "Authorized_contact_person_Email__c": applicant.authorizedContactPersonEmail ?? EMPTY,
                "Phone_Number_Work__c": applicant.phoneWork ?? EMPTY,
                "Company_Firm_LLP_PAN__c": applicant.companyFirmLLPPAN ?? EMPTY,
                "Corporate_LLP_Identification_Number__c": applicant.corporateLLPIdentificationNumber ?? EMPTY,
                "Director_Designated_Partner_Iden_No__c": applicant.directorDesignatedPartnerIdenNo ?? EMPTY,
                "Prior_Investment_in_Gaurs_Group_Project__c": applicant.priorInvestmentInGaursGroupProject ?? EMPTY,
                "Applicant_Mobile_Number__c": applicant.authorizedContactPersonPhone ?? EMPTY,
                "Applicant_Email_ID__c": applicant.authorizedContactPersonEmail ?? EMPTY,
                "Board_of_Resolution_Date__c": Helper.dateOrNull(applicant.boardResolutionDate),
                "GST_No__c": applicant.gstNo ?? EMPTY,
                "Authorisation_Letter_Date__c": Helper.dateOrNull(applicant.authorisationLetterDate),
                "Partnership_LLP_HUF_Deed_Date__c": Helper.dateOrNull(applicant.partnershipLLPHUFDeedDate),
                "Registration_State__c": applicant.registrationState ?? EMPTY,
                "Registration_No__c": applicant.registrationNo ?? EMPTY,
                "Prior_investment_in_the_existing_Project__c": applicant.priorInvestmentInExistingProject ?? EMPTY,
                "Unit_Number__c": applicant.unitNumber ?? EMPTY,
                
                "Salutation_for_Authorised_Signatory__c": applicant.salutationForAuthorisedSignatory ?? EMPTY,
                "Relation__c": applicant.relation ?? EMPTY,
                "Salutation_for_Relative__c": applicant.salutationForRelative ?? EMPTY,
                "Son_of_Daughter_of_Wife_of__c": applicant.relativeName ?? EMPTY,
                "PAN_of_Authorized_Signatory__c": applicant.panOfAuthorizedSignatory ?? EMPTY,
                "Aadhaar_of_Authorized_Signatory__c": applicant.aadhaarOfAuthorizedSignatory ?? EMPTY,
                
                "Registered_Address__c": applicant.registeredAddress ?? EMPTY,
                "Registered_Country__c": applicant.registeredCountry ?? EMPTY,
                "Registered_States__c": applicant.registeredStates ?? EMPTY,
                "Registered_City__c": applicant.registeredCity ?? EMPTY,
                "Registered_Pincode__c": applicant.registeredPincode ?? EMPTY,
                "Registered_Self_Owned__c": applicant.registeredSelfOwned ?? EMPTY,
                "Registered_Rented__c": applicant.registeredRented ?? EMPTY,
                "Correspondence_Address__c": applicant.correspondenceAddress ?? EMPTY,
                "Correspondence_City__c": applicant.correspondenceCity ?? EMPTY,
                "Correspondence_Country__c": applicant.correspondenceCountry ?? EMPTY,
                "Correspondence_Pincode__c": applicant.correspondencePincode ?? EMPTY,
                "Correspondence_State__c": applicant.correspondenceState ?? EMPTY,
                "Self_Owned__c": applicant.selfOwned ?? EMPTY,
                "Rented__c": applicant.rented ?? EMPTY,
                "Profession_Job_Title__c": applicant.profession ?? EMPTY,
                "Company_Name__c": applicant.companyName ?? EMPTY,
                "Employment_Type__c": applicant.employmentType ?? EMPTY,
                "Bank_Name__c": applicant.bankName ?? EMPTY,
                "Branch_Code__c": applicant.branchCode ?? EMPTY,
                "Bank_Account_Number__c": applicant.bankAccount ?? EMPTY,
                "UPI_ID__c": applicant.upiId ?? EMPTY,
                "Bank_IFSC_Code__c": applicant.bankIFSC ?? EMPTY,
                "Branch_Name__c": applicant.branchName ?? EMPTY,
                "Note__c": companyNameAddresstxtVw?.text ?? EMPTY
            ]
        }
        print("📌 applicantDetailsModel.notes =", applicantDetailsModel.notes ?? "NIL")

        print("📌 TextView note =", companyNameAddresstxtVw?.text ?? "NIL")

        print("📌 applicant.note =", applicant.note ?? "NIL")
        let endPoint = "/services/data/\(RestClient.shared.apiVersion)/sobjects/Applicant_Details__c/\(applicantDetailsModel.id ?? EMPTY)"
        createRequestWebService.updateRecordForFile(endPoint: endPoint, param: formPayload) { error, response, status in

            DispatchQueue.main.async {

                self.hideLoader()

                if status == .success {

                    self.view.makeToast("Applicant Updated Successfully")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                        Utility.gotoTabbar()
                    }

                } else {

                    self.view.makeToast("Something went wrong.")
                }
            }
        }
    }
    
    func uploadAttachmentsForApplicant(_ applicant: SaveModel) async {
        showLoader(with: "Uploading Attachments...")
        
        for file in applicant.uploadedFiles {

            guard var data = file.versionData else { continue }

            if let image = UIImage(data: data) {

                if let compressedData = image.jpegData(compressionQuality: 0.4) {
                    data = compressedData
                }
            }

            let fileSizeMB = Double(data.count) / (1024 * 1024)

            print("📦 Final File Size: \(fileSizeMB) MB")

            if fileSizeMB > 10 {
                print("❌ File still too large: \(file.title)")
                continue
            }

            let base64Data = data.base64EncodedString()

            let contentVersionBody: [String: Any] = [
                "Title": file.title,
                "PathOnClient": file.pathOnClient,
                "NetworkId": Defaults.networkId ?? "",
                "VersionData": base64Data
            ]

            do {

                let contentVersionId = try await CreateRequestWebService.shared.createRecordForFile(
                    ofType: "ContentVersion",
                    withFields: contentVersionBody
                )

                print("✅ ContentVersion created: \(file.title) - \(contentVersionId)")

                let soqlQuery = "SELECT ContentDocumentId FROM ContentVersion WHERE Id = '\(contentVersionId)'"

                let queryResponse = try await CreateRequestWebService.shared.queryRecordsAsync(
                    soqlQuery: soqlQuery
                )

                if let records = queryResponse["records"] as? [[String: Any]],
                   let firstRecord = records.first,
                   let contentDocumentId = firstRecord["ContentDocumentId"] as? String {

                    
                    guard let linkedApplicantId = applicant.id,
                          !linkedApplicantId.isEmpty else {

                        print("❌ Applicant ID missing for attachment upload")
                        print("Applicant Name: \(applicant.name ?? "No Name")")
                        print("ReferenceId: \(applicant.attributes?.referenceId ?? "nil")")

                        continue
                    }

                    let contentDocumentLinkBody: [String: Any] = [
                        "ContentDocumentId": contentDocumentId,
                        "LinkedEntityId": linkedApplicantId,
                        "ShareType": "V"
                    ]

                    let _ = try await CreateRequestWebService.shared.createRecordForFile(
                        ofType: "ContentDocumentLink",
                        withFields: contentDocumentLinkBody
                    )

                    print("✅ Linked \(file.title)")
                }

            } catch {

                print("❌ Failed to upload \(file.title): \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func nextBtnAction() {
        var applicant: SaveModel
        
        if let index = applicantIndex {
            applicant = OpportunityManager.shared.getApplicant(at: index) ?? SaveModel(dict: [:])
        } else {
            applicant = SaveModel(dict: [:])
//            OpportunityManager.shared.addApplicant(applicant)
            applicantIndex = OpportunityManager.shared.applicants.count - 1
        }
        if !applicant.uploadedFiles.isEmpty {
                print("Uploaded Files for Applicant:")
                for file in applicant.uploadedFiles {
                    print("Title: \(file.title), Path: \(file.pathOnClient), Data Size: \(file.versionData?.count ?? 0) bytes")
                }
            } else {
                print("No files uploaded for this applicant yet.")
            }
        
        applicant.note = companyNameAddresstxtVw?.text
        
        if let index = applicantIndex {
            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
        }
        
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let miscellaneousEOIScreenVCScreen = storyboard.instantiateViewController(withIdentifier: "miscellaneousEOIScreenVC") as! miscellaneousEOIScreenVC
        miscellaneousEOIScreenVCScreen.isFromCustomers = isFromCustomers
        miscellaneousEOIScreenVCScreen.cuatomerDetailsDict = cuatomerDetailsDict
        self.navigationController?.pushViewController(miscellaneousEOIScreenVCScreen, animated: true)
    }
    
    @IBAction func saveApplicantBtnAction() {

        var applicant: SaveModel

        if let index = applicantIndex {

            applicant = OpportunityManager.shared.getApplicant(at: index)
            ?? SaveModel(dict: [:])

        } else {

            let newApplicant = SaveModel(dict: [:])

            OpportunityManager.shared.applicants.append(newApplicant)

            applicantIndex = OpportunityManager.shared.applicants.count - 1

            applicant = newApplicant
        }

        applicant.note = companyNameAddresstxtVw?.text

        if let index = applicantIndex {

            OpportunityManager.shared.updateApplicant(
                at: index,
                with: applicant
            )
        }

        if let applicantListVC = navigationController?.viewControllers.first(where: {
            $0 is ApplicantListVC
        }) {

            navigationController?.popToViewController(
                applicantListVC,
                animated: true
            )

        } else {

            // ✅ First time only
            let storyboard = UIStoryboard(name: "EOI", bundle: nil)

            let vc = storyboard.instantiateViewController(
                withIdentifier: "ApplicantListVC"
            ) as! ApplicantListVC

            vc.isFromCustomers = isFromCustomers
            vc.cuatomerDetailsDict = cuatomerDetailsDict

            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func proceedBtnAction() {
        print("proceed")
    }
}

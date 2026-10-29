//
//  miscellaneousEOIScreenVC.swift
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

class miscellaneousEOIScreenVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    @IBOutlet var projectNametxtFld: MDCOutlinedTextField?
    @IBOutlet var tentativeSellabletxtFld: MDCOutlinedTextField?
    @IBOutlet var tentativePricetxtFld: MDCOutlinedTextField?
    @IBOutlet var submittedBytxtFld: MDCOutlinedTextField?
    @IBOutlet var nametxtFld: MDCOutlinedTextField?
    @IBOutlet var RMNametxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadTxtFld: MDCOutlinedTextField?
    @IBOutlet var agentNameTxtFld: MDCOutlinedTextField?
    @IBOutlet var agentMobileTxtFld: MDCOutlinedTextField?
    @IBOutlet var firstPreferenceTxtFld: MDCOutlinedTextField?
    @IBOutlet var secondPreferenceTxtFld: MDCOutlinedTextField?
    @IBOutlet var thirdPreferenceTxtFld: MDCOutlinedTextField?
    @IBOutlet var eoiLocationTxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadTxtFldHeight: NSLayoutConstraint?
    @IBOutlet var uploadImgIcon: UIImageView?
    @IBOutlet var resetBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    @IBOutlet var isOfflineEOIFormYes: UIButton?
    @IBOutlet var isOfflineEOIFormNO: UIButton?
    @IBOutlet var agreeBtn: UIButton?
    var isOfflineEOIForm: Bool = false
    var isAgreementEnable: Bool = false
    var validation = Validation()
    var tentativeSellableAreaDropdown = DropDown()
    var projectNameDropdown = DropDown()
    var tentativePriceRangeDropdown = DropDown()
    var submittedByDropdown = DropDown()
    var RMNameDropdown = DropDown()
    var allRMUsers: [RMUserModel] = []
    var filteredRMUsers: [RMUserModel] = []
    var preferencesList: [ProjectPreferenceModel] = []
    var firstPreference: ProjectPreferenceModel?
    var secondPreference: ProjectPreferenceModel?
    var thirdPreference: ProjectPreferenceModel?
    var selectedAttachment: Attachment?
    var createRequestWebService = CreateRequestWebService()
    var selectedProjectName: String = EMPTY
    var selectedRM: String = EMPTY
    var oppId: String = EMPTY
    var applicantId: String = EMPTY
    var recordTypeId: String = EMPTY
    var customerRecordTypeId: String = EMPTY
    var cuatomerDetailsDict: CustomerModel?
    var loaderContainer: UIView?
    var loaderView: UIActivityIndicatorView?
    var loaderLabel: UILabel?
    var isFromCustomers: Bool = false
    let endPoint = EndPoints()
    var isAgreementBtnClick: Bool = false {
        didSet {
            if isAgreementBtnClick {
                isAgreementEnable = true
                agreeBtn?.setImage(UIImage(named: "checkBoxSelected"), for: .normal)
            } else {
                isAgreementEnable = false
                agreeBtn?.setImage(UIImage(named: "Checkbox"), for: .normal)
            }
        }
    }
    var projectList: [ProjectModel] = []
    var eOIWebServices = EOIWebServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
        setCustomerProject()
        fetchProjects()
        Utility.getRecordType(type: Defaults.type ?? EMPTY) { recordTypeId in
            if let id = recordTypeId {
                print("\(Defaults.type ?? EMPTY)is : \(id)")
                self.recordTypeId = id
            }
        }
    
        LocationWebService().getRecordTypeForCustomer { _, data, _ in
            let id = (data?["records"] as? [[String: Any]])?.first?["Id"] as? String
            self.customerRecordTypeId = id ?? EMPTY
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            await FetchPicklistValue.shared.fetchPicklistValues(
                objectName: "Opportunity__c",
                fieldNames: [
                    "EOI_Saleable_Area__c",
                    "EOI_Tentative_Price_Range__c",
                    "Submitted_By__c",
                    "RM_Name__c"
                ]
            )

            await MainActor.run {
                self.showDefaultSubmittedByValue()
            }
        }
    }
    
    func showDefaultSubmittedByValue() {
        let options = FetchPicklistValue.shared
            .picklistOptionsDict["Submitted_By__c"] ?? []

        let sortedOptions = options.sorted {
            $0.label.localizedCaseInsensitiveCompare($1.label) == .orderedAscending
        }

        guard let firstOption = sortedOptions.first else {
            return
        }

        let currentValue = submittedBytxtFld?.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if currentValue.isEmpty {
            submittedBytxtFld?.text = firstOption.value
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
    
    func fetchProjects() {
        eOIWebServices.getProjects { error, projects, status in
            if status == .success, let projects = projects {
                self.projectList = projects
                let projectNames = projects.compactMap { $0.name }
                
                self.projectNameDropdown.dataSource = projectNames
            } else {
                print(error ?? "Failed to load projects")
            }
        }
    }
    
    func setCustomerProject() {
        guard let project = cuatomerDetailsDict?.project else {
            print("⚠️ Customer project not found")
            return
        }

        let projectName = project.name ?? EMPTY
        let projectId = project.id ?? EMPTY

        projectNametxtFld?.text = projectName
        selectedProjectName = projectId

        print("✅ Project Name: \(projectName)")
        print("✅ Project ID: \(projectId)")

        // Fetch project-related data
        if !projectId.isEmpty {
            fetchProjectConfiguration(for: projectId)
            fetchPreferences(for: projectId)
        }
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
    
    func setUpInitialUI() {
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        uploadTxtFldHeight?.constant = 0
        uploadTxtFld?.isHidden = true
        uploadImgIcon?.isHidden = true
        nametxtFld?.text = Defaults.name
        if Defaults.isIndividualEnable ?? false {
            pageNumberLbl?.text = "7"
            OutOfPageNumber?.text = "7"
        } else if Defaults.isPartnerShip ?? false {
            pageNumberLbl?.text = "8"
            OutOfPageNumber?.text = "8"
        } else {
            pageNumberLbl?.text = "7"
            OutOfPageNumber?.text = "7"
        }
        
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        resetBtn?.borderWidth = 1
        resetBtn?.borderColor = UIColor(hex: "DFE1E0")
        resetBtn?.layer.cornerRadius = 6
        nextBtn?.layer.cornerRadius = 6
        isOfflineEOIFormYes?.borderWidth = 1
        isOfflineEOIFormYes?.borderColor = UIColor(hex: "DFE1E0")
        isOfflineEOIFormYes?.layer.cornerRadius = 6
        isOfflineEOIFormNO?.borderWidth = 1
        isOfflineEOIFormNO?.borderColor = UIColor(hex: "DFE1E0")
        isOfflineEOIFormNO?.layer.cornerRadius = 6
        
        projectNametxtFld?.label.text = "Project Name *"
        projectNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        projectNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        projectNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
//        projectNametxtFld?.delegate = self
//        projectNametxtFld?.inputView = UIView()
        projectNametxtFld?.isEnabled = false
        
        tentativeSellabletxtFld?.label.text = "Tentative Sellable Area *"
        tentativeSellabletxtFld?.setOutlineColor(.darkGray, for: .normal)
        tentativeSellabletxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        tentativeSellabletxtFld?.translatesAutoresizingMaskIntoConstraints = false
//        tentativeSellabletxtFld?.isEnabled = false
        
        tentativePricetxtFld?.label.text = "Tentative Price Range"
        tentativePricetxtFld?.setOutlineColor(.darkGray, for: .normal)
        tentativePricetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        tentativePricetxtFld?.translatesAutoresizingMaskIntoConstraints = false
//        tentativePricetxtFld?.isEnabled = false
        
        submittedBytxtFld?.label.text = "Submitted By"
        submittedBytxtFld?.setOutlineColor(.darkGray, for: .normal)
        submittedBytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        submittedBytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        submittedBytxtFld?.delegate = self
        submittedBytxtFld?.inputView = UIView()
        
        nametxtFld?.label.text = "Name"
        nametxtFld?.setOutlineColor(.darkGray, for: .normal)
        nametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        nametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        nametxtFld?.isEnabled = false
        
        RMNametxtFld?.label.text = "RM Name *"
        RMNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        RMNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        RMNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
//        RMNametxtFld?.delegate = self
//        RMNametxtFld?.inputView = UIView()
        RMNametxtFld?.delegate = self
        RMNametxtFld?.inputView = nil
        RMNametxtFld?.isUserInteractionEnabled = true
        RMNametxtFld?.addTarget(
            self,
            action: #selector(rmNameTextChanged(_:)),
            for: .editingChanged
        )
        
        firstPreferenceTxtFld?.label.text = "1st Preference *"
        firstPreferenceTxtFld?.setOutlineColor(.darkGray, for: .normal)
        firstPreferenceTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        firstPreferenceTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        firstPreferenceTxtFld?.delegate = self
        firstPreferenceTxtFld?.inputView = UIView()
        
        secondPreferenceTxtFld?.label.text = "2nd Preference *"
        secondPreferenceTxtFld?.setOutlineColor(.darkGray, for: .normal)
        secondPreferenceTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        secondPreferenceTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        secondPreferenceTxtFld?.delegate = self
        secondPreferenceTxtFld?.inputView = UIView()
        
        thirdPreferenceTxtFld?.label.text = "3rd Preference"
        thirdPreferenceTxtFld?.setOutlineColor(.darkGray, for: .normal)
        thirdPreferenceTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        thirdPreferenceTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        thirdPreferenceTxtFld?.delegate = self
        thirdPreferenceTxtFld?.inputView = UIView()
        
        eoiLocationTxtFld?.label.text = "EOI Location"
        eoiLocationTxtFld?.setOutlineColor(.darkGray, for: .normal)
        eoiLocationTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        eoiLocationTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        agentNameTxtFld?.label.text = "Agent Name *"
        agentNameTxtFld?.setOutlineColor(.darkGray, for: .normal)
        agentNameTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        agentNameTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        agentMobileTxtFld?.label.text = "Agent Mobile *"
        agentMobileTxtFld?.setOutlineColor(.darkGray, for: .normal)
        agentMobileTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        agentMobileTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        uploadTxtFld?.label.text = "Upload EOI File"
        uploadTxtFld?.setOutlineColor(.darkGray, for: .normal)
        uploadTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        uploadTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let passportTap = UITapGestureRecognizer(target: self, action: #selector(uploadOptions))
        uploadTxtFld?.addGestureRecognizer(passportTap)
        uploadTxtFld?.isUserInteractionEnabled = true
    }
    
    @objc func uploadOptions() {
        showUploadOptions(sourceField: "Upload")
    }
    
    func showUploadOptions(sourceField: String) {
        let actionSheet = UIAlertController(title: "Upload \(sourceField)", message: "Choose an option", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openGallery()
        }))
        actionSheet.addAction(UIAlertAction(title: "Files", style: .default, handler: { _ in
            self.openDocumentPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .pdf, .plainText, .rtf, .spreadsheet])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let imageURL = info[.imageURL] as? URL {
            let fileExtension = imageURL.pathExtension
            let fileName = "EOI.\(fileExtension)"
            uploadTxtFld?.text = fileName
            selectedAttachment = Attachment(fileName: fileName, fileURL: imageURL, fileType: fileExtension)
            print("Selected Image: \(fileName)")
        } else if let image = info[.originalImage] as? UIImage {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("EOI.jpg")
                try? data.write(to: tempURL)
                uploadTxtFld?.text = "EOI.jpg"
                selectedAttachment = Attachment(fileName: "EOI.jpg", fileURL: tempURL, fileType: "jpg")
                print("Captured Image: EOI.jpg")
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        let fileExtension = url.pathExtension
        let fileName = "EOI.\(fileExtension)"
        
        uploadTxtFld?.text = fileName
        selectedAttachment = Attachment(fileName: fileName, fileURL: url, fileType: fileExtension)
        print("Selected File: \(fileName)")
    }
    
    func convertAttachmentToBase64(_ attachment: Attachment) -> String? {
        let fileURL = attachment.fileURL
        
        let didStartAccess = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccess {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }
        do {
            let data = try Data(contentsOf: fileURL)
            return data.base64EncodedString()
        } catch {
            print("❌ Failed to read file \(attachment.fileName): \(error)")
            return nil
        }
    }
    
    func clearAllFields() {
        projectNametxtFld?.text = ""
        tentativeSellabletxtFld?.text = ""
        tentativePricetxtFld?.text = ""
        submittedBytxtFld?.text = ""
        nametxtFld?.text = ""
        RMNametxtFld?.text = ""
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func validateProjectFields() -> Bool {
        let projectName = projectNametxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let tentativeSellable = tentativeSellabletxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let rmName = RMNametxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let firstPref = firstPreferenceTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let secondPref = secondPreferenceTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let agentName = agentNameTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let agentMobile = agentMobileTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if projectName.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Project Name.")
            return false
        }
        
        if tentativeSellable.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Tentative Sellable Area.")
            return false
        }
        
        if rmName.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter RM Name.")
            return false
        }
        
        if firstPref.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter 1st Preference.")
            return false
        }
        
        if secondPref.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter 2nd Preference.")
            return false
        }
        if agentName.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Agent Name.")
            return false
        }
        
        if agentMobile.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Agent Mobile.")
            return false
        }
        let mobileRegex = #"^[0-9]{10}$"#
        
        guard agentMobile.range(of: mobileRegex, options: .regularExpression) != nil else {
            
            showAlert(
                
                with: "Validation Error",
                
                message: "Agent Mobile must contain exactly 10 digits."
                
            )
            
            return false
            
        }
        
        return true
    }
    
    func uploadAttachment(linkedEntityId: String) async {
        guard let attachment = selectedAttachment else {
            print("⚠️ No attachment selected.")
            return
        }
        showLoader(with: "Uploading Attachment...")
        
        let base64Data = convertAttachmentToBase64(attachment) ?? ""
        let contentVersionBody: [String: Any] = [
            "Title": attachment.fileName,
            "PathOnClient": attachment.fileName,
            "NetworkId": Defaults.networkId ?? "",
            "VersionData": base64Data
        ]
        
        do {
            let contentVersionId = try await CreateRequestWebService.shared.createRecordForFile(ofType: "ContentVersion", withFields: contentVersionBody)
            print("✅ ContentVersion created: \(contentVersionId)")
            
            let soqlQuery = "SELECT ContentDocumentId FROM ContentVersion WHERE Id = '\(contentVersionId)'"
            let queryResponse = try await CreateRequestWebService.shared.queryRecordsAsync(soqlQuery: soqlQuery)
            
            guard let records = queryResponse["records"] as? [[String: Any]],
                  let firstRecord = records.first,
                  let contentDocumentId = firstRecord["ContentDocumentId"] as? String else {
                print("❌ Failed to fetch ContentDocumentId")
                self.handleError(
                    step: "Attachment Upload",
                    error: "Failed to fetch uploaded document ID."
                )
                return
            }
            print("✅ ContentDocumentId fetched: \(contentDocumentId)")
            let contentDocumentLinkBody: [String: Any] = [
                "ContentDocumentId": contentDocumentId,
                "LinkedEntityId": linkedEntityId,
                "ShareType": "V"
            ]
            
            let _ = try await CreateRequestWebService.shared.createRecordForFile(ofType: "ContentDocumentLink", withFields: contentDocumentLinkBody)
//            if Defaults.isIndividualEnable ?? false {
//                showLoader(with: "Submitting Applicants...")
//                self.sendApplicantsComposite()
//            } else {
//                showLoader(with: "Saving Company Details...")
//                await self.sendOtherData()
//            }
            
            if Defaults.isIndividualEnable ?? false {

                self.showLoader(with: "Submitting Applicant Details...")
                self.sendApplicantsComposite()

            } else {

                let type = Helper.typeDisplayName

                if type == "Partnership" {

                    self.showLoader(with: "Submitting Partnership Applicants...")
                    self.sendNonIndividualApplicantsComposite()

                } else {

                    self.showLoader(with: "Submitting  Details...")
                    await self.sendSingleNonIndividualApplicant()
                }
            }
            
            
            
        } catch {
            DispatchQueue.main.async {
                self.hideLoader()
                self.view.makeToast(error.localizedDescription)

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    Utility.gotoTabbar()

                }
            }
        }
    }
    
    
    func submitEOIForm() {
        guard validateProjectFields() else { return }
        var nameValue: String = EMPTY
        showLoader(with: "Creating Opportunity...")
        var recordTypeId: String = EMPTY

        if Defaults.isFromEOI == true {
            recordTypeId = Defaults.eoiRecordTypeId ?? EMPTY
        } else {
            recordTypeId = Defaults.legacyRecordTypeId ?? EMPTY
        }
        if Defaults.isIndividualEnable ?? false {
            if let primaryApplicant = OpportunityManager.shared.applicants.first(where: { $0.primary == true }) {
                nameValue = primaryApplicant.name ?? EMPTY
            } else {
                nameValue = EMPTY
            }
        } else {
            nameValue = OpportunityManager.shared.applicants.first?.nameOfCompanyFirmLLP ?? EMPTY
        }
        let maskedDataPayload: [String: Any] = [
            "Mobile": [
                "Default": cuatomerDetailsDict?.maskedData?.mobile?.defaultValue ?? EMPTY
            ],
            "Email": [
                "Default": cuatomerDetailsDict?.maskedData?.email?.defaultValue ?? EMPTY
            ]
        ]

        var maskedDataString = EMPTY
        if let jsonData = try? JSONSerialization.data(withJSONObject: maskedDataPayload, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            maskedDataString = jsonString
        }
        print("maskedDataStringmaskedDataStringmaskedDataString\(maskedDataString)")
        let formPayload: [String: Any] = [
            "Project__c": selectedProjectName,
            "EOI_Saleable_Area__c": tentativeSellabletxtFld?.text ?? "",
            "EOI_Tentative_Price_Range__c": tentativePricetxtFld?.text ?? "",
            "First_Preference__c": firstPreferenceTxtFld?.text ?? "",
            "Second_Preference__c": secondPreferenceTxtFld?.text ?? "",
            "third_Preference__c": thirdPreferenceTxtFld?.text ?? "",
            "Submitted_By__c": submittedBytxtFld?.text ?? "",
            "Channel_Partner_Agent_Name__c": agentNameTxtFld?.text ?? "",
            "Channel_Partner_Mobile_No__c": agentMobileTxtFld?.text ?? "",
            "RM_Name__c": selectedRM,
            "Applicant_Type__c": Helper.typeDisplayName,
            "IsOfflineEOIForm__c": isOfflineEOIForm,
            "Name": nameValue,
            "MobilePhone__c": cuatomerDetailsDict?.mobile ?? EMPTY,
            "Email__c": cuatomerDetailsDict?.email ?? EMPTY,
            "Stage__c": "EOI",
            "EOI_Form_Location__c": cuatomerDetailsDict?.country ?? EMPTY,
            "RecordTypeId": recordTypeId,
            "Masked_Data__c": maskedDataString
        ]
        print("opportunity Payload \(formPayload)")
        Task {
            await createRequestWebService.createRecord(ofType: "Opportunity__c", withFields: formPayload) { [weak self] opportunityId in
                guard let self = self else { return }
                print("✅ Opportunity created with Id: \(opportunityId)")
                self.oppId = opportunityId
                Task {
                    if self.isOfflineEOIForm, let _ = self.selectedAttachment {
                        self.showLoader(with: "Uploading Opportunity Attachment...")
                        await self.uploadAttachment(linkedEntityId: opportunityId)
                    } else {
//                        if Defaults.isIndividualEnable ?? false {
//                            self.showLoader(with: "Submitting Applicant Details...")
//                            self.sendApplicantsComposite()
//                        } else {
//                            self.showLoader(with: "Submitting Company Details...")
//                            await self.sendOtherData()
//                        }
                        
                        if Defaults.isIndividualEnable ?? false {

                            self.showLoader(with: "Submitting Applicant Details...")
                            self.sendApplicantsComposite()

                        } else {

                            let type = Helper.typeDisplayName

                            if type == "Partnership" {

                                self.showLoader(with: "Submitting Partnership Applicants...")
                                self.sendNonIndividualApplicantsComposite()

                            } else {

                                self.showLoader(with: "Submitting Company Details...")
                                await self.sendSingleNonIndividualApplicant()
                            }
                        }
                    }
                }
                
            } onFailure: { errorMsg in
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.view.makeToast(errorMsg)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                }
            }
        }
    }
    
    func sendApplicantsComposite() {
        let applicants = OpportunityManager.shared.applicants
        guard !applicants.isEmpty else {
            print("⚠️ No applicants to send")
            return
        }
        showLoader(with: "Saving Applicant Records...")
        
        var recordsArray: [[String: Any]] = []
        
        for index in 0..<applicants.count {
            OpportunityManager.shared.applicants[index].attributes = SaveModel.Attributes(dict: [
                "type": "Applicant_Details__c",
                "referenceId": "ref\(index + 1)"
            ])
            var nameValue: String = EMPTY
            if Defaults.isIndividualEnable ?? false {
                if let primaryApplicant = OpportunityManager.shared.applicants.first(where: { $0.primary == true }) {
                    nameValue = primaryApplicant.name ?? EMPTY
                } else {
                    nameValue = EMPTY
                }
            } else {
                nameValue = OpportunityManager.shared.applicants.first?.companyName ?? EMPTY
            }
            let maskedDataPayload: [String: Any] = [
                "Mobile": [
                    "Default": cuatomerDetailsDict?.maskedData?.mobile?.defaultValue ?? EMPTY
                ],
                "Email": [
                    "Default": cuatomerDetailsDict?.maskedData?.email?.defaultValue ?? EMPTY
                ]
            ]

            var maskedDataString = EMPTY
            if let jsonData = try? JSONSerialization.data(withJSONObject: maskedDataPayload, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                maskedDataString = jsonString
            }
            print("maskedDataStringmaskedDataStringmaskedDataString\(maskedDataString)")
            let record: [String: Any] = [
                "attributes": [
                    "type": "Applicant_Details__c",
                    "referenceId": "ref\(index + 1)"
                ],
                "Opportunity__c": oppId,
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
                "Passport_Validity__c": Helper.dateOrNull(OpportunityManager.shared.applicants[index].passportValidity),
                "Aadhaar_Number__c": OpportunityManager.shared.applicants[index].aadhaarNumber ?? EMPTY,
                "Verification_Type__c": OpportunityManager.shared.applicants[index].verificationType ?? EMPTY,
                "Verified_By_Adhaar__c": OpportunityManager.shared.applicants[index].verifiedByAdhaar ?? false,
                "PAN_Number__c": OpportunityManager.shared.applicants[index].panNumber ?? EMPTY,
                "Salutation__c": OpportunityManager.shared.applicants[index].salutation ?? EMPTY,
                "Occupation__c": OpportunityManager.shared.applicants[index].occupation ?? EMPTY,
                "Permanent_Address_is_Same_as_Corresponde__c":
                    OpportunityManager.shared.applicants[index].permanentAddressIsSameAsCorrespondence ?? false,
                "Masked_Data__c": maskedDataString
            ]
            recordsArray.append(record)
        }
        
        let compositePayload: [String: Any] = ["records": recordsArray]
        print("ApplicantsComposite applicants \(compositePayload)")
        
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
                                self.applicantId = id
                                OpportunityManager.shared.applicants[index].id = id
                                print("✅ Applicant \(applicants[index].name ?? "") mapped to Salesforce Id: \(id)")
                            }
                        }
                    }
                    
                     Task {
                        
                        for applicant in OpportunityManager.shared.applicants {

                            print("Applicant Upload Debug")
                            print("Name: \(applicant.name ?? "No Name")")
                            print("Applicant ID: \(applicant.id ?? "nil")")
                            print("Reference ID: \(applicant.attributes?.referenceId ?? "nil")")

                            if !applicant.uploadedFiles.isEmpty {

                                await self.uploadAttachmentsForApplicant(applicant)
                            }
                        }

                        DispatchQueue.main.async {

                            self.hideLoader()

                            if self.isFromCustomers {

                                Task {
                                    await self.sendCustomerData()
                                }

                            } else {
                                self.view.makeToast(OPPORTUNITY_ATTACHMENT_UPLOADED)

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    Utility.gotoTabbar()

                                }
                            }
                        }
                    }
                }
            case .alreadyRegister:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.view.makeToast(SESSION_EXPIRED)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                    print("⚠️ Token expired. Logging out.")
                }
            case .tokenExpired:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.view.makeToast(SESSION_EXPIRED)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                    print("⚠️ Token expired. Logging out.")
                }
            case .error:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.view.makeToast(errorMsg ?? "Unknown error")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                }
            case .badRequest:
                DispatchQueue.main.async {
                    self.hideLoader()
                    Utility.gotoTabbar()
                    self.view.makeToast(errorMsg ?? "Unknown error")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                }
            }
        }
    }
    
    func sendNonIndividualApplicantsComposite() {
        let applicants = OpportunityManager.shared.applicants
        guard !applicants.isEmpty else {
            print("⚠️ No non-individual applicants to send")
            return
        }

        showLoader(with: "Saving Partnership Applicants...")

        var recordsArray: [[String: Any]] = []

        for index in 0..<applicants.count {

            OpportunityManager.shared.applicants[index].attributes = SaveModel.Attributes(dict: [
                "type": "Applicant_Details__c",
                "referenceId": "nonIndRef\(index + 1)"
            ])

            let applicant = applicants[index]
            var nameValue: String = EMPTY
            if Defaults.isIndividualEnable ?? false {
                if let primaryApplicant = OpportunityManager.shared.applicants.first(where: { $0.primary == true }) {
                    nameValue = primaryApplicant.name ?? EMPTY
                } else {
                    nameValue = EMPTY
                }
            } else {
                nameValue = OpportunityManager.shared.applicants.first?.companyName ?? EMPTY
            }
            let maskedDataPayload: [String: Any] = [
                "Mobile": [
                    "Default": cuatomerDetailsDict?.maskedData?.mobile?.defaultValue ?? EMPTY
                ],
                "Email": [
                    "Default": cuatomerDetailsDict?.maskedData?.email?.defaultValue ?? EMPTY
                ]
            ]

            var maskedDataString = EMPTY
            if let jsonData = try? JSONSerialization.data(withJSONObject: maskedDataPayload, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                maskedDataString = jsonString
            }
            print("maskedDataStringmaskedDataStringmaskedDataString\(maskedDataString)")

            let record: [String: Any] = [
                "attributes": [
                    "type": "Applicant_Details__c",
                    "referenceId": "nonIndRef\(index + 1)"
                ],

                "Opportunity__c": oppId,
                "RecordTypeId": recordTypeId,
                "Primary__c": applicant.primary ?? EMPTY,
                "Name_of_Company_Firm_LLP__c": applicant.nameOfCompanyFirmLLP ?? EMPTY,
                "Date_of_Incorporation__c": Helper.dateOrNull(
                    applicant.dateOfIncorporation
                ),
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
                "Board_of_Resolution_Date__c": Helper.dateOrNull(
                        applicant.boardResolutionDate
                    ),
                "GST_No__c": applicant.gstNo ?? EMPTY,
                "Authorisation_Letter_Date__c": Helper.valueOrNull(applicant.authorisationLetterDate),
                "Partnership_LLP_HUF_Deed_Date__c": Helper.valueOrNull(applicant.partnershipLLPHUFDeedDate),
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
                "Note__c": applicant.note ?? EMPTY,
                "Masked_Data__c": maskedDataString
            ]

            recordsArray.append(record)
        }

        let compositePayload: [String: Any] = ["records": recordsArray]
        print("NonIndividualApplicantsComposite applicants \(compositePayload)")
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
                                self.applicantId = id
                                OpportunityManager.shared.applicants[index].id = id
                                print("✅ Applicant \(applicants[index].name ?? "") mapped to Salesforce Id: \(id)")
                            }
                        }
                    }
                    Task {

                        for applicant in OpportunityManager.shared.applicants {

                            print("Applicant Upload Debug")
                            print("Name: \(applicant.name ?? "No Name")")
                            print("Applicant ID: \(applicant.id ?? "nil")")
                            print("Reference ID: \(applicant.attributes?.referenceId ?? "nil")")

                            if !applicant.uploadedFiles.isEmpty {

                                await self.uploadAttachmentsForApplicant(applicant)
                            }
                        }

                        DispatchQueue.main.async {

                            self.hideLoader()

                            if self.isFromCustomers {

                                Task {
                                    await self.sendCustomerData()
                                }

                            } else {
                                self.view.makeToast(OPPORTUNITY_ATTACHMENT_UPLOADED)

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    Utility.gotoTabbar()

                                }
                            }
                        }
                    }
                }
            case .alreadyRegister:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.view.makeToast(SESSION_EXPIRED)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                }
            case .tokenExpired:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.view.makeToast(SESSION_EXPIRED)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                }
            case .error:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.view.makeToast(errorMsg ?? "Unknown error")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                }
            case .badRequest:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.view.makeToast(errorMsg ?? "Bad request")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                }
            }
        }
    }
    
    func sendSingleNonIndividualApplicant() async {

        guard let applicant = OpportunityManager.shared.applicants.first else {
            print("⚠️ No applicant data available")
            return
        }
        var nameValue: String = EMPTY
        if Defaults.isIndividualEnable ?? false {
            if let primaryApplicant = OpportunityManager.shared.applicants.first(where: { $0.primary == true }) {
                nameValue = primaryApplicant.name ?? EMPTY
            } else {
                nameValue = EMPTY
            }
        } else {
            nameValue = OpportunityManager.shared.applicants.first?.companyName ?? EMPTY
        }
        let maskedDataPayload: [String: Any] = [
            "Mobile": [
                "Default": cuatomerDetailsDict?.maskedData?.mobile?.defaultValue ?? EMPTY
            ],
            "Email": [
                "Default": cuatomerDetailsDict?.maskedData?.email?.defaultValue ?? EMPTY
            ]
        ]

        var maskedDataString = EMPTY
        if let jsonData = try? JSONSerialization.data(withJSONObject: maskedDataPayload, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            maskedDataString = jsonString
        }
        print("maskedDataStringmaskedDataStringmaskedDataString\(maskedDataString)")

        showLoader(with: "Saving Applicant Details...")        
        let formPayload: [String: Any] = [
            "Opportunity__c": oppId,
            "RecordTypeId": recordTypeId,
            "Primary__c": applicant.primary ?? EMPTY,
            "Name_of_Company_Firm_LLP__c": applicant.nameOfCompanyFirmLLP ?? EMPTY,

            // Date fields
            "Date_of_Incorporation__c": Helper.valueOrNull(applicant.dateOfIncorporation),
            "Board_of_Resolution_Date__c": Helper.valueOrNull(applicant.boardResolutionDate),
            "Authorisation_Letter_Date__c": Helper.valueOrNull(applicant.authorisationLetterDate),
            "Partnership_LLP_HUF_Deed_Date__c": Helper.valueOrNull(applicant.partnershipLLPHUFDeedDate),

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
            "GST_No__c": applicant.gstNo ?? EMPTY,
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
            "Note__c": applicant.note ?? EMPTY,
            "Masked_Data__c": maskedDataString
        ]
        print("📌 applicantDetailsModel.notes =", applicant.note ?? "NIL")


        print("📌 applicant.note =", applicant.note ?? "NIL")
        print("SingleNonIndividual applicants \(formPayload)")

        do {
            let applicantId = try await createRequestWebService.createRecordForFile(
                ofType: "Applicant_Details__c",
                withFields: formPayload
            )

            print("✅ Single Non-Individual Applicant created: \(applicantId)")

            self.applicantId = applicantId

            OpportunityManager.shared.applicants[0].id = applicantId

            OpportunityManager.shared.applicants[0].attributes = SaveModel.Attributes(dict: [
                "type": "Applicant_Details__c",
                "referenceId": "singleNonIndRef1"
            ])
            
            if !applicant.uploadedFiles.isEmpty {

                await self.uploadAttachmentsForApplicant(
                    OpportunityManager.shared.applicants[0]
                )

                if isFromCustomers {

                    await self.sendCustomerData()

                } else {

                    DispatchQueue.main.async {

                        self.hideLoader()
                        self.view.makeToast(OPPORTUNITY_ATTACHMENT_UPLOADED)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            Utility.gotoTabbar()

                        }
                    }
                }

            } else {

                if isFromCustomers {

                    await self.sendCustomerData()

                } else {

                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.view.makeToast(APPLICANT_CREATED)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            Utility.gotoTabbar()

                        }
                       
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.hideLoader()
                self.view.makeToast(error.localizedDescription)

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    Utility.gotoTabbar()

                }
            }
        }
    }
    
    func sendOtherData() async {
        guard let applicant = OpportunityManager.shared.applicants.first else {
            print("⚠️ No applicant data available.")
            return
        }
        showLoader(with: "Saving Applicant Records...")
        var nameValue: String = EMPTY
        if Defaults.isIndividualEnable ?? false {
            if let primaryApplicant = OpportunityManager.shared.applicants.first(where: { $0.primary == true }) {
                nameValue = primaryApplicant.name ?? EMPTY
            } else {
                nameValue = EMPTY
            }
        } else {
            nameValue = OpportunityManager.shared.applicants.first?.companyName ?? EMPTY
        }
        let maskedDataPayload: [String: Any] = [
            "Mobile": [
                "Default": cuatomerDetailsDict?.maskedData?.mobile?.defaultValue ?? EMPTY
            ],
            "Email": [
                "Default": cuatomerDetailsDict?.maskedData?.email?.defaultValue ?? EMPTY
            ]
        ]

        var maskedDataString = EMPTY
        if let jsonData = try? JSONSerialization.data(withJSONObject: maskedDataPayload, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            maskedDataString = jsonString
        }
        print("maskedDataStringmaskedDataStringmaskedDataString\(maskedDataString)")
        let formPayload: [String: Any] = [
            "Opportunity__c": oppId,
            "RecordTypeId": recordTypeId,
            "Primary__c": applicant.primary ?? EMPTY,
            "Name_of_Company_Firm_LLP__c": applicant.nameOfCompanyFirmLLP ?? EMPTY,
            "Date_of_Incorporation__c": Helper.dateOrNull(
                applicant.dateOfIncorporation
            ),
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
            "Board_of_Resolution_Date__c": Helper.dateOrNull(
                    applicant.boardResolutionDate
                ),
            "GST_No__c": applicant.gstNo ?? EMPTY,
            "Authorisation_Letter_Date__c": Helper.valueOrNull(applicant.authorisationLetterDate),
            "Partnership_LLP_HUF_Deed_Date__c": Helper.valueOrNull(applicant.partnershipLLPHUFDeedDate),
            "Registration_State__c": applicant.registrationState ?? EMPTY,
            "Registration_No__c": applicant.registrationNo ?? EMPTY,
            "Prior_investment_in_the_existing_Project__c": applicant.priorInvestmentInExistingProject ?? EMPTY,
            "Unit_Number__c": applicant.unitNumber ?? EMPTY,
            
            "Salutation_for_Authorised_Signatory__c": applicant.salutationForAuthorisedSignatory ?? EMPTY,
            "Relation__c": applicant.relation ?? EMPTY,
            "Salutation_for_Relative__c": applicant.salutationForRelative ?? EMPTY,
            "Name_of_Relative__c": applicant.relativeName ?? EMPTY,
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
            "Note__c": applicant.note ?? EMPTY,
            "Masked_Data__c": maskedDataString
        ]
        print("OtherData Applicants: \(formPayload)")
        do {
            let applicantId = try await createRequestWebService.createRecordForFile(
                ofType: "Applicant_Details__c",
                withFields: formPayload
            )
            print("✅ Applicant created with Id: \(applicantId)")
            self.applicantId = applicantId
            
            if !applicant.uploadedFiles.isEmpty {
                print("⬆️ Uploading \(applicant.uploadedFiles.count) files for applicant")
                await self.uploadAttachmentsForApplicant(applicant)
            }  else {
                if isFromCustomers {
                    await self.sendCustomerData()
                } else {
                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.view.makeToast(OPPORTUNITY_ATTACHMENT_UPLOADED)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            Utility.gotoTabbar()

                        }
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.hideLoader()
                self.view.makeToast(error.localizedDescription)

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    Utility.gotoTabbar()

                }
            }
            return
        }
    }
    
    func sendCustomerData() async {
        guard let customerId = cuatomerDetailsDict?.id,
              !customerId.isEmpty else {
            print("❌ Customer Id missing")
            return
        }
        showLoader(with: "Saving Customers Records...")
        var formPayload: [String: Any] = [:]
        
        formPayload = [
            "Converted_to_EOI__c": true,
            "RecordTypeId": customerRecordTypeId
        ]
        
        let endPoint = "\(endPoint.SEND_CUSTOMERS_COMPOSITE)\(customerId)"
        
        createRequestWebService.updateRecordForFile(endPoint: endPoint, param: formPayload) { error, response, status in
            DispatchQueue.main.async {
                self.hideLoader()
                
                if status == .success {
                    self.view.makeToast(APPLICANT_CREATED)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
                } else {
                    self.hideLoader()
                    self.view.makeToast(SOMETHING_WENT_WRONG_STR)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.gotoTabbar()

                    }
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
    
    @IBAction func resetAction() {
        clearAllFields()
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func agreementAction(_ sender: UIButton?) {
        isAgreementBtnClick = !isAgreementBtnClick
    }
    
    @IBAction func uploadOffLineFormAction(_ sender: UIButton?) {
        isOfflineEOIForm = false
        uploadTxtFldHeight?.constant = 0
        uploadTxtFld?.isHidden = true
        uploadImgIcon?.isHidden = true
        if sender?.tag == 11 {
            isOfflineEOIForm = true
            isOfflineEOIFormYes?.backgroundColor = UIColor(hex: "223B30")
            isOfflineEOIFormYes?.setTitleColor(.white, for: .normal)
            isOfflineEOIFormNO?.backgroundColor = UIColor(hex: "DFE1E0")
            isOfflineEOIFormNO?.setTitleColor(.black, for: .normal)
            uploadTxtFldHeight?.constant = 48
            uploadTxtFld?.isHidden = false
            uploadImgIcon?.isHidden = false
        } else if sender?.tag == 12 {
            isOfflineEOIForm = false
            isOfflineEOIFormYes?.backgroundColor = UIColor(hex: "DFE1E0")
            isOfflineEOIFormYes?.setTitleColor(.black, for: .normal)
            isOfflineEOIFormNO?.backgroundColor = UIColor(hex: "223B30")
            isOfflineEOIFormNO?.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func submitAction() {
        submitEOIForm()
    }
}

extension miscellaneousEOIScreenVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == projectNametxtFld {
//            showProjectNameDropdown()
//            return false
//        } else
        if textField == submittedBytxtFld {
            showSubmittedByDropdown()
            return false
        } else if textField == RMNametxtFld {
//            showRMNameDropdown()
//            return false
            return true
        } else if textField == firstPreferenceTxtFld {
            showPreferenceDropdown(for: firstPreferenceTxtFld!,
                                   selectedPreferences: [secondPreference, thirdPreference].compactMap { $0 },
                                   allPreferences: preferencesList) { selected in
                self.firstPreference = selected
            }
            return false
        } else if textField == secondPreferenceTxtFld {
            showPreferenceDropdown(for: secondPreferenceTxtFld!,
                                   selectedPreferences: [firstPreference, thirdPreference].compactMap { $0 },
                                   allPreferences: preferencesList) { selected in
                self.secondPreference = selected
            }
            return false
        } else if textField == thirdPreferenceTxtFld {
            showPreferenceDropdown(for: thirdPreferenceTxtFld!,
                                   selectedPreferences: [firstPreference, secondPreference].compactMap { $0 },
                                   allPreferences: preferencesList) { selected in
                self.thirdPreference = selected
            }
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == RMNametxtFld {
            
            // If data is already loaded, don't call API again
            if allRMUsers.isEmpty {
                loadRMUsers()
            } else {
                filteredRMUsers = allRMUsers
            }
        }
    }
    
    func loadRMUsers() {
        
        showLoader(with: "Loading RM users...")
        
        eOIWebServices.getActiveRMUsers { [weak self] error, users, status in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                self.hideLoader()
                
                if status == .success, let users = users {
                    
                    self.allRMUsers = users
                    self.filteredRMUsers = users
                    
                    // Don't show dropdown immediately.
                    // User can type first.
                    
                } else {
                    print(error ?? "Failed to fetch RM users")
                }
            }
        }
    }
    
    func showTentativeSellableAreaDropdown() {
        let options = FetchPicklistValue.shared.picklistOptionsDict["EOI_Saleable_Area__c"] ?? []
        let accountLabel = options.map { $0.label }
        let accountValue = options.map { $0.value }
        
        print("EOI_Saleable_Area__c Labels: \(accountLabel)")
        print("EOI_Saleable_Area__c: \(accountValue)")
        
        tentativeSellableAreaDropdown.anchorView = tentativeSellabletxtFld
        tentativeSellableAreaDropdown.dataSource = accountValue
        
        tentativeSellableAreaDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard index < accountLabel.count else { return }
            self?.tentativeSellabletxtFld?.text = item
        }
        tentativeSellableAreaDropdown.show()
    }
    
    func showProjectNameDropdown() {
        let projectNames = projectList.map { $0.name ?? "" }
        
        projectNameDropdown.anchorView = projectNametxtFld
        projectNameDropdown.dataSource = projectNames
        
        projectNameDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.projectNametxtFld?.text = item
            let selectedProject = self.projectList[index]
            selectedProjectName = selectedProject.id ?? EMPTY
            print("Selected Project ID: \(selectedProject.id ?? "")")
            if let projectId = selectedProject.id {
                self.fetchProjectConfiguration(for: projectId)
                self.fetchPreferences(for: projectId)
            }
        }
        projectNameDropdown.show()
    }
    
    func showTentativePriceRangeDropdown() {
        let options = FetchPicklistValue.shared.picklistOptionsDict["EOI_Tentative_Price_Range__c"] ?? []
        let accountLabel = options.map { $0.label }
        let accountValue = options.map { $0.value }
        
        print("EOI_Tentative_Price_Range__c Labels: \(accountLabel)")
        print("EOI_Tentative_Price_Range__c: \(accountValue)")
        
        tentativePriceRangeDropdown.anchorView = projectNametxtFld
        tentativePriceRangeDropdown.dataSource = accountValue
        
        tentativePriceRangeDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard index < accountLabel.count else { return }
            self?.projectNametxtFld?.text = item
        }
        tentativePriceRangeDropdown.show()
    }
    
//    func showSubmittedByDropdown() {
//        let options = FetchPicklistValue.shared.picklistOptionsDict["Submitted_By__c"] ?? []
//        let accountLabel = options.map { $0.label }
//        let accountValue = options.map { $0.value }
//        
//        print("Submitted_By__c Labels: \(accountLabel)")
//        print("Submitted_By__c: \(accountValue)")
//        
//        submittedByDropdown.anchorView = submittedBytxtFld
//        submittedByDropdown.dataSource = accountValue
//        
//        submittedByDropdown.selectionAction = { [weak self] (index: Int, item: String) in
//            guard index < accountLabel.count else { return }
//            self?.submittedBytxtFld?.text = item
//        }
//        submittedByDropdown.show()
//    }
    
    func showSubmittedByDropdown() {
        let options = FetchPicklistValue.shared
            .picklistOptionsDict["Submitted_By__c"] ?? []

        let sortedOptions = options.sorted {
            $0.label.localizedCaseInsensitiveCompare($1.label) == .orderedAscending
        }

        let accountLabels = sortedOptions.map { $0.label }
        let accountValues = sortedOptions.map { $0.value }

        submittedByDropdown.anchorView = submittedBytxtFld
        submittedByDropdown.dataSource = accountLabels

        submittedByDropdown.selectionAction = { [weak self] index, _ in
            guard index < accountValues.count else { return }
            self?.submittedBytxtFld?.text = accountValues[index]
        }

        submittedByDropdown.show()
    }
        
    func showRMNameDropdown() {
        if !allRMUsers.isEmpty {
            filteredRMUsers = allRMUsers
            updateRMNameDropdown()
            return
        }
        
        showLoader(with: "Loading RM users...")
        
        eOIWebServices.getActiveRMUsers { [weak self] error, users, status in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                self.hideLoader()
                
                if status == .success, let users = users {
                    
                    self.allRMUsers = users
                    self.filteredRMUsers = users
                    
                    self.updateRMNameDropdown()
                    
                } else {
                    print(error ?? "Failed to fetch RM users")
                }
            }
        }
    }
    
    func updateRMNameDropdown() {
        
        let names = filteredRMUsers.compactMap { $0.name }
        
        if names.isEmpty {
            RMNameDropdown.hide()
            return
        }
        
        RMNameDropdown.anchorView = RMNametxtFld
        RMNameDropdown.dataSource = names
        
        // Show dropdown ABOVE the text field
        RMNameDropdown.direction = .top
        
        // Optional: make dropdown same width as text field
        RMNameDropdown.width = RMNametxtFld?.bounds.width
        
        RMNameDropdown.selectionAction = { [weak self] index, item in
            
            guard let self = self else { return }
            
            guard index < self.filteredRMUsers.count else {
                return
            }
            
            let selectedUser = self.filteredRMUsers[index]
            
            self.RMNametxtFld?.text = selectedUser.name
            
            self.selectedRM = selectedUser.id ?? EMPTY
            
            print("✅ Selected RM Name: \(selectedUser.name ?? "")")
            print("✅ Selected RM ID: \(self.selectedRM)")
            
            self.RMNameDropdown.hide()
            self.RMNametxtFld?.resignFirstResponder()
        }
        
        RMNameDropdown.show()
    }
    
    @objc func rmNameTextChanged(_ textField: UITextField) {
        
        let searchText = textField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() ?? ""
        
        if searchText.isEmpty {
            filteredRMUsers = allRMUsers
        } else {
            filteredRMUsers = allRMUsers.filter { user in
                let name = user.name?.lowercased() ?? ""
                return name.contains(searchText)
            }
        }
        
        updateRMNameDropdown()
    }
    
    
    func showPreferenceDropdown(for textField: MDCOutlinedTextField, selectedPreferences: [ProjectPreferenceModel], allPreferences: [ProjectPreferenceModel], selectionAction: @escaping (ProjectPreferenceModel) -> ()) {
        
        let dropdown = DropDown()
        dropdown.anchorView = textField
        
        let filteredPreferences = allPreferences.filter { pref in
            !selectedPreferences.contains(where: { $0.id == pref.id })
        }
        
        let names = filteredPreferences.map { $0.name ?? "" }
        dropdown.dataSource = names
        
        dropdown.selectionAction = { index, item in
            let selectedPref = filteredPreferences[index]
            textField.text = selectedPref.name
            selectionAction(selectedPref)
        }
        
        dropdown.show()
    }
    
    func fetchProjectConfiguration(for projectId: String) {
        eOIWebServices.getProjectConfiguration(projectId: projectId) { [weak self] error, response, status in
            guard let self = self else { return }
            
            if status == .success,
               let records = response?["records"] as? [[String: Any]],
               let record = records.first {
                
                let sellableArea = record["Sellable_Area__c"] as? String ?? ""
                let priceRange = record["Price_Range__c"] as? String ?? ""
                
                DispatchQueue.main.async {
                    self.tentativeSellabletxtFld?.text = sellableArea
                    self.tentativePricetxtFld?.text = priceRange
                }
            } else {
                print(error ?? "Failed to load project configuration")
            }
        }
    }
    
    func fetchPreferences(for projectId: String) {
        eOIWebServices.getPreferences(projectId: projectId) { [weak self] error, preferences, status in
            guard let self = self else { return }
            
            if status == .success, let preferences = preferences {
                self.preferencesList = preferences
                print("✅ Preferences fetched: \(preferences.map { $0.name ?? "" })")
            } else {
                print(error ?? "Failed to load preferences")
            }
        }
    }
    
    func handleError(step: String, error: String) {

        DispatchQueue.main.async {

            self.hideLoader()

            Alert.showError(
                step: step,
                error: error,
                on: self
            )
        }
    }
}

struct Attachment {
    var fileName: String
    var fileURL: URL
    var fileType: String
}

//
//  AuthorizationVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 06/05/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Extended

class AuthorizationVC: UIViewController {
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    @IBOutlet var salurationSignatarytxtFld: MDCOutlinedTextField?
    @IBOutlet var RelationtxtFld: MDCOutlinedTextField?
    @IBOutlet var NameAuthorizationtxtFld: MDCOutlinedTextField?
    @IBOutlet var salutationRelativetxtFld: MDCOutlinedTextField?
    @IBOutlet var relativeNametxtFld: MDCOutlinedTextField?
    @IBOutlet var PANtxtFld: MDCOutlinedTextField?
    @IBOutlet var PANUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var PANUploadImg: UIImageView?
    @IBOutlet var aadhartxtFld: MDCOutlinedTextField?
    @IBOutlet var aadharUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var aadharUploadImg: UIImageView?
    
    var activeUploadField: String?
    @IBOutlet var resetBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    var validation = Validation()
    var applicantIndex: Int?
    let salutationSignataryDropDown = DropDown()
    var isFromCustomers: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var isForEditing: Bool = false
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var salutationRelativeArr: [String] = []
    var salutationArr: [String] = []
    var relationArr: [String] = []
    var isLocalEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
                
        if isForEditing {
            DispatchQueue.main.async {
                self.autoPopulateData()
            }
        } else if self.applicantIndex != nil {
            if let index = applicantIndex,
               let applicant = OpportunityManager.shared.getApplicant(at: index) {
                populateFromLocal(applicant)
            }
        }
//        salurationSignatarytxtFld?.text = "Mr."
//        NameAuthorizationtxtFld?.text = "Rajesh Kumar"
//        salutationRelativetxtFld?.text = "Mrs."
//        relativeNametxtFld?.text = "Sunita Kumar"
//        PANtxtFld?.text = "ABCDE1234F"
//        aadhartxtFld?.text = "123412341234"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await fetchPicklistData()
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
    
    func populateFromLocal(_ applicant: SaveModel) {
        salurationSignatarytxtFld?.text = applicant.salutationForAuthorisedSignatory
        NameAuthorizationtxtFld?.text = applicant.nameOfAuthorizedContactPerson
        RelationtxtFld?.text = applicant.relation
        salutationRelativetxtFld?.text = applicant.salutationForRelative
        relativeNametxtFld?.text = applicant.relativeName
        PANtxtFld?.text = applicant.panOfAuthorizedSignatory
        aadhartxtFld?.text = applicant.aadhaarOfAuthorizedSignatory

        if let panFile = applicant.authorizationPanUploadFileName,
           !panFile.isEmpty {
            PANUploadtxtFld?.text = "📄 \(panFile)"
        }

        if let aadhaarFile = applicant.authorizationAadhaarUploadFileName,
           !aadhaarFile.isEmpty {
            aadharUploadtxtFld?.text = "📄 \(aadhaarFile)"
        }
    }
    
    func autoPopulateData() {
        salurationSignatarytxtFld?.text = applicantDetailsModel.salutationForRelative
        RelationtxtFld?.text = applicantDetailsModel.relation
        NameAuthorizationtxtFld?.text = applicantDetailsModel.authorizedContactPerson
        salutationRelativetxtFld?.text = applicantDetailsModel.salutationForRelative
        relativeNametxtFld?.text = applicantDetailsModel.relation
        PANtxtFld?.text = applicantDetailsModel.panOfAuthorizedSignatory
        aadhartxtFld?.text = applicantDetailsModel.aadhaarOfAuthorizedSignatory

        if let pan = applicantDetailsModel.panOfAuthorizedSignatory,
           !pan.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            PANtxtFld?.isEnabled = false
        } else {
            PANtxtFld?.isEnabled = true
        }
        if let aadhaar = applicantDetailsModel.aadhaarOfAuthorizedSignatory,
           !aadhaar.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            aadhartxtFld?.isEnabled = false
        } else {
            
            aadhartxtFld?.isEnabled = true
        }
        PANUploadtxtFld?.isHidden = isForEditing
        aadharUploadtxtFld?.isHidden = isForEditing
        PANUploadImg?.isHidden = isForEditing
        aadharUploadImg?.isHidden = isForEditing
    }
    
    func fetchPicklistData() async {

        await FetchPicklistValue.shared.fetchPicklistValues(
            objectName: "Applicant_Details__c",
            fieldNames: [
                "Salutation_for_Authorised_Signatory__c",
                "Relation__c",
                "Salutation_for_Relative__c"
            ]
        )

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.salutationArr = FetchPicklistValue.shared
                .picklistOptionsDict["Salutation_for_Authorised_Signatory__c"]?
                .map { $0.label } ?? []

            self.relationArr = FetchPicklistValue.shared
                .picklistOptionsDict["Relation__c"]?
                .map { $0.label } ?? []
            
            self.salutationRelativeArr = FetchPicklistValue.shared
                .picklistOptionsDict["Salutation_for_Relative__c"]?
                .map { $0.label } ?? []

            print("Salutation Arr:", self.salutationArr)
            print("Relation Arr:", self.relationArr)
            print("Salutation for Relative Arr:", self.salutationRelativeArr)
        }
    }
    
    func setUpInitialUI() {
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        if Defaults.isPartnerShip ?? false {
            pageNumberLbl?.text = "2"
            OutOfPageNumber?.text = "8"
        } else {
            pageNumberLbl?.text = "2"
            OutOfPageNumber?.text = "7"
        }
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        resetBtn?.borderWidth = 1
        resetBtn?.borderColor = UIColor(hex: "DFE1E0")
        resetBtn?.layer.cornerRadius = 6
        nextBtn?.layer.cornerRadius = 6
        
        
        NameAuthorizationtxtFld?.label.text = "Name of the Authorized Signatory/Karta *"
        NameAuthorizationtxtFld?.setOutlineColor(.darkGray, for: .normal)
        NameAuthorizationtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        NameAuthorizationtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        relativeNametxtFld?.label.text = "Name of Relative *"
        relativeNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        relativeNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        relativeNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        PANtxtFld?.label.text = "PAN of Authorized Signatory *"
        PANtxtFld?.setOutlineColor(.darkGray, for: .normal)
        PANtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        PANtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        aadhartxtFld?.label.text = "Aadhaar of Authorized Signatory *"
        aadhartxtFld?.setOutlineColor(.darkGray, for: .normal)
        aadhartxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        aadhartxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        PANUploadtxtFld?.label.text = "Upload PAN of Authorized Signatory *"
        PANUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        PANUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        PANUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let panTap = UITapGestureRecognizer(target: self, action: #selector(panUploadOptions))
        PANUploadtxtFld?.addGestureRecognizer(panTap)
        PANUploadtxtFld?.isUserInteractionEnabled = true
        
        aadharUploadtxtFld?.label.text = "Upload Aadhaar of Authorized Signatory *"
        aadharUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        aadharUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        aadharUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let aadharUploadTap = UITapGestureRecognizer(target: self, action: #selector(addharUploadOptions))
        aadharUploadtxtFld?.addGestureRecognizer(aadharUploadTap)
        aadharUploadtxtFld?.isUserInteractionEnabled = true
                
        salurationSignatarytxtFld?.label.text = "Salutation for Authorised signatory *"
        salurationSignatarytxtFld?.setOutlineColor(.darkGray, for: .normal)
        salurationSignatarytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        salurationSignatarytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        salurationSignatarytxtFld?.delegate = self
        salurationSignatarytxtFld?.inputView = UIView()
        
        RelationtxtFld?.label.text = "Relation *"
        RelationtxtFld?.setOutlineColor(.darkGray, for: .normal)
        RelationtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        RelationtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        RelationtxtFld?.delegate = self
        RelationtxtFld?.inputView = UIView()
        
        salutationRelativetxtFld?.label.text = "Salutation for Relative *"
        salutationRelativetxtFld?.setOutlineColor(.darkGray, for: .normal)
        salutationRelativetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        salutationRelativetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        salutationRelativetxtFld?.delegate = self
        salutationRelativetxtFld?.inputView = UIView()
        
        
    }
    
    func clearAllFields() {
        salurationSignatarytxtFld?.text = ""
        RelationtxtFld?.text = ""
        NameAuthorizationtxtFld?.text = ""
        salutationRelativetxtFld?.text = ""
        relativeNametxtFld?.text = ""
        PANtxtFld?.text = ""
        PANUploadtxtFld?.text = ""
        aadhartxtFld?.text = ""
        aadharUploadtxtFld?.text = ""
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func resetAction() {
        clearAllFields()
    }
    
    func validateCompanyFields() -> Bool {
        let salutation = salurationSignatarytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let authName = NameAuthorizationtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let relation = RelationtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let relativeSalutation = salutationRelativetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let relativeName = relativeNametxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let pan = PANtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let panUpload = PANUploadtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let aadhaar = aadhartxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let aadhaarUpload = aadharUploadtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if salutation.isEmpty {
            showAlert(with: "Validation Error", message: "Please select Salutation.")
            return false
        }

        if authName.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Authorized Signatory Name.")
            return false
        }

        if relation.isEmpty {
            showAlert(with: "Validation Error", message: "Please select Relation.")
            return false
        }

        if relativeSalutation.isEmpty {
            showAlert(with: "Validation Error", message: "Please select Relative Salutation.")
            return false
        }

        if relativeName.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Relative Name.")
            return false
        }

        if pan.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter PAN.")
            return false
        } else if !validation.isValidPANNumber(pan) {
            showAlert(with: "Validation Error", message: "Please enter valid PAN.")
            return false
        }
        
        if !isForEditing {
            
            if panUpload.isEmpty {
                showAlert(with: "Validation Error", message: "Please upload PAN.")
                return false
            }
        }

        if aadhaar.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Aadhaar Number.")
            return false
        }
        
        if !isForEditing {
            
            if aadhaarUpload.isEmpty {
                showAlert(with: "Validation Error", message: "Please upload Aadhaar.")
                return false
            }
        }

        return true
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func nextBtnAction() {
        guard validateCompanyFields() else { return }

        guard let index = applicantIndex else {
            print("Applicant index missing")
            return
        }

        var applicant = OpportunityManager.shared.getApplicant(at: index) ?? SaveModel(dict: [:])

        applicant.salutationForAuthorisedSignatory = salurationSignatarytxtFld?.text
        applicant.nameOfAuthorizedContactPerson = NameAuthorizationtxtFld?.text
        applicant.relation = RelationtxtFld?.text
        applicant.salutationForRelative = salutationRelativetxtFld?.text
        applicant.relativeName = relativeNametxtFld?.text
        applicant.panOfAuthorizedSignatory = PANtxtFld?.text
        applicant.aadhaarOfAuthorizedSignatory = aadhartxtFld?.text

        OpportunityManager.shared.updateApplicant(at: index, with: applicant)

        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)

        let addressEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "AddressEOIScreenVC") as! AddressEOIScreenVC
        addressEOIScreenVC.applicantIndex = self.applicantIndex
        addressEOIScreenVC.isFromCustomers = isFromCustomers
        addressEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
        addressEOIScreenVC.isLocalEdit = isLocalEdit
        addressEOIScreenVC.applicantDetailsModel = applicantDetailsModel
        if isForEditing {
            addressEOIScreenVC.isForEditing = isForEditing
            addressEOIScreenVC.applicantDetailsModel = applicantDetailsModel
        }
        self.navigationController?.pushViewController(addressEOIScreenVC, animated: true)
    }
}

extension AuthorizationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    @objc func panUploadOptions() {
        if applicantIndex == nil {
            applicantIndex = 0
        }
        activeUploadField = "PAN"
        showUploadOptions(sourceField: "PAN")
    }
    
    @objc func addharUploadOptions() {
        if applicantIndex == nil {
            applicantIndex = 0
        }
        activeUploadField = "Aadhar"
        showUploadOptions(sourceField: "Aadhar")
    }
    
    func showUploadOptions(sourceField: String) {
        let actionSheet = UIAlertController(
            title: "Upload \(sourceField)",
            message: "Choose an option",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { _ in self.openCamera() })
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in self.openGallery() })
        actionSheet.addAction(UIAlertAction(title: "Files", style: .default) { _ in self.openDocumentPicker() })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }
        present(actionSheet, animated: true)
    }
    
    func saveUploadedFile(title: String, data: Data, fileExtension: String) {
        let mimeType = mimeTypeForExtension(fileExtension)
        
        let fileModel = FileUploadModel(
            title: title,
            pathOnClient: "\(title).\(fileExtension)",
            fileType: mimeType,
            networkId: nil,
            versionData: data
        )
        
        var applicant: SaveModel
        if let index = applicantIndex,
           let existingApplicant = OpportunityManager.shared.getApplicant(at: index) {
            applicant = existingApplicant
        } else {
            applicant = SaveModel(dict: [:])
            OpportunityManager.shared.addApplicant(applicant)
            applicantIndex = OpportunityManager.shared.applicants.count - 1
        }
        
        applicant.uploadedFiles.removeAll { $0.title == title }
        applicant.uploadedFiles.append(fileModel)
        
        if let index = applicantIndex {
            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
        }
        
        updateUI(for: title, path: fileModel.pathOnClient)
    }
    
    func updateUI(for title: String, path: String) {
        let fileName = (path as NSString).lastPathComponent
        
        guard let index = applicantIndex,
              var applicant = OpportunityManager.shared.getApplicant(at: index) else {
            return
        }
        
        switch title {
        case "PAN":
            PANUploadtxtFld?.text = "📄 \(fileName)"
            applicant.authorizationPanUploadFileName = fileName
            
        case "Aadhar":
            aadharUploadtxtFld?.text = "📄 \(fileName)"
            applicant.authorizationAadhaarUploadFileName = fileName
            
        default:
            break
        }
        
        OpportunityManager.shared.updateApplicant(at: index, with: applicant)
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage,
           let data = image.jpegData(compressionQuality: 0.8),
           let field = activeUploadField {
            saveUploadedFile(title: field, data: data, fileExtension: "jpg")
        }
        picker.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first,
              let field = activeUploadField else { return }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let fileExtension = fileURL.pathExtension
            saveUploadedFile(title: field, data: data, fileExtension: fileExtension)
        } catch {
            print("⚠️ Failed to read file: \(error.localizedDescription)")
        }
    }
    
    func mimeTypeForExtension(_ ext: String) -> String {
        let ext = ext.lowercased()
        switch ext {
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "heic": return "image/heic"
        case "pdf": return "application/pdf"
        case "doc": return "application/msword"
        case "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "xls": return "application/vnd.ms-excel"
        case "xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "txt": return "text/plain"
        case "zip": return "application/zip"
        default: return "application/octet-stream"
        }
    }
}

extension AuthorizationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == salurationSignatarytxtFld {
            showSalurationSignataryToDropdown()
            return false
        } else if textField == RelationtxtFld {
            showRelationToDropdown()
            return false
        } else if textField == salutationRelativetxtFld {
            showSalutationRelativeToDropdown()
            return false
        }
        return true
    }
    
    func showSalurationSignataryToDropdown() {

        salutationSignataryDropDown.anchorView = salurationSignatarytxtFld
        salutationSignataryDropDown.dataSource = salutationArr

        salutationSignataryDropDown.selectionAction = { [weak self] (index, item) in
            self?.salurationSignatarytxtFld?.text = item
        }

        salutationSignataryDropDown.show()
    }
    
    func showRelationToDropdown() {

        let dropdown = DropDown()

        dropdown.anchorView = RelationtxtFld
        dropdown.dataSource = relationArr

        dropdown.selectionAction = { [weak self] (index, item) in
            self?.RelationtxtFld?.text = item
        }

        dropdown.show()
    }
    
    func showSalutationRelativeToDropdown() {

        let dropdown = DropDown()

        dropdown.anchorView = salutationRelativetxtFld
        dropdown.dataSource = salutationRelativeArr

        dropdown.selectionAction = { [weak self] (index, item) in
            self?.salutationRelativetxtFld?.text = item
        }

        dropdown.show()
    }
}


//
//  BankDetailsEOISCreenVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 28/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class BankDetailsEOISCreenVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    @IBOutlet var bankNametxtFld: MDCOutlinedTextField?
    @IBOutlet var bankAccountNumbertxtFld: MDCOutlinedTextField?
    @IBOutlet var bankIFSCCodetxtFld: MDCOutlinedTextField?
    @IBOutlet var branchNametxtFld: MDCOutlinedTextField?
    @IBOutlet var branchCodetxtFld: MDCOutlinedTextField?
    @IBOutlet var UPIIdtxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadCancelledChecktxtFld: MDCOutlinedTextField?
    @IBOutlet var resetBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    var validation = Validation()
    var applicantIndex: Int?
    var activeUploadField: String?
    var isFromCustomers: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var isForEditing: Bool = false
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var isLocalEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(cuatomerDetailsDict)
//        bankNametxtFld?.text = "ecnd"
//        bankAccountNumbertxtFld?.text = "ecnd"
//        bankIFSCCodetxtFld?.text = "HDFC0123456"
//        branchNametxtFld?.text = "ecnd"
//        branchCodetxtFld?.text = "ecnd"
        setUpInitialUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
            statusBarView.backgroundColor = ColorConstant.screensBackgroundColor
            view.addSubview(statusBarView)
        }
    }
    
    func setUpInitialUI() {
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        if Defaults.isIndividualEnable ?? false {
            pageNumberLbl?.text = "4"
            OutOfPageNumber?.text = "7"
        } else if Defaults.isPartnerShip ?? false {
            pageNumberLbl?.text = "5"
            OutOfPageNumber?.text = "8"
        } else {
            pageNumberLbl?.text = "5"
            OutOfPageNumber?.text = "7"
        }
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        resetBtn?.borderWidth = 1
        resetBtn?.borderColor = UIColor(hex: "DFE1E0")
        resetBtn?.layer.cornerRadius = 6
        nextBtn?.layer.cornerRadius = 6
        
        bankNametxtFld?.label.text = "Bank Name *"
        bankNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        bankNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        bankNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        bankAccountNumbertxtFld?.label.text = "Bank Account Number *"
        bankAccountNumbertxtFld?.setOutlineColor(.darkGray, for: .normal)
        bankAccountNumbertxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        bankAccountNumbertxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        bankIFSCCodetxtFld?.label.text = "Bank IFSC Code *"
        bankIFSCCodetxtFld?.setOutlineColor(.darkGray, for: .normal)
        bankIFSCCodetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        bankIFSCCodetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        branchNametxtFld?.label.text = "Branch Name *"
        branchNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        branchNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        branchNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        branchCodetxtFld?.label.text = "Branch Code *"
        branchCodetxtFld?.setOutlineColor(.darkGray, for: .normal)
        branchCodetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        branchCodetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        UPIIdtxtFld?.label.text = "UPI ID"
        UPIIdtxtFld?.setOutlineColor(.darkGray, for: .normal)
        UPIIdtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        UPIIdtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        uploadCancelledChecktxtFld?.label.text = "Upload Cancelled Cheque *"
        uploadCancelledChecktxtFld?.setOutlineColor(.darkGray, for: .normal)
        uploadCancelledChecktxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        uploadCancelledChecktxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let adharTap = UITapGestureRecognizer(target: self, action: #selector(openUploadCancelledChequeOptions))
        uploadCancelledChecktxtFld?.addGestureRecognizer(adharTap)
        uploadCancelledChecktxtFld?.isUserInteractionEnabled = true
        if isForEditing {

            // SERVER EDIT
            DispatchQueue.main.async {
                self.bankNametxtFld?.text = self.applicantDetailsModel.bankName
                self.bankAccountNumbertxtFld?.text = self.applicantDetailsModel.bankAccountNumber
                self.bankIFSCCodetxtFld?.text = self.applicantDetailsModel.bankIfsc
                self.branchNametxtFld?.text = self.applicantDetailsModel.branchName
                self.branchCodetxtFld?.text = self.applicantDetailsModel.branchCode
                self.UPIIdtxtFld?.text = self.applicantDetailsModel.upiId
            }

        } else if isLocalEdit {

            // LOCAL EDIT
            DispatchQueue.main.async {
                if let index = self.applicantIndex {
                    
                    let applicant = OpportunityManager.shared.getApplicant(at: index)
                    
                    self.bankNametxtFld?.text = applicant?.bankName
                    self.bankAccountNumbertxtFld?.text = applicant?.bankAccount
                    self.bankIFSCCodetxtFld?.text = applicant?.bankIFSC
                    self.branchNametxtFld?.text = applicant?.branchName
                    self.branchCodetxtFld?.text = applicant?.branchCode
                    self.UPIIdtxtFld?.text = applicant?.upiId
                    self.uploadCancelledChecktxtFld?.text = applicant?.cancelledChequeFileName
                }
            }
        }
    }
    
    func validateBankDetails() -> Bool {
        var errorMessage = ""
        
        if bankNametxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errorMessage += "Please enter Bank Name.\n"
        }
        
        if bankAccountNumbertxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errorMessage += "Please enter Bank Account Number.\n"
        }
        
        if bankIFSCCodetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errorMessage += "Please enter Bank IFSC Code.\n"
        } else if let ifsc = bankIFSCCodetxtFld?.text, !validation.isValidIFSCCode(ifsc) {
            errorMessage += "Please enter a valid IFSC Code.\n"
        }
        
        if branchNametxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errorMessage += "Please enter Branch Name.\n"
        }
        
        if branchCodetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errorMessage += "Please enter Branch Code.\n"
        }
        
        var isCancelledChequeUploaded = false

        if let index = applicantIndex,
           let applicant = OpportunityManager.shared.getApplicant(at: index) {

            let chequeFileName = applicant.cancelledChequeFileName?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            isCancelledChequeUploaded =
                !chequeFileName.isEmpty &&
                !applicant.uploadedFiles.isEmpty
        }

        if !isCancelledChequeUploaded {
            
            errorMessage += "Please upload a Cancelled Cheque.\n"
            
        }
        
        if !errorMessage.isEmpty {
            Alert.showValidationAlert(message: errorMessage, on: self)
            return false
        }
        return true
    }
    
    func clearAllFields() {
        bankNametxtFld?.text = ""
        bankAccountNumbertxtFld?.text = ""
        bankIFSCCodetxtFld?.text = ""
        branchNametxtFld?.text = ""
        branchCodetxtFld?.text = ""
        UPIIdtxtFld?.text = ""
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
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

//    @IBAction func nextBtnAction() {
//        guard validateBankDetails() else { return }
//        var applicant: SaveModel
//
//        if let index = applicantIndex {
//            applicant = OpportunityManager.shared.getApplicant(at: index) ?? SaveModel(dict: [:])
//        } else {
//            applicant = SaveModel(dict: [:])
////            OpportunityManager.shared.addApplicant(applicant)
//            applicantIndex = OpportunityManager.shared.applicants.count - 1
//        }
//        
//        applicant.bankName = bankNametxtFld?.text
//        applicant.bankAccount = bankAccountNumbertxtFld?.text
//        applicant.bankIFSC = bankIFSCCodetxtFld?.text
//        applicant.branchName = branchNametxtFld?.text
//        applicant.branchCode = branchCodetxtFld?.text
//        applicant.upiId = UPIIdtxtFld?.text
//
//        if let index = applicantIndex {
//            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
//        }
//
//        let storyboardBundle = Bundle.main
//        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
//        let notesVC = storyboard.instantiateViewController(withIdentifier: "NotesEOIScreenVC") as! NotesEOIScreenVC
//        notesVC.applicantIndex = applicantIndex
//        notesVC.isFromCustomers = isFromCustomers
//        notesVC.cuatomerDetailsDict = cuatomerDetailsDict
//        notesVC.isForEditing = isForEditing
//        notesVC.applicantDetailsModel = applicantDetailsModel
//        self.navigationController?.pushViewController(notesVC, animated: true)
//    }
    
    @IBAction func nextBtnAction() {

//        guard validateBankDetails() else { return }

        var applicant: SaveModel

        if let index = applicantIndex {

            applicant = OpportunityManager.shared.getApplicant(at: index) ?? SaveModel(dict: [:])

        } else {

            let newApplicant = SaveModel(dict: [:])

            OpportunityManager.shared.applicants.append(newApplicant)

            applicantIndex = OpportunityManager.shared.applicants.count - 1

            applicant = newApplicant
        }

        applicant.bankName = bankNametxtFld?.text
        applicant.bankAccount = bankAccountNumbertxtFld?.text
        applicant.bankIFSC = bankIFSCCodetxtFld?.text
        applicant.branchName = branchNametxtFld?.text
        applicant.branchCode = branchCodetxtFld?.text
        applicant.upiId = UPIIdtxtFld?.text

        if let index = applicantIndex {
            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
        }

        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)

        let notesVC = storyboard.instantiateViewController(
            withIdentifier: "NotesEOIScreenVC"
        ) as! NotesEOIScreenVC

        notesVC.applicantIndex = applicantIndex
        notesVC.isFromCustomers = isFromCustomers
        notesVC.cuatomerDetailsDict = cuatomerDetailsDict

        // SERVER EDIT
        notesVC.isForEditing = isForEditing

        // LOCAL EDIT
        notesVC.isLocalEdit = isLocalEdit

        notesVC.applicantDetailsModel = applicantDetailsModel

        self.navigationController?.pushViewController(notesVC, animated: true)
    }
}

extension BankDetailsEOISCreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    @objc func openUploadCancelledChequeOptions() {
        activeUploadField = "Cancelled Cheque"
        showUploadOptions(sourceField: "Cancelled Cheque")
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
    
    // MARK: - Save Uploaded File
    func saveUploadedFile(title: String, data: Data, fileExtension: String = "png") {
        let fileModel = FileUploadModel(
            title: title,
            pathOnClient: "\(title).\(fileExtension)",
            fileType: fileExtension,
            networkId: nil,
            versionData: data
        )
        let fileName = "\(title).\(fileExtension)"
        
        // ✅ Get existing applicant or create if not available
        var applicant: SaveModel
        if let index = applicantIndex, let existingApplicant = OpportunityManager.shared.getApplicant(at: index) {
            applicant = existingApplicant
        } else {
            applicant = SaveModel(dict: [:])
            OpportunityManager.shared.addApplicant(applicant)
            applicantIndex = OpportunityManager.shared.applicants.count - 1
        }
        
        // ✅ Add the new file
        applicant.uploadedFiles.append(fileModel)
        applicant.cancelledChequeFileName = fileName
        
        // ✅ Update the manager
        if let index = applicantIndex {
            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
        }
        
        // ✅ Update the field UI
        uploadCancelledChecktxtFld?.text = "File Uploaded"
    }
    
    // MARK: - Open Camera
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Open Photo Library
    func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Open Document Picker
    func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
            .image, .pdf, .plainText, .jpeg, .png, .spreadsheet, .rtf, .text, .content, .data
        ], asCopy: true)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage,
           let imageData = selectedImage.pngData() {
            saveUploadedFile(title: activeUploadField ?? "Cancelled Cheque", data: imageData, fileExtension: "png")
        }
        uploadCancelledChecktxtFld?.text = "File Uploaded"
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Document Picker Delegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }
        let fileExtension = fileURL.pathExtension
        if let data = try? Data(contentsOf: fileURL) {
            saveUploadedFile(title: activeUploadField ?? "Cancelled Cheque", data: data, fileExtension: fileExtension)
        }
        uploadCancelledChecktxtFld?.text = fileURL.lastPathComponent
    }
}

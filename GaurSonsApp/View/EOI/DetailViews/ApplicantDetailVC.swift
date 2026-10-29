//
//  ApplicantDetailVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 03/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import QuickLook
import SalesforceSDKCore

class ApplicantDetailVC: UIViewController {
    @IBOutlet var mainVw: UIView?
    @IBOutlet var tableViewsHeaderView: UIView?
    @IBOutlet var topOppNameLbl: UILabel?
    @IBOutlet var applicantScrollView: UIScrollView?
    @IBOutlet var personalDetailHeadinView: UIView?
    @IBOutlet var personalDetailVw: UIView?
    @IBOutlet var companyDetailVw: UIView?
    @IBOutlet var addressDetailHeadinView: UIView?
    @IBOutlet var addressDetailVw: UIView?
    @IBOutlet var employmentDetailHeadinView: UIView?
    @IBOutlet var employmentDetailVw: UIView?
    @IBOutlet var bankDetailHeadinView: UIView?
    @IBOutlet var bankDetailVw: UIView?
    @IBOutlet var detailHeadingLbl: UILabel?
    @IBOutlet var firsAddresstHeadingLbl: UILabel?
    @IBOutlet var secondAddressHeadingLbl: UILabel?
    @IBOutlet var thirdViewTopToFirstView: NSLayoutConstraint?
    @IBOutlet var thirdViewTopToSecondView: NSLayoutConstraint?
    
    //personal details
    @IBOutlet var applicantTypeLbl: UILabel?
    @IBOutlet var primaryLbl: UILabel?
    @IBOutlet var isEOILbl: UILabel?
    @IBOutlet var isActiveLbl: UILabel?
    @IBOutlet var applicantNameLbl: UILabel?
    @IBOutlet var residentTypeLbl: UILabel?
    @IBOutlet var PANNumberLbl: UILabel?
    @IBOutlet var aadharNumberLbl: UILabel?
    @IBOutlet var SODOWOLbl: UILabel?
    @IBOutlet var DOBLbl: UILabel?
    @IBOutlet var maritalStatusLbl: UILabel?
    @IBOutlet var genderLbl: UILabel?
    @IBOutlet var nationalityLbl: UILabel?
    @IBOutlet var occupationLbl: UILabel?
    @IBOutlet var phoneNumberHomeLbl: UILabel?
    @IBOutlet var phoneNumberWorkLbl: UILabel?
    @IBOutlet var applicantMobileNumberLbl: UILabel?
    @IBOutlet var phoneNumberAnyOtherLbl: UILabel?
    @IBOutlet var emailIdLbl: UILabel?
    @IBOutlet var priorInvestmentInGaursGroupProjectLbl: UILabel?
    
    //company details
    @IBOutlet var applicantTypeCompanyLbl: UILabel?
    @IBOutlet var isEOICompanyLbl: UILabel?
    @IBOutlet var isActiveCompanyLbl: UILabel?
    @IBOutlet var nameOfCompanyLbl: UILabel?
    @IBOutlet var dateOfCorporationLbl: UILabel?
    @IBOutlet var authorisedContactPersonLbl: UILabel?
    @IBOutlet var phoneNumberWorkCompanyLbl: UILabel?
    @IBOutlet var mobileNumberLbl: UILabel?
    @IBOutlet var emailIdCompanyLbl: UILabel?
    @IBOutlet var panNumberLbl: UILabel?
    @IBOutlet var cinLbl: UILabel?
    @IBOutlet var dinLbl: UILabel?
    @IBOutlet var priorInvestmentLbl: UILabel?
    
    // Address Details
    @IBOutlet var typeLbl: UILabel?
    @IBOutlet var addressLbl: UILabel?
    @IBOutlet var countryLbl: UILabel?
    @IBOutlet var stateLbl: UILabel?
    @IBOutlet var cityeLbl: UILabel?
    @IBOutlet var postalcodeLbl: UILabel?
    // crosspondance Details
    @IBOutlet var crosspondanceTypeLbl: UILabel?
    @IBOutlet var crosspondanceAddressLbl: UILabel?
    @IBOutlet var crosspondanceCountryLbl: UILabel?
    @IBOutlet var crosspondanceStateLbl: UILabel?
    @IBOutlet var crosspondanceCityeLbl: UILabel?
    @IBOutlet var crosspondancePostalcodeLbl: UILabel?
    
    //Employment details
    @IBOutlet var employmentTypeLbl: UILabel?
    @IBOutlet var employmentJobTitleLbl: UILabel?
    @IBOutlet var companyNameAndAddressLbl: UILabel?
    
    //Bank Details
    @IBOutlet var bankNameLbl: UILabel?
    @IBOutlet var bankAccountNumberLbl: UILabel?
    @IBOutlet var bankIFSCCodeLbl: UILabel?
    @IBOutlet var branchCodeLbl: UILabel?
    @IBOutlet var branchNameLbl: UILabel?
    @IBOutlet var UPICodeLbl: UILabel?
    
    @IBOutlet var bankDetailEditBtn: UIButton?
    @IBOutlet var personalDetailEditBtn: UIButton?
    @IBOutlet var addressDetailEditBtn: UIButton?
    @IBOutlet var employmentDetailEditBtn: UIButton?
    
    @IBOutlet var detailBtn: UIButton?
    @IBOutlet var detailBtnLbl: UILabel?
    @IBOutlet var fileBtn: UIButton?
    @IBOutlet var fileBtnLbl: UILabel?
    
    @IBOutlet var fileHeaderView: UIView?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var tableViewsHeader: UIView?
    @IBOutlet var uploadFilesBtn: UIButton?
    @IBOutlet var fileCountLbl: UILabel?
    @IBOutlet var noDataFoundVw: UIView?
    
    //Masked Data
    @IBOutlet var maskedDataView: UIView?
    @IBOutlet var maskedDataInternalView: UIView?
    @IBOutlet var maskedMobileLbl: UILabel?
    @IBOutlet var maskedEmailLbl: UILabel?
    @IBOutlet var cross: UIButton?
    
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var applicantId = EMPTY
    var previewItemURL: URL?
    var fileArray: [FileModel] = []
    var isDetailEnable: Bool = true
    var loaderView: UIActivityIndicatorView?
    var selectedAttachment: Attachment?
    var applicantDetailsModelcuatomerDetailsDict: CustomerModel?
    var applicantEmailId: String = EMPTY
    var applicantPhoneNumber: String = EMPTY
    private var fileRequestID = UUID()
    private var isFileRequestActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Utility.getAllApplicantDetails(applicantId: applicantId) { success in
            self.applicantDetailsModel = GlobalData.allApplicantDetailsModel
            if success {
                self.setupInitialUI(applicantDetails: self.applicantDetailsModel)
            }
        }
        loaderView = UIActivityIndicatorView(style: .large)
        loaderView?.color = .gray
        loaderView?.center = view.center
        loaderView?.hidesWhenStopped = true
        if let loader = loaderView {
            view.addSubview(loader)
        }
    }
    
    func updateThirdViewPosition(applicantType : String) {
        if applicantType == "Individual" {
            thirdViewTopToFirstView?.isActive = true
            thirdViewTopToSecondView?.isActive = false
        } else {
            thirdViewTopToFirstView?.isActive = false
            thirdViewTopToSecondView?.isActive = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
        
    func fetchAllFiles() {

        let requestID = UUID()
        fileRequestID = requestID
        isFileRequestActive = true

        GlobalData.allContentDocModel.removeAll()
        fileArray.removeAll()

        DispatchQueue.main.async {
            self.loaderView?.startAnimating()
            self.tableView?.isHidden = true
            self.noDataFoundVw?.isHidden = true
            self.tableViewsHeader?.isHidden = true
        }

        Utility.getAllContentDoc(oppId: applicantId) { [weak self] success in

            guard let self = self else { return }

            guard self.fileRequestID == requestID,
                  self.isFileRequestActive else {
                return
            }

            guard success else {
                DispatchQueue.main.async {
                    guard self.fileRequestID == requestID,
                          self.isFileRequestActive else { return }

                    self.loaderView?.stopAnimating()
                    self.noDataFoundVw?.isHidden = false
                    self.tableView?.isHidden = true
                    self.tableViewsHeader?.isHidden = true
                }
                return
            }

            let contentDocs = GlobalData.allContentDocModel

            guard !contentDocs.isEmpty else {
                DispatchQueue.main.async {
                    guard self.fileRequestID == requestID,
                          self.isFileRequestActive else { return }

                    self.loaderView?.stopAnimating()
                    self.noDataFoundVw?.isHidden = false
                    self.tableView?.isHidden = true
                    self.tableViewsHeader?.isHidden = true
                }
                return
            }

            var tempFileArray: [FileModel] = []
            let dispatchGroup = DispatchGroup()

            for content in contentDocs {

                guard self.fileRequestID == requestID,
                      self.isFileRequestActive else {
                    break
                }

                dispatchGroup.enter()

                Utility.getVersionData(
                    contentDocId: content.contentDocumentId ?? EMPTY
                ) { versionSuccess in

                    guard self.fileRequestID == requestID,
                          self.isFileRequestActive else {
                        dispatchGroup.leave()
                        return
                    }

                    guard versionSuccess,
                          let versionId = GlobalData.allVersionDataModel.Id else {
                        dispatchGroup.leave()
                        return
                    }

                    Utility.getFileData(contentVersionId: versionId) { fileData in

                        defer {
                            dispatchGroup.leave()
                        }

                        guard self.fileRequestID == requestID,
                              self.isFileRequestActive else {
                            return
                        }

                        if let data = fileData {

                            let fileName = "\(versionId).pdf"

                            let fileModel = FileModel(
                                fileName: fileName,
                                fileData: data
                            )

                            tempFileArray.append(fileModel)
                        }
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {

                guard self.fileRequestID == requestID,
                      self.isFileRequestActive else {
                    return
                }

                self.loaderView?.stopAnimating()

                self.fileArray = tempFileArray

                self.fileHeaderView?.isHidden = false

                if self.fileArray.isEmpty {

                    self.noDataFoundVw?.isHidden = false
                    self.tableView?.isHidden = true
                    self.tableViewsHeader?.isHidden = true

                } else {

                    self.noDataFoundVw?.isHidden = true
                    self.tableView?.isHidden = false
                    self.tableViewsHeader?.isHidden = false
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    func setupInitialUI(applicantDetails: ApplicantDetailsModel) {
        print(applicantDetails)
        topOppNameLbl?.text = applicantDetails.opportunityName
        if applicantDetails.applicantType == "Individual" {
            companyDetailVw?.isHidden = true
            personalDetailVw?.isHidden = false
            detailHeadingLbl?.text = "Personal Detail"
            firsAddresstHeadingLbl?.text = "Permanent Address"
            secondAddressHeadingLbl?.text = "Correspondence Address"
            applicantTypeLbl?.text = applicantDetails.applicantType
            if let primary = applicantDetails.primary {
                primaryLbl?.text = primary ? "Yes" : "No"
            } else {
                primaryLbl?.text = "-"
            }
            
            if let isEOIData = applicantDetails.isEOI {
                isEOILbl?.text = isEOIData ? "Yes" : "No"
            } else {
                isEOILbl?.text = "-"
            }
            
            if let isActiveData = applicantDetails.isActive {
                isActiveLbl?.text = isActiveData ? "Yes" : "No"
            } else {
                isActiveLbl?.text = "-"
            }
            
            applicantNameLbl?.text = displayValue(applicantDetails.name)
            residentTypeLbl?.text = displayValue(applicantDetails.residentType)
            PANNumberLbl?.text = displayValue(applicantDetails.panNumber)
            aadharNumberLbl?.text = displayValue(applicantDetails.aadhaarNumber)
            SODOWOLbl?.text = displayValue(applicantDetails.relation)
            DOBLbl?.text = displayValue(applicantDetails.dob)
            maritalStatusLbl?.text = displayValue(applicantDetails.maritalStatus)
            genderLbl?.text = displayValue(applicantDetails.gender)
            nationalityLbl?.text = displayValue(applicantDetails.nationality)
            occupationLbl?.text = displayValue(applicantDetails.occupation)
            phoneNumberHomeLbl?.text = displayValue(applicantDetails.phoneHome)
            phoneNumberWorkLbl?.text = displayValue(applicantDetails.phoneWork)
            applicantMobileNumberLbl?.text = displayValue(applicantDetails.mobileNumber)
            phoneNumberAnyOtherLbl?.text = displayValue(applicantDetails.phoneOther)
            emailIdLbl?.text = displayValue(applicantDetails.email)
            
            //permanant Details
            //            typeLbl?.text = applicantDetails.permanentSelfOwned
            addressLbl?.text = displayValue(applicantDetails.permanentAddress)

            countryLbl?.text = displayValue(applicantDetails.permanentCountry)

            stateLbl?.text = displayValue(applicantDetails.permanentState)

            cityeLbl?.text = displayValue(applicantDetails.permanentCity)

            postalcodeLbl?.text = displayValue(applicantDetails.permanentPincode)

            crosspondanceAddressLbl?.text = displayValue(applicantDetails.correspondenceAddress)

            crosspondanceCountryLbl?.text = displayValue(applicantDetails.correspondenceCountry)

            crosspondanceStateLbl?.text = displayValue(applicantDetails.correspondenceState)

            crosspondanceCityeLbl?.text = displayValue(applicantDetails.correspondenceCity)

            crosspondancePostalcodeLbl?.text = displayValue(applicantDetails.correspondencePincode)
        } else {
            detailHeadingLbl?.text = "Company Detail"
            companyDetailVw?.isHidden = false
            personalDetailVw?.isHidden = true
            firsAddresstHeadingLbl?.text = "Correspondence Address"
            secondAddressHeadingLbl?.text = "Registered Address"
            if let isEOIData = applicantDetails.isEOI {
                isEOICompanyLbl?.text = isEOIData ? "Yes" : "No"
            } else {
                isEOICompanyLbl?.text = "-"
            }
            
            if let isActiveData = applicantDetails.isActive {
                isActiveCompanyLbl?.text = isActiveData ? "Yes" : "No"
            } else {
                isActiveCompanyLbl?.text = "-"
            }
            applicantTypeCompanyLbl?.text = displayValue(applicantDetails.applicantType)
            nameOfCompanyLbl?.text = displayValue(applicantDetails.nameOfCompanyFirm)
            dateOfCorporationLbl?.text = displayValue(applicantDetails.dateOfIncorporation)
            authorisedContactPersonLbl?.text = displayValue(applicantDetails.authorizedContactPerson)
            phoneNumberWorkCompanyLbl?.text = displayValue(applicantDetails.phoneWork)
            mobileNumberLbl?.text = displayValue(applicantDetails.mobileNumber)
            emailIdCompanyLbl?.text = displayValue(applicantDetails.email)
            panNumberLbl?.text = displayValue(applicantDetails.companyFirmLLPPan)
            cinLbl?.text = displayValue(applicantDetails.companyIdentificationNumber)
            dinLbl?.text = displayValue(applicantDetails.directorIdNumber)
            if let priorInvestment = applicantDetails.priorInvestmentInGaurs {
                priorInvestmentLbl?.text = priorInvestment ? "Yes" : "No"
            } else {
                priorInvestmentLbl?.text = "-"
            }
            
            addressLbl?.text = displayValue(applicantDetails.correspondenceAddress)
            countryLbl?.text = displayValue(applicantDetails.correspondenceCountry)
            stateLbl?.text = displayValue(applicantDetails.correspondenceState)
            cityeLbl?.text = displayValue(applicantDetails.correspondenceCity)
            postalcodeLbl?.text = displayValue(applicantDetails.correspondencePincode)

            crosspondanceAddressLbl?.text = displayValue(applicantDetails.registeredAddress)
            crosspondanceCountryLbl?.text = displayValue(applicantDetails.registeredCountry)
            crosspondanceStateLbl?.text = displayValue(applicantDetails.registeredState)
            crosspondanceCityeLbl?.text = displayValue(applicantDetails.registeredCity)
            crosspondancePostalcodeLbl?.text = displayValue(applicantDetails.registeredPincode)
            
        }
        maskedMobileLbl?.text = displayValue(
            DecryptDataFile.decryptValue(applicantDetailsModel.maskedData?.mobile?.defaultValue)
        )

        maskedEmailLbl?.text = displayValue(
            DecryptDataFile.decryptValue(applicantDetailsModel.maskedData?.email?.defaultValue)
        )
        
        //Employment Details
        employmentTypeLbl?.text = displayValue(applicantDetails.employmentType)
        employmentJobTitleLbl?.text = displayValue(applicantDetails.professionTitle)
        companyNameAndAddressLbl?.text = displayValue(applicantDetails.companyName)
        
        //Bank details
        bankNameLbl?.text = displayValue(applicantDetails.bankName)
        bankAccountNumberLbl?.text = displayValue(applicantDetails.bankAccountNumber)
        bankIFSCCodeLbl?.text = displayValue(applicantDetails.bankIfsc)
        branchCodeLbl?.text = displayValue(applicantDetails.branchCode)
        branchNameLbl?.text = displayValue(applicantDetails.branchName)
        UPICodeLbl?.text = displayValue(applicantDetails.upiId)
        DispatchQueue.main.async {
            self.updateThirdViewPosition(applicantType: applicantDetails.applicantType ?? EMPTY)
        }
    }
    
    func displayValue(_ value: String?) -> String {

        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines)

        return (trimmed?.isEmpty == false) ? trimmed! : "-"

    }
    
    func setupUI() {
        fileBtnLbl?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        if !isDetailEnable {
            self.noDataFoundVw?.isHidden = false
            self.tableView?.isHidden = true
        }
        applicantScrollView?.showsVerticalScrollIndicator = false
        applicantScrollView?.showsHorizontalScrollIndicator = false
        fileHeaderView?.isHidden = true
        tableView?.isHidden = true
        tableViewsHeader?.isHidden = true
        tableViewsHeader?.layer.cornerRadius = 8
        personalDetailVw?.borderWidth = 1
        personalDetailVw?.layer.cornerRadius = 8
        personalDetailVw?.borderColor = ColorConstant.buttonBorderLightColor
        companyDetailVw?.borderWidth = 1
        companyDetailVw?.layer.cornerRadius = 8
        companyDetailVw?.borderColor = ColorConstant.buttonBorderLightColor
        addressDetailVw?.borderWidth = 1
        addressDetailVw?.layer.cornerRadius = 8
        addressDetailVw?.borderColor = ColorConstant.buttonBorderLightColor
        employmentDetailVw?.borderWidth = 1
        employmentDetailVw?.layer.cornerRadius = 8
        employmentDetailVw?.borderColor = ColorConstant.buttonBorderLightColor
        bankDetailVw?.borderWidth = 1
        bankDetailVw?.layer.cornerRadius = 8
        bankDetailVw?.borderColor = ColorConstant.buttonBorderLightColor
        
        uploadFilesBtn?.layer.cornerRadius = 8
        bankDetailEditBtn?.layer.cornerRadius = 8
        personalDetailEditBtn?.layer.cornerRadius = 8
        addressDetailEditBtn?.layer.cornerRadius = 8
        employmentDetailEditBtn?.layer.cornerRadius = 8
        
    }
    
    @IBAction func showContact(_ sender: UIButton) {
        showMaskedDataView()
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        dismissMaskedDataView()
    }

    @IBAction func uiBtnsAction(_ sender: UIButton) {

        if sender.tag == 11 {
            isFileRequestActive = false
            fileRequestID = UUID()

            loaderView?.stopAnimating()

            fileArray.removeAll()

            fileHeaderView?.isHidden = true
            tableView?.isHidden = true
            tableViewsHeader?.isHidden = true
            noDataFoundVw?.isHidden = true

            applicantScrollView?.isHidden = false
            isDetailEnable = true

            detailBtnLbl?.backgroundColor = ColorConstant.primary
            detailBtn?.backgroundColor = .clear

            fileBtnLbl?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
            fileBtn?.backgroundColor = .clear

            return
        }



        if sender.tag == 12 {

            isFileRequestActive = true

            applicantScrollView?.isHidden = true

            fileHeaderView?.isHidden = false
            tableViewsHeader?.isHidden = true
            tableView?.isHidden = true
            noDataFoundVw?.isHidden = true

            isDetailEnable = false

            detailBtnLbl?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
            detailBtn?.backgroundColor = .clear

            fileBtnLbl?.backgroundColor = ColorConstant.primary
            fileBtn?.backgroundColor = .clear

            fetchAllFiles()

            return
        }
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func previewFile(at index: Int) {
        let file = fileArray[index]
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(file.fileName)
        
        do {
            try file.fileData.write(to: tempURL)
            self.previewItemURL = tempURL
            
            let previewController = QLPreviewController()
            previewController.dataSource = self
            present(previewController, animated: true)
            
        } catch {
            print("Error writing file to temp directory:", error)
        }
    }
    
    @IBAction func uploadFileAction() {
        showUploadOptions(sourceField: "File")
    }
    
    func showMaskedDataView() {

        guard let maskedDataView = maskedDataView else { return }
        guard let window = UIApplication.shared.keyWindow else { return }

        maskedDataView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        maskedDataView.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(maskedDataView)

        NSLayoutConstraint.activate([
            maskedDataView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            maskedDataView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            maskedDataView.topAnchor.constraint(equalTo: window.topAnchor),
            maskedDataView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])

        maskedDataView.alpha = 0
        maskedDataInternalView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.3) {

            maskedDataView.alpha = 1
            self.maskedDataInternalView?.transform = .identity
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMaskedDataView))
        maskedDataView.addGestureRecognizer(tapGesture)
    }

    @objc func dismissMaskedDataView() {

        UIView.animate(withDuration: 0.3, animations: {

            self.maskedDataInternalView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.maskedDataView?.alpha = 0

        }) { _ in

            self.maskedDataView?.removeFromSuperview()
            self.maskedDataInternalView?.transform = .identity
        }
    }
}

extension ApplicantDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
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
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true)
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
        picker.dismiss(animated: true)
        
        if let imageURL = info[.imageURL] as? URL {
            selectedAttachment = Attachment(fileName: imageURL.lastPathComponent, fileURL: imageURL, fileType: imageURL.pathExtension)
        } else if let image = info[.originalImage] as? UIImage {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("EOI.jpg")
            try? image.jpegData(compressionQuality: 0.8)?.write(to: tempURL)
            selectedAttachment = Attachment(fileName: "EOI.jpg", fileURL: tempURL, fileType: "jpg")
        }
        
        uploadSelectedFile()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        selectedAttachment = Attachment(fileName: url.lastPathComponent, fileURL: url, fileType: url.pathExtension)
        
        uploadSelectedFile()
    }
    
    func uploadSelectedFile() {
        guard selectedAttachment != nil else { return }
        
        Task {
            await uploadAttachment(linkedEntityId: applicantId)
            
            DispatchQueue.main.async {
                self.fetchAllFiles()
            }
        }
    }
    
    func uploadAttachment(linkedEntityId: String) async {
        guard let attachment = selectedAttachment else {
            print("⚠️ No attachment selected.")
            return
        }
        
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
                return
            }
            print("✅ ContentDocumentId fetched: \(contentDocumentId)")
            let contentDocumentLinkBody: [String: Any] = [
                "ContentDocumentId": contentDocumentId,
                "LinkedEntityId": linkedEntityId,
                "ShareType": "V"
            ]
            
            let _ = try await CreateRequestWebService.shared.createRecordForFile(ofType: "ContentDocumentLink", withFields: contentDocumentLinkBody)
            
        } catch {
            print("❌ Upload failed: \(error.localizedDescription)")
            SceneDelegate.getSceneDelegate().window?.rootViewController?.view.makeToast(error.localizedDescription)
        }
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
}
   
extension ApplicantDetailVC: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItemURL == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItemURL! as QLPreviewItem
    }
}

extension ApplicantDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileCountLbl?.text = "Files(\(fileArray.count))"
        return fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ApplicantDetailCell = tableView.dequeueReusableCell(withIdentifier: "ApplicantDetailCell", for: indexPath) as! ApplicantDetailCell
        let fileDict = self.fileArray[indexPath.row]
        cell.fileNameLbl?.text = "Attachment \(indexPath.row + 1)"
        cell.sizeLbl?.text = fileDict.fileSize
        cell.onPreviewTapped = {
            self.previewFile(at: indexPath.row)
        }
        cell.onDeleteTapped = {
            print("Delete button tapped at row \(indexPath.row)")
        }
        return cell
    }
}

class ApplicantDetailCell: UITableViewCell {
    @IBOutlet var sizeLbl: UILabel?
    @IBOutlet var fileNameLbl: UILabel?
    @IBOutlet var deleteBtn: UIButton?
    @IBOutlet var previewBtn: UIButton?
    @IBOutlet var vw: UIView?
    
    var onPreviewTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
        previewBtn?.layer.cornerRadius = 8
        deleteBtn?.layer.cornerRadius = 8

        previewBtn?.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        deleteBtn?.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func previewButtonTapped() {
        onPreviewTapped?()
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteTapped?()
    }
}


//
//  ProfileVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 13/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UIDocumentInteractionControllerDelegate {
    @IBOutlet var mainVw: UIView?
    @IBOutlet var userNameLbl: UILabel?
    @IBOutlet var subHeadingLbl: UILabel?
    @IBOutlet var topView: UIView?
    @IBOutlet var menuBtn: UIButton?
    @IBOutlet var BottomVw: UIView?
    @IBOutlet var notificationBtn: UIButton?
    @IBOutlet var profileIconBtn: UIButton?
    @IBOutlet var basicInfoBtn: UIButton?
    @IBOutlet var basicInfoBtnLbl: UILabel?
    @IBOutlet var statutoryInfoBtn: UIButton?
    @IBOutlet var statutoryInfoBtnLbl: UILabel?
    @IBOutlet var basicInfoView: UIView?
    @IBOutlet var statutoryInfoView: UIView?
    @IBOutlet var companyInfoView: UIView?
    @IBOutlet var ownerDetailView: UIView?
    @IBOutlet var boardView: UIView?
    @IBOutlet var companyView: UIView?
    @IBOutlet var bankView: UIView?
    @IBOutlet var legalDocumentView: UIView?
    @IBOutlet var MSMIView: UIView?
    @IBOutlet var GSTINView: UIView?
    @IBOutlet var RERAView: UIView?
    @IBOutlet var otherView: UIView?
    
    //basic Info Labels
    @IBOutlet var companyNameLbl: UILabel?
    @IBOutlet var companyTypeLbl: UILabel?
    @IBOutlet var companyPhoneLbl: UILabel?
    @IBOutlet var companyEmailIdLbl: UILabel?
    @IBOutlet var ownerNameLbl: UILabel?
    @IBOutlet var ownerPhoneNumberLbl: UILabel?
    @IBOutlet var ownerEmailLbl: UILabel?
    @IBOutlet var mobileWhatsappNumberLbl: UILabel?
    @IBOutlet var BRPersonNameLbl: UILabel?
    @IBOutlet var BRPersonPhoneNumberLbl: UILabel?
    @IBOutlet var BRPersonEmailLbl: UILabel?
    @IBOutlet var uploadedBRLbl: UILabel?
    @IBOutlet var companyAddressLbl: UILabel?
    @IBOutlet var companyCountryLbl: UILabel?
    @IBOutlet var companyStateLbl: UILabel?
    @IBOutlet var companyCityLbl: UILabel?
    @IBOutlet var companyPostalCodeLbl: UILabel?
    @IBOutlet var bankNameLbl: UILabel?
    @IBOutlet var bankAccountNumberLbl: UILabel?
    @IBOutlet var bankIFSCCodeLbl: UILabel?
    @IBOutlet var bankBranchCodeLbl: UILabel?
    @IBOutlet var bankBranchLbl: UILabel?
    @IBOutlet var bankUPIIDLbl: UILabel?
    @IBOutlet var cancelledChequeBtn: UIButton?
    
    //Statutory Info Labels
    @IBOutlet var panNameLbl: UILabel?
    @IBOutlet var uploadedPanBtn: UIButton?
    @IBOutlet var adharNumberLbl: UILabel?
    @IBOutlet var uploadedAdharBtn: UIButton?
    @IBOutlet var MSMILbl: UILabel?
    @IBOutlet var MSMINumberLbl: UILabel?
    @IBOutlet var uploadedMSMIBtn: UIButton?
    @IBOutlet var GSTApplicableLbl: UILabel?
    @IBOutlet var GSTNumberLbl: UILabel?
    @IBOutlet var uploadedGSTBtn: UIButton?
    @IBOutlet var RERANumberLbl: UILabel?
    @IBOutlet var RERADateLbl: UILabel?
    @IBOutlet var RERAValidUptoLbl: UILabel?
    @IBOutlet var RERARegistrationCertificateBtn: UIButton?
    @IBOutlet var logoUploadBtn: UIButton?
    @IBOutlet var profilePhotoUploadBtn: UIButton?
    
    var loaderView: UIActivityIndicatorView?
    var selectedAttachment: Attachment?
    var accountDetailModel = AccountDetailModel(dict: [:])
    var previewItemURL: URL?
    var fileArray: [FileModel] = []
    var profileFiles: [ProfileFileModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        Utility.getAllAccountDetails { success in
            if success {
                self.accountDetailModel = GlobalData.allAccountDetailModel
                DispatchQueue.main.async {
                    self.initialUI()
                }
            }
        }
        loaderView = UIActivityIndicatorView(style: .large)
        loaderView?.color = .gray
        loaderView?.center = view.center
        loaderView?.hidesWhenStopped = true
        if let loader = loaderView {
            view.addSubview(loader)
        }
//        fetchAllFiles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
            statusBarView.backgroundColor = ColorConstant.screensBackgroundColor
            view.addSubview(statusBarView)
        }
    }
    
//    func fetchAllFiles() {
//        GlobalData.allContentDocModel.removeAll()
//        DispatchQueue.main.async {
//            self.loaderView?.startAnimating()
//        }
//        
//        Utility.getAllContentDoc(oppId: accountDetailModel.id ?? EMPTY) { success in
//            if success {
//                let contentDocs = GlobalData.allContentDocModel
//                guard contentDocs.count > 0 else {
//                    DispatchQueue.main.async {
//                        self.loaderView?.stopAnimating()
//                    }
//                    return
//                }
//                
//                var tempFileArray: [FileModel] = []
//                let dispatchGroup = DispatchGroup()
//                
//                for content in contentDocs {
//                    dispatchGroup.enter()
//                    Utility.getVersionData(contentDocId: content.contentDocumentId ?? EMPTY) { versionSuccess in
//                        if let versionId = GlobalData.allVersionDataModel.Id {
//                            Utility.getFileData(contentVersionId: versionId) { fileData in
//                                if let data = fileData {
//                                    let fileName = "\(versionId).pdf"
//                                    let fileModel = FileModel(fileName: fileName, fileData: data)
//                                    tempFileArray.append(fileModel)
//                                }
//                                dispatchGroup.leave()
//                            }
//                        } else {
//                            dispatchGroup.leave()
//                        }
//                    }
//                }
//                
//                dispatchGroup.notify(queue: .main) {
//                    self.loaderView?.stopAnimating()
//                    
//                    self.fileArray = tempFileArray
////                    if self.fileArray.count > 0 {
////                        self.noDataFoundVw?.isHidden = true
////                        self.tableView?.isHidden = false
////                        self.tableViewsHeader?.isHidden = false
////                        self.tableView?.reloadData()
////                    } else {
////                        self.tableViewsHeader?.isHidden = true
////                        self.noDataFoundVw?.isHidden = false
////                        self.tableView?.isHidden = true
////                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.loaderView?.stopAnimating()
//                   
//                }
//            }
//        }
//    }
    
    
    func fetchAllFiles() {
        
        GlobalData.allContentDocModel.removeAll()
        self.fileArray.removeAll()
        self.profileFiles.removeAll()
        
        DispatchQueue.main.async {
            self.loaderView?.startAnimating()
        }
        
        Utility.getAllContentDoc(
            oppId: accountDetailModel.account?.id ?? EMPTY
        ) { success in
            
            guard success else {
                DispatchQueue.main.async {
                    self.loaderView?.stopAnimating()
                }
                return
            }
            
            let contentDocs = GlobalData.allContentDocModel
            
            var requiredDocs: [ContentDocModel] = []
            var foundTypes = Set<ProfileDocumentType>()
            
            for content in contentDocs {
                
                guard let title = content.contentDocument?.title,
                      let type = self.documentType(for: title) else {
                    continue
                }
                
                // Keep only one document for each type
                if !foundTypes.contains(type) {
                    foundTypes.insert(type)
                    requiredDocs.append(content)
                }
            }
            
            print("================================")
            print("Total Content Documents: \(contentDocs.count)")
            print("Required Profile Documents: \(requiredDocs.count)")
            
            for document in requiredDocs {
                print("Document: \(document.contentDocument?.title ?? "")")
            }
            print("================================")
            
            self.downloadDocumentsSequentially(
                documents: requiredDocs,
                index: 0
            )
        }
    }
    
    func profileFile(for type: ProfileDocumentType) -> ProfileFileModel? {
        return profileFiles.first {
            $0.documentType == type
        }
    }
    
    func downloadDocumentsSequentially(
        documents: [ContentDocModel],
        index: Int
    ) {
        
        guard index < documents.count else {
            
            DispatchQueue.main.async {
                self.loaderView?.stopAnimating()
                
                print("================================")
                print("Finished downloading documents")
                print("Total profile files: \(self.profileFiles.count)")
                
                for file in self.profileFiles {
                    print("Type: \(file.documentType)")
                    print("Title: \(file.title)")
                    print("ContentDocumentId: \(file.contentDocumentId)")
                    print("VersionId: \(file.versionId)")
                    print("Data size: \(file.fileData.count)")
                    print("--------------------------------")
                }
            }
            
            return
        }
        
        let content = documents[index]
        
        guard let title = content.contentDocument?.title,
              let documentType = documentType(for: title),
              let contentDocumentId = content.contentDocumentId else {
            
            self.downloadDocumentsSequentially(
                documents: documents,
                index: index + 1
            )
            
            return
        }
        
        print("================================")
        print("Downloading document")
        print("Title: \(title)")
        print("Type: \(documentType)")
        print("ContentDocumentId: \(contentDocumentId)")
        
        Utility.getVersionData(
            contentDocId: contentDocumentId
        ) { success in
            
            guard success,
                  let versionId = GlobalData.allVersionDataModel.Id else {
                
                print("Could not get Version Id for: \(title)")
                
                self.downloadDocumentsSequentially(
                    documents: documents,
                    index: index + 1
                )
                
                return
            }
            
            print("VersionId: \(versionId)")
            
            Utility.getFileData(
                contentVersionId: versionId
            ) { fileData in
                
                guard let data = fileData else {
                    
                    print("Failed downloading: \(title)")
                    
                    self.downloadDocumentsSequentially(
                        documents: documents,
                        index: index + 1
                    )
                    
                    return
                }
                
                print("Successfully downloaded: \(title)")
                print("Type: \(documentType)")
                print("Data size: \(data.count)")
                
                let profileFile = ProfileFileModel(
                    title: title,
                    documentType: documentType,
                    contentDocumentId: contentDocumentId,
                    versionId: versionId,
                    fileData: data
                )
                
                self.profileFiles.append(profileFile)
                
                DispatchQueue.main.async {
                    self.setDownloadedFile(
                        data: data,
                        type: documentType
                    )
                }
                
                // Download next document
                self.downloadDocumentsSequentially(
                    documents: documents,
                    index: index + 1
                )
            }
        }
    }
    
    func setDownloadedFile(
        data: Data,
        type: ProfileDocumentType
    ) {
        
        switch type {
            
        case .cancelledCheque:
            cancelledChequeBtn?.isHidden = false
            cancelledChequeBtn?.isUserInteractionEnabled = true
            
        case .pan:
            uploadedPanBtn?.isHidden = false
            uploadedPanBtn?.isUserInteractionEnabled = true
            
        case .aadhaar:
            uploadedAdharBtn?.isHidden = false
            uploadedAdharBtn?.isUserInteractionEnabled = true
            
        case .gst:
            uploadedGSTBtn?.isHidden = false
            uploadedGSTBtn?.isUserInteractionEnabled = true
            
        case .reraCertificate:
            RERARegistrationCertificateBtn?.isHidden = false
            RERARegistrationCertificateBtn?.isUserInteractionEnabled = true
            
        case .logo:
            logoUploadBtn?.isHidden = false
            logoUploadBtn?.isUserInteractionEnabled = true
            
        case .profilePhoto:
            profilePhotoUploadBtn?.isHidden = false
            profilePhotoUploadBtn?.isUserInteractionEnabled = true
        }
    }
    
    func initialUI() {
        
        userNameLbl?.text = "Welcome! \(Helper.displayValue(Defaults.name))"
        subHeadingLbl?.text = "CHANNEL PARTNER"
        
        // MARK: - Company Information
        companyNameLbl?.text = Helper.displayValue(accountDetailModel.account?.name)
        companyTypeLbl?.text = Helper.displayValue(accountDetailModel.account?.companyFirmType)
        companyPhoneLbl?.text = Helper.displayValue(accountDetailModel.account?.companyPhone)
        companyEmailIdLbl?.text = Helper.displayValue(accountDetailModel.account?.companyEmail)
        
        // MARK: - Owner Information
        ownerNameLbl?.text = Helper.displayValue(accountDetailModel.account?.owner?.name)
        ownerPhoneNumberLbl?.text = Helper.displayValue(accountDetailModel.account?.owner?.phone)
        ownerEmailLbl?.text = Helper.displayValue(accountDetailModel.account?.owner?.phone)
        mobileWhatsappNumberLbl?.text = Helper.displayValue(
            accountDetailModel.account?.owner?.mobilePhone
        )
        
        // MARK: - BR Person Information
        BRPersonNameLbl?.text = Helper.displayValue(
            accountDetailModel.account?.brokerCPBRPersonName
        )
        
        BRPersonPhoneNumberLbl?.text = Helper.displayValue(
            accountDetailModel.account?.brokerCPBRPersonMobile
        )
        
        BRPersonEmailLbl?.text = Helper.displayValue(
            accountDetailModel.account?.brokerCPBRPersonEmail
        )
        
        uploadedBRLbl?.text = "-"
        
        // MARK: - Company Address
        companyAddressLbl?.text = Helper.displayValue(
            accountDetailModel.account?.address
        )
        
        companyCountryLbl?.text = Helper.displayValue(
            accountDetailModel.account?.country
        )
        
        companyStateLbl?.text = Helper.displayValue(
            accountDetailModel.account?.state
        )
        
        companyCityLbl?.text = Helper.displayValue(
            accountDetailModel.account?.city
        )
        
        companyPostalCodeLbl?.text = Helper.displayValue(
            accountDetailModel.account?.pincode
        )
        
        // MARK: - Bank Information
        bankNameLbl?.text = Helper.displayValue(
            accountDetailModel.account?.bankName
        )
        
        bankAccountNumberLbl?.text = Helper.displayValue(
            accountDetailModel.account?.bankAccountNumber
        )
        
        bankIFSCCodeLbl?.text = Helper.displayValue(
            accountDetailModel.account?.bankIFSCCode
        )
        
        bankBranchCodeLbl?.text = Helper.displayValue(
            accountDetailModel.account?.branchCode
        )
        
        bankBranchLbl?.text = Helper.displayValue(
            accountDetailModel.account?.branchName
        )
        
        bankUPIIDLbl?.text = Helper.displayValue(
            accountDetailModel.account?.upiID
        )
        
        // MARK: - Statutory Information
        panNameLbl?.text = Helper.displayValue(
            accountDetailModel.account?.panNumber
        )
        
        adharNumberLbl?.text = Helper.displayValue(
            accountDetailModel.account?.aadhaarNumber
        )
        
        MSMILbl?.text = Helper.displayValue(
            accountDetailModel.account?.msme
        )
        
        MSMINumberLbl?.text = Helper.displayValue(
            accountDetailModel.account?.msmeNumber
        )
        
        GSTApplicableLbl?.text = Helper.displayValue(
            accountDetailModel.account?.gstApplicable
        )
        
        GSTNumberLbl?.text = Helper.displayValue(
            accountDetailModel.account?.gstNumber
        )
        
        RERANumberLbl?.text = Helper.displayValue(
            accountDetailModel.account?.reraNumber
        )
        
        RERADateLbl?.text = Helper.displayValue(
            accountDetailModel.account?.reraDate
        )
        
        RERAValidUptoLbl?.text = Helper.displayValue(
            accountDetailModel.account?.reraValidUpto
        )
        
        // Documents
        // Buttons are handled by fetchAllFiles()
        
        self.fetchAllFiles()
    }
    
    func setUpUI() {
        BottomVw?.backgroundColor = ColorConstant.screensBackgroundColor
        basicInfoBtnLbl?.backgroundColor = ColorConstant.primary
        basicInfoBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        statutoryInfoBtnLbl?.backgroundColor = .white
        profileIconBtn?.layer.cornerRadius = 22.5
        profileIconBtn?.setImage(UIImage(named: "profile"), for: .normal)
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        basicInfoView?.isHidden = false
        statutoryInfoView?.isHidden = true
        companyInfoView?.borderWidth = 1
        ownerDetailView?.borderWidth = 1
        boardView?.borderWidth = 1
        companyView?.borderWidth = 1
        bankView?.borderWidth = 1
        legalDocumentView?.borderWidth = 1
        MSMIView?.borderWidth = 1
        GSTINView?.borderWidth = 1
        RERAView?.borderWidth = 1
        otherView?.borderWidth = 1
        bankView?.layer.cornerRadius = 8
        companyInfoView?.layer.cornerRadius = 8
        ownerDetailView?.layer.cornerRadius = 8
        boardView?.layer.cornerRadius = 8
        companyView?.layer.cornerRadius = 8
        legalDocumentView?.layer.cornerRadius = 8
        MSMIView?.layer.cornerRadius = 8
        GSTINView?.layer.cornerRadius = 8
        RERAView?.layer.cornerRadius = 8
        otherView?.layer.cornerRadius = 8
        companyInfoView?.borderColor = ColorConstant.buttonBorderLightColor
        bankView?.borderColor = ColorConstant.buttonBorderLightColor
        ownerDetailView?.borderColor = ColorConstant.buttonBorderLightColor
        boardView?.borderColor = ColorConstant.buttonBorderLightColor
        companyView?.borderColor = ColorConstant.buttonBorderLightColor
        legalDocumentView?.borderColor = ColorConstant.buttonBorderLightColor
        MSMIView?.borderColor = ColorConstant.buttonBorderLightColor
        GSTINView?.borderColor = ColorConstant.buttonBorderLightColor
        RERAView?.borderColor = ColorConstant.buttonBorderLightColor
        otherView?.borderColor = ColorConstant.buttonBorderLightColor
    }
    
    func documentType(for title: String) -> ProfileDocumentType? {
        
        let title = title
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        if title.contains("cancel") && title.contains("cheque") {
            return .cancelledCheque
        }
        
        if title.contains("pan") {
            return .pan
        }
        
        if title.contains("aadhar") || title.contains("aadhaar") {
            return .aadhaar
        }
        
        if title.contains("gst") {
            return .gst
        }
        
        if title.contains("rera") {
            return .reraCertificate
        }
        
        if title.contains("logo") {
            return .logo
        }
        
        // Profile photo
        if title.contains("profile photo")
            || title.contains("profilephoto")
            || title.contains("applicant photo")
            || title.contains("applicantphoto") {
            return .profilePhoto
        }
        
        return nil
    }
    
    func presentFromLeft80Percent(_ vc: UIViewController) {
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = .clear
        
        let screenWidth = UIScreen.main.bounds.width
        vc.view.frame = CGRect(x: -screenWidth * 0.8,
                               y: 0,
                               width: screenWidth * 0.8,
                               height: UIScreen.main.bounds.height)
        
        present(vc, animated: false) {
            UIView.animate(withDuration: 0.3) {
                vc.view.frame.origin.x = 0
            }
        }
    }
    
    @IBAction func viewActions(_ sender: UIButton) {
        
        let documentType: ProfileDocumentType?
        
        switch sender {
            
        case cancelledChequeBtn:
            documentType = .cancelledCheque
            
        case uploadedPanBtn:
            documentType = .pan
            
        case uploadedAdharBtn:
            documentType = .aadhaar
            
        case uploadedGSTBtn:
            documentType = .gst
            
        case RERARegistrationCertificateBtn:
            documentType = .reraCertificate
            
        case logoUploadBtn:
            documentType = .logo
            
        case profilePhotoUploadBtn:
            documentType = .profilePhoto
            
        default:
            documentType = nil
        }
        
        guard let type = documentType else {
            return
        }
        
        guard let profileFile = profileFiles.first(where: {
            $0.documentType == type
        }) else {
            
            let alert = UIAlertController(
                title: "No Document",
                message: "No attachment found for this document.",
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(title: "OK", style: .default)
            )
            
            present(alert, animated: true)
            return
        }
        
        if type == .logo || type == .profilePhoto {
            
            showImagePreview(
                data: profileFile.fileData
            )
            
        } else {
            
            showDocumentPreview(
                data: profileFile.fileData,
                fileName: profileFile.title
            )
        }
    }
    
    func showDocumentPreview(data: Data, fileName: String) {
        
        let fileExtension = (fileName as NSString).pathExtension.isEmpty
            ? "pdf"
            : (fileName as NSString).pathExtension
        
        let baseName = (fileName as NSString).deletingPathExtension
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(baseName).\(fileExtension)")
        
        do {
            try data.write(to: tempURL)
            
            previewItemURL = tempURL
            
            let previewController = UIDocumentInteractionController(url: tempURL)
            previewController.delegate = self
            
            // Keep the controller alive
            objc_setAssociatedObject(
                self,
                "previewController",
                previewController,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            
            previewController.presentPreview(animated: true)
            
        } catch {
            print("Failed to create preview file: \(error)")
            
            showAlert(
                with: "Error",
                message: "Unable to open this document."
            )
        }
    }
    
    func showImagePreview(data: Data) {
        
        guard let image = UIImage(data: data) else {
            showAlert(
                with: "Error",
                message: "Unable to display this image."
            )
            return
        }
        
        let imageVC = UIViewController()
        imageVC.view.backgroundColor = .black
        
        let imageView = UIImageView(frame: imageVC.view.bounds)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        
        imageVC.view.addSubview(imageView)
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.frame = CGRect(
            x: imageVC.view.bounds.width - 80,
            y: 50,
            width: 70,
            height: 40
        )
        closeButton.autoresizingMask = [.flexibleLeftMargin]
        
        closeButton.addAction(
            UIAction { _ in
                imageVC.dismiss(animated: true)
            },
            for: .touchUpInside
        )
        
        imageVC.view.addSubview(closeButton)
        
        imageVC.modalPresentationStyle = .fullScreen
        
        present(imageVC, animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(
        _ controller: UIDocumentInteractionController
    ) -> UIViewController {
        return self
    }
    
    @IBAction func uiBtnsAction(_ sender: UIButton) {
        if sender.tag == 1 {
            basicInfoBtnLbl?.backgroundColor = ColorConstant.primary
            statutoryInfoBtnLbl?.backgroundColor = .white
            basicInfoView?.isHidden = false
            statutoryInfoView?.isHidden = true
            basicInfoBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        } else if sender.tag == 2 {
            basicInfoBtnLbl?.backgroundColor = .white
            statutoryInfoBtnLbl?.backgroundColor = ColorConstant.primary
            basicInfoView?.isHidden = true
            statutoryInfoView?.isHidden = false
            statutoryInfoBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
    }
    
    @IBAction func notificationAction() {
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let SchemeListVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(SchemeListVC, animated: true)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "SideBarVC") as? SideBarVC {
            presentFromLeft80Percent(sideMenuVC)
        } else {
            showAlert(with: "Error", message: "❌ Could not instantiate SideBarVC from Home.storyboard")
        }
    }
    
    @IBAction func backAction() {
        Utility.gotoTabbar()
    }
}

struct ProfileFileModel {
    let title: String
    let documentType: ProfileDocumentType
    let contentDocumentId: String
    let versionId: String
    let fileData: Data
}

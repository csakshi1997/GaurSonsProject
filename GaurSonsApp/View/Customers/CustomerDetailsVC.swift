//
//  CustomerDetailsVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 15/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import QuickLook
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class CustomerDetailsVC: UIViewController {
    @IBOutlet var mainVw: UIView?
    @IBOutlet var topView: UIView?
    @IBOutlet var detailsBtn: UIButton?
    @IBOutlet var filesBtn: UIButton?
    @IBOutlet var detailsBtnLbl: UILabel?
    @IBOutlet var filesBtnLbl: UILabel?
    @IBOutlet var headerCustomerNameLbl: UILabel?
    @IBOutlet var convertToEOIBtn: UIButton?
    @IBOutlet var showContactDetailsBtn: UIButton?
    
    //Detail
    @IBOutlet var detailsView: UIView?
    @IBOutlet var detailsScrollView: UIScrollView?
    @IBOutlet var infoView: UIView?
    @IBOutlet var customerNameLbl: UILabel?
    @IBOutlet var statusLbl: UILabel?
    @IBOutlet var mobileLbl: UILabel?
    @IBOutlet var emailLbl: UILabel?
    @IBOutlet var projectLbl: UILabel?
    @IBOutlet var submissionTypeLbl: UILabel?
    @IBOutlet var verificationTypeLbl: UILabel?
    @IBOutlet var agentNameLbl: UILabel?
    
    //Aadhar
    @IBOutlet var aadharView: UIView?
    @IBOutlet var aadhaarNameLbl: UILabel?
    @IBOutlet var aadhaarEndingLbl: UILabel?
    @IBOutlet var genderLbl: UILabel?
    @IBOutlet var dOBLbl: UILabel?
    @IBOutlet var careOfLbl: UILabel?
    
    //Address
    @IBOutlet var addressView: UIView?
    @IBOutlet var landmarkLbl: UILabel?
    @IBOutlet var houseLbl: UILabel?
    @IBOutlet var streetLbl: UILabel?
    @IBOutlet var VTCLbl: UILabel?
    @IBOutlet var districtbl: UILabel?
    @IBOutlet var subDistrictLbl: UILabel?
    @IBOutlet var postalCodeLbl: UILabel?
    @IBOutlet var postOfficeLbl: UILabel?
    @IBOutlet var stateLbl: UILabel?
    @IBOutlet var countryLbl: UILabel?
    
    //Complete Address
    @IBOutlet var completeAddressView: UIView?
    @IBOutlet var addressLbl: UILabel?
    
    //declaration
    @IBOutlet var declarationView: UIView?
    @IBOutlet var declarationHeadingLbl: UILabel?
    @IBOutlet var declarationTextLbl: UILabel?
    @IBOutlet var declarationHeight: NSLayoutConstraint?
    
    //Files
    @IBOutlet var fileHeaderView: UIView?
    @IBOutlet var fileTableView: UITableView?
    @IBOutlet var tableViewsHeader: UIView?
    @IBOutlet var uploadFilesBtn: UIButton?
    @IBOutlet var noDataFoundVw: UIView?
    
    //New EOI
    @IBOutlet var addNewEOIView: UIView?
    @IBOutlet var addNewEOIInternalView: UIView?
    @IBOutlet var applicantTypeTxtFld: MDCOutlinedTextField?
    @IBOutlet var addNewEOIHeightConstraint: NSLayoutConstraint!
    let applicantTypeDropDown = DropDown()
    
    //Masked Data
    @IBOutlet var maskedDataView: UIView?
    @IBOutlet var maskedDataInternalView: UIView?
    @IBOutlet var maskedMobileLbl: UILabel?
    @IBOutlet var maskedEmailLbl: UILabel?
    @IBOutlet var cross: UIButton?
    
    
    var previewItemURL: URL?
    var fileArray: [FileModel] = []
    var selectedAttachment: Attachment?
    var loaderView: UIActivityIndicatorView?
    var isDetailsEnable: Bool = false
    var isFilesEnable: Bool = false
    var isEOISelected: Bool = false
    var isApplicantTypeSelected: Bool = false
    var selectedButtons: Set<Int> = []
    var isOfflineYesEnable: Bool = false
    var isOfflineNoEnable: Bool = false
    var isIndividualEnable: Bool = false
    var isCompanyEnable: Bool = false
    var isPartnershipEnable: Bool = false
    var isProprietorshipEnable: Bool = false
    var isLLPEnable: Bool = false
    var isHUFEnable: Bool = false
    var isWelfareSocietyEnable: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var maskedEmail: String = EMPTY
    var maskedMobile: String = EMPTY

    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        applicantTypeTxtFld?.delegate = self
        
        setupApplicantDropdown()
        LocationWebService().getRecordTypeForEOI(type: "EOI") { _, data, _ in
            let id = (data?["records"] as? [[String: Any]])?.first?["Id"] as? String
            Defaults.eoiRecordTypeId = id
        }
        LocationWebService().getRecordTypeForLegacy(type: "Legacy") { _, data, _ in
            let id = (data?["records"] as? [[String: Any]])?.first?["Id"] as? String
            Defaults.legacyRecordTypeId = id
        }
    }
    
    func setUP() {
        applicantTypeTxtFld?.label.text = "Select Type"
        applicantTypeTxtFld?.setOutlineColor(.darkGray, for: .normal)
        applicantTypeTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        applicantTypeTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        applicantTypeTxtFld?.delegate = self
        applicantTypeTxtFld?.inputView = UIView()
        
        detailsBtnLbl?.backgroundColor = ColorConstant.primary
        filesBtnLbl?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        convertToEOIBtn?.layer.cornerRadius = 8
//        detailsView?.borderWidth = 1
        aadharView?.borderWidth = 1
        addressView?.borderWidth = 1
        completeAddressView?.borderWidth = 1
        declarationView?.borderWidth = 1
        detailsView?.layer.cornerRadius = 8
        aadharView?.layer.cornerRadius = 8
        addressView?.layer.cornerRadius = 8
        completeAddressView?.layer.cornerRadius = 8
        declarationView?.layer.cornerRadius = 8
//        detailsView?.borderColor = ColorConstant.buttonBorderLightColor
        aadharView?.borderColor = ColorConstant.buttonBorderLightColor
        addressView?.borderColor = ColorConstant.buttonBorderLightColor
        completeAddressView?.borderColor = ColorConstant.buttonBorderLightColor
        declarationView?.borderColor = ColorConstant.buttonBorderLightColor
        self.tableViewsHeader?.isHidden = true
        self.noDataFoundVw?.isHidden = true
        self.fileTableView?.isHidden = true
        self.fileHeaderView?.isHidden = true
        
        // populate Data
        headerCustomerNameLbl?.text = cuatomerDetailsDict?.name
        customerNameLbl?.text = cuatomerDetailsDict?.name
        statusLbl?.text = cuatomerDetailsDict?.status
        mobileLbl?.text = cuatomerDetailsDict?.mobile
        emailLbl?.text = cuatomerDetailsDict?.email
        projectLbl?.text = cuatomerDetailsDict?.project?.name
        submissionTypeLbl?.text = cuatomerDetailsDict?.brokerType
        verificationTypeLbl?.text = cuatomerDetailsDict?.verificationType
        agentNameLbl?.text = cuatomerDetailsDict?.createdBy?.name
        
        aadhaarNameLbl?.text = cuatomerDetailsDict?.aadhaarName
        aadhaarEndingLbl?.text = cuatomerDetailsDict?.aadhaarEnding
        genderLbl?.text = cuatomerDetailsDict?.gender
        dOBLbl?.text = cuatomerDetailsDict?.dateOfBirth
        careOfLbl?.text = cuatomerDetailsDict?.careOf
        
        landmarkLbl?.text = cuatomerDetailsDict?.landmark
        houseLbl?.text = cuatomerDetailsDict?.house
        streetLbl?.text = cuatomerDetailsDict?.street
        VTCLbl?.text = cuatomerDetailsDict?.vtc
        districtbl?.text = cuatomerDetailsDict?.district
        subDistrictLbl?.text = cuatomerDetailsDict?.subdist
        postalCodeLbl?.text = cuatomerDetailsDict?.pincode
        postOfficeLbl?.text = cuatomerDetailsDict?.postOffice
        stateLbl?.text = cuatomerDetailsDict?.state
        countryLbl?.text = cuatomerDetailsDict?.country
        addressLbl?.text = "Complete Address\n\n \(cuatomerDetailsDict?.completeAddress ?? EMPTY)"
        if cuatomerDetailsDict?.convertedToEOI ?? false {
            convertToEOIBtn?.setTitle("Converted", for: .normal)
            convertToEOIBtn?.backgroundColor = .gray
            convertToEOIBtn?.isEnabled = false
        } else {
            if cuatomerDetailsDict?.project?.channelPartnerVisible ?? false {
                Defaults.isFromEOI = false
                convertToEOIBtn?.setTitle("Booking Form", for: .normal)
                convertToEOIBtn?.backgroundColor = UIColor(hex: "98C355")
                convertToEOIBtn?.isEnabled = true
            } else {
                convertToEOIBtn?.setTitle("EOI Form", for: .normal)
                Defaults.isFromEOI = true
                convertToEOIBtn?.backgroundColor = UIColor(hex: "98C355")
                convertToEOIBtn?.isEnabled = true
            }
        }
        let declaration = cuatomerDetailsDict?.declaration?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if let declaration = declaration, !declaration.isEmpty {
            declarationTextLbl?.text = declaration.htmlToPlainText
            declarationView?.isHidden = false
            declarationHeadingLbl?.isHidden = false
        } else {
            declarationView?.isHidden = true
            declarationHeadingLbl?.isHidden = true
        }
        
        maskedMobileLbl?.text = DecryptDataFile.decryptValue(cuatomerDetailsDict?.maskedData?.mobile?.defaultValue) ?? EMPTY

        maskedEmailLbl?.text = DecryptDataFile.decryptValue(cuatomerDetailsDict?.maskedData?.email?.defaultValue) ?? EMPTY
    }
    
    func setupAddEOIVIew() {
        addNewEOIInternalView?.layer.cornerRadius = 24
        DispatchQueue.main.async {
            self.setupApplicantDropdown()
        }
    }
    
    func resetEOIViewHeight() {
        addNewEOIHeightConstraint.constant = 144
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        dismissMaskedDataView()
    }
    
    @IBAction func showContact(_ sender: UIButton) {
        showMaskedDataView()
    }
    
    func setupApplicantDropdown() {
        guard let textField = applicantTypeTxtFld else { return }
        
        applicantTypeDropDown.anchorView = textField
        applicantTypeDropDown.direction = .bottom
        print(textField.frame.height)
        print(textField.bounds.height)
        applicantTypeDropDown.bottomOffset = CGPoint(x: 0, y: textField.frame.height + 10)
        
        applicantTypeDropDown.dataSource = [
            "Company",
            "Individual",
            "Partnership",
            "Proprietorship",
            "LLP",
            "HUF",
            "Welfare Society"
        ]
        
        applicantTypeDropDown.backgroundColor = .white
        applicantTypeDropDown.selectionBackgroundColor = UIColor(hex: "223B30")
        applicantTypeDropDown.selectedTextColor = .white
        applicantTypeDropDown.textColor = .black
        
        applicantTypeDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.applicantTypeTxtFld?.text = item
            print("Selected Applicant Type: \(item)")
            self.handleApplicantSelection(item: item)
            self.resetEOIViewHeight()
            self.applicantTypeDropDown.hide()
            self.dismissAddNewEOIView()
            if isIndividualEnable {
                Defaults.isIndividualEnable = isIndividualEnable
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let personalEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "PersonalEOIScreenVC") as! PersonalEOIScreenVC
                personalEOIScreenVC.isFromCustomers = true
                personalEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
                personalEOIScreenVC.isOffline = isOfflineYesEnable
                self.navigationController?.pushViewController(personalEOIScreenVC, animated: true)
            } else if isCompanyEnable {
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let companyDetailsEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
                companyDetailsEOIScreenVC.isFromCustomers = true
                companyDetailsEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
                self.navigationController?.pushViewController(companyDetailsEOIScreenVC, animated: true)
            } else if isPartnershipEnable {
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let companyDetailsEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
                companyDetailsEOIScreenVC.isFromCustomers = true
                companyDetailsEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
                self.navigationController?.pushViewController(companyDetailsEOIScreenVC, animated: true)
            } else if isProprietorshipEnable {
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let companyDetailsEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
                companyDetailsEOIScreenVC.isFromCustomers = true
                companyDetailsEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
                self.navigationController?.pushViewController(companyDetailsEOIScreenVC, animated: true)
            } else if isLLPEnable {
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let companyDetailsEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
                companyDetailsEOIScreenVC.isFromCustomers = true
                companyDetailsEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
                self.navigationController?.pushViewController(companyDetailsEOIScreenVC, animated: true)
            } else if isHUFEnable {
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let companyDetailsEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
                companyDetailsEOIScreenVC.isFromCustomers = true
                companyDetailsEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
                self.navigationController?.pushViewController(companyDetailsEOIScreenVC, animated: true)
            } else if isWelfareSocietyEnable {
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let companyDetailsEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
                companyDetailsEOIScreenVC.isFromCustomers = true
                companyDetailsEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
                self.navigationController?.pushViewController(companyDetailsEOIScreenVC, animated: true)
            } else {
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let companyDetailsEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
                companyDetailsEOIScreenVC.isFromCustomers = true
                companyDetailsEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
                self.navigationController?.pushViewController(companyDetailsEOIScreenVC, animated: true)
            }
        }
    }
    
    func getDropdownHeight() -> CGFloat {
        let itemCount = applicantTypeDropDown.dataSource.count
        let cellHeight = applicantTypeDropDown.cellHeight
        let maxVisibleItems = 5

        let visibleItems = min(itemCount, maxVisibleItems)
        return CGFloat(visibleItems) * cellHeight
    }
    
    func handleApplicantSelection(item: String) {
        isIndividualEnable = false
        isCompanyEnable = false
        isPartnershipEnable = false
        isProprietorshipEnable = false
        Defaults.isIndividualEnable = false
        Defaults.isPartnerShip = false
        
        switch item {
        case "Individual":
            isIndividualEnable = true
            Defaults.type = "Individual"
            Defaults.isIndividualEnable = true
            
        case "Company":
            isCompanyEnable = true
            Defaults.type = "Company"
            
        case "Partnership":
            isPartnershipEnable = true
            Defaults.type = "Partnership"
            Defaults.isPartnerShip = true
            
        case "Proprietorship":
            isProprietorshipEnable = true
            Defaults.type = "Proprietorship"
            
        case "LLP":
            isLLPEnable = true
            Defaults.type = "LLP"
            
        case "HUF":
            isHUFEnable = true
            Defaults.type = "HUF"
            
        case "Welfare Society":
            isWelfareSocietyEnable = true
            Defaults.type = "Welfare_Society"
            
        default:
            break
        }
        
    }
    
    
    func fetchAllFiles() {
        GlobalData.allContentDocModel.removeAll()
        DispatchQueue.main.async {
            self.loaderView?.startAnimating()
            self.fileTableView?.isHidden = true
//            self.fileHeaderView?.isHidden = true
            self.noDataFoundVw?.isHidden = true
        }
        
        Utility.getAllContentDoc(oppId: cuatomerDetailsDict?.id ?? EMPTY) { success in
            if success {
                let contentDocs = GlobalData.allContentDocModel
                guard contentDocs.count > 0 else {
                    DispatchQueue.main.async {
                        self.loaderView?.stopAnimating()
                        self.noDataFoundVw?.isHidden = false
                        self.fileTableView?.isHidden = true
//                        self.fileHeaderView?.isHidden = true
                    }
                    return
                }
                
                var tempFileArray: [FileModel] = []
                let dispatchGroup = DispatchGroup()
                
                for content in contentDocs {
                    dispatchGroup.enter()
                    Utility.getVersionData(contentDocId: content.contentDocumentId ?? EMPTY) { versionSuccess in
                        if let versionId = GlobalData.allVersionDataModel.Id {
                            Utility.getFileData(contentVersionId: versionId) { fileData in
                                if let data = fileData {
                                    let fileName = "\(versionId).pdf"
                                    let fileModel = FileModel(fileName: fileName, fileData: data)
                                    tempFileArray.append(fileModel)
                                }
                                dispatchGroup.leave()
                            }
                        } else {
                            dispatchGroup.leave()
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.loaderView?.stopAnimating()
                    
                    self.fileArray = tempFileArray
                    self.fileHeaderView?.isHidden = false
                    if self.fileArray.count > 0 {
                        self.noDataFoundVw?.isHidden = true
                        self.fileTableView?.isHidden = false
                        self.tableViewsHeader?.isHidden = false
                        self.fileTableView?.reloadData()
                    } else {
                        self.tableViewsHeader?.isHidden = true
                        self.noDataFoundVw?.isHidden = false
                        self.fileTableView?.isHidden = true
//                        self.fileHeaderView?.isHidden = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loaderView?.stopAnimating()
                    self.noDataFoundVw?.isHidden = false
                    self.fileTableView?.isHidden = true
//                    self.fileHeaderView?.isH idden = true
                }
            }
        }
    }
    
    @IBAction func proccedBtnAction() {
        dismissAddNewEOIView()
        if isIndividualEnable {
            Defaults.isIndividualEnable = isIndividualEnable
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
            let personalEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "PersonalEOIScreenVC") as! PersonalEOIScreenVC
            personalEOIScreenVC.isFromCustomers = true
            personalEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
            personalEOIScreenVC.isOffline = isOfflineYesEnable 
            self.navigationController?.pushViewController(personalEOIScreenVC, animated: true)
        } else {
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
            let companyDetailsEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
            companyDetailsEOIScreenVC.isFromCustomers = true
            companyDetailsEOIScreenVC.cuatomerDetailsDict = cuatomerDetailsDict
            self.navigationController?.pushViewController(companyDetailsEOIScreenVC, animated: true)
        }
    }
    
    @IBAction func uploadFileAction() {
        print("Upload button tapped")
        showUploadOptions(sourceField: "File")
    }
    
//    @IBAction func applicantTypeTapped(_ sender: UIButton) {
//        if sender == applicantTypeIndividual {
//            isIndividualEnable.toggle()
//            isCompanyEnable = false
//            isPartnershipEnable = false
//            isProprietorshipEnable = false
//        } else if sender == applicantTypeCompany {
//            isCompanyEnable.toggle()
//            isIndividualEnable = false
//            isPartnershipEnable = false
//            isProprietorshipEnable = false
//        } else if sender == applicantTypePartnership {
//            isPartnershipEnable.toggle()
//            isIndividualEnable = false
//            isCompanyEnable = false
//            isProprietorshipEnable = false
//        } else if sender == applicantTypeProprietorship {
//            isProprietorshipEnable.toggle()
//            isIndividualEnable = false
//            isCompanyEnable = false
//            isPartnershipEnable = false
//        }
//
//        [applicantTypeIndividual, applicantTypeCompany, applicantTypePartnership, applicantTypeProprietorship].forEach { btn in
//            btn?.backgroundColor = .white
//            btn?.setTitleColor(.black, for: .normal)
//        }
//
//        if isIndividualEnable {
//            Defaults.type = "Individual"
//            applicantTypeIndividual?.backgroundColor = UIColor(hex: "223B30")
//            applicantTypeIndividual?.setTitleColor(.white, for: .normal)
//        }
//        if isCompanyEnable { applicantTypeCompany?.backgroundColor = UIColor(hex: "223B30")
//            Defaults.type = "Company"
//            applicantTypeCompany?.setTitleColor(.white, for: .normal)
//        }
//        if isPartnershipEnable { applicantTypePartnership?.backgroundColor = UIColor(hex: "223B30")
//            Defaults.type = "Partnership"
//            applicantTypePartnership?.setTitleColor(.white, for: .normal)
//        }
//        if isProprietorshipEnable { applicantTypeProprietorship?.backgroundColor = UIColor(hex: "223B30")
//            Defaults.type = "Proprietorship"
//            applicantTypeProprietorship?.setTitleColor(.white, for: .normal)
//        }
//        checkProceedEligibility()
//    }
    
//    func resetEOISelection() {
//        isOfflineYesEnable = false
//        isOfflineNoEnable = false
//        
//        [isOfflineEOIYES, isOfflineEOINO].forEach { btn in
//            btn?.backgroundColor = .white
//            btn?.setTitleColor(.black, for: .normal)
//        }
//        
//        isProprietorshipEnable = false
//        isIndividualEnable = false
//        isCompanyEnable = false
//        isPartnershipEnable = false
//        
//        [applicantTypeIndividual, applicantTypeCompany, applicantTypePartnership, applicantTypeProprietorship].forEach { btn in
//            btn?.backgroundColor = .white
//            btn?.setTitleColor(.black, for: .normal)
//        }
//    }
    
//    @IBAction func eoiOptionTapped(_ sender: UIButton) {
//        if sender == isOfflineEOIYES {
//            isOfflineYesEnable.toggle()
//            isOfflineNoEnable = false
//        } else if sender == isOfflineEOINO {
//            isOfflineNoEnable.toggle()
//            isOfflineYesEnable = false
//        }
//        
//        [isOfflineEOIYES, isOfflineEOINO].forEach { btn in
//            btn?.backgroundColor = .white
//            btn?.setTitleColor(.black, for: .normal)
//        }
//        
//        if isOfflineYesEnable {
//            isOfflineEOIYES?.backgroundColor = UIColor(hex: "223B30")
//            isOfflineEOIYES?.setTitleColor(.white, for: .normal)
//        }
//        if isOfflineNoEnable {
//            isOfflineEOINO?.backgroundColor = UIColor(hex: "223B30")
//            isOfflineEOINO?.setTitleColor(.white, for: .normal)
//        }
//        
//        checkProceedEligibility()
//    }
    
    @IBAction func uiBtnsAction(_ sender: UIButton) {
        detailsBtnLbl?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
        filesBtnLbl?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
        detailsScrollView?.isHidden = true
        fileHeaderView?.isHidden = true
        fileTableView?.isHidden = true
        tableViewsHeader?.isHidden = true
        noDataFoundVw?.isHidden = true
        isDetailsEnable = false
        isFilesEnable = false
        if sender.tag == 11 {
            isDetailsEnable = true
            detailsBtnLbl?.backgroundColor = ColorConstant.primary
            detailsScrollView?.isHidden = false
        } else if sender.tag == 14 {
            isFilesEnable = true
            fileHeaderView?.isHidden = false
            filesBtnLbl?.backgroundColor = ColorConstant.primary
            fetchAllFiles()
        }
    }
    
    @IBAction func convertToEOIAction() {
        guard let addNewEOIView = addNewEOIView else { return }
        guard let window = UIApplication.shared.keyWindow else { return }

        addNewEOIView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addNewEOIView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(addNewEOIView)
        setupAddEOIVIew()
        NSLayoutConstraint.activate([
            addNewEOIView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            addNewEOIView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            addNewEOIView.topAnchor.constraint(equalTo: window.topAnchor),
            addNewEOIView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])

        addNewEOIView.alpha = 0
        addNewEOIView.transform = CGAffineTransform(translationX: 0, y: window.frame.height)

        UIView.animate(withDuration: 0.3, animations: {
            addNewEOIView.alpha = 1
            addNewEOIView.transform = .identity
        })

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAddNewEOIView))
        addNewEOIView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissAddNewEOIView() {
        guard let addNewEOIView = addNewEOIView else { return }

        UIView.animate(withDuration: 0.3, animations: {
            addNewEOIView.alpha = 0
            addNewEOIView.transform = CGAffineTransform(translationX: 0, y: addNewEOIView.frame.height)
        }, completion: { _ in
            addNewEOIView.removeFromSuperview()
        })
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
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CustomerDetailsVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == applicantTypeTxtFld {
            
            let dropdownHeight = getDropdownHeight()
            addNewEOIHeightConstraint.constant = 200 + dropdownHeight
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                self.applicantTypeDropDown.show()
            }
            return false
        }
        return true
    }
}

extension CustomerDetailsVC: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItemURL == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItemURL! as QLPreviewItem
    }
}

extension CustomerDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == fileTableView {
            guard indexPath.row < fileArray.count else {
                return UITableViewCell()
            }
            let cell: FilelCell = tableView.dequeueReusableCell(withIdentifier: "FilelCell", for: indexPath) as! FilelCell
            let fileDict = self.fileArray[indexPath.row]
            cell.fileNameLbl?.text = fileDict.fileName
            cell.sizeLbl?.text = fileDict.fileSize
            cell.onPreviewTapped = { [weak self] in
                self?.previewFile(at: indexPath.row)
            }
            return cell
        }
        return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

class FilesCell: UITableViewCell {
    @IBOutlet var primaryLbl: UILabel?
    @IBOutlet var fileNameLbl: UILabel?
    @IBOutlet var sizeLbl: UILabel?
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

        previewBtn?.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        deleteBtn?.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func copyButtonTapped() {
        onPreviewTapped?()
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteTapped?()
    }
}

extension CustomerDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
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
            await uploadAttachment(linkedEntityId: cuatomerDetailsDict?.id ?? EMPTY)
            
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



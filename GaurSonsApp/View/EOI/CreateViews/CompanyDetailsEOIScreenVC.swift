//
//  CompanyDetailsEOIScreenVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 28/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Extended

class CompanyDetailsEOIScreenVC: UIViewController {
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    @IBOutlet var nameOfCompnaytxtFld: MDCOutlinedTextField?
    @IBOutlet var dateOfIncorporationtxtFld: MDCOutlinedTextField?
    @IBOutlet var dateOfIncorporationDateImg: UIImageView?
    @IBOutlet var phoneNumberWorktxtFld: MDCOutlinedTextField?
    @IBOutlet var mobileNumberetxtFld: MDCOutlinedTextField?
    @IBOutlet var emailtxtFld: MDCOutlinedTextField?
    @IBOutlet var PANNumbertxtFld: MDCOutlinedTextField?
    @IBOutlet var PANUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var PANUploadStack: UIStackView?
    @IBOutlet var PANUploadImg: UIImageView?
    @IBOutlet var corporateNumbertxtFld: MDCOutlinedTextField?
    @IBOutlet var corporateNumberUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var corporateNumberUploadStack: UIStackView?
    @IBOutlet var corporateNumberUploadImg: UIImageView?
    @IBOutlet var designatedPartnerIdentificationNumbertxtFld: MDCOutlinedTextField?
    @IBOutlet var designatedPartnerIdentificationNumberUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var designatedPartnerIdentificationNumberUploadStack: UIStackView?
    @IBOutlet var designatedPartnerIdentificationNumberUploadImg: UIImageView?
    @IBOutlet var boardResolutionDateTxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadResolutionTxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadResolutionStack: UIStackView?
    @IBOutlet var uploadResolutionImg: UIImageView?
    @IBOutlet var boardResolutionDateImg: UIImageView?
    @IBOutlet var gstNotxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadGSTtxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadGSTStack: UIStackView?
    @IBOutlet var uploadGSTImg: UIImageView?
    @IBOutlet var nameOfContactPersontxtFld: MDCOutlinedTextField?
    @IBOutlet var PriorInvestmenttxtFld: MDCOutlinedTextField?
    @IBOutlet var ProjectNametxtFld: MDCOutlinedTextField?
    @IBOutlet var unitNumbertxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadCOItxtFld: MDCOutlinedTextField?
    @IBOutlet var ProjectNameStack: UIStackView?
    @IBOutlet var UnitNumberStack: UIStackView?
    @IBOutlet var uploadCOIStack: UIStackView?
    @IBOutlet var uploadCOIImg: UIImageView?
    
    @IBOutlet var authorizationLetterDatetxtFld: MDCOutlinedTextField?
    @IBOutlet var authorizationLetterDateStack: UIStackView?
    @IBOutlet var authorizationLetterDateImg: UIImageView?
    @IBOutlet var authorizationLetterUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var authorizationLetterUploadStack: UIStackView?
    @IBOutlet var authorizationLetterUploadImg: UIImageView?
    @IBOutlet var partnershipDatetxtFld: MDCOutlinedTextField?
    @IBOutlet var partnershipDateStack: UIStackView?
    @IBOutlet var partnershipDateImg: UIImageView?
    @IBOutlet var uploadPartnershiptxtFld: MDCOutlinedTextField?
    @IBOutlet var partnershipUploadStack: UIStackView?
    @IBOutlet var uploadPartnershipImg: UIImageView?
    @IBOutlet var registrationStateTxtFld: MDCOutlinedTextField?
    @IBOutlet var registrationStateStack: UIStackView?
    @IBOutlet var registrationStateImg: UIImageView?
    @IBOutlet var registrationNoTxtFld: MDCOutlinedTextField?
    @IBOutlet var registrationNoStack: UIStackView?
    @IBOutlet var registrationNoImg: UIImageView?
    @IBOutlet var uploadRegistrationCertifcatetxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadRegistrationCertifcateStack: UIStackView?
    @IBOutlet var uploadRegistrationCertifcateImg: UIImageView?
    
    var activeUploadField: String?
    @IBOutlet var resetBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    var DOIDatePicker = UIDatePicker()
    var resolutionDatePicker = UIDatePicker()
    var authLetterDatePicker = UIDatePicker()
    var deedDatePicker = UIDatePicker()
    var isPrimaryYES: Bool = false
    var isPrimaryNO: Bool = false
    var validation = Validation()
    var applicantIndex: Int?
    let priorInvestmentDropDown = DropDown()
    let registrationStateDropDown = DropDown()
    var registrationStateValues: [String] = []
    var isFromCustomers: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var isForEditing: Bool = false
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var applicantRecord: ApplicantRecord?
    var originalApplicantData: SaveModel?
    var isLocalEdit: Bool = false
    var isAddingNewApplicant: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
//                nameOfCompnaytxtFld?.text = "ABC Technologies Pvt Ltd"
//                dateOfIncorporationtxtFld?.text = "2020-05-15"
//                phoneNumberWorktxtFld?.text = "01145678901"
//                mobileNumberetxtFld?.text = "9876543210"
//                emailtxtFld?.text = "info@abctech.com"
//                PANNumbertxtFld?.text = "ABCDE1234F"
//                corporateNumbertxtFld?.text = "U12345DL2020PTC123456"
//                designatedPartnerIdentificationNumbertxtFld?.text = "12345678"
//                boardResolutionDateTxtFld?.text = "2024-01-10"
//                gstNotxtFld?.text = "07ABCDE1234F1Z5"
//                nameOfContactPersontxtFld?.text = "Sakshi Choudhary"
//                PriorInvestmenttxtFld?.text = "Yes"
//                authorizationLetterDatetxtFld?.text = "2024-02-12"
//                partnershipDatetxtFld?.text = "2022-08-01"
//                registrationStateTxtFld?.text = "Haryana"
//                registrationNoTxtFld?.text = "REG123456"
//                if isForEditing {
//                    Utility.getAllApplicantDetails(applicantId: applicantRecord?.id ?? EMPTY) { success in
//                        if success {
//                            DispatchQueue.main.async {
//                                self.applicantDetailsModel = GlobalData.allApplicantDetailsModel
//                                self.autoPopulateFieldsForEditing()
//                            }
//                        }
//                    }
//                }
        
        if isForEditing {
            Utility.getAllApplicantDetails(applicantId: applicantRecord?.id ?? EMPTY) { success in
                self.applicantDetailsModel = GlobalData.allApplicantDetailsModel
                DispatchQueue.main.async {
                    self.autoPopulateFieldsForEditing()
                }
            }
        } else if isLocalEdit {
            if let index = applicantIndex,
               let applicant = OpportunityManager.shared.getApplicant(at: index) {
                populateFromLocal(applicant)
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
    
    func fetchPicklistData() async {

        await FetchPicklistValue.shared.fetchPicklistValues(
            objectName: "Applicant_Details__c",
            fieldNames: [
                "Registration_State__c",
            ]
        )

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.registrationStateValues = FetchPicklistValue.shared
                .picklistOptionsDict["Registration_State__c"]?
                .map { $0.label } ?? []


            print("registrationStateValues Arr:", self.registrationStateValues)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await fetchPicklistData()
        }
    }
    
    func populateFromLocal(_ applicant: SaveModel) {
        
        nameOfCompnaytxtFld?.text = applicant.nameOfCompanyFirmLLP
        dateOfIncorporationtxtFld?.text = applicant.dateOfIncorporation
        nameOfContactPersontxtFld?.text = applicant.nameOfAuthorizedContactPerson
        mobileNumberetxtFld?.text = applicant.authorizedContactPersonPhone
        emailtxtFld?.text = applicant.authorizedContactPersonEmail
        phoneNumberWorktxtFld?.text = applicant.phoneWork
        
        PANNumbertxtFld?.text = applicant.companyFirmLLPPAN
        corporateNumbertxtFld?.text = applicant.corporateLLPIdentificationNumber
        designatedPartnerIdentificationNumbertxtFld?.text = applicant.directorDesignatedPartnerIdenNo
        
        PriorInvestmenttxtFld?.text = applicant.priorInvestmentInGaursGroupProject
        ProjectNametxtFld?.text = applicant.priorInvestmentInExistingProject
        unitNumbertxtFld?.text = applicant.unitNumber
        updatePriorInvestmentFields()
        gstNotxtFld?.text = applicant.gstNo
        
        boardResolutionDateTxtFld?.text = applicant.boardResolutionDate
        authorizationLetterDatetxtFld?.text = applicant.authorisationLetterDate
        partnershipDatetxtFld?.text = applicant.partnershipLLPHUFDeedDate
        registrationStateTxtFld?.text = applicant.registrationState
        registrationNoTxtFld?.text = applicant.registrationNo
//        PANUploadtxtFld?.text = applicant.panUploadFileName
//        corporateNumberUploadtxtFld?.text = applicant.cinUploadFileName
//        designatedPartnerIdentificationNumberUploadtxtFld?.text = applicant.dinUploadFileName
//        uploadCOItxtFld?.text = applicant.coiUploadFileName
//        uploadGSTtxtFld?.text = applicant.gstUploadFileName
//        uploadResolutionTxtFld?.text = applicant.resolutionUploadFileName
//        authorizationLetterUploadtxtFld?.text = applicant.authorizationLetterFileName
//        uploadPartnershiptxtFld?.text = applicant.partnershipFileName
//        uploadRegistrationCertifcatetxtFld?.text = applicant.registrationCertificateFileName
    }
    
    func autoPopulateFieldsForEditing() {
        
        nameOfCompnaytxtFld?.text = applicantDetailsModel.nameOfCompanyFirm
        dateOfIncorporationtxtFld?.text = applicantDetailsModel.dateOfIncorporation
        nameOfContactPersontxtFld?.text = applicantDetailsModel.authorizedContactPerson
        mobileNumberetxtFld?.text = applicantRecord?.applicantMobileNumber
        emailtxtFld?.text = applicantRecord?.applicantEmailID
        phoneNumberWorktxtFld?.text = applicantDetailsModel.phoneWork
        
        PANNumbertxtFld?.text = applicantDetailsModel.companyFirmLLPPan
        corporateNumbertxtFld?.text = applicantDetailsModel.corporateLLPIdentificationNumber
        designatedPartnerIdentificationNumbertxtFld?.text = applicantDetailsModel.directorIdNumber
        
        PriorInvestmenttxtFld?.text =
        (applicantDetailsModel.priorInvestmentInGaurs ?? false) ? "Yes" : "No"
        ProjectNametxtFld?.text = applicantDetailsModel.priorInvestmentExistingProject
        unitNumbertxtFld?.text = applicantDetailsModel.unitNumber.map { String($0) }
        updatePriorInvestmentFields()
        gstNotxtFld?.text = applicantDetailsModel.gstNo
        boardResolutionDateTxtFld?.text = applicantDetailsModel.boardOfResolutionDate
        authorizationLetterDatetxtFld?.text = applicantDetailsModel.authorisationLetterDate
        partnershipDatetxtFld?.text = applicantDetailsModel.partnershipLLPHUFDeedDate
        registrationStateTxtFld?.text = applicantDetailsModel.registrationState
        registrationNoTxtFld?.text = applicantDetailsModel.registrationNo
        PANUploadStack?.isHidden = true
        PANUploadImg?.isHidden = true
        
        corporateNumberUploadStack?.isHidden = true
        corporateNumberUploadImg?.isHidden = true
        
        designatedPartnerIdentificationNumberUploadStack?.isHidden = true
        designatedPartnerIdentificationNumberUploadImg?.isHidden = true
        
        uploadCOIStack?.isHidden = true
        uploadCOIImg?.isHidden = true
        
        uploadGSTStack?.isHidden = true
        uploadGSTImg?.isHidden = true
        
        uploadResolutionStack?.isHidden = true
        uploadResolutionImg?.isHidden = true
        
        authorizationLetterUploadStack?.isHidden = true
        authorizationLetterUploadImg?.isHidden = true
        
        partnershipUploadStack?.isHidden = true
        uploadPartnershipImg?.isHidden = true
        
        authorizationLetterUploadStack?.isHidden = true
        authorizationLetterUploadImg?.isHidden = true
        
        uploadRegistrationCertifcateStack?.isHidden = true
        uploadRegistrationCertifcateImg?.isHidden = true
        
    }
    
    func setUpInitialUI() {
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        if Defaults.isPartnerShip ?? false {
            pageNumberLbl?.text = "1"
            OutOfPageNumber?.text = "8"
        } else {
            pageNumberLbl?.text = "1"
            OutOfPageNumber?.text = "7"
        }
        authorizationLetterUploadStack?.isHidden = true
        authorizationLetterDateStack?.isHidden = true
        partnershipDateStack?.isHidden = true
        partnershipUploadStack?.isHidden = true
        registrationNoStack?.isHidden = true
        registrationStateStack?.isHidden = true
        uploadRegistrationCertifcateStack?.isHidden = true
        authorizationLetterDateImg?.isHidden = true
        authorizationLetterUploadImg?.isHidden = true
        partnershipDateImg?.isHidden = true
        uploadPartnershipImg?.isHidden = true
        registrationStateImg?.isHidden = true
        registrationNoImg?.isHidden = true
        uploadRegistrationCertifcateImg?.isHidden = true
//        boardResolutionDateImg?.isHidden = true
//        dateOfIncorporationDateImg?.isHidden = false
        ProjectNameStack?.isHidden = true

        UnitNumberStack?.isHidden = true
        
        
        if Defaults.type == "Company" {
            
        } else if Defaults.type == "Partnership" || Defaults.type == "LLP" || Defaults.type == "HUF" {
            authorizationLetterUploadStack?.isHidden = false
            authorizationLetterDateStack?.isHidden = false
            partnershipDateStack?.isHidden = false
            partnershipUploadStack?.isHidden = false
            authorizationLetterDateImg?.isHidden = false
            authorizationLetterUploadImg?.isHidden = false
            partnershipDateImg?.isHidden = false
            uploadPartnershipImg?.isHidden = false
        } else if Defaults.type == "Welfare_Society" {
            authorizationLetterUploadStack?.isHidden = false
            authorizationLetterDateStack?.isHidden = false
            registrationNoStack?.isHidden = false
            registrationStateStack?.isHidden = false
            uploadRegistrationCertifcateStack?.isHidden = false
            authorizationLetterDateImg?.isHidden = false
            authorizationLetterUploadImg?.isHidden = false
            registrationStateImg?.isHidden = false
            registrationNoImg?.isHidden = false
            uploadRegistrationCertifcateImg?.isHidden = false
//            boardResolutionDateImg?.isHidden = false
            
        }
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        resetBtn?.borderWidth = 1
        resetBtn?.borderColor = UIColor(hex: "DFE1E0")
        resetBtn?.layer.cornerRadius = 6
        nextBtn?.layer.cornerRadius = 6
        
        nameOfCompnaytxtFld?.label.text = "Name of Company/Firm/LLP *"
        nameOfCompnaytxtFld?.placeholder = "Enter Name of Company/Firm"
        nameOfCompnaytxtFld?.setOutlineColor(.darkGray, for: .normal)
        nameOfCompnaytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        nameOfCompnaytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        dateOfIncorporationtxtFld?.label.text = "Date of Incorporation *"
        dateOfIncorporationtxtFld?.placeholder = "Choose Date"
        dateOfIncorporationtxtFld?.setOutlineColor(.darkGray, for: .normal)
        dateOfIncorporationtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        dateOfIncorporationtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        DOIDatePicker.datePickerMode = .date
        DOIDatePicker.preferredDatePickerStyle = .wheels
        DOIDatePicker.addTarget(self, action: #selector(dateChangedForStart(_:)), for: .valueChanged)
        dateOfIncorporationtxtFld?.inputView = DOIDatePicker
        
        nameOfContactPersontxtFld?.label.text = "Name of the Authorized Contact Person"
        nameOfContactPersontxtFld?.setOutlineColor(.darkGray, for: .normal)
        nameOfContactPersontxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        nameOfContactPersontxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        phoneNumberWorktxtFld?.label.text = "Phone Number (Work)"
        phoneNumberWorktxtFld?.setOutlineColor(.darkGray, for: .normal)
        phoneNumberWorktxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        phoneNumberWorktxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        mobileNumberetxtFld?.label.text = "Mobile *"
        mobileNumberetxtFld?.setOutlineColor(.darkGray, for: .normal)
        mobileNumberetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        mobileNumberetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        emailtxtFld?.label.text = "Email ID *"
        emailtxtFld?.setOutlineColor(.darkGray, for: .normal)
        emailtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        emailtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        PANNumbertxtFld?.label.text = "Company/Firm/LLP PAN No. *"
        PANNumbertxtFld?.setOutlineColor(.darkGray, for: .normal)
        PANNumbertxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        PANNumbertxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        PANUploadtxtFld?.label.text = "Pan Upload *"
        PANUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        PANUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        PANUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let panTap = UITapGestureRecognizer(target: self, action: #selector(openPanUploadOptions))
        PANUploadtxtFld?.addGestureRecognizer(panTap)
        PANUploadtxtFld?.isUserInteractionEnabled = true
        
        corporateNumbertxtFld?.label.text = "Corporate/LLP Ident. Number (CIN/LLPIN) *"
        corporateNumbertxtFld?.setOutlineColor(.darkGray, for: .normal)
        corporateNumbertxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        corporateNumbertxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        corporateNumberUploadtxtFld?.label.text = "Upload CIN/LLPIN *"
        corporateNumberUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        corporateNumberUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        corporateNumberUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let corporateNumberTap = UITapGestureRecognizer(target: self, action: #selector(opencorporateNumberUploadOptions))
        corporateNumberUploadtxtFld?.addGestureRecognizer(corporateNumberTap)
        corporateNumberUploadtxtFld?.isUserInteractionEnabled = true
        
        designatedPartnerIdentificationNumbertxtFld?.label.text = "Director/Designated Partner Identification Number (DIN/DPIN)"
        designatedPartnerIdentificationNumbertxtFld?.setOutlineColor(.darkGray, for: .normal)
        designatedPartnerIdentificationNumbertxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        designatedPartnerIdentificationNumbertxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        designatedPartnerIdentificationNumberUploadtxtFld?.label.text = "Upload DIN/DPIN"
        designatedPartnerIdentificationNumberUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        designatedPartnerIdentificationNumberUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        designatedPartnerIdentificationNumberUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let designatedPartnerTap = UITapGestureRecognizer(target: self, action: #selector(designatedPartnerIdentificationNumberUploadOptions))
        designatedPartnerIdentificationNumberUploadtxtFld?.addGestureRecognizer(designatedPartnerTap)
        designatedPartnerIdentificationNumberUploadtxtFld?.isUserInteractionEnabled = true
        
        PriorInvestmenttxtFld?.label.text = "Prior Investment in Gaurs Group project"
        PriorInvestmenttxtFld?.setOutlineColor(.darkGray, for: .normal)
        PriorInvestmenttxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        PriorInvestmenttxtFld?.translatesAutoresizingMaskIntoConstraints = false
        PriorInvestmenttxtFld?.delegate = self
        PriorInvestmenttxtFld?.inputView = UIView()
        
        ProjectNametxtFld?.label.text = "Project Name *"
        ProjectNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        ProjectNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        ProjectNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        unitNumbertxtFld?.label.text = "Unit Number *"
        unitNumbertxtFld?.setOutlineColor(.darkGray, for: .normal)
        unitNumbertxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        unitNumbertxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        uploadCOItxtFld?.label.text = "Upload COI (Certificate of Incorporation)"
        uploadCOItxtFld?.setOutlineColor(.darkGray, for: .normal)
        uploadCOItxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        uploadCOItxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let COITap = UITapGestureRecognizer(target: self, action: #selector(COIUploadOptions))
        uploadCOItxtFld?.addGestureRecognizer(COITap)
        uploadCOItxtFld?.isUserInteractionEnabled = true
        
        uploadGSTtxtFld?.label.text = "Upload GST *"
        uploadGSTtxtFld?.setOutlineColor(.darkGray, for: .normal)
        uploadGSTtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        uploadGSTtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let gstTap = UITapGestureRecognizer(target: self, action: #selector(GSTUploadOptions))
        uploadGSTtxtFld?.addGestureRecognizer(gstTap)
        uploadGSTtxtFld?.isUserInteractionEnabled = true
        
        gstNotxtFld?.label.text = "GST No *"
        gstNotxtFld?.setOutlineColor(.darkGray, for: .normal)
        gstNotxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        gstNotxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        uploadResolutionTxtFld?.label.text = "Upload Resolution *"
        uploadResolutionTxtFld?.setOutlineColor(.darkGray, for: .normal)
        uploadResolutionTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        uploadResolutionTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let resolutionUploadOptionsTap = UITapGestureRecognizer(target: self, action: #selector(ResolutionUploadOptions))
        uploadResolutionTxtFld?.addGestureRecognizer(resolutionUploadOptionsTap)
        uploadResolutionTxtFld?.isUserInteractionEnabled = true
        
        boardResolutionDateTxtFld?.label.text = "Board of Resolution Date *"
        boardResolutionDateTxtFld?.setOutlineColor(.darkGray, for: .normal)
        boardResolutionDateTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        boardResolutionDateTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        resolutionDatePicker.datePickerMode = .date
        resolutionDatePicker.preferredDatePickerStyle = .wheels
        resolutionDatePicker.addTarget(self, action: #selector(dateChangedForBoardResolution(_:)), for: .valueChanged)
        boardResolutionDateTxtFld?.inputView = resolutionDatePicker
        
        authorizationLetterDatetxtFld?.label.text = "Authorization letter Date *"
        authorizationLetterDatetxtFld?.setOutlineColor(.darkGray, for: .normal)
        authorizationLetterDatetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        authorizationLetterDatetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        authLetterDatePicker.datePickerMode = .date
        authLetterDatePicker.preferredDatePickerStyle = .wheels
        authLetterDatePicker.addTarget(self, action: #selector(dateChangedForAuthorizationLetter(_:)), for: .valueChanged)
        authorizationLetterDatetxtFld?.inputView = authLetterDatePicker
        
        authorizationLetterUploadtxtFld?.label.text = "Authorization Letter Upload certificate *"
        authorizationLetterUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        authorizationLetterUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        authorizationLetterUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let authorizationLetterUploadOptionsTAP = UITapGestureRecognizer(target: self, action: #selector(authorizationLetterUploadOptions))
        authorizationLetterUploadtxtFld?.addGestureRecognizer(authorizationLetterUploadOptionsTAP)
        authorizationLetterUploadtxtFld?.isUserInteractionEnabled = true
        
        partnershipDatetxtFld?.label.text = "Partnership/LLP/HUF Deed Date *"
        partnershipDatetxtFld?.setOutlineColor(.darkGray, for: .normal)
        partnershipDatetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        partnershipDatetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        deedDatePicker.datePickerMode = .date
        deedDatePicker.preferredDatePickerStyle = .wheels
        deedDatePicker.addTarget(self, action: #selector(dateChangedForDeedDate(_:)), for: .valueChanged)
        partnershipDatetxtFld?.inputView = deedDatePicker
        
        uploadPartnershiptxtFld?.label.text = "Upload Partnership/LLP/HUF Deed *"
        uploadPartnershiptxtFld?.setOutlineColor(.darkGray, for: .normal)
        uploadPartnershiptxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        uploadPartnershiptxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let partnershipUploadOptionsTap = UITapGestureRecognizer(target: self, action: #selector(partnershipUploadOptions))
        uploadPartnershiptxtFld?.addGestureRecognizer(partnershipUploadOptionsTap)
        uploadPartnershiptxtFld?.isUserInteractionEnabled = true
        
        registrationStateTxtFld?.label.text = "Registration State *"
        registrationStateTxtFld?.setOutlineColor(.darkGray, for: .normal)
        registrationStateTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        registrationStateTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        registrationStateTxtFld?.delegate = self
        registrationStateTxtFld?.inputView = UIView()
        
        registrationNoTxtFld?.label.text = "Registration No. *"
        registrationNoTxtFld?.setOutlineColor(.darkGray, for: .normal)
        registrationNoTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        registrationNoTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        uploadRegistrationCertifcatetxtFld?.label.text = "Upload Registration Certificate *"
        uploadRegistrationCertifcatetxtFld?.setOutlineColor(.darkGray, for: .normal)
        uploadRegistrationCertifcatetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        uploadRegistrationCertifcatetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let registrationCertificateUploadOptionsTap = UITapGestureRecognizer(target: self, action: #selector(registrationCertificateUploadOptions))
        uploadRegistrationCertifcatetxtFld?.addGestureRecognizer(registrationCertificateUploadOptionsTap)
        uploadRegistrationCertifcatetxtFld?.isUserInteractionEnabled = true
        
    }
    
    func updatePriorInvestmentFields() {
        let isYes = PriorInvestmenttxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "yes"
        
        ProjectNameStack?.isHidden = !isYes
        UnitNumberStack?.isHidden = !isYes
        
        if !isYes {
            ProjectNametxtFld?.text = EMPTY
            unitNumbertxtFld?.text = EMPTY
        }
    }
    
//    func clearAllFields() {
//        nameOfCompnaytxtFld?.text = EMPTY
//        dateOfIncorporationtxtFld?.text = EMPTY
//        nameOfContactPersontxtFld?.text = EMPTY
//        phoneNumberWorktxtFld?.text = EMPTY
//        mobileNumberetxtFld?.text = EMPTY
//        emailtxtFld?.text = EMPTY
//        PANNumbertxtFld?.text = EMPTY
//        PANUploadtxtFld?.text = EMPTY
//        corporateNumbertxtFld?.text = EMPTY
//        corporateNumberUploadtxtFld?.text = EMPTY
//        designatedPartnerIdentificationNumbertxtFld?.text = EMPTY
//        designatedPartnerIdentificationNumberUploadtxtFld?.text = EMPTY
//        PriorInvestmenttxtFld?.text = EMPTY
//        uploadCOItxtFld?.text = EMPTY
//        uploadResolutionTxtFld?.text = EMPTY
//        gstNotxtFld?.text = EMPTY
//        uploadGSTtxtFld?.text = EMPTY
//        boardResolutionDateTxtFld?.text = EMPTY
//        authorizationLetterDatetxtFld?.text = EMPTY
//        authorizationLetterUploadtxtFld?.text = EMPTY
//        partnershipDatetxtFld?.text = EMPTY
//        uploadPartnershiptxtFld?.text = EMPTY
//        registrationStateTxtFld?.text = EMPTY
//        registrationNoTxtFld?.text = EMPTY
//        uploadRegistrationCertifcatetxtFld?.text = EMPTY
//    }
    
    func clearAllFields() {

        // 1. Clear all text fields
        let textFields: [MDCOutlinedTextField?] = [
            nameOfCompnaytxtFld,
            dateOfIncorporationtxtFld,
            phoneNumberWorktxtFld,
            mobileNumberetxtFld,
            emailtxtFld,
            PANNumbertxtFld,
            PANUploadtxtFld,
            corporateNumbertxtFld,
            corporateNumberUploadtxtFld,
            designatedPartnerIdentificationNumbertxtFld,
            designatedPartnerIdentificationNumberUploadtxtFld,
            boardResolutionDateTxtFld,
            uploadResolutionTxtFld,
            gstNotxtFld,
            uploadGSTtxtFld,
            nameOfContactPersontxtFld,
            PriorInvestmenttxtFld,
            ProjectNametxtFld,
            unitNumbertxtFld,
            uploadCOItxtFld,
            authorizationLetterDatetxtFld,
            authorizationLetterUploadtxtFld,
            partnershipDatetxtFld,
            uploadPartnershiptxtFld,
            registrationStateTxtFld,
            registrationNoTxtFld,
            uploadRegistrationCertifcatetxtFld
        ]

        textFields.forEach { $0?.text = EMPTY }

        // 2. Reset conditional prior-investment fields
        ProjectNametxtFld?.text = EMPTY
        unitNumbertxtFld?.text = EMPTY

        ProjectNameStack?.isHidden = true
        UnitNumberStack?.isHidden = true

        // 3. Reset date pickers
        DOIDatePicker.date = Date()
        resolutionDatePicker.date = Date()
        authLetterDatePicker.date = Date()
        deedDatePicker.date = Date()

        // 4. Reset the active upload field
        activeUploadField = nil

        // 5. Reset primary selection flags
        isPrimaryYES = false
        isPrimaryNO = false

        // 6. Clear keyboard and dropdowns
        view.endEditing(true)
        priorInvestmentDropDown.hide()
        registrationStateDropDown.hide()

        print("Company details form reset successfully")
    }
    
    @objc func dateChangedForStart(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = formatter.string(from: sender.date)
        dateOfIncorporationtxtFld?.text = selectedDateString
    }
    
    @objc func dateChangedForDeedDate(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = formatter.string(from: sender.date)
        partnershipDatetxtFld?.text = selectedDateString
    }
    
    @objc func dateChangedForBoardResolution(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = formatter.string(from: sender.date)
        boardResolutionDateTxtFld?.text = selectedDateString
    }
    
    @objc func dateChangedForAuthorizationLetter(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = formatter.string(from: sender.date)
        authorizationLetterDatetxtFld?.text = selectedDateString
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
    
    func decryptedValue(_ value: String?) -> String {
        guard let value = value?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return ""
        }

        return DecryptDataFile.decryptValue(value) ?? ""
    }
    
    func validateCompanyFields() -> Bool {
        let companyName = nameOfCompnaytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dateOfIncorporation = dateOfIncorporationtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        var mobileNumber = EMPTY
        var email = EMPTY
        if !isForEditing {
            mobileNumber = mobileNumberetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            email = emailtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        } else {
            mobileNumber = DecryptDataFile.decryptValue(applicantRecord?.maskedData?.mobile?.defaultValue) ?? EMPTY
            email = DecryptDataFile.decryptValue(applicantRecord?.maskedData?.email?.defaultValue) ?? EMPTY
        }
        let panNumber = PANNumbertxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let panUpload = PANUploadtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let gstNo = gstNotxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let gstUpload = uploadGSTtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let resolutionDate = boardResolutionDateTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let resolutionUpload = uploadResolutionTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let cin = corporateNumbertxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let cinUpload = corporateNumberUploadtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if companyName.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Name of Company/Firm/LLP.")
            return false
        }
        
        if dateOfIncorporation.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Name of Date of Incorporation.")
            return false
        }
        
        if mobileNumber.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Mobile Number.")
            return false
        } else if !validation.isValidMobile(mobileNumber) {
            showAlert(with: "Validation Error", message: "Please enter a valid Mobile Number.")
            return false
        }
        
        if email.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Email ID.")
            return false
        } else if !validation.isValidEmail(email) {
            showAlert(with: "Validation Error", message: "Please enter a valid Email ID.")
            return false
        }
        
        if panNumber.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Company PAN Number.")
            return false
        } else if !validation.isValidPANNumber(panNumber) {
            showAlert(with: "Validation Error", message: "Please enter a valid PAN Number.")
            return false
        }
        
        if cin.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter CIN/LLPIN.")
            return false
        }
        
        let isPriorInvestmentYes =
            PriorInvestmenttxtFld?.text?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased() == "yes"

        if isPriorInvestmentYes {
            
            let projectName = ProjectNametxtFld?.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            let unitNumber = unitNumbertxtFld?.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            // Project Name mandatory
            if projectName.isEmpty {
                showAlert(
                    with: "Validation Error",
                    message: "Please enter Project Name."
                )
                return false
            }
            
            // Unit Number mandatory
            if unitNumber.isEmpty {
                showAlert(
                    with: "Validation Error",
                    message: "Please enter Unit Number."
                )
                return false
            }
            
            // Unit Number should be integer
            if Int(unitNumber) == nil {
                showAlert(
                    with: "Validation Error",
                    message: "Unit Number should contain only numbers."
                )
                return false
            }
        }

        if gstNo.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter GST Number.")
            return false
        }

        if resolutionDate.isEmpty {
            showAlert(with: "Validation Error", message: "Please select Board Resolution Date.")
            return false
        }
        
        if Defaults.type == "Partnership" || Defaults.type == "LLP" || Defaults.type == "HUF" {

            if authorizationLetterDatetxtFld?.text?.isEmpty ?? true {
                showAlert(with: "Validation Error", message: "Please select Authorization Letter Date.")
                return false
            }

            if partnershipDatetxtFld?.text?.isEmpty ?? true {
                showAlert(with: "Validation Error", message: "Please select Partnership/LLP/HUF Deed Date.")
                return false
            }
            
            if !isForEditing && !isLocalEdit {

                if authorizationLetterUploadtxtFld?.text?.isEmpty ?? true {

                    showAlert(with: "Validation Error", message: "Please upload Authorization Letter.")

                    return false

                }

                if uploadPartnershiptxtFld?.text?.isEmpty ?? true {

                    showAlert(with: "Validation Error", message: "Please upload Partnership/LLP/HUF Deed.")

                    return false

                }

            }

        }
        if !isForEditing && !isLocalEdit {
            if panUpload.isEmpty {
                showAlert(with: "Validation Error", message: "Please upload PAN document.")
                return false
            }
        }

        if !isForEditing && !isLocalEdit {
            if cinUpload.isEmpty {
                showAlert(with: "Validation Error", message: "Please upload CIN/LLPIN document.")
                return false
            }
        }

        if !isForEditing && !isLocalEdit {
            if gstUpload.isEmpty {
                showAlert(with: "Validation Error", message: "Please upload GST document.")
                return false
            }
        }

        if !isForEditing && !isLocalEdit {
            if resolutionUpload.isEmpty {
                showAlert(with: "Validation Error", message: "Please upload Resolution document.")
                return false
            }
        }
        return true
    }
    
//    @IBAction func backAction() {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @IBAction func backAction() {

        if isAddingNewApplicant {
            // Remove the newly-created empty applicant
            if let index = applicantIndex,
               index < OpportunityManager.shared.applicants.count {

                OpportunityManager.shared.applicants.remove(at: index)
            }

            // Go back to the screen before ApplicantListVC
            
                navigationController?.popViewController(animated: true)

        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func nextBtnAction() {
        guard validateCompanyFields() else { return }
        
        if applicantIndex == nil {

                let newApplicant = SaveModel(dict: [:])

                OpportunityManager.shared.applicants.append(newApplicant)

                applicantIndex = OpportunityManager.shared.applicants.count - 1

            }

            guard let index = applicantIndex else { return }

            var applicant = OpportunityManager.shared.getApplicant(at: index) ?? SaveModel(dict: [:])
        
        applicant.primary = true
        applicant.nameOfCompanyFirmLLP = nameOfCompnaytxtFld?.text
        applicant.dateOfIncorporation = dateOfIncorporationtxtFld?.text
        applicant.nameOfAuthorizedContactPerson = nameOfContactPersontxtFld?.text
        applicant.authorizedContactPersonPhone = mobileNumberetxtFld?.text
        applicant.authorizedContactPersonEmail = emailtxtFld?.text
        applicant.phoneWork = phoneNumberWorktxtFld?.text

        applicant.companyFirmLLPPAN = PANNumbertxtFld?.text
        applicant.corporateLLPIdentificationNumber = corporateNumbertxtFld?.text
        applicant.directorDesignatedPartnerIdenNo = designatedPartnerIdentificationNumbertxtFld?.text
        applicant.priorInvestmentInGaursGroupProject = PriorInvestmenttxtFld?.text
        applicant.priorInvestmentInExistingProject = ProjectNametxtFld?.text
        applicant.unitNumber = unitNumbertxtFld?.text
        applicant.gstNo = gstNotxtFld?.text
        applicant.boardResolutionDate = boardResolutionDateTxtFld?.text
        applicant.authorisationLetterDate = authorizationLetterDatetxtFld?.text
        applicant.partnershipLLPHUFDeedDate = partnershipDatetxtFld?.text
        applicant.registrationState = registrationStateTxtFld?.text
        applicant.registrationNo = registrationNoTxtFld?.text
        applicant.panUploadFileName = PANUploadtxtFld?.text
        applicant.cinUploadFileName = corporateNumberUploadtxtFld?.text
        applicant.dinUploadFileName = designatedPartnerIdentificationNumberUploadtxtFld?.text
        applicant.coiUploadFileName = uploadCOItxtFld?.text
        applicant.gstUploadFileName = uploadGSTtxtFld?.text
        applicant.resolutionUploadFileName = uploadResolutionTxtFld?.text
        applicant.authorizationLetterFileName = authorizationLetterUploadtxtFld?.text
        applicant.partnershipFileName = uploadPartnershiptxtFld?.text
        applicant.registrationCertificateFileName = uploadRegistrationCertifcatetxtFld?.text
        
        if let index = applicantIndex {
            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
        }
        
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let authorizationVC = storyboard.instantiateViewController(withIdentifier: "AuthorizationVC") as! AuthorizationVC
        authorizationVC.applicantIndex = applicantIndex
        authorizationVC.isFromCustomers = isFromCustomers
        authorizationVC.cuatomerDetailsDict = cuatomerDetailsDict
        authorizationVC.isLocalEdit = isLocalEdit
        authorizationVC.applicantDetailsModel = applicantDetailsModel
        if isForEditing {
            authorizationVC.isForEditing = isForEditing
            authorizationVC.applicantDetailsModel = applicantDetailsModel
        }
        self.navigationController?.pushViewController(authorizationVC, animated: true)
    }
}

    extension CompanyDetailsEOIScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
        
        @objc func openPanUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "PAN"
            showUploadOptions(sourceField: "PAN")
        }
        
        @objc func opencorporateNumberUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "CIN/LLPIN"
            showUploadOptions(sourceField: "CIN/LLPIN")
        }
        
        @objc func designatedPartnerIdentificationNumberUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "DIN/DPIN"
            showUploadOptions(sourceField: "DIN/DPIN")
        }
        
        @objc func COIUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "COI"
            showUploadOptions(sourceField: "COI")
        }
        
        @objc func ResolutionUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "Resolution"
            showUploadOptions(sourceField: "Resolution")
        }
        
        @objc func partnershipUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "Partnership"
            showUploadOptions(sourceField: "Partnership")
        }
        
        @objc func registrationCertificateUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "RegistrationCertificate"
            showUploadOptions(sourceField: "RegistrationCertificate")
        }
        
        @objc func authorizationLetterUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "AuthorizationLetter"
            showUploadOptions(sourceField: "AuthorizationLetter")
        }
        
        @objc func GSTUploadOptions() {
            if applicantIndex == nil {
                applicantIndex = 0
            }
            activeUploadField = "GST"
            showUploadOptions(sourceField: "GST")
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
                applicant.panUploadFileName = fileName

            case "CIN/LLPIN":
                corporateNumberUploadtxtFld?.text = "📄 \(fileName)"
                applicant.cinUploadFileName = fileName

            case "DIN/DPIN":
                designatedPartnerIdentificationNumberUploadtxtFld?.text = "📄 \(fileName)"
                applicant.dinUploadFileName = fileName

            case "COI":
                uploadCOItxtFld?.text = "📄 \(fileName)"
                applicant.coiUploadFileName = fileName

            case "GST":
                uploadGSTtxtFld?.text = "📄 \(fileName)"
                applicant.gstUploadFileName = fileName

            case "Resolution":
                uploadResolutionTxtFld?.text = "📄 \(fileName)"
                applicant.resolutionUploadFileName = fileName
                
            case "AuthorizationLetter":
                authorizationLetterUploadtxtFld?.text = "📄 \(fileName)"
                applicant.authorizationLetterFileName = fileName

            case "Partnership":
                uploadPartnershiptxtFld?.text = "📄 \(fileName)"
                applicant.partnershipFileName = fileName

            case "RegistrationCertificate":
                uploadRegistrationCertifcatetxtFld?.text = "📄 \(fileName)"
                applicant.registrationCertificateFileName = fileName

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

extension CompanyDetailsEOIScreenVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == PriorInvestmenttxtFld {
            showPriorInvestmentToDropdown()
            return false
        }
        if textField == registrationStateTxtFld {
            showRegistrationStateDropdown()
            return false
        }
        return true
    }
    
    func showPriorInvestmentToDropdown() {
        
        priorInvestmentDropDown.anchorView = PriorInvestmenttxtFld
        priorInvestmentDropDown.dataSource = ["Yes", "No"]
        
        priorInvestmentDropDown.selectionAction = { [weak self] (index, item) in
            self?.PriorInvestmenttxtFld?.text = item
            self?.updatePriorInvestmentFields()
        }
        priorInvestmentDropDown.show()
    }
    
    func showRegistrationStateDropdown() {
        guard !registrationStateValues.isEmpty else {
            print("⚠️ Registration state picklist values are empty")
            return
        }
       registrationStateDropDown.anchorView = registrationStateTxtFld
        registrationStateDropDown.dataSource = registrationStateValues
        registrationStateDropDown.selectionAction = { [weak self] (_, item) in
            self?.registrationStateTxtFld?.text = item
        }
        registrationStateDropDown.show()
    }
}


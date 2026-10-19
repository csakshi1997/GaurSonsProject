//
//  PersonalEOIScreenVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 26/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import SafariServices
import Extended

class PersonalEOIScreenVC: UIViewController {
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var pleaseNoteTopHeadingLbl: UILabel?
    @IBOutlet var CustomerDetailsVwHeight: NSLayoutConstraint?
    @IBOutlet var CustomerDetailsVw: UIView?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    @IBOutlet var residentTypetxtFld: MDCOutlinedTextField?
    
    @IBOutlet var salutationtxtFld: MDCOutlinedTextField?
    @IBOutlet var applicantPhotoUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var salutationForRelativetxtFld: MDCOutlinedTextField?
    @IBOutlet var relativeNametxtFld: MDCOutlinedTextField?
    
    @IBOutlet var uploadAdhartxtFld: MDCOutlinedTextField?
    @IBOutlet var uploadAdhartxtFldHeight: NSLayoutConstraint?
    @IBOutlet var passportNumbertxtFld: MDCOutlinedTextField?
    @IBOutlet var passportValiditytxtFld: MDCOutlinedTextField?
    @IBOutlet var passportUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var panNotxtFld: MDCOutlinedTextField?
    @IBOutlet var panUploadtxtFld: MDCOutlinedTextField?
    @IBOutlet var DOBtxtFld: MDCOutlinedTextField?
    @IBOutlet var maritalStatustxtFld: MDCOutlinedTextField?
    @IBOutlet var applicantNametxtFld: MDCOutlinedTextField?
    @IBOutlet var SDWtxtFld: MDCOutlinedTextField?
    @IBOutlet var emailtxtFld: MDCOutlinedTextField?
    @IBOutlet var mobiletxtFld: MDCOutlinedTextField?
    @IBOutlet var gendertxtFld: MDCOutlinedTextField?
    @IBOutlet var nationalitytxtFld: MDCOutlinedTextField?
    @IBOutlet var occupationtxtFld: MDCOutlinedTextField?
    @IBOutlet var phoneNumberHometxtFld: MDCOutlinedTextField?
    @IBOutlet var phoneNumberWorktxtFld: MDCOutlinedTextField?
    @IBOutlet var phoneNumberOthertxtFld: MDCOutlinedTextField?
    @IBOutlet var chooseAadharVerificationMethodLblStack: UILabel?
    @IBOutlet var verifyViaDigiLockerOrUploadAadharBtnsStack: UIStackView?
    @IBOutlet var sendBtnsStack: UIStackView?
    @IBOutlet var uploadAadharBtn: UIButton?
    @IBOutlet var verifyViaDigilockerBtn: UIButton?
    @IBOutlet var verifyBtn: UIButton?
    @IBOutlet var sendVerificationLinkBtn: UIButton?
    @IBOutlet var resetBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    @IBOutlet var primaryYESBtn: UIButton?
    @IBOutlet var primaryNOBtn: UIButton?
    @IBOutlet var customerDetailsYESBtn: UIButton?
    @IBOutlet var customerDetailsNOBtn: UIButton?
    @IBOutlet var relationUploadImgView: UIImageView?
    @IBOutlet var panUploadImgView: UIImageView?
    @IBOutlet var passportValidityImgView: UIImageView?
    @IBOutlet var passportUploadImgView: UIImageView?
    @IBOutlet var applicantUploadImgView: UIImageView?
    @IBOutlet var adhaarUploadImgView: UIImageView?
    var dobDatePicker = UIDatePicker()
    var passportValidityDatePicker = UIDatePicker()
    var isPrimaryYES: Bool = false
    var isPrimaryNO: Bool = false
    var isCustomerDetailsFillYES: Bool = false
    var isCustomerDetailsFillNO: Bool = false
    var isIndianType: Bool = true
    var validation = Validation()
    var fetchPickListValues = FetchPicklistValue()
    var residentTypeDropdown = DropDown()
    var genderDropdown = DropDown()
    var maritalStatusDropdown = DropDown()
    var SDWDropdown = DropDown()
    var nationalityDropdown = DropDown()
    var isVerifyViaDigiLocker: Bool = true
    var isVerifyViaUploadAdhar: Bool = false
    var applicantIndex: Int?
    let digilockerService = DigilockerService()
    var transactionId: String?
    var referenceId: String?
    var uploadedBase64: String?
    var currentUploadField: UploadField?
    var isFromCustomers: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var isForEditing: Bool = false
    var applicantRecord: ApplicantRecord?
    var isResidentIndian: Bool = false
    var isDoneVerifyViaDigiLocker: Bool = false
    var isDoneVerifyAadhaar: Bool = false
    var isOffline: Bool = false
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var isLocalEdit: Bool = false
    var salutationDropdown = DropDown()
    var relativeSalutationDropdown = DropDown()
    var salutationArr: [String] = []
    var relativeSalutationArr: [String] = []
    var addharDetailsDict: [String: Any] = [:]
    var isAddharVerify: Bool = false
    var isAddingNewApplicant: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
        if isForEditing {
            // SERVER EDIT
            Utility.getAllApplicantDetails(applicantId: applicantRecord?.id ?? EMPTY) { success in
                self.applicantDetailsModel = GlobalData.allApplicantDetailsModel
                if success {
                    DispatchQueue.main.async {
                        self.fillServerApplicantData()
                    }
                }
            }
        } else if isLocalEdit {
            // LOCAL EDIT
            self.fillLocalApplicantData()
        }
//        fillDummyData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            await FetchPicklistValue.shared.fetchPicklistValues(
                objectName: "Applicant_Details__c",
                fieldNames: [
                    "Resident_Type__c",
                    "Gender__c",
                    "Marital_Status__c",
                    "Son_of_Daughter_of_Wife_of__c",
                    "Nationality__c",
                    "Salutation__c",
                    "Salutation_for_Relative__c",
                    "Salutation_for_Authorised_Signatory__c"
                ]
            )

            await MainActor.run {

                self.salutationArr =
                    FetchPicklistValue.shared
                    .picklistOptionsDict["Salutation__c"]?
                    .map { $0.label } ?? []

                self.relativeSalutationArr =
                    FetchPicklistValue.shared
                    .picklistOptionsDict["Salutation_for_Relative__c"]?
                    .map { $0.label } ?? []

                print("Salutation:", self.salutationArr)
                print("Relative:", self.relativeSalutationArr)
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
    
    
    func fillDummyData() {
        
        residentTypetxtFld?.text = "Indian"
        
        panNotxtFld?.text = "ABCDE1234F"
        
        passportNumbertxtFld?.text = "N1234567"
        passportValiditytxtFld?.text = "2030-12-31"
        
        DOBtxtFld?.text = "1998-05-15"
                
        applicantNametxtFld?.text = "Sakshi Choudhary"
        
        SDWtxtFld?.text = "D/O"
        
        emailtxtFld?.text = "sakshi.demo@gmail.com"
        
        mobiletxtFld?.text = "9876543210"
        
        
        nationalitytxtFld?.text = "Indian"
        
        occupationtxtFld?.text = "Software Engineer"
        
        phoneNumberHometxtFld?.text = "0114567890"
        
        phoneNumberWorktxtFld?.text = "0124456789"
        
        phoneNumberOthertxtFld?.text = "9999999999"
        
    }
    
    func fillServerApplicantData() {
        if self.isForEditing {
            if self.applicantDetailsModel.primary ?? false {
                self.isPrimaryYES = true
                self.primaryYESBtn?.backgroundColor = UIColor(hex: "223B30")
                self.primaryYESBtn?.setTitleColor(.white, for: .normal)
                self.primaryNOBtn?.backgroundColor = UIColor(hex: "DFE1E0")
                self.primaryNOBtn?.setTitleColor(.black, for: .normal)
            } else {
                self.isPrimaryNO = true
                self.primaryYESBtn?.backgroundColor = UIColor(hex: "DFE1E0")
                self.primaryNOBtn?.setTitleColor(.white, for: .normal)
                self.primaryNOBtn?.backgroundColor = UIColor(hex: "223B30")
                self.primaryYESBtn?.setTitleColor(.black, for: .normal)
            }
            self.CustomerDetailsVwHeight?.constant = 0
            self.CustomerDetailsVw?.isHidden = true
            self.residentTypetxtFld?.text = self.applicantDetailsModel.residentType
            
            self.residentTypetxtFld?.isEnabled = false
            self.UIUpdateAccordingToPaymentMode(
                residentType: self.applicantDetailsModel.residentType ?? ""
            )
            //            self.relationUploadImgView?.isHidden = true
            //            UIUpdateAccordingToPaymentMode(residentType: self.applicantDetailsModel.residentType ?? EMPTY)
            self.passportNumbertxtFld?.text = self.applicantDetailsModel.passportNumber
            self.passportValiditytxtFld?.text = self.applicantDetailsModel.passportValidity
            self.adhaarUploadImgView?.isHidden = true
            self.passportUploadImgView?.isHidden = true
            self.panUploadImgView?.isHidden = true
            self.applicantUploadImgView?.isHidden = true
            self.panNotxtFld?.text = self.applicantDetailsModel.panNumber
            self.DOBtxtFld?.text = self.applicantDetailsModel.dob
            self.DOBtxtFld?.isEnabled = false
            self.maritalStatustxtFld?.text = self.applicantDetailsModel.maritalStatus
            self.applicantNametxtFld?.text = self.applicantDetailsModel.name
            self.applicantNametxtFld?.isEnabled = false
            self.SDWtxtFld?.text = self.applicantDetailsModel.relation
            self.emailtxtFld?.text = self.applicantDetailsModel.email
            self.mobiletxtFld?.text = self.applicantDetailsModel.mobileNumber
            self.gendertxtFld?.text = self.applicantDetailsModel.gender
            self.nationalitytxtFld?.text = self.applicantDetailsModel.nationality
            self.occupationtxtFld?.text = self.applicantDetailsModel.occupation
            self.phoneNumberHometxtFld?.text = self.applicantDetailsModel.phoneHome
            self.phoneNumberWorktxtFld?.text = self.applicantDetailsModel.phoneWork
            self.phoneNumberOthertxtFld?.text = self.applicantDetailsModel.phoneOther
            self.salutationtxtFld?.text = applicantDetailsModel.salutationForRelative
            self.salutationForRelativetxtFld?.text = applicantDetailsModel.salutationForRelative
            self.relativeNametxtFld?.text = applicantDetailsModel.fatherSpouseName
            self.relativeNametxtFld?.isEnabled = false
            verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = true
            sendBtnsStack?.isHidden = true
            chooseAadharVerificationMethodLblStack?.isHidden = true
            pleaseNoteTopHeadingLbl?.text = ""
            pleaseNoteTopHeadingLbl?.isHidden = true
            // Attachments cannot be edited
            
            uploadAdhartxtFld?.isHidden = true
            
            panUploadtxtFld?.isHidden = true
            
            passportUploadtxtFld?.isHidden = true
            
            applicantPhotoUploadtxtFld?.isHidden = true
            
            // Hide upload icons/images
            
            adhaarUploadImgView?.isHidden = true
            
            panUploadImgView?.isHidden = true
            
            passportUploadImgView?.isHidden = true
            
            applicantUploadImgView?.isHidden = true
            
            // Hide Aadhaar verification UI
            
            chooseAadharVerificationMethodLblStack?.isHidden = true
            
            verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = true
            
            sendBtnsStack?.isHidden = true
        }
    }
    
    func fillLocalApplicantData() {
        
        guard let index = applicantIndex,
              index < OpportunityManager.shared.applicants.count else {
            return
        }
        
        let applicant = OpportunityManager.shared.applicants[index]
        
        if applicant.primary ?? false {
            isPrimaryYES = true
            
            primaryYESBtn?.backgroundColor = UIColor(hex: "223B30")
            primaryYESBtn?.setTitleColor(.white, for: .normal)
            
            primaryNOBtn?.backgroundColor = UIColor(hex: "DFE1E0")
            primaryNOBtn?.setTitleColor(.black, for: .normal)
        } else {
            
            isPrimaryNO = true
            
            primaryNOBtn?.backgroundColor = UIColor(hex: "223B30")
            primaryNOBtn?.setTitleColor(.white, for: .normal)
            
            primaryYESBtn?.backgroundColor = UIColor(hex: "DFE1E0")
            primaryYESBtn?.setTitleColor(.black, for: .normal)
        }
        
        residentTypetxtFld?.text = applicant.residentType
        DOBtxtFld?.text = applicant.dob
        gendertxtFld?.text = applicant.gender
        maritalStatustxtFld?.text = applicant.maritalStatus
        nationalitytxtFld?.text = applicant.nationality
        applicantNametxtFld?.text = applicant.name
        panNotxtFld?.text = applicant.panNumber
        panUploadtxtFld?.text = applicant.panUploadFileName
        passportUploadtxtFld?.text = applicant.passportUploadFileName
        uploadAdhartxtFld?.text = applicant.aadhaarUploadFileName
        passportNumbertxtFld?.text = applicant.passportNumber
        occupationtxtFld?.text = applicant.occupation
        SDWtxtFld?.text = applicant.relation
        phoneNumberHometxtFld?.text = applicant.phoneHome
        emailtxtFld?.text = applicant.applicantEmail
        phoneNumberWorktxtFld?.text = applicant.phoneWork
        mobiletxtFld?.text = applicant.applicantMobile
        phoneNumberOthertxtFld?.text = applicant.phoneOther
        salutationtxtFld?.text = applicant.salutation
        applicantPhotoUploadtxtFld?.text = applicant.applicantPhotoFileName
        salutationForRelativetxtFld?.text = applicant.salutationForRelative
        relativeNametxtFld?.text = applicant.relativeName
        
        if applicant.residentType == "Indian" {
            isIndianType = true
        } else {
            isIndianType = false
        }
        
        UIUpdateAccordingToPaymentMode(
            residentType: applicant.residentType ?? ""
        )
    }
    
    func setUpInitialUI() {
        UIUpdateAccordingToPaymentMode(residentType: "Indian")
        residentTypetxtFld?.text = "Indian"
//        chooseAadharVerificationMethodLblStack?.isHidden = false
//        verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = false
//        sendBtnsStack?.isHidden = false
//        panNotxtFld?.isHidden = false
//        panUploadtxtFld?.isHidden = false
//        panUploadImgView?.isHidden = false
//        isResidentIndian = true
//        if isOffline {
//            chooseAadharVerificationMethodLblStack?.isHidden = true
//            verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = true
//            sendBtnsStack?.isHidden = true
//        } else {
//            chooseAadharVerificationMethodLblStack?.isHidden = false
//            verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = false
//            sendBtnsStack?.isHidden = false
//            panNotxtFld?.isHidden = false
//            panUploadtxtFld?.isHidden = false
//            panUploadImgView?.isHidden = false
//            isResidentIndian = true
//        }
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        if Defaults.isOpportunityIDPresent ?? false {
            Defaults.isIndividualEnable = true
        }
        if Defaults.isIndividualEnable ?? false {
            pageNumberLbl?.text = "1"
            OutOfPageNumber?.text = "7"
        }
        adhaarUploadImgView?.isHidden = true
        uploadAdhartxtFld?.isHidden = true
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        resetBtn?.borderWidth = 1
        resetBtn?.borderColor = UIColor(hex: "DFE1E0")
        resetBtn?.layer.cornerRadius = 6
        nextBtn?.layer.cornerRadius = 6
        primaryYESBtn?.borderWidth = 1
        primaryYESBtn?.borderColor = UIColor(hex: "DFE1E0")
        primaryYESBtn?.layer.cornerRadius = 6
        customerDetailsYESBtn?.borderWidth = 1
        customerDetailsYESBtn?.borderColor = UIColor(hex: "DFE1E0")
        customerDetailsYESBtn?.layer.cornerRadius = 6
        customerDetailsNOBtn?.borderWidth = 1
        customerDetailsNOBtn?.borderColor = UIColor(hex: "DFE1E0")
        customerDetailsNOBtn?.layer.cornerRadius = 6
        primaryNOBtn?.borderWidth = 1
        primaryNOBtn?.borderColor = UIColor(hex: "DFE1E0")
        primaryNOBtn?.layer.cornerRadius = 6
        sendVerificationLinkBtn?.layer.cornerRadius = 6
        verifyBtn?.layer.cornerRadius = 6
        verifyBtn?.borderWidth = 1
        verifyBtn?.borderColor = UIColor(hex: "DFE1E0")
        
        residentTypetxtFld?.label.text = "Resident Type *"
        residentTypetxtFld?.setOutlineColor(.darkGray, for: .normal)
        residentTypetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        residentTypetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        
        uploadAdhartxtFld?.label.text = "Aadhaar Upload "
        uploadAdhartxtFld?.setOutlineColor(.darkGray, for: .normal)
        uploadAdhartxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        uploadAdhartxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let adharTap = UITapGestureRecognizer(target: self, action: #selector(openAadhaarUploadOptions))
        uploadAdhartxtFld?.addGestureRecognizer(adharTap)
        uploadAdhartxtFld?.isUserInteractionEnabled = true
        
        panNotxtFld?.label.text = "PAN No. *"
        panNotxtFld?.setOutlineColor(.darkGray, for: .normal)
        panNotxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        panNotxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        panUploadtxtFld?.label.text = "Pan Upload *"
        panUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        panUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        panUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let panTap = UITapGestureRecognizer(target: self, action: #selector(openPanUploadOptions))
        panUploadtxtFld?.addGestureRecognizer(panTap)
        panUploadtxtFld?.isUserInteractionEnabled = true
        
//        passportNumbertxtFld?.isHidden = false
//        passportValiditytxtFld?.isHidden = false
//        passportUploadtxtFld?.isHidden = false
        
        passportNumbertxtFld?.label.text = "Passport No. *"
        passportNumbertxtFld?.setOutlineColor(.darkGray, for: .normal)
        passportNumbertxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        passportNumbertxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        passportValiditytxtFld?.label.text = "Passport Validity *"
        passportValiditytxtFld?.setOutlineColor(.darkGray, for: .normal)
        passportValiditytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        passportValiditytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        passportValidityDatePicker.datePickerMode = .date
        passportValidityDatePicker.preferredDatePickerStyle = .wheels
        passportValidityDatePicker.addTarget(self, action: #selector(dateChangedForPassportValidity(_:)), for: .valueChanged)
        passportValiditytxtFld?.inputView = passportValidityDatePicker
        
        passportUploadtxtFld?.label.text = "Passport Upload *"
        passportUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        passportUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        passportUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let passportTap = UITapGestureRecognizer(target: self, action: #selector(openPassportUploadOptions))
        passportUploadtxtFld?.addGestureRecognizer(passportTap)
        passportUploadtxtFld?.isUserInteractionEnabled = true
        
        DOBtxtFld?.label.text = "DOB *"
        DOBtxtFld?.setOutlineColor(.darkGray, for: .normal)
        DOBtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        DOBtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        dobDatePicker.datePickerMode = .date
        dobDatePicker.preferredDatePickerStyle = .wheels
        dobDatePicker.addTarget(self, action: #selector(dateChangedForStart(_:)), for: .valueChanged)
        DOBtxtFld?.inputView = dobDatePicker
        
        maritalStatustxtFld?.label.text = "Marital Status"
        maritalStatustxtFld?.setOutlineColor(.darkGray, for: .normal)
        maritalStatustxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        maritalStatustxtFld?.translatesAutoresizingMaskIntoConstraints = false
        maritalStatustxtFld?.delegate = self
        maritalStatustxtFld?.inputView = UIView()
        
        salutationtxtFld?.label.text = "Salutation *"
        salutationtxtFld?.setOutlineColor(.darkGray, for: .normal)
        salutationtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        salutationtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        salutationtxtFld?.delegate = self
        salutationtxtFld?.inputView = UIView()
        
        applicantNametxtFld?.label.text = "Applicant Name *"
        applicantNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        applicantNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        applicantNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        applicantPhotoUploadtxtFld?.label.text = "Applicant Upload *"
        applicantPhotoUploadtxtFld?.setOutlineColor(.darkGray, for: .normal)
        applicantPhotoUploadtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        applicantPhotoUploadtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let applicantTap = UITapGestureRecognizer(target: self, action: #selector(openApplicantUploadOptions))
        applicantPhotoUploadtxtFld?.addGestureRecognizer(applicantTap)
        passportUploadtxtFld?.isUserInteractionEnabled = true
        
        SDWtxtFld?.label.text = "Relation *"
        SDWtxtFld?.setOutlineColor(.darkGray, for: .normal)
        SDWtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        SDWtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        SDWtxtFld?.delegate = self
        SDWtxtFld?.inputView = UIView()
        
        salutationForRelativetxtFld?.label.text = "Salutation for Relative *"
        salutationForRelativetxtFld?.setOutlineColor(.darkGray, for: .normal)
        salutationForRelativetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        salutationForRelativetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        salutationForRelativetxtFld?.delegate = self
        salutationForRelativetxtFld?.inputView = UIView()
        
        relativeNametxtFld?.label.text = "Name of Relative *"
        relativeNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        relativeNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        relativeNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        emailtxtFld?.label.text = "Email ID *"
        emailtxtFld?.setOutlineColor(.darkGray, for: .normal)
        emailtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        emailtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        mobiletxtFld?.label.text = "Mobile *"
        mobiletxtFld?.setOutlineColor(.darkGray, for: .normal)
        mobiletxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        mobiletxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        gendertxtFld?.label.text = "Gender"
        gendertxtFld?.setOutlineColor(.darkGray, for: .normal)
        gendertxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        gendertxtFld?.translatesAutoresizingMaskIntoConstraints = false
        gendertxtFld?.delegate = self
        gendertxtFld?.inputView = UIView()
        
        nationalitytxtFld?.label.text = "Nationality"
        nationalitytxtFld?.setOutlineColor(.darkGray, for: .normal)
        nationalitytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        nationalitytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        occupationtxtFld?.label.text = "Occupation"
        occupationtxtFld?.setOutlineColor(.darkGray, for: .normal)
        occupationtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        occupationtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        phoneNumberHometxtFld?.label.text = "Phone Number (Home)"
        phoneNumberHometxtFld?.setOutlineColor(.darkGray, for: .normal)
        phoneNumberHometxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        phoneNumberHometxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        phoneNumberWorktxtFld?.label.text = "Phone Number (Work)"
        phoneNumberWorktxtFld?.setOutlineColor(.darkGray, for: .normal)
        phoneNumberWorktxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        phoneNumberWorktxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        phoneNumberOthertxtFld?.label.text = "Phone Number (Any Other)"
        phoneNumberOthertxtFld?.setOutlineColor(.darkGray, for: .normal)
        phoneNumberOthertxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        phoneNumberOthertxtFld?.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    func clearAllFields() {
//        residentTypetxtFld?.text = ""
//        panNotxtFld?.text = ""
//        panUploadtxtFld?.text = ""
//        passportNumbertxtFld?.text = ""
//        passportValiditytxtFld?.text = ""
//        DOBtxtFld?.text = ""
//        maritalStatustxtFld?.text = ""
//        applicantNametxtFld?.text = ""
//        SDWtxtFld?.text = ""
//        emailtxtFld?.text = ""
//        mobiletxtFld?.text = ""
//        gendertxtFld?.text = ""
//        nationalitytxtFld?.text = ""
//        occupationtxtFld?.text = ""
//        phoneNumberHometxtFld?.text = ""
//        phoneNumberWorktxtFld?.text = ""
//        phoneNumberOthertxtFld?.text = ""
//        residentTypetxtFld?.isEnabled = true
//        panNotxtFld?.isEnabled = true
//        panUploadtxtFld?.isEnabled = true
//        passportNumbertxtFld?.isEnabled = true
//        passportValiditytxtFld?.isEnabled = true
//        DOBtxtFld?.isEnabled = true
//        maritalStatustxtFld?.isEnabled = true
//        applicantNametxtFld?.isEnabled = true
//        SDWtxtFld?.isEnabled = true
//        emailtxtFld?.isEnabled = true
//        mobiletxtFld?.isEnabled = true
//        gendertxtFld?.isEnabled = true
//        nationalitytxtFld?.isEnabled = true
//        occupationtxtFld?.isEnabled = true
//        phoneNumberHometxtFld?.isEnabled = true
//        phoneNumberWorktxtFld?.isEnabled = true
//        phoneNumberOthertxtFld?.isEnabled = true
//        salutationtxtFld?.text = ""
//        applicantPhotoUploadtxtFld?.text = ""
//        salutationForRelativetxtFld?.text = ""
//        relativeNametxtFld?.text = ""
//        salutationtxtFld?.isEnabled = true
//        applicantPhotoUploadtxtFld?.isEnabled = true
//        salutationForRelativetxtFld?.isEnabled = true
//        relativeNametxtFld?.isEnabled = true
//        
//    }
    
    func clearAllFields() {

        // MARK: - Clear all text fields
        let textFields: [MDCOutlinedTextField?] = [
            residentTypetxtFld,
            salutationtxtFld,
            applicantPhotoUploadtxtFld,
            salutationForRelativetxtFld,
            relativeNametxtFld,
            uploadAdhartxtFld,
            passportNumbertxtFld,
            passportValiditytxtFld,
            passportUploadtxtFld,
            panNotxtFld,
            panUploadtxtFld,
            DOBtxtFld,
            maritalStatustxtFld,
            applicantNametxtFld,
            SDWtxtFld,
            emailtxtFld,
            mobiletxtFld,
            gendertxtFld,
            nationalitytxtFld,
            occupationtxtFld,
            phoneNumberHometxtFld,
            phoneNumberWorktxtFld,
            phoneNumberOthertxtFld
        ]

        textFields.forEach {
            $0?.text = ""
            $0?.isEnabled = true
        }

        // MARK: - Reset primary applicant selection
        isPrimaryYES = false
        isPrimaryNO = false

        primaryYESBtn?.backgroundColor = UIColor(hex: "DFE1E0")
        primaryYESBtn?.setTitleColor(.black, for: .normal)

        primaryNOBtn?.backgroundColor = UIColor(hex: "DFE1E0")
        primaryNOBtn?.setTitleColor(.black, for: .normal)

        // MARK: - Reset customer details selection
        isCustomerDetailsFillYES = false
        isCustomerDetailsFillNO = false

        customerDetailsYESBtn?.backgroundColor = UIColor(hex: "DFE1E0")
        customerDetailsYESBtn?.setTitleColor(.black, for: .normal)

        customerDetailsNOBtn?.backgroundColor = UIColor(hex: "DFE1E0")
        customerDetailsNOBtn?.setTitleColor(.black, for: .normal)

        // MARK: - Reset resident type
        isIndianType = true
        isResidentIndian = false

        // MARK: - Reset Aadhaar verification
        isVerifyViaDigiLocker = true
        isVerifyViaUploadAdhar = false
        isDoneVerifyViaDigiLocker = false
        isDoneVerifyAadhaar = false
        isAddharVerify = false

        transactionId = nil
        referenceId = nil
        uploadedBase64 = nil
        addharDetailsDict.removeAll()

        verifyViaDigilockerBtn?.setImage(
            UIImage(named: "RodioUnselected"),
            for: .normal
        )

        uploadAadharBtn?.setImage(
            UIImage(named: "RodioUnselected"),
            for: .normal
        )

        verifyBtn?.setTitle("Verify", for: .normal)
        verifyBtn?.backgroundColor = .white
        verifyBtn?.setTitleColor(.black, for: .normal)
        verifyBtn?.borderColor = UIColor(hex: "DFE1E0")
        verifyBtn?.isEnabled = true

        sendVerificationLinkBtn?.setTitle(
            "Send Verification Link",
            for: .normal
        )
//        sendVerificationLinkBtn?.backgroundColor = ColorConstant.systesm

        // MARK: - Reset conditional fields
        UIUpdateAccordingToPaymentMode(residentType: "")

        // MARK: - Reset upload images
        adhaarUploadImgView?.isHidden = true

        // MARK: - Reset date pickers
        dobDatePicker.date = Date()
        passportValidityDatePicker.date = Date()

        // MARK: - Reset customer details section
        if isFromCustomers {
            CustomerDetailsVwHeight?.constant = 75
            CustomerDetailsVw?.isHidden = false
        } else {
            CustomerDetailsVwHeight?.constant = 0
            CustomerDetailsVw?.isHidden = true
        }

        view.endEditing(true)
    }
    
    func forCustomerDetailsUI() {
        if isFromCustomers {
            print(cuatomerDetailsDict)
            CustomerDetailsVwHeight?.constant = 75
            CustomerDetailsVw?.isHidden = false
            //            residentTypetxtFld?.text = cuatomerDetailsDict
            //            panNotxtFld?.text = cuatomerDetailsDict.pa
            panUploadtxtFld?.text = ""
            //            passportNumbertxtFld?.text = cuatomerDetailsDic
            passportValiditytxtFld?.text = ""
            DOBtxtFld?.text = cuatomerDetailsDict?.dateOfBirth
            //            maritalStatustxtFld?.text = cuatomerDetailsDict.
            applicantNametxtFld?.text = cuatomerDetailsDict?.name
            //            SDWtxtFld?.text = cuatomerDetailsDict.
            emailtxtFld?.text = cuatomerDetailsDict?.email
            mobiletxtFld?.text = cuatomerDetailsDict?.mobile
            gendertxtFld?.text = cuatomerDetailsDict?.gender
            relativeNametxtFld?.text = cuatomerDetailsDict?.careOf
            //            nationalitytxtFld?.text = cuatomerDetailsDict
            //            occupationtxtFld?.text = cuatomerDetailsDict.
            phoneNumberHometxtFld?.text = ""
            phoneNumberWorktxtFld?.text = ""
            phoneNumberOthertxtFld?.text = ""
            
            // Array of all your text fields
            let textFields: [UITextField?] = [
                residentTypetxtFld,
                panNotxtFld,
                panUploadtxtFld,
                passportNumbertxtFld,
                passportValiditytxtFld,
                DOBtxtFld,
                maritalStatustxtFld,
                applicantNametxtFld,
                SDWtxtFld,
                emailtxtFld,
                mobiletxtFld,
                gendertxtFld,
                nationalitytxtFld,
                occupationtxtFld,
                phoneNumberHometxtFld,
                phoneNumberWorktxtFld,
                phoneNumberOthertxtFld,
                salutationtxtFld,
                applicantPhotoUploadtxtFld,
                salutationForRelativetxtFld,
                relativeNametxtFld
            ]
            
            for textField in textFields {
                if let tf = textField {
                    if let text = tf.text, !text.isEmpty {
                        tf.isEnabled = false
                    } else {
                        tf.isEnabled = true
                    }
                }
            }
            
        } else {
//            CustomerDetailsVw?.isHidden = true
            residentTypetxtFld?.text = ""
            panNotxtFld?.text = ""
            panUploadtxtFld?.text = ""
            passportNumbertxtFld?.text = ""
            passportValiditytxtFld?.text = ""
            DOBtxtFld?.text = ""
            maritalStatustxtFld?.text = ""
            applicantNametxtFld?.text = ""
            SDWtxtFld?.text = ""
            emailtxtFld?.text = ""
            mobiletxtFld?.text = ""
            gendertxtFld?.text = ""
            nationalitytxtFld?.text = ""
            occupationtxtFld?.text = ""
            phoneNumberHometxtFld?.text = ""
            phoneNumberWorktxtFld?.text = ""
            phoneNumberOthertxtFld?.text = ""
            salutationtxtFld?.text = ""
            applicantPhotoUploadtxtFld?.text = ""
            salutationForRelativetxtFld?.text = ""
            relativeNametxtFld?.text = ""
        }
    }
    
    @objc func dateChangedForStart(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = formatter.string(from: sender.date)
        DOBtxtFld?.text = selectedDateString
    }
    
    @objc func dateChangedForPassportValidity(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = formatter.string(from: sender.date)
        passportValiditytxtFld?.text = selectedDateString
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
    
    @IBAction func primaryAction(_ sender: UIButton) {
        
        if sender.tag == 11 {
            
            // Check whether another applicant is already Primary
            if isAnotherApplicantPrimary() {
                
                // Keep current applicant as NO
                isPrimaryYES = false
                isPrimaryNO = true
                
                primaryYESBtn?.backgroundColor = UIColor(hex: "DFE1E0")
                primaryYESBtn?.setTitleColor(.black, for: .normal)
                
                primaryNOBtn?.backgroundColor = UIColor(hex: "223B30")
                primaryNOBtn?.setTitleColor(.white, for: .normal)
                
                showAlert(
                    with: "Primary Applicant",
                    message: "Only one applicant can be marked as Primary."
                )
                
                return
            }
            
            // No other primary applicant → allow YES
            isPrimaryYES = true
            isPrimaryNO = false
            
            primaryYESBtn?.backgroundColor = UIColor(hex: "223B30")
            primaryYESBtn?.setTitleColor(.white, for: .normal)
            
            primaryNOBtn?.backgroundColor = UIColor(hex: "DFE1E0")
            primaryNOBtn?.setTitleColor(.black, for: .normal)
            
        } else if sender.tag == 12 {
            
            // Primary NO is always allowed
            isPrimaryYES = false
            isPrimaryNO = true
            
            primaryYESBtn?.backgroundColor = UIColor(hex: "DFE1E0")
            primaryYESBtn?.setTitleColor(.black, for: .normal)
            
            primaryNOBtn?.backgroundColor = UIColor(hex: "223B30")
            primaryNOBtn?.setTitleColor(.white, for: .normal)
        }
    }
        
//    @IBAction func CustomerDetailsAction(_ sender: UIButton) {
//        
//        isCustomerDetailsFillNO = false
//        isCustomerDetailsFillYES = false
//        
//        if sender.tag == 21 {
//            
//            // Customer Details: YES
//            isCustomerDetailsFillYES = true
//            
//            customerDetailsYESBtn?.backgroundColor = UIColor(hex: "223B30")
//            customerDetailsYESBtn?.setTitleColor(.white, for: .normal)
//            customerDetailsNOBtn?.backgroundColor = UIColor(hex: "DFE1E0")
//            customerDetailsNOBtn?.setTitleColor(.black, for: .normal)
//            
//            forCustomerDetailsUI()
//            
//            // Update UI according to the selected resident type
//            UIUpdateAccordingToPaymentMode(
//                residentType: residentTypetxtFld?.text ?? ""
//            )
//            
//        } else if sender.tag == 22 {
//            
//            // Customer Details: NO
//            isCustomerDetailsFillNO = true
//            
//            customerDetailsYESBtn?.backgroundColor = UIColor(hex: "DFE1E0")
//            customerDetailsNOBtn?.setTitleColor(.white, for: .normal)
//            customerDetailsNOBtn?.backgroundColor = UIColor(hex: "223B30")
//            customerDetailsYESBtn?.setTitleColor(.black, for: .normal)
//            
//            clearAllFields()
//            
//            // Clear resident type state
//            isIndianType = false
//            isResidentIndian = false
//            
//            // Hide Aadhaar verification and PAN/passport fields
//            UIUpdateAccordingToPaymentMode(residentType: "")
//            
//            chooseAadharVerificationMethodLblStack?.isHidden = true
//            verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = true
//            sendBtnsStack?.isHidden = true
//        }
//    }
    
    @IBAction func CustomerDetailsAction(_ sender: UIButton) {

        if sender.tag == 21 {

            // Customer Details: YES
            isCustomerDetailsFillYES = true
            isCustomerDetailsFillNO = false

            customerDetailsYESBtn?.backgroundColor = UIColor(hex: "223B30")
            customerDetailsYESBtn?.setTitleColor(.white, for: .normal)

            customerDetailsNOBtn?.backgroundColor = UIColor(hex: "DFE1E0")
            customerDetailsNOBtn?.setTitleColor(.black, for: .normal)

            // Fill customer details without disabling Resident Type.
            forCustomerDetailsUI()

            // Keep Resident Type selectable.
            residentTypetxtFld?.isEnabled = true

        } else if sender.tag == 22 {

            // Customer Details: NO
            clearAllFields()

            // Set selection AFTER clearAllFields(), because that method resets these flags.
            isCustomerDetailsFillYES = false
            isCustomerDetailsFillNO = true

            customerDetailsYESBtn?.backgroundColor = UIColor(hex: "DFE1E0")
            customerDetailsYESBtn?.setTitleColor(.black, for: .normal)

            customerDetailsNOBtn?.backgroundColor = UIColor(hex: "223B30")
            customerDetailsNOBtn?.setTitleColor(.white, for: .normal)

            // Allow the user to select Resident Type.
            residentTypetxtFld?.isEnabled = true
        }

        // Reapply the UI rules after either selection.
        UIUpdateAccordingToPaymentMode(
            residentType: residentTypetxtFld?.text ?? ""
        )
    }
    
    func decryptedValue(_ value: String?) -> String {

        guard let value = value?

            .trimmingCharacters(in: .whitespacesAndNewlines),

              !value.isEmpty else {

            return ""

        }

        return DecryptDataFile.decryptValue(value) ?? ""

    }
    
    func validateRequiredFields() -> Bool {
        let applicantName = applicantNametxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let dob = DOBtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        var mobileNumber = EMPTY
        var email = EMPTY
        if !isForEditing {
            if isCustomerDetailsFillYES {
                mobileNumber = DecryptDataFile.decryptValue(cuatomerDetailsDict?.maskedData?.mobile?.defaultValue) ?? EMPTY
                email = DecryptDataFile.decryptValue(cuatomerDetailsDict?.maskedData?.email?.defaultValue) ?? EMPTY
            } else {
                mobileNumber = mobiletxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                email = emailtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
        } else {
            mobileNumber = mobiletxtFld?.text ?? EMPTY
            email = emailtxtFld?.text ?? EMPTY
        }
        let passportNo = passportNumbertxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let passportValidity = passportValiditytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let passportUpload = passportUploadtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let salutation = salutationtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let applicantPhoto = applicantPhotoUploadtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let relativeName = relativeNametxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let relativeSalutation = salutationForRelativetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if applicantName.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Applicant Name.")
            return false
        }
        
        if dob.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter your Date of Birth.")
            return false
        }
        
        if let dobDate = CustomDateFormatter().dateFromString(dob) {

            let today = Calendar.current.startOfDay(for: Date())

            let selectedDOB = Calendar.current.startOfDay(for: dobDate)

            if selectedDOB >= today {

                showAlert(

                    with: "Validation Error",

                    message: "Date of Birth cannot be today or a future date."

                )

                return false

            }

        }
        
        if email.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Email ID.")
            return false
        }
        let isMaskedEmail = email.contains("*")
        if !isMaskedEmail && !validation.isValidEmail(email) {
            showAlert(with: "Validation Error", message: "Please enter a valid Email ID.")
            return false
        }
        if mobileNumber.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter Mobile number.")
            return false
        } else if mobileNumber.count < 10 {
            showAlert(with: "Validation Error", message: "Please enter a valid 10-digit Mobile number.")
            return false
        }
        if !isIndianType {

            if passportNo.isEmpty {
                showAlert(
                    with: "Validation Error",
                    message: "Please enter Passport Number."
                )
                return false
            }

            if passportValidity.isEmpty {
                showAlert(
                    with: "Validation Error",
                    message: "Please select Passport Validity date."
                )
                return false
            }

            if let passportDate = CustomDateFormatter().dateFromString(passportValidity) {
                let today = Calendar.current.startOfDay(for: Date())
                let selectedPassportDate = Calendar.current.startOfDay(for: passportDate)

                if selectedPassportDate < today {
                    showAlert(
                        with: "Validation Error",
                        message: "Passport Validity cannot be a past date."
                    )
                    return false
                }
            }

            if !isForEditing {
                if passportUpload.isEmpty {
                    showAlert(
                        with: "Validation Error",
                        message: "Please upload Passport document."
                    )
                    return false
                }
            }
        }
//        if isIndianType {
//            let panNumber = panNotxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//            let panUpload = panUploadtxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//            if !isOffline {
//                if panNumber.isEmpty {
//                    showAlert(with: "Validation Error", message: "Please enter PAN Number.")
//                    return false
//                } else if !validation.isValidPANNumber(panNumber) {
//                    showAlert(with: "Validation Error", message: "Please enter a valid PAN Number.")
//                    return false
//                }
//                if !isForEditing {
//                    
//                    if panUpload.isEmpty {
//                        showAlert(with: "Validation Error", message: "Please upload PAN document.")
//                        return false
//                    }
//                }
//            }
//        }
        let residentType = residentTypetxtFld?.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let isIndianResident = residentType.caseInsensitiveCompare("Indian") == .orderedSame

        if isIndianResident && !isOffline {

            let panNumber = panNotxtFld?.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let panUpload = panUploadtxtFld?.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            if panNumber.isEmpty {
                showAlert(with: "Validation Error", message: "Please enter PAN Number.")
                return false
            } else if !validation.isValidPANNumber(panNumber) {
                showAlert(with: "Validation Error", message: "Please enter a valid PAN Number.")
                return false
            }

            if !isForEditing && panUpload.isEmpty {
                showAlert(with: "Validation Error", message: "Please upload PAN document.")
                return false
            }
        }
        if salutation.isEmpty {
            showAlert(with: "Validation Error",
                      message: "Please select Salutation.")
            return false
        }
        
        if !isForEditing {
            if applicantPhoto.isEmpty {
                showAlert(with: "Validation Error",
                          message: "Please upload Applicant Photo.")
                return false
            }
        }

        if relativeSalutation.isEmpty {
            showAlert(with: "Validation Error",
                      message: "Please select Relative Salutation.")
            return false
        }

        if relativeName.isEmpty {
            showAlert(with: "Validation Error",
                      message: "Please enter Relative Name.")
            return false
        }
        return true
    }
        
//    func UIUpdateAccordingToPaymentMode(residentType: String) {
//        let resident = residentType.trimmingCharacters(in: .whitespacesAndNewlines)
//        let isIndian = resident.caseInsensitiveCompare("Indian") == .orderedSame
//        
//        // Update resident type state
//        isIndianType = isIndian
//        isResidentIndian = isIndian
//        
//        // Hide all conditional fields initially
//        passportNumbertxtFld?.isHidden = true
//        passportValiditytxtFld?.isHidden = true
//        passportUploadtxtFld?.isHidden = true
//        passportValidityImgView?.isHidden = true
//        passportUploadImgView?.isHidden = true
//        
//        panNotxtFld?.isHidden = true
//        panUploadtxtFld?.isHidden = true
//        panUploadImgView?.isHidden = true
//        
//        chooseAadharVerificationMethodLblStack?.isHidden = true
//        verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = true
//        sendBtnsStack?.isHidden = true
//        
//        // If resident type is empty, hide all related fields
//        guard !resident.isEmpty else {
//            return
//        }
//        
//        // Indian resident
//        if isIndian {
//            
//            if !isOffline {
//                
//                chooseAadharVerificationMethodLblStack?.isHidden = false
//                verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = false
//                sendBtnsStack?.isHidden = false
//                
//                panNotxtFld?.isHidden = false
//                panUploadtxtFld?.isHidden = false
//                panUploadImgView?.isHidden = false
//            }
//            
//        } else {
//            
//            // NRI / non-Indian resident
//            passportNumbertxtFld?.isHidden = false
//            passportValiditytxtFld?.isHidden = false
//            passportUploadtxtFld?.isHidden = false
//            passportValidityImgView?.isHidden = false
//            passportUploadImgView?.isHidden = false
//        }
//    }
    
    func UIUpdateAccordingToPaymentMode(residentType: String) {

        let resident = residentType.trimmingCharacters(in: .whitespacesAndNewlines)
        let isIndian = resident.caseInsensitiveCompare("Indian") == .orderedSame

        // Update resident type state.
        isIndianType = isIndian
        isResidentIndian = isIndian

        // Hide conditional fields initially.
        passportNumbertxtFld?.isHidden = true
        passportValiditytxtFld?.isHidden = true
        passportUploadtxtFld?.isHidden = true
        passportValidityImgView?.isHidden = true
        passportUploadImgView?.isHidden = true

        panNotxtFld?.isHidden = true
        panUploadtxtFld?.isHidden = true
        panUploadImgView?.isHidden = true

        // Hide Aadhaar verification initially.
        chooseAadharVerificationMethodLblStack?.isHidden = true
        verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = true
        sendBtnsStack?.isHidden = true

        // No resident type selected.
        guard !resident.isEmpty else {
            return
        }

        if isIndian {

            // Indian resident: show PAN fields.
            panNotxtFld?.isHidden = false
            panUploadtxtFld?.isHidden = false
            panUploadImgView?.isHidden = false

            // Show Aadhaar verification only when Customer Details is NOT YES.
            if !isCustomerDetailsFillYES && !isOffline && !isForEditing {
                chooseAadharVerificationMethodLblStack?.isHidden = false
                verifyViaDigiLockerOrUploadAadharBtnsStack?.isHidden = false
                sendBtnsStack?.isHidden = false
            }

        } else {

            // Non-Indian resident: show passport fields.
            passportNumbertxtFld?.isHidden = false
            passportValiditytxtFld?.isHidden = false
            passportUploadtxtFld?.isHidden = false
            passportValidityImgView?.isHidden = false
            passportUploadImgView?.isHidden = false
        }
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
                navigationController?.popViewController(animated: true)

        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func verifyViaDigiORAadharAction(_ sender: UIButton?) {
        //        if isVerifyViaDigiLocker {
        sendBtnsStack?.isHidden = false
        adhaarUploadImgView?.isHidden = true
        uploadAdhartxtFld?.isHidden = true
        verifyViaDigilockerBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
        uploadAadharBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
        isVerifyViaDigiLocker = false
        isVerifyViaUploadAdhar = false
        if sender?.tag == 11 {
            isVerifyViaDigiLocker = true
            verifyViaDigilockerBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
        } else if sender?.tag == 12 {
            isVerifyViaUploadAdhar = true
            uploadAadharBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
            sendBtnsStack?.isHidden = true
            adhaarUploadImgView?.isHidden = false
            uploadAdhartxtFld?.isHidden = false
        }
    }
    
    func verifyAadhaar(base64Doc: String) async {
        let url = URL(string: getAadhaarDetailsApiUrl)!
        let referenceId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let body: [String: Any] = [
            "reference_id": referenceId,
            "source": base64Doc,
            "verification": true,
            "doc_type": "aadhaar_card"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(applictionId, forHTTPHeaderField: "x-parse-application-id")
        request.setValue(ApiKey, forHTTPHeaderField: "x-parse-rest-api-key")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("Aadhaar Verification Response:", json)
                
                DispatchQueue.main.async {
                    if let status = json["status"] as? String, status.lowercased() == "success" {
                        self.isDoneVerifyAadhaar = true
                        self.showAlert(with: "Success", message: "Aadhaar verified successfully via upload.")
                        self.uploadAdhartxtFld?.label.text = "Aadhaar Verified ✅"
                    } else {
                        self.isVerifyViaUploadAdhar = false
                        let errorMsg = json["error"] as? String ?? "Verification failed. Please try again."
                        self.showAlert(with: "Verification Failed", message: errorMsg)
                        self.uploadAdhartxtFld?.label.text = "Aadhaar Upload Failed ❌"
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isDoneVerifyAadhaar = false
                self.showAlert(with: "Error", message: "Failed to verify Aadhaar: \(error.localizedDescription)")
                self.uploadAdhartxtFld?.label.text = "Aadhaar Upload Failed ❌"
            }
        }
    }
    
    func fillAadhaarFromDigilocker(_ details: [String: Any]) {
        
        guard let result = details["result"] as? [String: Any],
              let validatedData = result["validated_data"] as? [String: Any],
              let finalResult = validatedData["result"] as? [String: Any] else {
            print("❌ Parsing failed")
            return
        }
        
        print("✅ Parsed Data:", finalResult)
        self.addharDetailsDict = finalResult
        // ✅ Name
        self.applicantNametxtFld?.text = finalResult["name"] as? String
        
        // ✅ DOB convert (30-12-2001 → yyyy-MM-dd)
        if let dob = finalResult["dob"] as? String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd-MM-yyyy"
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = inputFormatter.date(from: dob) {
                self.DOBtxtFld?.text = outputFormatter.string(from: date)
            } else {
                self.DOBtxtFld?.text = dob
            }
        }
        
        // ✅ Gender
        if let gender = finalResult["gender"] as? String {
            self.gendertxtFld?.text = gender == "M" ? "Male" : (gender == "F" ? "Female" : gender)
        }
        
        // ✅ S/O, D/O, W/O
        self.relativeNametxtFld?.text = finalResult["care_of"] as? String
        
        // ✅ Aadhaar masked
        if let uid = finalResult["uid"] as? String {
            self.uploadAdhartxtFld?.text = "XXXX XXXX \(uid.suffix(4))"
            self.uploadAdhartxtFld?.label.text = "Aadhaar Verified ✅"
        }
        
        // ✅ Nationality
        self.nationalitytxtFld?.text = "Indian"
        
        // (Optional) Address logging
        if let address = finalResult["address"] as? String {
            print("📍 Address:", address)
        }
        
        // 🔒 Disable fields (recommended)
        self.applicantNametxtFld?.isEnabled = false
        self.DOBtxtFld?.isEnabled = false
        self.gendertxtFld?.isEnabled = false
        self.relativeNametxtFld?.isEnabled = false
    }
    
    func generateReferenceId() -> String {
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return String(uuid.prefix(16))
    }
    
    func pickAadhaarFile() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image])
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func sendVerificationLinkAction() {
        
        if isDoneVerifyViaDigiLocker {
            showAlert(with: "Already Verified", message: "Aadhaar is already verified via Digilocker.")
            return
        }
        
        if let existingRefId = referenceId,
           let existingTxnId = transactionId {
            
            let alert = UIAlertController(
                title: "Link Already Generated",
                message: "You already generated a verification link. Do you want to open it again or generate a new one?",
                preferredStyle: .alert
            )
            
            // 🔁 Open existing link
            alert.addAction(UIAlertAction(title: "Open Link", style: .default, handler: { _ in
                self.digilockerService.generateDigilockerLink(referenceId: existingRefId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let (link, _)):
                            if let url = URL(string: link) {
                                let safariVC = SFSafariViewController(url: url)
                                self.present(safariVC, animated: true)
                            }
                        case .failure(let error):
                            self.showAlert(with: "Error", message: error.localizedDescription)
                        }
                    }
                }
            }))
            
            // 🆕 Generate new link
            alert.addAction(UIAlertAction(title: "Generate New", style: .destructive, handler: { _ in
                self.generateNewDigilockerLink()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true)
            return
        }
        
        // ✅ Case 3: First time
        generateNewDigilockerLink()
    }
    
    func generateNewDigilockerLink() {
        
        referenceId = digilockerService.generateReferenceId()
        
        guard let refId = referenceId else { return }
        
        digilockerService.generateDigilockerLink(referenceId: refId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (link, txnId)):
                    
                    self?.transactionId = txnId
                    
                    // ✅ Update UI
                    self?.sendVerificationLinkBtn?.setTitle("Link Sent ✅", for: .normal)
                    self?.sendVerificationLinkBtn?.backgroundColor = UIColor.systemGreen
                    
                    if let url = URL(string: link) {
                        let safariVC = SFSafariViewController(url: url)
                        self?.present(safariVC, animated: true)
                    }
                    
                case .failure(let error):
                    self?.showAlert(with: "Verification Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func verifyAction() {
        
        if isDoneVerifyViaDigiLocker {
            showAlert(with: "Already Verified", message: "Aadhaar is already verified via Digilocker.")
            return
        }
        
        if isVerifyViaDigiLocker {
            guard let txnId = transactionId, let refId = referenceId else {
                print("Complete Digilocker verification first")
                return
            }
            
            digilockerService.getAadhaarDetails(referenceId: refId, transactionId: txnId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let details):
                        if let status = details["status"] as? String, status.lowercased() == "success" {
                            self.isDoneVerifyViaDigiLocker = true
                            print("✅ Digilocker Aadhaar Verified:", details)
                            self.isDoneVerifyViaDigiLocker = true

                                                   

                                                   // ✅ Fill data
                                                   self.fillAadhaarFromDigilocker(details)
                            self.isAddharVerify = true
                                                   

                                                   // ✅ Update UI

                                                   self.updateVerificationUI()
//                            self.fillAadhaarFromDigilocker(details)
                            self.showAlert(with: "Success", message: "Aadhaar verified successfully via Digilocker.")
                        } else {
                            self.isDoneVerifyViaDigiLocker = false
                            let errorMsg = details["error"] as? String ?? "Unknown error"
                            print("❌ Digilocker verification failed:", details)
                            self.showAlert(with: "Verification Failed", message: errorMsg)
                        }
                    case .failure(let error):
                        self.isDoneVerifyViaDigiLocker = false
                        if (error as NSError).code == 401 {
                            self.showAlert(with: "Verification Error", message: "Permission denied. Please grant access in Digilocker.")
                        } else {
                            self.showAlert(with: "Verification Error", message: "Error fetching Digilocker details: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func updateVerificationUI() {
        
        verifyBtn?.setTitle("Verified ✅", for: .normal)
        
        verifyBtn?.backgroundColor = UIColor.systemGreen
        verifyBtn?.setTitleColor(.white, for: .normal)
        
        verifyBtn?.isEnabled = false
        
        verifyBtn?.borderColor = UIColor.systemGreen
    }
    
    func isAnotherApplicantPrimary() -> Bool {
        
        guard let currentIndex = applicantIndex else {
            return OpportunityManager.shared.applicants.contains {
                $0.primary == true
            }
        }
        
        return OpportunityManager.shared.applicants.enumerated().contains {
            index, applicant in
            index != currentIndex && applicant.primary == true
        }
    }
    
    
    func saveApplicantData() -> Bool {

        guard validateRequiredFields() else { return false }

        if !isForEditing && !isCustomerDetailsFillYES && isResidentIndian {
            
            if !isDoneVerifyAadhaar && !isDoneVerifyViaDigiLocker {
                
                showAlert(
                    with: "Verification Required",
                    message: "Please verify your Aadhaar via DigiLocker or Aadhaar Upload before proceeding."
                )
                
                return false
            }
        }
        
        var applicant: SaveModel

        if let index = applicantIndex,
           index < OpportunityManager.shared.applicants.count {

            applicant = OpportunityManager.shared.getApplicant(at: index) ?? SaveModel(dict: [:])

        } else {

            applicant = SaveModel(dict: [:])

            OpportunityManager.shared.addApplicant(applicant)

            applicantIndex = OpportunityManager.shared.applicants.count - 1
        }

        applicant.primary = isPrimaryYES
        applicant.residentType = residentTypetxtFld?.text
        applicant.dob = DOBtxtFld?.text
        applicant.gender = gendertxtFld?.text
        applicant.maritalStatus = maritalStatustxtFld?.text
        applicant.nationality = nationalitytxtFld?.text
        applicant.name = applicantNametxtFld?.text
        applicant.panNumber = panNotxtFld?.text
        applicant.panUploadFileName = panUploadtxtFld?.text
        applicant.aadhaarUploadFileName = uploadAdhartxtFld?.text
        applicant.passportUploadFileName = passportUploadtxtFld?.text
        applicant.passportNumber = passportNumbertxtFld?.text
        applicant.occupation = occupationtxtFld?.text
        applicant.relation = SDWtxtFld?.text
        applicant.phoneHome = phoneNumberHometxtFld?.text
        applicant.applicantEmail = emailtxtFld?.text
        applicant.phoneWork = phoneNumberWorktxtFld?.text
        applicant.applicantMobile = mobiletxtFld?.text
        applicant.phoneOther = phoneNumberOthertxtFld?.text
        applicant.salutation = salutationtxtFld?.text
        applicant.applicantPhotoFileName = applicantPhotoUploadtxtFld?.text
        applicant.salutationForRelative = salutationForRelativetxtFld?.text
        applicant.relativeName = relativeNametxtFld?.text

        if let index = applicantIndex {
            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
        }

        return true
    }
    
    @IBAction func nextBtnAction() {

        guard saveApplicantData() else { return }

//        let storyboard = UIStoryboard(name: "EOI", bundle: Bundle.main)
//
//        if let addressVC = storyboard.instantiateViewController(
//            withIdentifier: "AddressEOIScreenVC"
//        ) as? AddressEOIScreenVC {
//
//            addressVC.applicantIndex = applicantIndex
//            addressVC.isFromCustomers = isFromCustomers
//            addressVC.isLocalEdit = isLocalEdit
//            addressVC.cuatomerDetailsDict = cuatomerDetailsDict
//            addressVC.addharDetailDict =  self.addharDetailsDict
//            addressVC.isAddharVerify = self.isAddharVerify
//
//            if isForEditing {
//                addressVC.isForEditing = isForEditing
//                addressVC.applicantDetailsModel = applicantDetailsModel
//            }
//
//            navigationController?.pushViewController(addressVC, animated: true)
//        }
        let storyboard = UIStoryboard(name: "EOI", bundle: Bundle.main)

        if let addressVC = storyboard.instantiateViewController(
            withIdentifier: "AddressEOIScreenVC"
        ) as? AddressEOIScreenVC {

            addressVC.applicantIndex = applicantIndex
            addressVC.isFromCustomers = isFromCustomers
            addressVC.isLocalEdit = isLocalEdit
            addressVC.cuatomerDetailsDict = cuatomerDetailsDict
            addressVC.addharDetailDict = self.addharDetailsDict
            addressVC.isAddharVerify = self.isAddharVerify

            // Pass Customer Details YES selection
            addressVC.isCustomerDetailsSelected = isCustomerDetailsFillYES

            if isForEditing {
                addressVC.isForEditing = isForEditing
                addressVC.applicantDetailsModel = applicantDetailsModel
            }

            navigationController?.pushViewController(
                addressVC,
                animated: true
            )
        }
    }
}

extension PersonalEOIScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    func saveUploadedFile(title: String, data: Data, fileExtension: String) {
        guard let index = applicantIndex else { return }
        
        if index >= OpportunityManager.shared.applicants.count {
            print("⚠️ Invalid applicant index \(index), creating new applicant")
            let newApplicant = SaveModel(dict: [:])
            OpportunityManager.shared.addApplicant(newApplicant)
        }
        
        var applicant = OpportunityManager.shared.applicants[index]
        let mimeType = mimeTypeForExtension(fileExtension)
        
        let fileModel = FileUploadModel(
            title: title,
            pathOnClient: "\(title).\(fileExtension)",
            fileType: mimeType,
            networkId: nil,
            versionData: data
        )
        
        applicant.uploadedFiles.removeAll { $0.title == title }
        applicant.uploadedFiles.append(fileModel)
        
        OpportunityManager.shared.applicants[index] = applicant
        
        updateUI(for: UploadField(rawValue: title) ?? .aadhaar, path: fileModel.pathOnClient)
    }
    
    private func updateUI(for field: UploadField, path: String) {
        switch field {
        case .aadhaar:
            uploadAdhartxtFld?.text = path
        case .pan:
            panUploadtxtFld?.text = path
        case .passport:
            passportUploadtxtFld?.text = path
        case .applicantPhoto:
            applicantPhotoUploadtxtFld?.text = path
        }
    }
    
    
    @objc func openPanUploadOptions() {
        if applicantIndex == nil {
            applicantIndex = 0
        }
        openUploadOptions(for: .pan)
    }
    
    @objc func openPassportUploadOptions() {
        if applicantIndex == nil {
            applicantIndex = 0
        }
        openUploadOptions(for: .passport)
    }
    
    @objc func openApplicantUploadOptions() {
        if applicantIndex == nil {
            applicantIndex = 0
        }
        openUploadOptions(for: .applicantPhoto)
    }
    
    @objc func openAadhaarUploadOptions() {
        if applicantIndex == nil {
            applicantIndex = 0
        }
        openUploadOptions(for: .aadhaar)
    }
    
    func openUploadOptions(for field: UploadField) {
        currentUploadField = field
        let actionSheet = UIAlertController(title: "Upload \(field.rawValue)", message: "Choose an option", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { _ in self.openCamera() })
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in self.openGallery() })
        actionSheet.addAction(UIAlertAction(title: "Files", style: .default) { _ in self.openDocumentPicker() })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
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
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        
        guard let image = info[.originalImage] as? UIImage,
              let field = currentUploadField else {
            picker.dismiss(animated: true)
            return
        }
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            picker.dismiss(animated: true)
            return
        }
        
        // Only Aadhaar should go through verification
        if field == .aadhaar && isVerifyViaUploadAdhar {
            
            let base64String = data.base64EncodedString()
            
            Task {
                await verifyAadhaar(base64Doc: base64String)
            }
            
        } else {
            
            // PAN, Passport and Applicant Photo
            // will continue with normal upload flow
            saveUploadedFile(
                title: field.rawValue,
                data: data,
                fileExtension: "jpg"
            )
        }
        
        picker.dismiss(animated: true)
    }
    
    func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        
        guard let fileURL = urls.first,
              let field = currentUploadField else {
            return
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return
        }
        
        // Only Aadhaar should go through verification
        if field == .aadhaar && isVerifyViaUploadAdhar {
            
            let base64String = data.base64EncodedString()
            
            Task {
                await verifyAadhaar(base64Doc: base64String)
            }
            
        } else {
            
            // PAN, Passport and Applicant Photo
            // will continue with normal upload flow
            saveUploadedFile(
                title: field.rawValue,
                data: data,
                fileExtension: fileURL.pathExtension
            )
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

extension PersonalEOIScreenVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == residentTypetxtFld {
            showResidentTypeDropdown()
            return false
        } else if textField == gendertxtFld {
            showGenderToDropdown()
            return false
        } else if textField == maritalStatustxtFld {
            showMaritalStatusToDropdown()
            return false
        } else if textField == SDWtxtFld {
            showSDWDropdown()
            return false
        } else if textField == salutationtxtFld {
            showSalutationDropdown()
            return false
        } else if textField == salutationForRelativetxtFld {
            showRelativeSalutationDropdown()
            return false
        }
        return true
    }
    
    func showSDWDropdown() {
        let options = ["S/O", "D/O", "W/O"] 
        
        SDWDropdown.anchorView = SDWtxtFld
        SDWDropdown.dataSource = options
        
        SDWDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.SDWtxtFld?.text = item
        }
        
        SDWDropdown.show()
    }
    
    func showSalutationDropdown() {

        let options = FetchPicklistValue.shared
            .picklistOptionsDict["Salutation__c"] ?? []

        salutationDropdown.anchorView = salutationtxtFld
        salutationDropdown.dataSource = options.map { $0.label }

        salutationDropdown.selectionAction = { [weak self] index, item in
            self?.salutationtxtFld?.text = item
        }

        salutationDropdown.show()
    }

    func showRelativeSalutationDropdown() {

        let options = FetchPicklistValue.shared
            .picklistOptionsDict["Salutation_for_Relative__c"] ?? []

        relativeSalutationDropdown.anchorView = salutationForRelativetxtFld
        relativeSalutationDropdown.dataSource = options.map { $0.label }

        relativeSalutationDropdown.selectionAction = { [weak self] index, item in
            self?.salutationForRelativetxtFld?.text = item
        }

        relativeSalutationDropdown.show()
    }
    
    func showMaritalStatusToDropdown() {
        let options = FetchPicklistValue.shared.picklistOptionsDict["Marital_Status__c"] ?? []
        let accountLabel = options.map { $0.label }
        let accountValue = options.map { $0.value }
        
        print("Marital_Status__c Labels: \(accountLabel)")
        print("Marital_Status__c: \(accountValue)")
        
        maritalStatusDropdown.anchorView = maritalStatustxtFld
        maritalStatusDropdown.dataSource = accountValue
        
        maritalStatusDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard index < accountLabel.count else { return }
            self?.maritalStatustxtFld?.text = item
        }
        maritalStatusDropdown.show()
    }
    
    func showGenderToDropdown() {
        let options = FetchPicklistValue.shared.picklistOptionsDict["Gender__c"] ?? []
        let accountLabel = options.map { $0.label }
        let accountValue = options.map { $0.value }
        
        print("PI_Gender__c Labels: \(accountLabel)")
        print("PI_Gender__c: \(accountValue)")
        
        genderDropdown.anchorView = gendertxtFld
        genderDropdown.dataSource = accountValue
        
        genderDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard index < accountLabel.count else { return }
            self?.gendertxtFld?.text = item
        }
        genderDropdown.show()
    }
    
//    func showResidentTypeDropdown() {
//        let options = FetchPicklistValue.shared.picklistOptionsDict["Resident_Type__c"] ?? []
//        let accountLabel = options.map { $0.label }
//        let accountValue = options.map { $0.value }
//        
//        print("ResidentType Labels: \(accountLabel)")
//        print("ResidentTypeValues: \(accountValue)")
//        
//        residentTypeDropdown.anchorView = residentTypetxtFld
//        residentTypeDropdown.dataSource = accountValue
//        
//        residentTypeDropdown.selectionAction = { [weak self] (index: Int, item: String) in
//            guard index < accountLabel.count else { return }
//            self?.residentTypetxtFld?.text = item
//            if self?.residentTypetxtFld?.text == "Indian" {
//                self?.isIndianType = true
//            } else {
//                self?.isIndianType = false
//            }
//            self?.UIUpdateAccordingToPaymentMode(residentType: item)
//        }
//        residentTypeDropdown.show()
//    }
    
    func showResidentTypeDropdown() {

        let options = FetchPicklistValue.shared
            .picklistOptionsDict["Resident_Type__c"] ?? []

        let accountValue = options.map { $0.value }

        residentTypeDropdown.anchorView = residentTypetxtFld
        residentTypeDropdown.dataSource = accountValue

        residentTypeDropdown.selectionAction = { [weak self] _, item in

            guard let self = self else { return }

            // Update selected Resident Type.
            self.residentTypetxtFld?.text = item

            // Update PAN/passport fields and Aadhaar visibility.
            self.UIUpdateAccordingToPaymentMode(residentType: item)
        }

        residentTypeDropdown.show()
    }
}


//
//  CreatePaymentVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 04/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import DropDown
import Toast_Swift
import SafariServices

class CreatePaymentVC: UIViewController {
    @IBOutlet var mainVw: UIView?
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var paymentModeTxtFld: MDCOutlinedTextField?
    @IBOutlet var EOITxtFld: MDCOutlinedTextField?
    @IBOutlet var UTRTxtFld: MDCOutlinedTextField?
    @IBOutlet var DDNumberTxtFld: MDCOutlinedTextField?
    @IBOutlet var DDDateTxtFld: MDCOutlinedTextField?
    @IBOutlet var drawnBankTxtFld: MDCOutlinedTextField?
    @IBOutlet var paymentStatusTxtFld: MDCOutlinedTextField?
    @IBOutlet var UPIIdTxtFld: MDCOutlinedTextField?
    @IBOutlet var bankAccountNumberTxtFld: MDCOutlinedTextField?
    @IBOutlet var IFSCTxtFld: MDCOutlinedTextField?
    @IBOutlet var referenceNumberTxtFld: MDCOutlinedTextField?
    @IBOutlet var AttachDocumentTxtFld: MDCOutlinedTextField?
    @IBOutlet var cancelChequeUploadTxtFld: MDCOutlinedTextField?
    @IBOutlet var transactionIdTxtFld: MDCOutlinedTextField?
    @IBOutlet var paymentMadeViaTxtFld: MDCOutlinedTextField?
    @IBOutlet var transactionMessageTxtFld: MDCOutlinedTextField?
    @IBOutlet var paymentDateTxtFld: MDCOutlinedTextField?
    @IBOutlet var paymentTimeTxtFld: MDCOutlinedTextField?
    @IBOutlet var notesTxtView: UITextView?
    @IBOutlet var checkBtn: UIButton?
    @IBOutlet var positiveCheckBtn: UIButton?
    @IBOutlet var positiveStackView: UIStackView?
    @IBOutlet var positiveStackViewHeight: NSLayoutConstraint?
    @IBOutlet var sendLinkBtn: UIButton?
    @IBOutlet var verifyPaymentBtn: UIButton?
    @IBOutlet var submitBtn: UIButton?
    @IBOutlet var backBtn: UIButton?
    @IBOutlet var ddDateImgView: UIImageView?
    @IBOutlet var paymentMadeViaImgView: UIImageView?
    @IBOutlet var paymentDateImgView: UIImageView?
    @IBOutlet var paymentTimeImgView: UIImageView?
    @IBOutlet var attachDocumentImgView: UIImageView?
    @IBOutlet var cancelChequetImgView: UIImageView?
    @IBOutlet var btnsStackView: UIStackView?
    
    var paymentMode: String = EMPTY
    var paymentModeDropdown = DropDown()
    var DDDatePicker = UIDatePicker()
    var paymentDatePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var isPositiveCheckBox: Bool = false
    var isCheckBox: Bool = false
    var fetchPickListValues = FetchPicklistValue()
    var paymentWebService = PaymentWebService()
    var EOiModelDict = EOIModel(dict: [:])
    var selectedAttachment: Attachment?
    var paymentId: String = EMPTY
    var currentUploadField: String?
    var completionalHandler: (String) -> Void = {_ in}
    var loaderView: UIActivityIndicatorView?
    var paymentDetailId: String? = EMPTY
    var transactionId: String? = EMPTY
    var selectedPaymentType: String? = EMPTY
//    var isEasebuzzPaymentVerified: Bool = false
    var isCheckBoxEnabled: Bool = false {
        didSet {
            if isCheckBoxEnabled {
                checkBtn?.setImage(UIImage(named: "checkBoxSelected"), for: .normal)
                isCheckBox = true
                sendLinkBtn?.backgroundColor = ColorConstant.buttonBackgroundDarkColor
                sendLinkBtn?.setTitleColor(.white, for: .normal)
            } else {
                isCheckBox = false
                checkBtn?.setImage(UIImage(named: "Checkbox"), for: .normal)
                sendLinkBtn?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
                sendLinkBtn?.setTitleColor(.black, for: .normal)
            }
        }
    }
    var isPositiveCheckBoxEnabled: Bool = false {
        didSet {
            if isPositiveCheckBoxEnabled {
                positiveCheckBtn?.setImage(UIImage(named: "checkBoxSelected"), for: .normal)
                isPositiveCheckBox = true
            } else {
                isPositiveCheckBox = false
                positiveCheckBtn?.setImage(UIImage(named: "Checkbox"), for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let textView = notesTxtView?.viewWithTag(101) as? UITextView {
            textView.delegate = self
        }
        loaderView = UIActivityIndicatorView(style: .large)
        loaderView?.color = .gray
        loaderView?.center = view.center
        loaderView?.hidesWhenStopped = true
        if let loader = loaderView {
            view.addSubview(loader)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            await FetchPicklistValue.shared.fetchPicklistValues(
                objectName: "Payment_Detail__c",
                fieldNames: ["Payment_Mode__c", "Status"]
            )

            DispatchQueue.main.async {

                if let selectedType = self.selectedPaymentType,
                   !selectedType.isEmpty {

                    self.paymentMode = selectedType
                    self.paymentModeTxtFld?.text = selectedType
                    self.UIUpdateAccordingToPaymentMode(paymentMode: selectedType)

                } else if let paymentModes = FetchPicklistValue.shared.picklistOptionsDict["Payment_Mode__c"],
                          let firstMode = paymentModes.first?.value {

                    self.paymentMode = firstMode
                    self.paymentModeTxtFld?.text = firstMode
                    self.UIUpdateAccordingToPaymentMode(paymentMode: firstMode)
                }
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
    
    func showLoader() {
        DispatchQueue.main.async {
            self.loaderView?.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.loaderView?.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func setUpInitialUI() {
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        btnsStackView?.isHidden = true
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        sendLinkBtn?.layer.cornerRadius = 8
        verifyPaymentBtn?.layer.cornerRadius = 8
        submitBtn?.layer.cornerRadius = 8
        paymentModeTxtFld?.label.text = "Payment Mode *"
        paymentModeTxtFld?.setOutlineColor(.darkGray, for: .normal)
        paymentModeTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        paymentModeTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        paymentModeTxtFld?.text = selectedPaymentType
        paymentModeTxtFld?.isEnabled = false
        paymentModeTxtFld?.delegate = self
        
        EOITxtFld?.label.text = "EOI Amount *"
        EOITxtFld?.setOutlineColor(.darkGray, for: .normal)
        EOITxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        EOITxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        UTRTxtFld?.label.text = "UTR Number *"
        UTRTxtFld?.setOutlineColor(.darkGray, for: .normal)
        UTRTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        UTRTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        DDNumberTxtFld?.label.text = "Demand Draft(DD) Number *"
        DDNumberTxtFld?.setOutlineColor(.darkGray, for: .normal)
        DDNumberTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        DDNumberTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        paymentStatusTxtFld?.label.text = "Payment Status"
        paymentStatusTxtFld?.setOutlineColor(.darkGray, for: .normal)
        paymentStatusTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        paymentStatusTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        DDDateTxtFld?.label.text = "Demand Draft(DD) Date *"
        DDDateTxtFld?.setOutlineColor(.darkGray, for: .normal)
        DDDateTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        DDDateTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        drawnBankTxtFld?.label.text = "Drawn Bank *"
        drawnBankTxtFld?.setOutlineColor(.darkGray, for: .normal)
        drawnBankTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        drawnBankTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        bankAccountNumberTxtFld?.label.text = "Bank Account Number *"
        bankAccountNumberTxtFld?.setOutlineColor(.darkGray, for: .normal)
        bankAccountNumberTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        bankAccountNumberTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        UPIIdTxtFld?.label.text = "UPI Id *"
        UPIIdTxtFld?.setOutlineColor(.darkGray, for: .normal)
        UPIIdTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        UPIIdTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        referenceNumberTxtFld?.label.text = "Payment Refrence Number"
        referenceNumberTxtFld?.setOutlineColor(.darkGray, for: .normal)
        referenceNumberTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        referenceNumberTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        IFSCTxtFld?.label.text = "IFSC Code *"
        IFSCTxtFld?.setOutlineColor(.darkGray, for: .normal)
        IFSCTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        IFSCTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        transactionIdTxtFld?.label.text = "Transaction Id"
        transactionIdTxtFld?.setOutlineColor(.darkGray, for: .normal)
        transactionIdTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        transactionIdTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        paymentMadeViaTxtFld?.label.text = "Payment Made Via"
        paymentMadeViaTxtFld?.setOutlineColor(.darkGray, for: .normal)
        paymentMadeViaTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        paymentMadeViaTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        paymentMadeViaTxtFld?.delegate = self
        paymentMadeViaTxtFld?.inputView = UIView()
        
        paymentDateTxtFld?.label.text = "Payment Date *"
        paymentDateTxtFld?.setOutlineColor(.darkGray, for: .normal)
        paymentDateTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        paymentDateTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        cancelChequeUploadTxtFld?.label.text = "Cancel Cheque Upload *"
        cancelChequeUploadTxtFld?.setOutlineColor(.darkGray, for: .normal)
        cancelChequeUploadTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        cancelChequeUploadTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let ChequeUploadTap = UITapGestureRecognizer(target: self, action: #selector(openChequeUploadOptions))
        cancelChequeUploadTxtFld?.addGestureRecognizer(ChequeUploadTap)
        cancelChequeUploadTxtFld?.isUserInteractionEnabled = true
        
        AttachDocumentTxtFld?.label.text = "Attach Document"
        AttachDocumentTxtFld?.setOutlineColor(.darkGray, for: .normal)
        AttachDocumentTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        AttachDocumentTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        let documentUploadTap = UITapGestureRecognizer(target: self, action: #selector(openDocumentUploadOptions))
        AttachDocumentTxtFld?.addGestureRecognizer(documentUploadTap)
        AttachDocumentTxtFld?.isUserInteractionEnabled = true
        
        transactionMessageTxtFld?.label.text = "Transactional message"
        transactionMessageTxtFld?.setOutlineColor(.darkGray, for: .normal)
        transactionMessageTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        transactionMessageTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        paymentTimeTxtFld?.label.text = "Payment Time"
        paymentTimeTxtFld?.setOutlineColor(.darkGray, for: .normal)
        paymentTimeTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        paymentTimeTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        notesTxtView?.delegate = self
        notesTxtView?.borderWidth = 1
        notesTxtView?.borderColor = UIColor(hex: "223B30")
        notesTxtView?.placeholder = "Type Notes here.."
        notesTxtView?.cornerRadius = 4
        notesTxtView?.textColor = .darkGray
        notesTxtView?.textContainerInset = UIEdgeInsets(top: 13, left: 10, bottom: 10, right: 13)
        
        DDDatePicker.datePickerMode = .date
        DDDatePicker.preferredDatePickerStyle = .wheels
        DDDatePicker.addTarget(self, action: #selector(dateChangedForDDDate(_:)), for: .valueChanged)
        DDDateTxtFld?.inputView = DDDatePicker
        
        paymentDatePicker.datePickerMode = .date
        paymentDatePicker.preferredDatePickerStyle = .wheels
        paymentDatePicker.addTarget(self, action: #selector(dateChangedForPayment(_:)), for: .valueChanged)
        paymentDateTxtFld?.inputView = paymentDatePicker
        setupTimePicker()
        updateButtonState(step: .sendLink)
    }
        
    func UIUpdateAccordingToPaymentMode(paymentMode: String) {
        [
            EOITxtFld,
            UTRTxtFld,
            DDNumberTxtFld,
            DDDateTxtFld,
            drawnBankTxtFld,
            paymentStatusTxtFld,
            UPIIdTxtFld,
            bankAccountNumberTxtFld,
            IFSCTxtFld,
            referenceNumberTxtFld,
            AttachDocumentTxtFld,
            cancelChequeUploadTxtFld,
            transactionIdTxtFld,
            paymentMadeViaTxtFld,
            transactionMessageTxtFld,
            paymentDateTxtFld,
            paymentTimeTxtFld
        ].forEach { $0?.isHidden = true }

        [
            ddDateImgView,
            paymentMadeViaImgView,
            paymentDateImgView,
            paymentTimeImgView,
            attachDocumentImgView,
            cancelChequetImgView
        ].forEach { $0?.isHidden = true }

        btnsStackView?.isHidden = true

        // Default state for all payment modes
        submitBtn?.isEnabled = true
        submitBtn?.alpha = 1.0
        positiveStackView?.isHidden = true
        positiveStackViewHeight?.constant = 0

        switch paymentMode {

        case "RTGS":

            EOITxtFld?.isHidden = false
            UTRTxtFld?.isHidden = false
            drawnBankTxtFld?.isHidden = false
            bankAccountNumberTxtFld?.isHidden = false
            IFSCTxtFld?.isHidden = false
            referenceNumberTxtFld?.isHidden = false
            paymentDateTxtFld?.isHidden = false
            paymentDateImgView?.isHidden = false
            cancelChequeUploadTxtFld?.isHidden = false
            cancelChequetImgView?.isHidden = false

        case "NEFT":

            EOITxtFld?.isHidden = false
            UTRTxtFld?.isHidden = false
            drawnBankTxtFld?.isHidden = false
            bankAccountNumberTxtFld?.isHidden = false
            IFSCTxtFld?.isHidden = false
            referenceNumberTxtFld?.isHidden = false
            paymentDateTxtFld?.isHidden = false
            paymentDateImgView?.isHidden = false
            AttachDocumentTxtFld?.isHidden = false
            attachDocumentImgView?.isHidden = false

        case "Cheque":

            EOITxtFld?.isHidden = false
            DDNumberTxtFld?.isHidden = false
            DDDateTxtFld?.isHidden = false
            ddDateImgView?.isHidden = false
            drawnBankTxtFld?.isHidden = false
            bankAccountNumberTxtFld?.isHidden = false
            cancelChequeUploadTxtFld?.isHidden = false
            cancelChequetImgView?.isHidden = false
            positiveStackView?.isHidden = false
            positiveStackViewHeight?.constant = 71
            positiveCheckBtn?.setImage(UIImage(named: "checkBoxSelected"), for: .normal)
            isPositiveCheckBox = true

        case "Demand Draft(DD)":

            EOITxtFld?.isHidden = false
            DDNumberTxtFld?.isHidden = false
            DDDateTxtFld?.isHidden = false
            ddDateImgView?.isHidden = false
            drawnBankTxtFld?.isHidden = false
            bankAccountNumberTxtFld?.isHidden = false
            AttachDocumentTxtFld?.isHidden = false
            attachDocumentImgView?.isHidden = false
            positiveStackView?.isHidden = false
            positiveStackViewHeight?.constant = 71
            positiveCheckBtn?.setImage(UIImage(named: "checkBoxSelected"), for: .normal)
            isPositiveCheckBox = true

        case "UPI":

            EOITxtFld?.isHidden = false
            drawnBankTxtFld?.isHidden = false
            UPIIdTxtFld?.isHidden = false
            referenceNumberTxtFld?.isHidden = false
            paymentDateTxtFld?.isHidden = false
            paymentDateImgView?.isHidden = false
            AttachDocumentTxtFld?.isHidden = false
            attachDocumentImgView?.isHidden = false

        case "Easebuzz":

            EOITxtFld?.isHidden = false
            paymentStatusTxtFld?.isHidden = false
            referenceNumberTxtFld?.isHidden = false
            transactionIdTxtFld?.isHidden = false
            paymentMadeViaTxtFld?.isHidden = false
            paymentMadeViaImgView?.isHidden = false
            transactionMessageTxtFld?.isHidden = false
            paymentDateTxtFld?.isHidden = false
            paymentDateImgView?.isHidden = false
            paymentTimeTxtFld?.isHidden = false
            paymentTimeImgView?.isHidden = false
            btnsStackView?.isHidden = false

            // Only Send Link button visible
            sendLinkBtn?.isHidden = false
            verifyPaymentBtn?.isHidden = true
            submitBtn?.isHidden = true

            configureEasebuzzFields()
        default:
            break
        }
    }
    
    func configureEasebuzzFields() {

        // EOI Amount should remain editable
        EOITxtFld?.isEnabled = true

        // Disable all other fields
        [
            UTRTxtFld,
            DDNumberTxtFld,
            DDDateTxtFld,
            drawnBankTxtFld,
            paymentStatusTxtFld,
            UPIIdTxtFld,
            bankAccountNumberTxtFld,
            IFSCTxtFld,
            referenceNumberTxtFld,
            AttachDocumentTxtFld,
            cancelChequeUploadTxtFld,
            transactionIdTxtFld,
            paymentMadeViaTxtFld,
            transactionMessageTxtFld,
            paymentDateTxtFld,
            paymentTimeTxtFld,
            
        ].forEach {
            $0?.isEnabled = false
        }

        // Also disable upload/date related interaction
        AttachDocumentTxtFld?.isUserInteractionEnabled = false
        cancelChequeUploadTxtFld?.isUserInteractionEnabled = false

        // Checkbox initially unchecked
        isCheckBoxEnabled = false

        // Send Link disabled initially
        sendLinkBtn?.isEnabled = false
        sendLinkBtn?.alpha = 0.5

        // Verify and Submit should remain disabled
        verifyPaymentBtn?.isEnabled = false
        verifyPaymentBtn?.alpha = 0.5

        submitBtn?.isEnabled = false
        submitBtn?.alpha = 0.5
        notesTxtView?.isEditable = false
    }
    
    func validatePaymentFields(paymentMode: String) -> Bool {
        var missingFields: [String] = []

        switch paymentMode {

        case "RTGS":

            if EOITxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("EOI")
            }

            if UTRTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("UTR")
            }

            if drawnBankTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Drawn Bank")
            }

            if bankAccountNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Bank Account Number")
            }

            if IFSCTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("IFSC Code")
            }

//            if referenceNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
//                missingFields.append("Reference Number")
//            }

            if paymentDateTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Payment Date")
            }

            if cancelChequeUploadTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Cancel Cheque Upload")
            }

        case "NEFT":

            if EOITxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("EOI")
            }

            if UTRTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("UTR")
            }

            if drawnBankTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Drawn Bank")
            }
            
            if bankAccountNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Bank Account Number")
            }

            if IFSCTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("IFSC Code")
            }

//            if referenceNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
//                missingFields.append("Reference Number")
//            }

//            if paymentDateTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
//                missingFields.append("Payment Date")
//            }

            if AttachDocumentTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Attach Document")
            }

        case "Cheque":

            if EOITxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("EOI")
            }

            if DDNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Cheque Number")
            }

            if DDDateTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Cheque Date")
            }

            if drawnBankTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Drawn Bank")
            }

            if bankAccountNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Bank Account Number")
            }

            if cancelChequeUploadTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Cancel Cheque Upload")
            }

        case "Demand Draft(DD)":

            if EOITxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("EOI")
            }

            if DDNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("DD Number")
            }

            if DDDateTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("DD Date")
            }

            if drawnBankTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Drawn Bank")
            }
            
            if bankAccountNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Bank Account Number")
            }

//            if referenceNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
//                missingFields.append("Reference Number")
//            }

            if AttachDocumentTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Attach Document")
            }

        case "UPI":

            if EOITxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("EOI")
            }

            if drawnBankTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Drawn Bank")
            }

            if UPIIdTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("UPI ID")
            }

//            if referenceNumberTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
//                missingFields.append("Reference Number")
//            }

            if paymentDateTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Payment Date")
            }

            if AttachDocumentTxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("Attach Document")
            }

        case "Easebuzz":

            if EOITxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                missingFields.append("EOI")
            }

        default:
            break
        }

        if !missingFields.isEmpty {
            let message = missingFields.joined(separator: ", ")
            Alert.showAlert(
                message: "Please fill/select: \(message)",
                on: self
                
            )
           return false
        }

        return true
    }
    
    @objc func dateChangedForDDDate(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = formatter.string(from: sender.date)
        DDDateTxtFld?.text = selectedDateString
    }
    
    @objc func dateChangedForPayment(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = formatter.string(from: sender.date)
        paymentDateTxtFld?.text = selectedDateString
    }
    
    @objc func doneSelectingTime() {
        if let picker = paymentTimeTxtFld?.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            paymentTimeTxtFld?.text = formatter.string(from: picker.date)
        }
        paymentTimeTxtFld?.resignFirstResponder()
    }
    
    func setupTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "en_GB")

        paymentTimeTxtFld?.inputView = timePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneSelectingTime))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        paymentTimeTxtFld?.inputAccessoryView = toolbar
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendLinkAction(_ sender: UIButton) {
        if let email = EOiModelDict.email, !email.isEmpty,
           let mobile = EOiModelDict.mobilePhone, !mobile.isEmpty {
            
            guard let mode = paymentModeTxtFld?.text, mode == "Easebuzz" else { return }
            
            showLoader()
            
            let payload: [String: Any] = [
                "recordId": EOiModelDict.id ?? "",
                "EOIAmount": Double(EOITxtFld?.text ?? "0") ?? 0
            ]
            
//            paymentWebService.sendPaymentLink(param: payload) { error, json, status in
//                DispatchQueue.main.async {
//                    self.hideLoader()
//                    
//                    if status == .success,
//                       let record = json?["record"] as? [String: Any],
//                       let paymentURL = record["Payment_URL__c"] as? String,
//                       let transactionId = record["Transaction_Id__c"] as? String,
//                       let paymentDetailId = record["Id"] as? String {
//
//                        self.paymentStatusTxtFld?.text = "Success"
//
//                        self.paymentDetailId = paymentDetailId
//
//                        self.transactionIdTxtFld?.text = transactionId
//                        self.transactionIdTxtFld?.isEnabled = false
//
//                        let msg = error ?? (json?["message"] as? String) ?? "Link Send Successfully!!"
//
//                        self.hideLoader()
//
//                        self.view.makeToast(
//                            msg,
//                            duration: 2.0,
//                            position: .bottom
//                        )
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//
//                    } else {
//
//                        let msg = error ?? (json?["error_description"] as? String) ?? "Failed to generate payment link."
////                        SceneDelegate.getSceneDelegate().window?.rootViewController?.view.makeToast(msg)
//                        self.view.makeToast(
//
//                            msg,
//
//                            duration: 2.0,
//
//                            position: .bottom
//
//                        )
//                    }
//                }
//            }
            
            paymentWebService.sendPaymentLink(param: payload) { error, json, status in
                DispatchQueue.main.async {
                    self.hideLoader()

                    print("📩 Raw Response: \(json ?? [:])")

                    // API returned failure message
                    if let successSendingLink = json?["successSendingLink"] as? Bool,
                       successSendingLink == false {

                        let message = json?["message"] as? String
                            ?? error
                            ?? "Failed to generate payment link."

                        self.view.makeToast(
                            message,
                            duration: 3.0,
                            position: .bottom
                        )

                        return
                    }

                    // Successful response
                    if status == .success,
                       let record = json?["record"] as? [String: Any],
                       let paymentURL = record["Payment_URL__c"] as? String,
                       let transactionId = record["Transaction_Id__c"] as? String,
                       let paymentDetailId = record["Id"] as? String {

                        self.paymentStatusTxtFld?.text = "Success"

                        self.paymentDetailId = paymentDetailId
                        self.transactionIdTxtFld?.text = transactionId
                        self.transactionIdTxtFld?.isEnabled = false

                        let msg = json?["message"] as? String
                            ?? "Link sent successfully!"

                        self.view.makeToast(
                            msg,
                            duration: 2.0,
                            position: .bottom
                        )

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.navigationController?.popViewController(animated: true)
                        }

                    } else {

                        // Generic API failure
                        let message = json?["message"] as? String
                            ?? json?["error_description"] as? String
                            ?? error
                            ?? "Failed to generate payment link."

                        self.view.makeToast(
                            message,
                            duration: 3.0,
                            position: .bottom
                        )
                    }
                }
            }
            
        } else {
          
            self.view.makeToast(

                "Your Email and Mobile are empty. Please edit your details before proceeding.",

                duration: 2.0,

                position: .bottom

            )
        }
    }
    
    @IBAction func verifyPaymentAction(_ sender: UIButton) {

        showLoader()

        let payload: [String: Any] = [
            "paymentDetailId": paymentDetailId ?? EMPTY
        ]

        paymentWebService.verifyPaymentAPI(param: payload) { error, json, status in

            DispatchQueue.main.async {

                self.hideLoader()

                if status == .success {

                    self.paymentStatusTxtFld?.text = "Success"

                    self.updateButtonState(step: .submit)

                    SceneDelegate.getSceneDelegate().window?.rootViewController?.view.makeToast("Payment verified successfully.")

                } else {

                    let msg = error ?? "Payment verification failed."

                    SceneDelegate.getSceneDelegate().window?.rootViewController?.view.makeToast(msg)
                }
            }
        }
    }
    
    func updateButtonState(step: PaymentStep) {

        switch step {

        case .sendLink:

            sendLinkBtn?.isEnabled = true
            verifyPaymentBtn?.isEnabled = false
            submitBtn?.isEnabled = false

            sendLinkBtn?.alpha = 1.0
            verifyPaymentBtn?.alpha = 0.5
            submitBtn?.alpha = 0.5

        case .verifyPayment:

            sendLinkBtn?.isEnabled = false
            verifyPaymentBtn?.isEnabled = true
            submitBtn?.isEnabled = false

            sendLinkBtn?.alpha = 0.5
            verifyPaymentBtn?.alpha = 1.0
            submitBtn?.alpha = 0.5

        case .submit:

            sendLinkBtn?.isEnabled = false
            verifyPaymentBtn?.isEnabled = false
            submitBtn?.isEnabled = true

            sendLinkBtn?.alpha = 0.5
            verifyPaymentBtn?.alpha = 0.5
            submitBtn?.alpha = 1.0
        }
    }
        

    @IBAction func savePaymentAction(_ sender: UIButton) {
        guard let mode = paymentModeTxtFld?.text, validatePaymentFields(paymentMode: mode) else { return }
        showLoader()
        var paymentPayload: [String: Any] = [:]
        switch mode {
        case "RTGS":
            paymentPayload = [
                "Opportunity_Name__c": EOiModelDict.id ?? EMPTY,
                "Payment_Mode__c": mode,
                "EOI_Amount__c": EOITxtFld?.text ?? EMPTY,
                "UTR_Number__c": UTRTxtFld?.text ?? EMPTY,
                "Drawn_Bank__c": drawnBankTxtFld?.text ?? EMPTY,
                "Bank_Account_Number__c": bankAccountNumberTxtFld?.text ?? EMPTY,
                "IFSC_Code__c": IFSCTxtFld?.text ?? EMPTY,
                "Payment_Reference_Number__c": referenceNumberTxtFld?.text ?? EMPTY,
                "Payment_Date__c": paymentDateTxtFld?.text ?? EMPTY,
                "Notes__c": notesTxtView?.text ?? EMPTY,
                "Declaration__c": isCheckBoxEnabled
            ]

        case "NEFT":
            paymentPayload = [
                "Opportunity_Name__c": EOiModelDict.id ?? EMPTY,
                "Payment_Mode__c": mode,
                "EOI_Amount__c": EOITxtFld?.text ?? EMPTY,
                "UTR_Number__c": UTRTxtFld?.text ?? EMPTY,
                "Drawn_Bank__c": drawnBankTxtFld?.text ?? EMPTY,
                "IFSC_Code__c": IFSCTxtFld?.text ?? EMPTY,
                "Payment_Reference_Number__c": referenceNumberTxtFld?.text ?? EMPTY,
                "Payment_Date__c": paymentDateTxtFld?.text ?? EMPTY,
                "Notes__c": notesTxtView?.text ?? EMPTY,
                "Declaration__c": isCheckBoxEnabled
            ]
        case "Cheque":
            paymentPayload = [
                "Opportunity_Name__c": EOiModelDict.id ?? EMPTY,
                "Payment_Mode__c": mode,
                "EOI_Amount__c": EOITxtFld?.text ?? EMPTY,
                "Cheque_UTR_Number__c": DDNumberTxtFld?.text ?? EMPTY,
                "Cheque_UTR_Date__c": DDDateTxtFld?.text ?? EMPTY,
                "Drawn_Bank__c": drawnBankTxtFld?.text ?? EMPTY,
                "Bank_Account_Number__c": bankAccountNumberTxtFld?.text ?? EMPTY,
                "Notes__c": notesTxtView?.text ?? EMPTY,
                "Declaration__c": isCheckBoxEnabled
            ]
        case "Demand Draft(DD)":
            paymentPayload = [
                "Opportunity_Name__c": EOiModelDict.id ?? EMPTY,
                "Payment_Mode__c": mode,
                "EOI_Amount__c": EOITxtFld?.text ?? EMPTY,
                "Cheque_UTR_Number__c": DDNumberTxtFld?.text ?? EMPTY,
                "Cheque_UTR_Date__c": DDDateTxtFld?.text ?? EMPTY,
                "Drawn_Bank__c": drawnBankTxtFld?.text ?? EMPTY,
                "Payment_Reference_Number__c": referenceNumberTxtFld?.text ?? EMPTY,
                "Notes__c": notesTxtView?.text ?? EMPTY,
                "Declaration__c": isCheckBoxEnabled
            ]

        case "UPI":
            paymentPayload = [
                "Opportunity_Name__c": EOiModelDict.id ?? EMPTY,
                "Payment_Mode__c": mode,
                "EOI_Amount__c": EOITxtFld?.text ?? EMPTY,
                "UPI_Id__c": UPIIdTxtFld?.text ?? EMPTY,
                "Payment_Reference_Number__c": referenceNumberTxtFld?.text ?? EMPTY,
                "Payment_Date__c": paymentDateTxtFld?.text ?? EMPTY,
                "Drawn_Bank__c": drawnBankTxtFld?.text ?? EMPTY,
                "Notes__c": notesTxtView?.text ?? EMPTY,
                "Declaration__c": isCheckBoxEnabled
            ]
        case "Easebuzz":
            guard let paymentDetailId = self.paymentDetailId,
                  !paymentDetailId.isEmpty else {

                self.hideLoader()

                SceneDelegate.getSceneDelegate().window?.rootViewController?.view.makeToast("Please send the payment link first before submitting.")
                
                return
            }
            paymentPayload = [
                "Opportunity_Name__c": EOiModelDict.id ?? EMPTY,
                "Payment_Mode__c": mode,
                "Payment_Detail__c": paymentDetailId,
                "EOI_Amount__c": EOITxtFld?.text ?? EMPTY,
                "Payment_Status__c": paymentStatusTxtFld?.text ?? EMPTY,
                "Payment_Reference_Number__c": referenceNumberTxtFld?.text ?? EMPTY,
                "Transaction_Id__c": transactionIdTxtFld?.text ?? EMPTY,
                "Payment_Made_Via__c": paymentMadeViaTxtFld?.text ?? EMPTY,
                "Transaction_Message__c": transactionMessageTxtFld?.text ?? EMPTY,
                "Payment_Date__c": paymentDateTxtFld?.text ?? EMPTY,
                "Payment_Time__c": paymentTimeTxtFld?.text ?? EMPTY,
                "Notes__c": notesTxtView?.text ?? EMPTY,
                "Declaration__c": isCheckBoxEnabled
            ]

        default:
            break
        }
        print(paymentPayload)
        paymentWebService.createPayment(payload: paymentPayload) { error, json, status in

            if status == .success {

                if let dict = json,
                   let id = dict["recordId"] as? String {

                    self.paymentId = id

                    if let _ = self.selectedAttachment {

                        Task {

                            await self.uploadAttachment(linkedEntityId: id)

                            DispatchQueue.main.async {

                                self.hideLoader()
                                
                                self.view.makeToast("Payment created and file uploaded successfully.")

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    self.completionalHandler(EMPTY)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }

                    } else {

                        DispatchQueue.main.async {

                            self.hideLoader()

                            
                            self.view.makeToast(

                                "payment created successfully",

                                duration: 2.0,

                                position: .bottom

                            )

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.completionalHandler(EMPTY)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }

                } else {

                    self.hideLoader()

                    let message = json?["message"] as? String ?? "Payment ID not found."

                    self.showAlert(with: "Error", message: message)
                }

            } else {

                DispatchQueue.main.async {
                    self.hideLoader()

                    let msg = error ?? "Something went wrong."

                    self.view.makeToast(
                        msg,
                        duration: 4.0,
                        position: .bottom
                    )
                }
            }
        }
    }
    
    func uploadAttachment(linkedEntityId: String) async {
        guard let attachment = selectedAttachment else { return }
        
        do {
            let base64Data = convertAttachmentToBase64(attachment) ?? ""
            let contentVersionBody: [String: Any] = [
                "Title": attachment.fileName,
                "PathOnClient": attachment.fileName,
                "NetworkId": Defaults.networkId ?? "",
                "VersionData": base64Data
            ]
            
            let contentVersionId = try await CreateRequestWebService.shared.createRecordForFile(
                ofType: "ContentVersion",
                withFields: contentVersionBody
            )
            
            let query = "SELECT ContentDocumentId FROM ContentVersion WHERE Id = '\(contentVersionId)'"
            let queryResponse = try await CreateRequestWebService.shared.queryRecordsAsync(soqlQuery: query)
            
            guard let records = queryResponse["records"] as? [[String: Any]],
                  let contentDocumentId = records.first?["ContentDocumentId"] as? String else {
                throw NSError(domain: "ContentError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ContentDocumentId missing"])
            }
            
            let contentDocumentLinkBody: [String: Any] = [
                "ContentDocumentId": contentDocumentId,
                "LinkedEntityId": linkedEntityId,
                "ShareType": "V"
            ]
            
            _ = try await CreateRequestWebService.shared.createRecordForFile(
                ofType: "ContentDocumentLink",
                withFields: contentDocumentLinkBody
            )
            
        } catch {
            DispatchQueue.main.async {
                self.hideLoader()
                SceneDelegate.getSceneDelegate().window?.makeToast(
                    error.localizedDescription,
                    duration: 2.0,
                    position: Toast_Swift.ToastPosition.bottom
                )
            }
        }
    }
        
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func checkBtnAction() {
        isCheckBoxEnabled = !isCheckBoxEnabled
        sendLinkBtn?.isEnabled = isCheckBoxEnabled
        sendLinkBtn?.alpha = isCheckBoxEnabled ? 1.0 : 0.5
    }
    
    @IBAction func postiveCheckBtnAction() {
        isPositiveCheckBoxEnabled = !isPositiveCheckBoxEnabled
    }
}

extension CreatePaymentVC: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == paymentModeTxtFld {
            showPaymentModeDropdown()
            return false
        }
        return true
    }
    
    func showPaymentModeDropdown() {
        let options = FetchPicklistValue.shared.picklistOptionsDict["Payment_Mode__c"] ?? []
        let accountLabel = options.map { $0.label }
        let accountValue = options.map { $0.value }
        
        print("Payment Mode Labels: \(accountLabel)")
        print("Payment Mode Values: \(accountValue)")
        
        paymentModeDropdown.anchorView = paymentModeTxtFld
        paymentModeDropdown.dataSource = accountValue
        
        paymentModeDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard index < accountLabel.count else { return }
            self?.paymentModeTxtFld?.text = item
            self?.paymentMode = item
            self?.UIUpdateAccordingToPaymentMode(paymentMode: item)
        }
        
        if let firstItem = accountValue.first {
            paymentModeTxtFld?.text = firstItem
            UIUpdateAccordingToPaymentMode(paymentMode: firstItem)
        }
        
        paymentModeDropdown.show()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == notesTxtView {
            let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = size.height
                }
            }
//            let currentCount = textView.text.count
//            countLbl?.text = "\(currentCount)"
            if textView.text.isEmpty {
                textView.setPlaceholder("Type Notes here..")
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
}

extension CreatePaymentVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    @objc func openChequeUploadOptions() {
        currentUploadField = "Cheque"
        showUploadOptions(sourceField: "Cheque")
    }
    
    @objc func openDocumentUploadOptions() {
        currentUploadField = "Document"
        showUploadOptions(sourceField: "Document")
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
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let timestamp = Int(Date().timeIntervalSince1970)
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("image_\(timestamp).jpg")
                try? imageData.write(to: tempURL)
                
                selectedAttachment = Attachment(
                    fileName: "image_\(timestamp).jpg",
                    fileURL: tempURL,
                    fileType: "image/jpeg"
                )
                
                if currentUploadField == "Cheque" {
                    cancelChequeUploadTxtFld?.text = "Cheque Image Selected"
                } else {
                    AttachDocumentTxtFld?.text = "Image Selected"
                }
                
                print("✅ Image assigned to selectedAttachment: \(tempURL)")
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        
        let fileName = selectedFile.lastPathComponent
        let fileType = selectedFile.pathExtension.lowercased()
        
        selectedAttachment = Attachment(
            fileName: fileName,
            fileURL: selectedFile,
            fileType: fileType
        )
        
        if currentUploadField == "Cheque" {
            cancelChequeUploadTxtFld?.text = fileName
        } else {
            AttachDocumentTxtFld?.text = fileName
        }
        
        print("✅ File assigned to selectedAttachment: \(selectedFile)")
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



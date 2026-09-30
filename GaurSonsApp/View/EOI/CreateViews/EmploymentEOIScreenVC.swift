//
//  EmploymentEOIScreenVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 28/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class EmploymentEOIScreenVC: UIViewController, UITextViewDelegate {
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    @IBOutlet var professionalJobTitletxtFld: MDCOutlinedTextField?
    @IBOutlet var employmentTitletxtFld: MDCOutlinedTextField?
    @IBOutlet var companyNameAddresstxtVw: UITextView?
    @IBOutlet var resetBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    var validation = Validation()
    var applicantIndex: Int?
    var employmentTypeDropdown = DropDown()
    var jobTitleDropdown = DropDown()
    var isFromCustomers: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var isForEditing: Bool = false
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var isLocalEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let textView = companyNameAddresstxtVw?.viewWithTag(101) as? UITextView {
            textView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await FetchPicklistValue.shared.fetchPicklistValues(
                objectName: "Applicant_Details__c",
                fieldNames: ["Profession_Job_Title__c", "Employment_Type__c"]
            )
        }
    }
    
    func setUpInitialUI() {
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        if Defaults.isIndividualEnable ?? false {
            pageNumberLbl?.text = "3"
            OutOfPageNumber?.text = "7"
        } else if Defaults.isPartnerShip ?? false {
            pageNumberLbl?.text = "4"
            OutOfPageNumber?.text = "8"
        } else {
            pageNumberLbl?.text = "4"
            OutOfPageNumber?.text = "7"
        }
        companyNameAddresstxtVw?.delegate = self
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        resetBtn?.borderWidth = 1
        resetBtn?.borderColor = UIColor(hex: "DFE1E0")
        resetBtn?.layer.cornerRadius = 6
        nextBtn?.layer.cornerRadius = 6
        companyNameAddresstxtVw?.dropShadow()
        companyNameAddresstxtVw?.placeholder = "Enter Company Name & Address"
        companyNameAddresstxtVw?.textColor = .darkGray
        companyNameAddresstxtVw?.textContainerInset = UIEdgeInsets(top: 13, left: 10, bottom: 10, right: 13)
        
        professionalJobTitletxtFld?.label.text = "Profession / Job Title"
        professionalJobTitletxtFld?.setOutlineColor(.darkGray, for: .normal)
        professionalJobTitletxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        professionalJobTitletxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        employmentTitletxtFld?.label.text = "Employment Type"
        employmentTitletxtFld?.setOutlineColor(.darkGray, for: .normal)
        employmentTitletxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        employmentTitletxtFld?.translatesAutoresizingMaskIntoConstraints = false
        employmentTitletxtFld?.delegate = self
        employmentTitletxtFld?.inputView = UIView()
        if isForEditing {
            DispatchQueue.main.async {
                self.companyNameAddresstxtVw?.text = self.applicantDetailsModel.companyName
                self.professionalJobTitletxtFld?.text = self.applicantDetailsModel.professionTitle
                self.employmentTitletxtFld?.text = self.applicantDetailsModel.employmentType
                
                if !(self.applicantDetailsModel.companyName ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.companyNameAddresstxtVw?.removePlaceholder()
                }
            }

        } else if isLocalEdit {

            if let index = applicantIndex {
                let applicant = OpportunityManager.shared.getApplicant(at: index)

                companyNameAddresstxtVw?.text = applicant?.companyName
                professionalJobTitletxtFld?.text = applicant?.profession
                employmentTitletxtFld?.text = applicant?.employmentType

                if !(applicant?.companyName ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    companyNameAddresstxtVw?.removePlaceholder()
                }
            }
        }
    }
    
    func clearAllFields() {
        companyNameAddresstxtVw?.text = ""
        professionalJobTitletxtFld?.text = ""
        employmentTitletxtFld?.text = ""
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
    
    func validateFields() -> Bool {
        
        let profession = professionalJobTitletxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let employmentType = employmentTitletxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let companyAddress = companyNameAddresstxtVw?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if profession.isEmpty {
            showAlert(with: "Validation Error", message: "Please enter profession/job title.")
            return false
        }
        
        if employmentType.isEmpty {
            showAlert(with: "Validation Error", message: "Please select employment type.")
            return false
        }
        
        if companyAddress.isEmpty || companyAddress == "Enter Company Name & Address" {
            showAlert(with: "Validation Error", message: "Please enter company name & address.")
            return false
        }
        
        return true
    }
    
    @IBAction func resetAction() {
        clearAllFields()
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction() {

        guard validateFields() else { return }

        var applicant: SaveModel

        if let index = applicantIndex {

            applicant = OpportunityManager.shared.getApplicant(at: index) ?? SaveModel(dict: [:])

        } else {

            let newApplicant = SaveModel(dict: [:])

            OpportunityManager.shared.applicants.append(newApplicant)

            applicantIndex = OpportunityManager.shared.applicants.count - 1

            applicant = newApplicant
        }

        applicant.profession = professionalJobTitletxtFld?.text
        applicant.employmentType = employmentTitletxtFld?.text
        applicant.companyName = companyNameAddresstxtVw?.text

        if let index = applicantIndex {
            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
        }

        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)

        let bankDetailsVC = storyboard.instantiateViewController(
            withIdentifier: "BankDetailsEOISCreenVC"
        ) as! BankDetailsEOISCreenVC

        bankDetailsVC.applicantIndex = applicantIndex
        bankDetailsVC.isFromCustomers = isFromCustomers
        bankDetailsVC.cuatomerDetailsDict = cuatomerDetailsDict

        bankDetailsVC.isForEditing = isForEditing

        bankDetailsVC.isLocalEdit = isLocalEdit

        bankDetailsVC.applicantDetailsModel = applicantDetailsModel

        self.navigationController?.pushViewController(bankDetailsVC, animated: true)
    }
    
    
//    @IBAction func nextBtnAction() {
//        guard validateFields() else { return }
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
//        applicant.profession = professionalJobTitletxtFld?.text
//        applicant.employmentType = employmentTitletxtFld?.text
//        applicant.companyName = companyNameAddresstxtVw?.text
//        
//        if let index = applicantIndex {
//            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
//        }
//        
//        let storyboardBundle = Bundle.main
//        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
//        let bankDetailsVC = storyboard.instantiateViewController(withIdentifier: "BankDetailsEOISCreenVC") as! BankDetailsEOISCreenVC
//        bankDetailsVC.applicantIndex = applicantIndex
//        bankDetailsVC.isFromCustomers = isFromCustomers
//        bankDetailsVC.cuatomerDetailsDict = cuatomerDetailsDict
//        bankDetailsVC.isForEditing = isForEditing
//        bankDetailsVC.applicantDetailsModel = applicantDetailsModel
//        self.navigationController?.pushViewController(bankDetailsVC, animated: true)
//    }
}

extension EmploymentEOIScreenVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == employmentTitletxtFld {
            showEmploymentTitleDropdown()
            return false
        }
        //        else if textField == professionalJobTitletxtFld {
        //            showJobTitleDropdown()
        //            return false
        //        }
        return true
    }
    
    func showEmploymentTitleDropdown() {
        let options = FetchPicklistValue.shared.picklistOptionsDict["Employment_Type__c"] ?? []
        let accountLabel = options.map { $0.label }
        let accountValue = options.map { $0.value }
        
        print("Employment_Type__c Labels: \(accountLabel)")
        print("Employment_Type__c: \(accountValue)")
        
        employmentTypeDropdown.anchorView = employmentTitletxtFld
        employmentTypeDropdown.dataSource = accountValue
        
        employmentTypeDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard index < accountLabel.count else { return }
            self?.employmentTitletxtFld?.text = item
        }
        employmentTypeDropdown.show()
    }
    
    //    func showJobTitleDropdown() {
    //        let options = FetchPicklistValue.shared.picklistOptionsDict["Profession_Job_Title__c"] ?? []
    //        let accountLabel = options.map { $0.label }
    //        let accountValue = options.map { $0.value }
    //
    //        print("Profession_Job_Title__c Labels: \(accountLabel)")
    //        print("Profession_Job_Title__c: \(accountValue)")
    //
    //        jobTitleDropdown.anchorView = professionalJobTitletxtFld
    //        jobTitleDropdown.dataSource = accountValue
    //
    //        jobTitleDropdown.selectionAction = { [weak self] (index: Int, item: String) in
    //            guard index < accountLabel.count else { return }
    //            self?.professionalJobTitletxtFld?.text = item
    //        }
    //        jobTitleDropdown.show()
    //    }
    
}

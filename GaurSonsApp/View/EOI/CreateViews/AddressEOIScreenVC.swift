//
//  AddressEOIScreenVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 26/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class AddressEOIScreenVC: UIViewController {
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var headingLbl: UILabel?
    @IBOutlet var permanentView: UIView?
    @IBOutlet var permanentViewHeight: NSLayoutConstraint?
    @IBOutlet var crosspondanceView: UIView?
    @IBOutlet var crosspondanceAddressLbl: UILabel?
    @IBOutlet var crossYesHeight: NSLayoutConstraint?
    @IBOutlet var crossNoHeight: NSLayoutConstraint?
    @IBOutlet var crosspondanceViewHeight: NSLayoutConstraint?
    @IBOutlet var registerView: UIView?
    @IBOutlet var registerViewHeight: NSLayoutConstraint?
    @IBOutlet var pageNumberLbl: UILabel?
    @IBOutlet var OutOfPageNumber: UILabel?
    @IBOutlet var topRedTextLabel: UILabel?
    @IBOutlet var permanentAddresstxtFld: MDCOutlinedTextField?
    @IBOutlet var permanentCountrytxtFld: MDCOutlinedTextField?
    @IBOutlet var permanentStatetxtFld: MDCOutlinedTextField?
    @IBOutlet var permanentCitytxtFld: MDCOutlinedTextField?
    @IBOutlet var permanentPincodetxtFld: MDCOutlinedTextField?
    @IBOutlet var correspondenceAddresstxtFld: MDCOutlinedTextField?
    @IBOutlet var correspondenceCountrytxtFld: MDCOutlinedTextField?
    @IBOutlet var correspondenceStatetxtFld: MDCOutlinedTextField?
    @IBOutlet var correspondenceCitytxtFld: MDCOutlinedTextField?
    @IBOutlet var correspondencePincodetxtFld: MDCOutlinedTextField?
    @IBOutlet var registerAddresstxtFld: MDCOutlinedTextField?
    @IBOutlet var registerCountrytxtFld: MDCOutlinedTextField?
    @IBOutlet var registerStatetxtFld: MDCOutlinedTextField?
    @IBOutlet var registerCitytxtFld: MDCOutlinedTextField?
    @IBOutlet var registerPincodetxtFld: MDCOutlinedTextField?
    @IBOutlet var resetBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    @IBOutlet var permanentSelfOwnedBtn: UIButton?
    @IBOutlet var permanentRentedBtn: UIButton?
    @IBOutlet var isCorrespondenceYES: UIButton?
    @IBOutlet var isCorrespondenceNO: UIButton?
    @IBOutlet var isRegisterYES: UIButton?
    @IBOutlet var isRegisterNO: UIButton?
    @IBOutlet var correspondenceSelfOwnedBtn: UIButton?
    @IBOutlet var correspondenceRentedBtn: UIButton?
    @IBOutlet var registeredSelfOwnedBtn: UIButton?
    @IBOutlet var registeredRentedBtn: UIButton?
    @IBOutlet var countryImg: UIImageView?
    @IBOutlet var stateImg: UIImageView?
    @IBOutlet var cityImg: UIImageView?
    @IBOutlet var regcountryImg: UIImageView?
    @IBOutlet var regstateImg: UIImageView?
    @IBOutlet var regcityImg: UIImageView?
    var isPermanentSelfOwnedBtnEnabled: Bool = false
    var isPermanentRentedBtnEnabled: Bool = false
    var isCorrespondencetSelfOwnedBtnEnabled: Bool = false
    var isCorrespondenceRentedBtnEnabled: Bool = false
    var isRegisteredSelfOwnedBtnEnabled: Bool = false
    var isRegisteredRentedBtnEnabled: Bool = false
    var isYesSamePermamnet: Bool = false
    var isYesSameCorrespondence: Bool = false
    var isCustomerDetailsSelected: Bool = false
    var validation = Validation()
    var applicantIndex: Int?
    
    var permanentCountryDropdown = DropDown()
    var permanentStateDropdown = DropDown()
    var permanentCityDropdown = DropDown()

    var correspondenceCountryDropdown = DropDown()
    var correspondenceStateDropdown = DropDown()
    var correspondenceCityDropdown = DropDown()

    var registerCountryDropdown = DropDown()
    var registerStateDropdown = DropDown()
    var registerCityDropdown = DropDown()
    var crosspondanceCountryDropdown = DropDown()
    var crosspondanceStateDropdown = DropDown()
    var crosspondanceCityDropdown = DropDown()
    var isFromCustomers: Bool = false
    var cuatomerDetailsDict: CustomerModel?
    var isForEditing: Bool = false
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    var countriesList: [String] = []
    var statesList: [String: [String]] = [:]
    var citiesList: [String: [String]] = [:]
    var loaderView: UIActivityIndicatorView?
    var isLocalEdit: Bool = false
    var addharDetailDict: [String: Any] = [:]
    var isAddharVerify: Bool = false
    
    private var isIndividualApplicantFlow: Bool {
        let applicantType = (Helper.typeDisplayName ?? EMPTY).trimmingCharacters(in: .whitespacesAndNewlines)
        return applicantType.caseInsensitiveCompare("Individual") == .orderedSame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView = UIActivityIndicatorView(style: .large)
        loaderView?.color = .gray
        loaderView?.center = view.center
        loaderView?.hidesWhenStopped = true
        if let loader = loaderView {
            view.addSubview(loader)
        }
        setUpInitialUI()
        print(cuatomerDetailsDict)
        fetchCountriesInitially()
       
//        Utility.getAllCountries { success in
//            if success {
//                self.countryDropdown.dataSource = GlobalData.allCountries.compactMap { $0.name }
//                self.countryDropdown.show()
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
            statusBarView.backgroundColor = ColorConstant.screensBackgroundColor
            view.addSubview(statusBarView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        permanentView?.isHidden = true
        permanentViewHeight?.constant = 0
        registerView?.isHidden = true
        registerViewHeight?.constant = 0
        crosspondanceAddressLbl?.text = "Correspondence Address is Same as Permanent Address"
//        permanentAddresstxtFld?.text = "H.No 245, Sector 15"
//        permanentPincodetxtFld?.text = "122001"
        crossYesHeight?.constant = 40
        crossNoHeight?.constant = 40
        isCorrespondenceYES?.isHidden = false
        isCorrespondenceNO?.isHidden = false
        countryImg?.isHidden = true
        stateImg?.isHidden = true
        cityImg?.isHidden = true
        regcountryImg?.isHidden = true
        regstateImg?.isHidden = true
        regcityImg?.isHidden = true
        if isIndividualApplicantFlow {
            permanentView?.isHidden = false
            permanentViewHeight?.constant = 476
            regcountryImg?.isHidden = false
            regstateImg?.isHidden = false
            regcityImg?.isHidden = false
        } else {
            crosspondanceAddressLbl?.text = ""
            crossYesHeight?.constant = 0
            isCorrespondenceYES?.isHidden = true
            isCorrespondenceNO?.isHidden = true
            crossNoHeight?.constant = 0
            registerView?.isHidden = false
            registerViewHeight?.constant = 520
            countryImg?.isHidden = false
            stateImg?.isHidden = false
            cityImg?.isHidden = false
        }
//        Task {
//            await FetchPicklistValue.shared.fetchPicklistValues(
//                objectName: "Address_Details__c",
//                fieldNames: ["Permanent_Country__c", "Permanent_City__c", "Permanent_State__c"]
//            )
//        }
        
    }
    
    
    
    func fetchCountriesInitially() {
        DispatchQueue.main.async {
            self.loaderView?.startAnimating()
        }
        Task {
            let countries = await FetchPicklistValue.shared.fetchCountries()
            DispatchQueue.main.async {
                self.countriesList = countries.map { $0.value }
                DispatchQueue.main.async {
                    self.loaderView?.stopAnimating()
                }
            }
        }
    }
    
    func fetchStates(country: String) {
        if statesList[country] != nil {
            return
        }
        Task {
            let states = await FetchPicklistValue.shared.fetchStates(country: country)
            
            let uniqueStates = Array(Set(states.map { $0.value })).sorted()
            
            DispatchQueue.main.async {
                self.statesList[country] = uniqueStates
            }
        }
    }
    
    func fetchCities(state: String) {

        if citiesList[state] != nil {
            return
        }

        Task {

            let cities = await FetchPicklistValue.shared.fetchCities(state: state)

            let uniqueCities = Array(Set(cities.map { $0.value })).sorted()

            DispatchQueue.main.async {
                self.citiesList[state] = uniqueCities
            }
        }
    }
    
    func setUpInitialUI() {
        if isAddharVerify {

            print("🔵 addharDetailDict:", addharDetailDict)

                print("🔵 split_address:", addharDetailDict["split_address"] as Any)

            if let splitAddress = addharDetailDict["split_address"] as? [String: Any] {

                let house = splitAddress["house"] as? String ?? ""

                let landmark = splitAddress["landmark"] as? String ?? ""

                let street = splitAddress["street"] as? String ?? ""

                let vtc = splitAddress["vtc"] as? String ?? ""

                let po = splitAddress["po"] as? String ?? ""

                let district = splitAddress["dist"] as? String ?? ""

                let state = splitAddress["state"] as? String ?? ""

                let country = splitAddress["country"] as? String ?? ""

                let pincode = "\(splitAddress["pincode"] ?? "")"

                // Build complete address

                let addressParts = [

                    house,

                    street,

                    landmark,

                    vtc,

                    po,

                    district

                ]

                .filter { !$0.isEmpty }

                let permanentAddress = addressParts.joined(separator: ", ")

                DispatchQueue.main.async {

                    // Populate Permanent Address

                    self.permanentAddresstxtFld?.text = permanentAddress

                    self.permanentCountrytxtFld?.text = country

                    self.permanentStatetxtFld?.text = state

                    self.permanentCitytxtFld?.text = district

                    self.permanentPincodetxtFld?.text = pincode

                    // Disable fields because data came from Aadhaar

                    self.permanentAddresstxtFld?.isEnabled = false

                    self.permanentCountrytxtFld?.isEnabled = false

                    self.permanentStatetxtFld?.isEnabled = false

                    self.permanentCitytxtFld?.isEnabled = false

                    self.permanentPincodetxtFld?.isEnabled = false

                    print("✅ Permanent Address populated from Aadhaar")

                    print("📍 Address:", permanentAddress)

                    print("🏙️ City:", district)

                    print("📌 State:", state)

                    print("📮 Pincode:", pincode)

                    print("🌍 Country:", country)

                }

            }

        }
        
        if isFromCustomers && !isAddharVerify {
            populateAddressFromCustomer()
        }
        if Defaults.isIndividualEnable ?? false {
            pageNumberLbl?.text = "2"
            OutOfPageNumber?.text = "7"
        } else if Defaults.isPartnerShip ?? false {
            pageNumberLbl?.text = "3"
            OutOfPageNumber?.text = "8"
        } else {
            pageNumberLbl?.text = "3"
            OutOfPageNumber?.text = "7"
        }
        if Defaults.isFromEOI ?? false {
            headingLbl?.text = "Applicant EOI Form"
        } else {
            headingLbl?.text = "Applicant Booking Form"
        }
        if Defaults.type == "Individual" {
            topRedTextLabel?.text = "Please Note: In case of Aadhaar Upload, fill the State, City, Pin Code field manually."
        } else {
            topRedTextLabel?.text = EMPTY
        }
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addTapGestureToDismissKeyboard()
        resetBtn?.borderWidth = 1
        resetBtn?.borderColor = UIColor(hex: "DFE1E0")
        resetBtn?.layer.cornerRadius = 6
        nextBtn?.layer.cornerRadius = 6
        isCorrespondenceYES?.borderWidth = 1
        isCorrespondenceYES?.borderColor = UIColor(hex: "DFE1E0")
        isCorrespondenceYES?.layer.cornerRadius = 6
        isCorrespondenceNO?.borderWidth = 1
        isCorrespondenceNO?.borderColor = UIColor(hex: "DFE1E0")
        isCorrespondenceNO?.layer.cornerRadius = 6
        
        isRegisterYES?.borderWidth = 1
        isRegisterYES?.borderColor = UIColor(hex: "DFE1E0")
        isRegisterYES?.layer.cornerRadius = 6
        isRegisterNO?.borderWidth = 1
        isRegisterNO?.borderColor = UIColor(hex: "DFE1E0")
        isRegisterNO?.layer.cornerRadius = 6
        
        permanentAddresstxtFld?.label.text = "Permanent Address"
        permanentAddresstxtFld?.setOutlineColor(.darkGray, for: .normal)
        permanentAddresstxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        permanentAddresstxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        permanentCountrytxtFld?.label.text = "Permanent Country"
        permanentCountrytxtFld?.setOutlineColor(.darkGray, for: .normal)
        permanentCountrytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        permanentCountrytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        permanentCountrytxtFld?.delegate = self
        permanentCountrytxtFld?.inputView = UIView()
//        permanentCountrytxtFld?.text = addharDetailDict.
        
        permanentStatetxtFld?.label.text = "Permanent State"
        permanentStatetxtFld?.setOutlineColor(.darkGray, for: .normal)
        permanentStatetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        permanentStatetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        permanentStatetxtFld?.delegate = self
        permanentStatetxtFld?.inputView = UIView()
        
        permanentCitytxtFld?.label.text = "Permanent City"
        permanentCitytxtFld?.setOutlineColor(.darkGray, for: .normal)
        permanentCitytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        permanentCitytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        permanentCitytxtFld?.delegate = self
        permanentCitytxtFld?.inputView = UIView()
        
        permanentPincodetxtFld?.label.text = "Permanent Pincode"
        permanentPincodetxtFld?.setOutlineColor(.darkGray, for: .normal)
        permanentPincodetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        permanentPincodetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        correspondenceAddresstxtFld?.label.text = "Correspondence Address"
        correspondenceAddresstxtFld?.setOutlineColor(.darkGray, for: .normal)
        correspondenceAddresstxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        correspondenceAddresstxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        correspondenceCountrytxtFld?.label.text = "Correspondence Country"
        correspondenceCountrytxtFld?.setOutlineColor(.darkGray, for: .normal)
        correspondenceCountrytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        correspondenceCountrytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        correspondenceCountrytxtFld?.delegate = self
        correspondenceCountrytxtFld?.inputView = UIView()
        
        correspondenceStatetxtFld?.label.text = "Correspondence State"
        correspondenceStatetxtFld?.setOutlineColor(.darkGray, for: .normal)
        correspondenceStatetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        correspondenceStatetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        correspondenceStatetxtFld?.delegate = self
        correspondenceStatetxtFld?.inputView = UIView()
        
        correspondenceCitytxtFld?.label.text = "Correspondence City"
        correspondenceCitytxtFld?.setOutlineColor(.darkGray, for: .normal)
        correspondenceCitytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        correspondenceCitytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        correspondenceCitytxtFld?.delegate = self
        correspondenceCitytxtFld?.inputView = UIView()
        
        correspondencePincodetxtFld?.label.text = "Correspondence Pincode"
        correspondencePincodetxtFld?.setOutlineColor(.darkGray, for: .normal)
        correspondencePincodetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        correspondencePincodetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        registerAddresstxtFld?.label.text = "Registered Address"
        registerAddresstxtFld?.setOutlineColor(.darkGray, for: .normal)
        registerAddresstxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        registerAddresstxtFld?.translatesAutoresizingMaskIntoConstraints = false
        
        registerCountrytxtFld?.label.text = "Registered Country"
        registerCountrytxtFld?.setOutlineColor(.darkGray, for: .normal)
        registerCountrytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        registerCountrytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        registerCountrytxtFld?.delegate = self
        registerCountrytxtFld?.inputView = UIView()
        
        registerStatetxtFld?.label.text = "Registered State"
        registerStatetxtFld?.setOutlineColor(.darkGray, for: .normal)
        registerStatetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        registerStatetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        registerStatetxtFld?.delegate = self
        registerStatetxtFld?.inputView = UIView()
        
        registerCitytxtFld?.label.text = "Registered City"
        registerCitytxtFld?.setOutlineColor(.darkGray, for: .normal)
        registerCitytxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        registerCitytxtFld?.translatesAutoresizingMaskIntoConstraints = false
        registerCitytxtFld?.delegate = self
        registerCitytxtFld?.inputView = UIView()
        
        registerPincodetxtFld?.label.text = "Registered Pincode"
        registerPincodetxtFld?.setOutlineColor(.darkGray, for: .normal)
        registerPincodetxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        registerPincodetxtFld?.translatesAutoresizingMaskIntoConstraints = false
        if isForEditing {
            DispatchQueue.main.async {
                self.isPermanentSelfOwnedBtnEnabled = self.applicantDetailsModel.permanentSelfOwned ?? false
                self.isPermanentRentedBtnEnabled = self.applicantDetailsModel.permanentRented ?? false
                if self.isPermanentSelfOwnedBtnEnabled {
                    self.permanentSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioSelected"),
                        for: .normal
                    )
                    
                    self.permanentRentedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                } else if self.isPermanentRentedBtnEnabled {
                    self.permanentSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                    self.permanentRentedBtn?.setImage(
                        UIImage(named: "RodioSelected"),
                        for: .normal
                    )
                    
                } else {
                    self.permanentSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                    self.permanentRentedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                }
                self.permanentAddresstxtFld?.text = self.applicantDetailsModel.permanentAddress
                self.permanentCountrytxtFld?.text = self.applicantDetailsModel.permanentCountry
                self.permanentStatetxtFld?.text = self.applicantDetailsModel.permanentState
                self.permanentCitytxtFld?.text = self.applicantDetailsModel.permanentCity
                self.permanentPincodetxtFld?.text = self.applicantDetailsModel.permanentPincode
                self.permanentCitytxtFld?.isEnabled = false
                self.permanentStatetxtFld?.isEnabled = false
                self.permanentCountrytxtFld?.isEnabled = false
                self.permanentAddresstxtFld?.isEnabled = false
                self.permanentPincodetxtFld?.isEnabled = false
                
                self.isCorrespondencetSelfOwnedBtnEnabled = self.applicantDetailsModel.selfOwned ?? false
                self.isCorrespondenceRentedBtnEnabled = self.applicantDetailsModel.rented ?? false
                self.correspondenceAddresstxtFld?.text = self.applicantDetailsModel.correspondenceAddress
                self.correspondenceCountrytxtFld?.text = self.applicantDetailsModel.correspondenceCountry
                self.correspondenceStatetxtFld?.text = self.applicantDetailsModel.correspondenceState
                self.correspondenceCitytxtFld?.text = self.applicantDetailsModel.correspondenceCity
                self.correspondencePincodetxtFld?.text = self.applicantDetailsModel.correspondencePincode
                if self.isCorrespondencetSelfOwnedBtnEnabled {
                    self.correspondenceSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioSelected"),
                        for: .normal
                    )
                    
                    self.correspondenceRentedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                } else if self.isCorrespondenceRentedBtnEnabled {
                    self.correspondenceSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                    self.correspondenceRentedBtn?.setImage(
                        UIImage(named: "RodioSelected"),
                        for: .normal
                    )
                    
                } else {
                    self.correspondenceSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                    self.correspondenceRentedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                }
                self.isRegisteredSelfOwnedBtnEnabled = self.applicantDetailsModel.registeredSelfOwned ?? false
                self.isRegisteredRentedBtnEnabled = self.applicantDetailsModel.registeredRented ?? false
                self.registerAddresstxtFld?.text = self.applicantDetailsModel.registeredAddress
                self.registerCountrytxtFld?.text = self.applicantDetailsModel.registeredCountry
                self.registerStatetxtFld?.text = self.applicantDetailsModel.registeredState
                self.registerCitytxtFld?.text = self.applicantDetailsModel.registeredCity
                self.registerPincodetxtFld?.text = self.applicantDetailsModel.registeredPincode
                if self.isRegisteredSelfOwnedBtnEnabled {
                    self.registeredSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioSelected"),
                        for: .normal
                    )
                    
                    self.registeredRentedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                } else if self.isRegisteredRentedBtnEnabled {
                    self.registeredSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                    self.registeredRentedBtn?.setImage(
                        UIImage(named: "RodioSelected"),
                        for: .normal
                    )
                    
                } else {
                    self.registeredSelfOwnedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                    self.registeredRentedBtn?.setImage(
                        UIImage(named: "RodioUnselected"),
                        for: .normal
                    )
                    
                }
            }
        } else if isLocalEdit {

            guard let index = applicantIndex else { return }

            let applicant = OpportunityManager.shared.getApplicant(at: index)
            if isIndividualApplicantFlow {
                permanentAddresstxtFld?.text = applicant?.permanentAddress
                permanentCountrytxtFld?.text = applicant?.permanentCountry
                permanentStatetxtFld?.text = applicant?.permanentState
                permanentCitytxtFld?.text = applicant?.permanentCity
                permanentPincodetxtFld?.text = applicant?.permanentPincode
            } else {
                registerAddresstxtFld?.text = applicant?.registeredAddress
                registerCountrytxtFld?.text = applicant?.registeredCountry
                registerStatetxtFld?.text = applicant?.registeredStates
                registerCitytxtFld?.text = applicant?.registeredCity
                registerPincodetxtFld?.text = applicant?.registeredPincode
            }

            correspondenceAddresstxtFld?.text = applicant?.correspondenceAddress
            correspondenceCountrytxtFld?.text = applicant?.correspondenceCountry
            correspondenceStatetxtFld?.text = applicant?.correspondenceState
            correspondenceCitytxtFld?.text = applicant?.correspondenceCity
            correspondencePincodetxtFld?.text = applicant?.correspondencePincode

        }
    }
    
//    private func populateAddressFromCustomer() {
//        guard let customer = cuatomerDetailsDict else {
//            print("❌ Customer details are nil")
//            return
//        }
//
//        // Build the address using the customer response.
//        let address: String
//
//        if let completeAddress = customer.completeAddress,
//           !completeAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
//           completeAddress.caseInsensitiveCompare("<null>") != .orderedSame {
//
//            address = completeAddress
//
//        } else {
//            let addressParts = [
//                customer.house,
//                customer.street,
//                customer.landmark,
//                customer.vtc,
//                customer.postOffice,
//                customer.district
//            ]
//            .compactMap { $0 }
//            .filter {
//                let value = $0.trimmingCharacters(in: .whitespacesAndNewlines)
//                return !value.isEmpty &&
//                       value.caseInsensitiveCompare("<null>") != .orderedSame
//            }
//
//            address = addressParts.joined(separator: ", ")
//        }
//
//        let country = customer.country ?? ""
//        let state = customer.state ?? ""
//        let city = customer.district ?? ""
//        let pincode = customer.pincode ?? ""
//
//        DispatchQueue.main.async {
//            if self.isIndividualApplicantFlow {
//                // Individual applicant: Permanent Address
//                self.permanentAddresstxtFld?.text = address
//                self.permanentCountrytxtFld?.text = country
//                self.permanentStatetxtFld?.text = state
//                self.permanentCitytxtFld?.text = city
//                self.permanentPincodetxtFld?.text = pincode
//
//            } else {
//                // Non-individual applicant: Registered Address
//                self.registerAddresstxtFld?.text = address
//                self.registerCountrytxtFld?.text = country
//                self.registerStatetxtFld?.text = state
//                self.registerCitytxtFld?.text = city
//                self.registerPincodetxtFld?.text = pincode
//            }
//
//            print("✅ Customer address populated")
//            print("🌍 Country: \(country)")
//            print("📍 Address: \(address)")
//            print("🏙️ State: \(state)")
//            print("🏙️ City: \(city)")
//            print("📮 Pincode: \(pincode)")
//        }
//    }
    
    private func populateAddressFromCustomer() {
        guard let customer = cuatomerDetailsDict else {
            print("❌ Customer details are nil")
            return
        }

        // Convert nil, empty, "null", and "<null>" values to empty strings.
        func cleanValue(_ value: String?) -> String {
            guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !value.isEmpty,
                  value.caseInsensitiveCompare("null") != .orderedSame,
                  value.caseInsensitiveCompare("<null>") != .orderedSame else {
                return ""
            }

            return value
        }

        // Clean individual address components.
        let house = cleanValue(customer.house)
        let street = cleanValue(customer.street)
        let landmark = cleanValue(customer.landmark)
        let vtc = cleanValue(customer.vtc)
        let postOffice = cleanValue(customer.postOffice)
        let district = cleanValue(customer.district)

        // Use complete address if available; otherwise build it.
        let completeAddress = cleanValue(customer.completeAddress)

        let address: String

        if !completeAddress.isEmpty {
            address = completeAddress
        } else {
            address = [
                house,
                street,
                landmark,
                vtc,
                postOffice,
                district
            ]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        }

        // Clean country, state, city, and pincode.
        let country = cleanValue(customer.country)
        let state = cleanValue(customer.state)
        let city = cleanValue(customer.district)
        let pincode = cleanValue(customer.pincode)

        DispatchQueue.main.async {
            if self.isIndividualApplicantFlow {
                // Individual applicant: Populate Permanent Address.
                self.permanentAddresstxtFld?.text = address
                self.permanentCountrytxtFld?.text = country
                self.permanentStatetxtFld?.text = state
                self.permanentCitytxtFld?.text = city
                self.permanentPincodetxtFld?.text = pincode
            } else {
                // Non-individual applicant: Populate Registered Address.
                self.registerAddresstxtFld?.text = address
                self.registerCountrytxtFld?.text = country
                self.registerStatetxtFld?.text = state
                self.registerCitytxtFld?.text = city
                self.registerPincodetxtFld?.text = pincode
            }

            print("✅ Customer address populated")
            print("🌍 Country: \(country)")
            print("📍 Address: \(address)")
            print("🏙️ State: \(state)")
            print("🏙️ City: \(city)")
            print("📮 Pincode: \(pincode)")
        }
    }
    
    func clearAllFields() {
        permanentAddresstxtFld?.text = ""
        permanentCountrytxtFld?.text = ""
        permanentStatetxtFld?.text = ""
        permanentCitytxtFld?.text = ""
        permanentPincodetxtFld?.text = ""
        
        correspondenceAddresstxtFld?.text = ""
        correspondenceCountrytxtFld?.text = ""
        correspondenceStatetxtFld?.text = ""
        correspondenceCitytxtFld?.text = ""
        correspondencePincodetxtFld?.text = ""
        
        registerAddresstxtFld?.text = ""
        registerCountrytxtFld?.text = ""
        registerStatetxtFld?.text = ""
        registerCitytxtFld?.text = ""
        registerPincodetxtFld?.text = ""
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func validateFields() -> Bool {
        
        if isIndividualApplicantFlow {
            
            // MARK: Permanent Address Validation
            
            if (permanentAddresstxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please enter permanent address.")
                return false
            }
            
            if (permanentCountrytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select permanent country.")
                return false
            }
            
            if (permanentStatetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select permanent state.")
                return false
            }
            
            if (permanentCitytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select permanent city.")
                return false
            }
            
            let permanentPincode = permanentPincodetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if permanentPincode.isEmpty {
                showAlert(with: "Validation Error", message: "Please enter permanent pincode.")
                return false
            }
            
            if permanentPincode.count != 6 {
                showAlert(with: "Validation Error", message: "Please enter valid permanent pincode.")
                return false
            }
            if !isForEditing {
                if !isPermanentSelfOwnedBtnEnabled && !isPermanentRentedBtnEnabled {
                    showAlert(with: "Validation Error", message: "Please select permanent address type.")
                    return false
                }
            }
            
            // MARK: Correspondence Address Validation
            
            if (correspondenceAddresstxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please enter correspondence address.")
                return false
            }
            
            if (correspondenceCountrytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select correspondence country.")
                return false
            }
            
            if (correspondenceStatetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select correspondence state.")
                return false
            }
            
            if (correspondenceCitytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select correspondence city.")
                return false
            }
            
            let correspondencePincode = correspondencePincodetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if correspondencePincode.isEmpty {
                showAlert(with: "Validation Error", message: "Please enter correspondence pincode.")
                return false
            }
            
            if correspondencePincode.count != 6 {
                showAlert(with: "Validation Error", message: "Please enter valid correspondence pincode.")
                return false
            }
            
            if !isCorrespondencetSelfOwnedBtnEnabled && !isCorrespondenceRentedBtnEnabled {
                showAlert(with: "Validation Error", message: "Please select correspondence address type.")
                return false
            }
            
        } else {
            
            // MARK: Registered Address Validation
            
            if (registerAddresstxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please enter registered address.")
                return false
            }
            
            if (registerCountrytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select registered country.")
                return false
            }
            
            if (registerStatetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select registered state.")
                return false
            }
            
            if (registerCitytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select registered city.")
                return false
            }
            
            let registeredPincode = registerPincodetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if registeredPincode.isEmpty {
                showAlert(with: "Validation Error", message: "Please enter registered pincode.")
                return false
            }
            
            if registeredPincode.count != 6 {
                showAlert(with: "Validation Error", message: "Please enter valid registered pincode.")
                return false
            }
            
            if !isRegisteredSelfOwnedBtnEnabled && !isRegisteredRentedBtnEnabled {
                showAlert(with: "Validation Error", message: "Please select registered address type.")
                return false
            }
            
            // MARK: Correspondence Address Validation
            
            if (correspondenceAddresstxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please enter correspondence address.")
                return false
            }
            
            if (correspondenceCountrytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select correspondence country.")
                return false
            }
            
            if (correspondenceStatetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select correspondence state.")
                return false
            }
            
            if (correspondenceCitytxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                showAlert(with: "Validation Error", message: "Please select correspondence city.")
                return false
            }
            
            let correspondencePincode = correspondencePincodetxtFld?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if correspondencePincode.isEmpty {
                showAlert(with: "Validation Error", message: "Please enter correspondence pincode.")
                return false
            }
            
            if correspondencePincode.count != 6 {
                showAlert(with: "Validation Error", message: "Please enter valid correspondence pincode.")
                return false
            }
            
            if !isCorrespondencetSelfOwnedBtnEnabled && !isCorrespondenceRentedBtnEnabled {
                showAlert(with: "Validation Error", message: "Please select correspondence address type.")
                return false
            }
        }
        
        return true
    }
    
    @IBAction func resetAction() {
        clearAllFields()
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func permanentAction(_ sender: UIButton?) {
        isPermanentSelfOwnedBtnEnabled = false
        isPermanentRentedBtnEnabled = false
        if sender?.tag == 11 {
            isPermanentSelfOwnedBtnEnabled = true
            permanentSelfOwnedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
            permanentRentedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
        } else if sender?.tag == 12 {
            isPermanentRentedBtnEnabled = true
            permanentSelfOwnedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
            permanentRentedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
        }
    }
    
    @IBAction func correspondenceAction(_ sender: UIButton?) {
        isCorrespondencetSelfOwnedBtnEnabled = false
        isCorrespondenceRentedBtnEnabled = false
        if sender?.tag == 21 {
            isCorrespondencetSelfOwnedBtnEnabled = true
            correspondenceSelfOwnedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
            correspondenceRentedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
        } else if sender?.tag == 22 {
            isCorrespondenceRentedBtnEnabled = true
            correspondenceSelfOwnedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
            correspondenceRentedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
        }
    }
    
    @IBAction func registeredAction(_ sender: UIButton?) {
        isRegisteredSelfOwnedBtnEnabled = false
        isRegisteredRentedBtnEnabled = false
        if sender?.tag == 31 {
            isRegisteredSelfOwnedBtnEnabled = true
            registeredSelfOwnedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
            registeredRentedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
        } else if sender?.tag == 32 {
            isRegisteredRentedBtnEnabled = true
            registeredSelfOwnedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
            registeredRentedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
        }
    }
    
//    @IBAction func samepermanentAddressAction(_ sender: UIButton?) {
//        isYesSamePermamnet = false
//        if sender?.tag == 31 {
//            isYesSamePermamnet = true
//            isCorrespondenceYES?.backgroundColor = UIColor(hex: "223B30")
//            isCorrespondenceYES?.setTitleColor(.white, for: .normal)
//            isCorrespondenceNO?.backgroundColor = UIColor(hex: "DFE1E0")
//            isCorrespondenceNO?.setTitleColor(.black, for: .normal)
//            correspondenceAddresstxtFld?.text = permanentAddresstxtFld?.text
//            correspondenceCountrytxtFld?.text = permanentCountrytxtFld?.text
//            correspondenceStatetxtFld?.text = permanentStatetxtFld?.text
//            correspondenceCitytxtFld?.text = permanentCitytxtFld?.text
//            correspondencePincodetxtFld?.text = permanentPincodetxtFld?.text
//            if isPermanentSelfOwnedBtnEnabled {
//                isCorrespondencetSelfOwnedBtnEnabled = true
//                correspondenceSelfOwnedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
//            } else if isPermanentRentedBtnEnabled {
//                isCorrespondenceRentedBtnEnabled = true
//                correspondenceRentedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
//            }
//        } else if sender?.tag == 32 {
//            isYesSamePermamnet = false
//            isCorrespondenceYES?.backgroundColor = UIColor(hex: "DFE1E0")
//            isCorrespondenceYES?.setTitleColor(.black, for: .normal)
//            isCorrespondenceNO?.backgroundColor = UIColor(hex: "223B30")
//            isCorrespondenceNO?.setTitleColor(.white, for: .normal)
//            correspondenceAddresstxtFld?.text = ""
//            correspondenceCountrytxtFld?.text = ""
//            correspondenceStatetxtFld?.text = ""
//            correspondenceCitytxtFld?.text = ""
//            correspondencePincodetxtFld?.text = ""
//            isCorrespondencetSelfOwnedBtnEnabled = false
//            isCorrespondenceRentedBtnEnabled = false
//            correspondenceRentedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
//            correspondenceSelfOwnedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
//        }
//        else if sender?.tag == 33 {
//            isYesSamePermamnet = false
//            isRegisterYES?.backgroundColor = UIColor(hex: "DFE1E0")
//            isRegisterYES?.setTitleColor(.black, for: .normal)
//            isRegisterNO?.backgroundColor = UIColor(hex: "223B30")
//            isRegisterNO?.setTitleColor(.white, for: .normal)
//            registerAddresstxtFld?.text = ""
//            registerCountrytxtFld?.text = ""
//            registerStatetxtFld?.text = ""
//            registerCitytxtFld?.text = ""
//            registerPincodetxtFld?.text = ""
//            isRegisteredSelfOwnedBtnEnabled = false
//            isRegisteredRentedBtnEnabled = false
//            registeredRentedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
//            registeredSelfOwnedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
//        }
//    }
    
    @IBAction func samepermanentAddressAction(_ sender: UIButton?) {
        guard let tag = sender?.tag else { return }

        if tag == 31 { // YES: Correspondence = Permanent

            isYesSamePermamnet = true

            isCorrespondenceYES?.backgroundColor = UIColor(hex: "223B30")
            isCorrespondenceYES?.setTitleColor(.white, for: .normal)
            isCorrespondenceNO?.backgroundColor = UIColor(hex: "DFE1E0")
            isCorrespondenceNO?.setTitleColor(.black, for: .normal)

            // Copy permanent address into correspondence fields
            correspondenceAddresstxtFld?.text = permanentAddresstxtFld?.text
            correspondenceCountrytxtFld?.text = permanentCountrytxtFld?.text
            correspondenceStatetxtFld?.text = permanentStatetxtFld?.text
            correspondenceCitytxtFld?.text = permanentCitytxtFld?.text
            correspondencePincodetxtFld?.text = permanentPincodetxtFld?.text

            // Disable correspondence fields
            correspondenceAddresstxtFld?.isEnabled = false
            correspondenceCountrytxtFld?.isEnabled = false
            correspondenceStatetxtFld?.isEnabled = false
            correspondenceCitytxtFld?.isEnabled = false
            correspondencePincodetxtFld?.isEnabled = false

            // Copy ownership selection
            isCorrespondencetSelfOwnedBtnEnabled = isPermanentSelfOwnedBtnEnabled
            isCorrespondenceRentedBtnEnabled = isPermanentRentedBtnEnabled

            correspondenceSelfOwnedBtn?.setImage(
                UIImage(named: isCorrespondencetSelfOwnedBtnEnabled ? "RodioSelected" : "RodioUnselected"),
                for: .normal
            )

            correspondenceRentedBtn?.setImage(
                UIImage(named: isCorrespondenceRentedBtnEnabled ? "RodioSelected" : "RodioUnselected"),
                for: .normal
            )

        } else if tag == 32 { // NO: Correspondence address is different

            isYesSamePermamnet = false

            isCorrespondenceYES?.backgroundColor = UIColor(hex: "DFE1E0")
            isCorrespondenceYES?.setTitleColor(.black, for: .normal)
            isCorrespondenceNO?.backgroundColor = UIColor(hex: "223B30")
            isCorrespondenceNO?.setTitleColor(.white, for: .normal)

            // Clear correspondence fields
            correspondenceAddresstxtFld?.text = ""
            correspondenceCountrytxtFld?.text = ""
            correspondenceStatetxtFld?.text = ""
            correspondenceCitytxtFld?.text = ""
            correspondencePincodetxtFld?.text = ""

            // Enable correspondence fields
            correspondenceAddresstxtFld?.isEnabled = true
            correspondenceCountrytxtFld?.isEnabled = true
            correspondenceStatetxtFld?.isEnabled = true
            correspondenceCitytxtFld?.isEnabled = true
            correspondencePincodetxtFld?.isEnabled = true

            // Reset ownership selection
            isCorrespondencetSelfOwnedBtnEnabled = false
            isCorrespondenceRentedBtnEnabled = false

            correspondenceSelfOwnedBtn?.setImage(
                UIImage(named: "RodioUnselected"),
                for: .normal
            )

            correspondenceRentedBtn?.setImage(
                UIImage(named: "RodioUnselected"),
                for: .normal
            )
        }
    }
    
//    @IBAction func sameCorrepondenceAddressAction(_ sender: UIButton?) {
//        isYesSameCorrespondence = false
//        if sender?.tag == 33 {
//            isRegisterYES?.backgroundColor = UIColor(hex: "223B30")
//            isRegisterYES?.setTitleColor(.white, for: .normal)
//            isRegisterNO?.backgroundColor = UIColor(hex: "DFE1E0")
//            isRegisterNO?.setTitleColor(.black, for: .normal)
//            registerAddresstxtFld?.text = correspondenceAddresstxtFld?.text
//            registerCountrytxtFld?.text = correspondenceCountrytxtFld?.text
//            registerStatetxtFld?.text = correspondenceStatetxtFld?.text
//            registerCitytxtFld?.text = correspondenceCitytxtFld?.text
//            registerPincodetxtFld?.text = correspondencePincodetxtFld?.text
//            if isCorrespondencetSelfOwnedBtnEnabled {
//                isRegisteredSelfOwnedBtnEnabled = true
//                registeredSelfOwnedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
//            } else if isCorrespondenceRentedBtnEnabled {
//                isRegisteredRentedBtnEnabled = true
//                registeredRentedBtn?.setImage(UIImage(named: "RodioSelected"), for: .normal)
//            }
//        } else if sender?.tag == 34 {
//            isYesSameCorrespondence = false
//            isRegisterYES?.backgroundColor = UIColor(hex: "DFE1E0")
//            isRegisterYES?.setTitleColor(.black, for: .normal)
//            isRegisterNO?.backgroundColor = UIColor(hex: "223B30")
//            isRegisterNO?.setTitleColor(.white, for: .normal)
//            registerAddresstxtFld?.text = ""
//            registerCountrytxtFld?.text = ""
//            registerStatetxtFld?.text = ""
//            registerCitytxtFld?.text = ""
//            registerPincodetxtFld?.text = ""
//            isRegisteredSelfOwnedBtnEnabled = false
//            isRegisteredRentedBtnEnabled = false
//            registeredRentedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
//            registeredSelfOwnedBtn?.setImage(UIImage(named: "RodioUnselected"), for: .normal)
//        }
//    }
    
    @IBAction func sameCorrepondenceAddressAction(_ sender: UIButton?) {
        guard let tag = sender?.tag else { return }

        if tag == 33 { // YES: Registered = Correspondence

            isYesSameCorrespondence = true

            isRegisterYES?.backgroundColor = UIColor(hex: "223B30")
            isRegisterYES?.setTitleColor(.white, for: .normal)
            isRegisterNO?.backgroundColor = UIColor(hex: "DFE1E0")
            isRegisterNO?.setTitleColor(.black, for: .normal)

            // Copy correspondence address into registered fields
            registerAddresstxtFld?.text = correspondenceAddresstxtFld?.text
            registerCountrytxtFld?.text = correspondenceCountrytxtFld?.text
            registerStatetxtFld?.text = correspondenceStatetxtFld?.text
            registerCitytxtFld?.text = correspondenceCitytxtFld?.text
            registerPincodetxtFld?.text = correspondencePincodetxtFld?.text

            // Disable registered fields
            registerAddresstxtFld?.isEnabled = false
            registerCountrytxtFld?.isEnabled = false
            registerStatetxtFld?.isEnabled = false
            registerCitytxtFld?.isEnabled = false
            registerPincodetxtFld?.isEnabled = false

            // Copy ownership selection
            isRegisteredSelfOwnedBtnEnabled = isCorrespondencetSelfOwnedBtnEnabled
            isRegisteredRentedBtnEnabled = isCorrespondenceRentedBtnEnabled

            registeredSelfOwnedBtn?.setImage(
                UIImage(named: isRegisteredSelfOwnedBtnEnabled ? "RodioSelected" : "RodioUnselected"),
                for: .normal
            )

            registeredRentedBtn?.setImage(
                UIImage(named: isRegisteredRentedBtnEnabled ? "RodioSelected" : "RodioUnselected"),
                for: .normal
            )

        } else if tag == 34 { // NO: Registered address is different

            isYesSameCorrespondence = false

            isRegisterYES?.backgroundColor = UIColor(hex: "DFE1E0")
            isRegisterYES?.setTitleColor(.black, for: .normal)
            isRegisterNO?.backgroundColor = UIColor(hex: "223B30")
            isRegisterNO?.setTitleColor(.white, for: .normal)

            // Clear registered fields
            registerAddresstxtFld?.text = ""
            registerCountrytxtFld?.text = ""
            registerStatetxtFld?.text = ""
            registerCitytxtFld?.text = ""
            registerPincodetxtFld?.text = ""

            // Enable registered fields
            registerAddresstxtFld?.isEnabled = true
            registerCountrytxtFld?.isEnabled = true
            registerStatetxtFld?.isEnabled = true
            registerCitytxtFld?.isEnabled = true
            registerPincodetxtFld?.isEnabled = true

            // Reset ownership selection
            isRegisteredSelfOwnedBtnEnabled = false
            isRegisteredRentedBtnEnabled = false

            registeredSelfOwnedBtn?.setImage(
                UIImage(named: "RodioUnselected"),
                for: .normal
            )

            registeredRentedBtn?.setImage(
                UIImage(named: "RodioUnselected"),
                for: .normal
            )
        }
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

        if isIndividualApplicantFlow {
            applicant.permanentAddress = permanentAddresstxtFld?.text
            applicant.permanentCountry = permanentCountrytxtFld?.text
            applicant.permanentState = permanentStatetxtFld?.text
            applicant.permanentCity = permanentCitytxtFld?.text
            applicant.permanentPincode = permanentPincodetxtFld?.text
            applicant.permanentSelfOwned = isPermanentSelfOwnedBtnEnabled
            applicant.permanentRented = isPermanentRentedBtnEnabled
            applicant.correspondenceAddress = correspondenceAddresstxtFld?.text
            applicant.correspondenceCountry = correspondenceCountrytxtFld?.text
            applicant.correspondenceState = correspondenceStatetxtFld?.text
            applicant.correspondenceCity = correspondenceCitytxtFld?.text
            applicant.correspondencePincode = correspondencePincodetxtFld?.text
            applicant.selfOwned = isCorrespondencetSelfOwnedBtnEnabled
            applicant.rented = isCorrespondenceRentedBtnEnabled
        } else {
            applicant.registeredAddress = registerAddresstxtFld?.text
            applicant.registeredCountry = registerCountrytxtFld?.text
            applicant.registeredStates = registerStatetxtFld?.text
            applicant.registeredCity = registerCitytxtFld?.text
            applicant.registeredPincode = registerPincodetxtFld?.text
            applicant.registeredSelfOwned = isRegisteredSelfOwnedBtnEnabled
            applicant.registeredRented = isRegisteredRentedBtnEnabled
            applicant.correspondenceAddress = correspondenceAddresstxtFld?.text
            applicant.correspondenceCountry = correspondenceCountrytxtFld?.text
            applicant.correspondenceState = correspondenceStatetxtFld?.text
            applicant.correspondenceCity = correspondenceCitytxtFld?.text
            applicant.correspondencePincode = correspondencePincodetxtFld?.text
            applicant.selfOwned = isCorrespondencetSelfOwnedBtnEnabled
            applicant.rented = isCorrespondenceRentedBtnEnabled
        }
        if let index = applicantIndex {
            OpportunityManager.shared.updateApplicant(at: index, with: applicant)
        }
        

        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let employmentVC = storyboard.instantiateViewController(withIdentifier: "EmploymentEOIScreenVC") as! EmploymentEOIScreenVC
        employmentVC.applicantIndex = applicantIndex
        employmentVC.isFromCustomers = isFromCustomers
        employmentVC.cuatomerDetailsDict = cuatomerDetailsDict
        employmentVC.isForEditing = isForEditing
        employmentVC.isLocalEdit = isLocalEdit
        employmentVC.applicantDetailsModel = applicantDetailsModel
        self.navigationController?.pushViewController(employmentVC, animated: true)
    }
}

extension AddressEOIScreenVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case permanentCountrytxtFld:
            showPermanentCountryDropdown()
            return false
        case permanentStatetxtFld:
            showPermanentStateDropdown()
            return false
        case permanentCitytxtFld:
            showPermanentCityDropdown()
            return false
        case correspondenceCountrytxtFld:
            showCorrespondenceCountryDropdown()
            return false
        case correspondenceStatetxtFld:
            showCorrespondenceStateDropdown()
            return false
        case correspondenceCitytxtFld:
            showCorrespondenceCityDropdown()
            return false
        case registerCountrytxtFld:
            showregisteredCountryDropdown()
            return false
        case registerStatetxtFld:
            showRegisterStateDropdown()
            return false
        case registerCitytxtFld:
            showregisterCityDropdown()
            return false
        default:
            return true
        }
    }
    
    // MARK: - Permanent Address Dropdowns

    func showPermanentCountryDropdown() {

        permanentCountryDropdown.anchorView = permanentCountrytxtFld
        permanentCountryDropdown.dataSource = countriesList

        permanentCountryDropdown.selectionAction = { [weak self] index, item in

            guard let self = self else { return }

            self.permanentCountrytxtFld?.text = item
            self.permanentStatetxtFld?.text = ""
            self.permanentCitytxtFld?.text = ""

            self.fetchStates(country: item)
        }

        permanentCountryDropdown.show()
    }

    func showPermanentStateDropdown() {

        guard let country = permanentCountrytxtFld?.text,
              !country.isEmpty else {

            Utility.showAlert(message: "Please select country first.")
            return
        }

        if let states = statesList[country] {

            permanentStateDropdown.anchorView = permanentStatetxtFld
            permanentStateDropdown.dataSource = states

            permanentStateDropdown.selectionAction = { [weak self] index, item in

                guard let self = self else { return }

                self.permanentStatetxtFld?.text = item
                self.permanentCitytxtFld?.text = ""

                self.fetchCities(state: item)
            }

            permanentStateDropdown.show()

        } else {

            fetchStates(country: country)

            Utility.showAlert(message: "Please wait loading states...")
        }
    }

    func showPermanentCityDropdown() {

        guard let state = permanentStatetxtFld?.text,
              !state.isEmpty else {

            Utility.showAlert(message: "Please select state first.")
            return
        }

        if let cities = citiesList[state] {

            permanentCityDropdown.anchorView = permanentCitytxtFld
            permanentCityDropdown.dataSource = cities

            permanentCityDropdown.selectionAction = { [weak self] index, item in

                self?.permanentCitytxtFld?.text = item
            }

            permanentCityDropdown.show()

        } else {

            fetchCities(state: state)

            Utility.showAlert(message: "Please wait loading cities...")
        }
    }

    // MARK: - Correspondence Address Dropdowns

//    func showCorrespondenceCountryDropdown() {
//
//        Task {
//
//            let countries = await FetchPicklistValue.shared.fetchCountries()
//
//            DispatchQueue.main.async {
//
//                self.correspondenceCountryDropdown.anchorView = self.correspondenceCountrytxtFld
//                self.correspondenceCountryDropdown.dataSource = Array(Set(countries.map { $0.value })).sorted()
//
//                self.correspondenceCountryDropdown.selectionAction = { [weak self] index, item in
//
//                    guard let self = self else { return }
//
//                    self.correspondenceCountrytxtFld?.text = item
//                    self.correspondenceStatetxtFld?.text = ""
//                    self.correspondenceCitytxtFld?.text = ""
//                }
//
//                self.correspondenceCountryDropdown.show()
//            }
//        }
//    }
    
    func showCorrespondenceCountryDropdown() {
        
        Helper.showLoadingDropdown(

            correspondenceCountryDropdown,

            anchorView: correspondenceCountrytxtFld,

            message: "Loading countries, please wait..."

        )
        
        Task {
            
            let countries = await FetchPicklistValue.shared.fetchCountries()
            
            let countryList = Array(
                Set(countries.map { $0.value })
            ).sorted()
            
            await MainActor.run {
                
                self.correspondenceCountryDropdown.dataSource = countryList
                
                self.correspondenceCountryDropdown.selectionAction = { [weak self] index, item in
                    
                    guard let self = self else { return }
                    
                    self.correspondenceCountrytxtFld?.text = item
                    self.correspondenceStatetxtFld?.text = ""
                    self.correspondenceCitytxtFld?.text = ""
                }
                
                self.correspondenceCountryDropdown.reloadAllComponents()
            }
        }
    }

    func showCorrespondenceStateDropdown() {

        guard let country = correspondenceCountrytxtFld?.text,
              !country.isEmpty else { return }

        Task {

            let states = await FetchPicklistValue.shared.fetchStates(country: country)

            DispatchQueue.main.async {

                self.correspondenceStateDropdown.anchorView = self.correspondenceStatetxtFld
                self.correspondenceStateDropdown.dataSource = states.map { $0.value }

                self.correspondenceStateDropdown.selectionAction = { [weak self] index, item in

                    guard let self = self else { return }

                    self.correspondenceStatetxtFld?.text = item
                    self.correspondenceCitytxtFld?.text = ""
                }

                self.correspondenceStateDropdown.show()
            }
        }
    }

    func showCorrespondenceCityDropdown() {

        guard let state = correspondenceStatetxtFld?.text,
              !state.isEmpty else { return }

        Task {

            let cities = await FetchPicklistValue.shared.fetchCities(state: state)

            DispatchQueue.main.async {

                self.correspondenceCityDropdown.anchorView = self.correspondenceCitytxtFld
                self.correspondenceCityDropdown.dataSource = cities.map { $0.value }

                self.correspondenceCityDropdown.selectionAction = { [weak self] index, item in

                    self?.correspondenceCitytxtFld?.text = item
                }

                self.correspondenceCityDropdown.show()
            }
        }
    }

    // MARK: - Registered Address Dropdowns

    func showregisteredCountryDropdown() {

        Task {

            let countries = await FetchPicklistValue.shared.fetchCountries()

            DispatchQueue.main.async {

                self.registerCountryDropdown.anchorView = self.registerCountrytxtFld
                self.registerCountryDropdown.dataSource = Array(Set(countries.map { $0.value })).sorted()

                self.registerCountryDropdown.selectionAction = { [weak self] index, item in

                    guard let self = self else { return }

                    self.registerCountrytxtFld?.text = item
                    self.registerStatetxtFld?.text = ""
                    self.registerCitytxtFld?.text = ""
                }

                self.registerCountryDropdown.show()
            }
        }
    }

    func showRegisterStateDropdown() {

        guard let country = registerCountrytxtFld?.text,
              !country.isEmpty else { return }

        Task {

            let states = await FetchPicklistValue.shared.fetchStates(country: country)

            DispatchQueue.main.async {

                self.registerStateDropdown.anchorView = self.registerStatetxtFld
                self.registerStateDropdown.dataSource = states.map { $0.value }

                self.registerStateDropdown.selectionAction = { [weak self] index, item in

                    guard let self = self else { return }

                    self.registerStatetxtFld?.text = item
                    self.registerCitytxtFld?.text = ""
                }

                self.registerStateDropdown.show()
            }
        }
    }

    func showregisterCityDropdown() {

        guard let state = registerStatetxtFld?.text,
              !state.isEmpty else { return }

        Task {

            let cities = await FetchPicklistValue.shared.fetchCities(state: state)

            DispatchQueue.main.async {

                self.registerCityDropdown.anchorView = self.registerCitytxtFld
                self.registerCityDropdown.dataSource = cities.map { $0.value }

                self.registerCityDropdown.selectionAction = { [weak self] index, item in

                    self?.registerCitytxtFld?.text = item
                }

                self.registerCityDropdown.show()
            }
        }
    }
}



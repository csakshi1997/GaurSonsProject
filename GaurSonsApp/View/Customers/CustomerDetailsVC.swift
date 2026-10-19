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

class CustomerDetailsVC: UIViewController, UITextViewDelegate {
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
        print(cuatomerDetailsDict)
        applicantTypeTxtFld?.label.text = "Select Type"
        applicantTypeTxtFld?.setOutlineColor(.darkGray, for: .normal)
        applicantTypeTxtFld?.setOutlineColor(
            UIColor(hex: "223B30") ?? UIColor(),
            for: .editing
        )
        applicantTypeTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        applicantTypeTxtFld?.delegate = self
        applicantTypeTxtFld?.inputView = UIView()

        detailsBtnLbl?.backgroundColor = ColorConstant.primary
        filesBtnLbl?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        convertToEOIBtn?.layer.cornerRadius = 8

        aadharView?.borderWidth = 1
        addressView?.borderWidth = 1
        completeAddressView?.borderWidth = 1
        declarationView?.borderWidth = 1

        detailsView?.layer.cornerRadius = 8
        aadharView?.layer.cornerRadius = 8
        addressView?.layer.cornerRadius = 8
        completeAddressView?.layer.cornerRadius = 8
        declarationView?.layer.cornerRadius = 8

        aadharView?.borderColor = ColorConstant.buttonBorderLightColor
        addressView?.borderColor = ColorConstant.buttonBorderLightColor
        completeAddressView?.borderColor = ColorConstant.buttonBorderLightColor
        declarationView?.borderColor = ColorConstant.buttonBorderLightColor

        tableViewsHeader?.isHidden = true
        noDataFoundVw?.isHidden = true
        fileTableView?.isHidden = true
        fileHeaderView?.isHidden = true

        // MARK: - Customer Details

        headerCustomerNameLbl?.text = Helper.displayValue(cuatomerDetailsDict?.name)
        customerNameLbl?.text = Helper.displayValue(cuatomerDetailsDict?.name)
        statusLbl?.text = Helper.displayValue(cuatomerDetailsDict?.status)
        mobileLbl?.text = Helper.displayValue(cuatomerDetailsDict?.mobile)
        emailLbl?.text = Helper.displayValue(cuatomerDetailsDict?.email)
        projectLbl?.text = Helper.displayValue(cuatomerDetailsDict?.project?.name)
        submissionTypeLbl?.text = Helper.displayValue(cuatomerDetailsDict?.brokerType)
        verificationTypeLbl?.text = Helper.displayValue(cuatomerDetailsDict?.verificationType)
        agentNameLbl?.text = Helper.displayValue(cuatomerDetailsDict?.createdBy?.name)

        // MARK: - Aadhaar Details

        aadhaarNameLbl?.text = Helper.displayValue(cuatomerDetailsDict?.aadhaarName)
        aadhaarEndingLbl?.text = Helper.displayValue(cuatomerDetailsDict?.aadhaarEnding)
        genderLbl?.text = Helper.displayValue(cuatomerDetailsDict?.gender)
        dOBLbl?.text = Helper.displayValue(cuatomerDetailsDict?.dateOfBirth)
        careOfLbl?.text = Helper.displayValue(cuatomerDetailsDict?.careOf)

        // MARK: - Address Details

        landmarkLbl?.text = Helper.displayValue(cuatomerDetailsDict?.landmark)
        let house = cuatomerDetailsDict?.house?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if let house = house,
           !house.isEmpty,
           house.caseInsensitiveCompare("<null>") != .orderedSame,
           house.caseInsensitiveCompare("null") != .orderedSame {

            houseLbl?.text = house
        } else {
            houseLbl?.text = "-"
        }
        streetLbl?.text = Helper.displayValue(cuatomerDetailsDict?.street)
        VTCLbl?.text = Helper.displayValue(cuatomerDetailsDict?.vtc)
        districtbl?.text = Helper.displayValue(cuatomerDetailsDict?.district)
        subDistrictLbl?.text = Helper.displayValue(cuatomerDetailsDict?.subdist)
        postalCodeLbl?.text = Helper.displayValue(cuatomerDetailsDict?.pincode)
        postOfficeLbl?.text = Helper.displayValue(cuatomerDetailsDict?.postOffice)
        stateLbl?.text = Helper.displayValue(cuatomerDetailsDict?.state)
        countryLbl?.text = Helper.displayValue(cuatomerDetailsDict?.country)

        addressLbl?.text = """
        Complete Address

        \(Helper.displayValue(cuatomerDetailsDict?.completeAddress))
        """

        // MARK: - Convert to EOI / Booking Form Button

        if cuatomerDetailsDict?.convertedToEOI ?? false {
            convertToEOIBtn?.setTitle("Converted", for: .normal)
            convertToEOIBtn?.backgroundColor = .gray
            convertToEOIBtn?.isEnabled = false
        } else {
            if cuatomerDetailsDict?.project?.channelPartnerVisible ?? false {
                Defaults.isFromEOI = false
                convertToEOIBtn?.setTitle("Booking Form", for: .normal)
            } else {
                Defaults.isFromEOI = true
                convertToEOIBtn?.setTitle("EOI Form", for: .normal)
            }

            convertToEOIBtn?.backgroundColor = UIColor(hex: "98C355")
            convertToEOIBtn?.isEnabled = true
        }

        let declaration = cuatomerDetailsDict?.declaration?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if let declaration = declaration,
           !declaration.isEmpty,
           declaration.caseInsensitiveCompare("<null>") != .orderedSame {

            declarationView?.isHidden = false
            declarationHeadingLbl?.isHidden = false
            declarationTextLbl?.isHidden = false

            let plainText = declaration.htmlToPlainText

            // Find email addresses in the declaration.
            let emailPattern = #"[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}"#

            let attributedString = NSMutableAttributedString(
                string: plainText,
                attributes: [
                    .font: declarationTextLbl?.font ?? UIFont.systemFont(ofSize: 14),
                    .foregroundColor: declarationTextLbl?.textColor ?? UIColor.label
                ]
            )

            if let regex = try? NSRegularExpression(
                pattern: emailPattern,
                options: [.caseInsensitive]
            ) {
                let range = NSRange(
                    plainText.startIndex..<plainText.endIndex,
                    in: plainText
                )

                let matches = regex.matches(
                    in: plainText,
                    range: range
                )

                for match in matches {
                    guard let emailRange = Range(match.range, in: plainText) else {
                        continue
                    }

                    let email = String(plainText[emailRange])

                    attributedString.addAttributes(
                        [
                            .foregroundColor: UIColor.systemBlue,
                            .underlineStyle: NSUnderlineStyle.single.rawValue
                        ],
                        range: match.range
                    )

                    print("Declaration email found: \(email)")
                }
            }

            declarationTextLbl?.attributedText = attributedString
            declarationTextLbl?.numberOfLines = 0
            declarationTextLbl?.lineBreakMode = .byWordWrapping
            declarationTextLbl?.isUserInteractionEnabled = true

            // Add the tap gesture only once.
            let hasTapGesture = declarationTextLbl?.gestureRecognizers?.contains {
                $0.name == "DeclarationEmailTap"
            } ?? false

            if !hasTapGesture {
                let tapGesture = UITapGestureRecognizer(
                    target: self,
                    action: #selector(handleDeclarationTap(_:))
                )

                tapGesture.name = "DeclarationEmailTap"
                declarationTextLbl?.addGestureRecognizer(tapGesture)
            }

        } else {
            declarationTextLbl?.text = "-"
            declarationTextLbl?.isHidden = true
            declarationView?.isHidden = true
            declarationHeadingLbl?.isHidden = true
        }
        let decryptedMobile = DecryptDataFile.decryptValue(
            cuatomerDetailsDict?.maskedData?.mobile?.defaultValue
        )

        maskedMobileLbl?.text = Helper.displayValue(decryptedMobile)

        let decryptedEmail = DecryptDataFile.decryptValue(
            cuatomerDetailsDict?.maskedData?.email?.defaultValue
        )

        maskedEmailLbl?.text = Helper.displayValue(decryptedEmail)
    }
    
    @objc private func handleDeclarationTap(_ gesture: UITapGestureRecognizer) {
        guard let label = declarationTextLbl,
              let attributedText = label.attributedText else {
            return
        }

        let text = attributedText.string
        let location = gesture.location(in: label)

        // Configure TextKit to identify the tapped character.
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let textBounds = layoutManager.usedRect(for: textContainer)

        let verticalOffset: CGFloat
        switch label.textAlignment {
        case .center:
            verticalOffset = max(0, (label.bounds.height - textBounds.height) / 2)
        default:
            verticalOffset = 0
        }

        let horizontalOffset: CGFloat
        switch label.textAlignment {
        case .center:
            horizontalOffset = max(0, (label.bounds.width - textBounds.width) / 2)
        case .right:
            horizontalOffset = max(0, label.bounds.width - textBounds.width)
        default:
            horizontalOffset = 0
        }

        let adjustedLocation = CGPoint(
            x: location.x - horizontalOffset,
            y: location.y - verticalOffset
        )

        // Ignore taps outside the displayed text.
        guard adjustedLocation.x >= 0,
              adjustedLocation.y >= 0,
              adjustedLocation.x <= label.bounds.width,
              adjustedLocation.y <= label.bounds.height else {
            return
        }

        let characterIndex = layoutManager.characterIndex(
            for: adjustedLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        guard characterIndex < textStorage.length else {
            return
        }

        // First, check whether the tapped character has a mailto link.
        if let link = attributedText.attribute(
            .link,
            at: characterIndex,
            effectiveRange: nil
        ) as? String,
           let url = URL(string: link),
           url.scheme?.lowercased() == "mailto" {

            openEmailLink(url)
            return
        }

        // Fallback: find an email address at the tapped character.
        let emailPattern = #"[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}"#

        guard let regex = try? NSRegularExpression(
            pattern: emailPattern,
            options: [.caseInsensitive]
        ) else {
            return
        }

        let fullRange = NSRange(
            location: 0,
            length: (text as NSString).length
        )

        for match in regex.matches(in: text, range: fullRange) {
            guard NSLocationInRange(characterIndex, match.range) else {
                continue
            }

            let email = (text as NSString).substring(with: match.range)

            guard let encodedEmail = email.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) else {
                return
            }

            guard let mailURL = URL(string: "mailto:\(encodedEmail)") else {
                return
            }

            openEmailLink(mailURL)
            return
        }
    }

    private func openEmailLink(_ mailURL: URL) {
        guard let email = URLComponents(url: mailURL, resolvingAgainstBaseURL: false)?
            .path else {
            UIApplication.shared.open(mailURL)
            return
        }

        let encodedEmail = email.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? email

        // Prefer Gmail when installed.
        if let gmailURL = URL(
            string: "googlegmail://co?to=\(encodedEmail)"
        ), UIApplication.shared.canOpenURL(gmailURL) {

            UIApplication.shared.open(gmailURL) { success in
                print("Gmail opened successfully: \(success)")
            }

        } else {
            // Fallback to the default email app.
            UIApplication.shared.open(mailURL) { success in
                print("Default email app opened successfully: \(success)")
            }
        }
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
            self.noDataFoundVw?.isHidden = true
        }

        Utility.getAllContentDoc(oppId: cuatomerDetailsDict?.id ?? EMPTY) { success in

            guard success else {
                DispatchQueue.main.async {
                    self.loaderView?.stopAnimating()
                    self.noDataFoundVw?.isHidden = false
                    self.fileTableView?.isHidden = true
                }
                return
            }

            let contentDocs = GlobalData.allContentDocModel

            guard !contentDocs.isEmpty else {
                DispatchQueue.main.async {
                    self.loaderView?.stopAnimating()
                    self.noDataFoundVw?.isHidden = false
                    self.fileTableView?.isHidden = true
                }
                return
            }

            let dispatchGroup = DispatchGroup()
            let resultQueue = DispatchQueue(label: "com.gaursons.attachments")
            var tempFileArray: [(index: Int, file: FileModel)] = []

            for (index, content) in contentDocs.enumerated() {
                dispatchGroup.enter()

                Utility.getVersionData(
                    contentDocId: content.contentDocumentId ?? EMPTY
                ) { versionSuccess in

                    guard versionSuccess,
                          let versionId = GlobalData.allVersionDataModel.Id else {
                        dispatchGroup.leave()
                        return
                    }

                    Utility.getFileData(contentVersionId: versionId) { fileData in

                        if let data = fileData {
                            // Keep the real filename for previewing.
                            // Keep the file extension for QuickLook preview.
                            let actualFileName = "\(versionId).pdf"

                            let fileModel = FileModel(
                                fileName: actualFileName,
                                fileData: data
                            )
                            resultQueue.sync {
                                tempFileArray.append((index: index, file: fileModel))
                            }
                        }

                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.loaderView?.stopAnimating()

                // Preserve the original attachment order.
                self.fileArray = tempFileArray
                    .sorted { $0.index < $1.index }
                    .map { $0.file }

                guard self.isFilesEnable else { return }

                self.fileHeaderView?.isHidden = false

                let hasFiles = !self.fileArray.isEmpty
                self.noDataFoundVw?.isHidden = hasFiles
                self.fileTableView?.isHidden = !hasFiles
                self.tableViewsHeader?.isHidden = !hasFiles

                self.fileTableView?.reloadData()
                self.view.layoutIfNeeded()
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
        
    @IBAction func uiBtnsAction(_ sender: UIButton) {
        let isDetailsSelected = sender.tag == 11

        // Update selected tab state
        isDetailsEnable = isDetailsSelected
        isFilesEnable = !isDetailsSelected

        // Details tab
        detailsBtnLbl?.backgroundColor = isDetailsSelected
            ? ColorConstant.primary
            : ColorConstant.buttonBackgroundWhiteColor

        // Files tab
        filesBtnLbl?.backgroundColor = isDetailsSelected
            ? ColorConstant.buttonBackgroundWhiteColor
            : ColorConstant.primary

        // Show only the selected tab's content
        detailsScrollView?.isHidden = !isDetailsSelected

        fileHeaderView?.isHidden = isDetailsSelected
        fileTableView?.isHidden = isDetailsSelected
        tableViewsHeader?.isHidden = isDetailsSelected
        noDataFoundVw?.isHidden = true

        if isDetailsSelected {
            // Show Details only
            detailsScrollView?.isHidden = false
        } else {
            // Show Files only
            fileHeaderView?.isHidden = false
            fetchAllFiles()
        }

        view.layoutIfNeeded()
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
//            cell.fileNameLbl?.text = fileDict.fileName
            cell.fileNameLbl?.text = "Attachment \(indexPath.row + 1)"
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
//        let contentVersionBody: [String: Any] = [
//            "Title": attachment.fileName,
//            "PathOnClient": attachment.fileName,
//            "NetworkId": Defaults.networkId ?? "",
//            "VersionData": base64Data
//        ]
        
        let fileNameWithoutExtension = (
            attachment.fileName as NSString
        ).deletingPathExtension

        let contentVersionBody: [String: Any] = [
            "Title": fileNameWithoutExtension,
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



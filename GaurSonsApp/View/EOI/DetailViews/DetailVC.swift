//
//  DetailVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 31/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import QuickLook
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class DetailVC: UIViewController {
    
    @IBOutlet var noDataFoundVw: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var topOppNameLbl: UILabel?
    @IBOutlet var topView: UIView?
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    //Timer
    @IBOutlet var timerView: UIView?
    @IBOutlet var timerBtn: UIButton?
    @IBOutlet var timerLeftImgBtn: UIButton?
    @IBOutlet var timer1Lbl: UILabel?
    @IBOutlet var timer2Lbl: UILabel?
    @IBOutlet var timerHeight: NSLayoutConstraint?
    var countdownTimer: Timer?
    var totalTimeInSeconds: Int = 0
    
    //Detail
    @IBOutlet var detailsView: UIView?
    @IBOutlet var detailsScrollView: UIScrollView?
    @IBOutlet var firstView: UIView?
    @IBOutlet var secondView: UIView?
    @IBOutlet var documenrNRICompanyStack: UIStackView?
    @IBOutlet var carpetEOITerraceStack: UIStackView?
    @IBOutlet var eventUrlStack: UIStackView?
    @IBOutlet var bookedOflinePaymentNotApprovedStack: UIStackView?
    @IBOutlet var documenrNRICompanyStackHeight: NSLayoutConstraint?
    @IBOutlet var carpetEOITerraceStackHeight: NSLayoutConstraint?
    @IBOutlet var eventUrlStackHeight: NSLayoutConstraint?
    @IBOutlet var bookedOflinePaymentNotApprovedStackHeight: NSLayoutConstraint?
    @IBOutlet var documenrNRICompanyStackTop: NSLayoutConstraint?
    @IBOutlet var carpetEOITerraceStackTop: NSLayoutConstraint?
    @IBOutlet var eventUrlStackTop: NSLayoutConstraint?
    @IBOutlet var bookedOflinePaymentNotApprovedStackTop: NSLayoutConstraint?
    @IBOutlet var thirdView: UIView?
    @IBOutlet var projectView: UIView?
    @IBOutlet var fourthView: UIView?
    @IBOutlet var opportunityNameLbl: UILabel?
    @IBOutlet var opportunityIDLbl: UILabel?
    @IBOutlet var projectLbl: UILabel?
    @IBOutlet var stageLbl: UILabel?
    @IBOutlet var channelPartnerLbl: UILabel?
    @IBOutlet var priorityNumberLbl: UILabel?
    @IBOutlet var emailLbl: UILabel?
    @IBOutlet var mobileLbl: UILabel?
    @IBOutlet var applicationNumberLbl: UILabel?
    @IBOutlet var carpetAreaLbl: UILabel?
    @IBOutlet var totalPaymentLbl: UILabel?
    @IBOutlet var paymentSubmissionLbl: UILabel?
    @IBOutlet var terraceAreaLbl: UILabel?
    @IBOutlet var totalPriceLbl: UILabel?
    @IBOutlet var totalPaymentDetailLbl: UILabel?
    @IBOutlet var bookedLbl: UILabel?
    @IBOutlet var offlineEOILbl: UILabel?
    @IBOutlet var projectNamebl: UILabel?
    @IBOutlet var EOITentativeLbl: UILabel?
    @IBOutlet var EOISaleableAreaLbl: UILabel?
    @IBOutlet var submittedByLbl: UILabel?
    @IBOutlet var RMNameLbl: UILabel?
    @IBOutlet var documentNumberLbl: UILabel?
    @IBOutlet var NRIStatusLbl: UILabel?
    @IBOutlet var companyLbl: UILabel?
    @IBOutlet var applicationDateLbl: UILabel?
    @IBOutlet var EOIPaymentSubmissionDateLbl: UILabel?
    @IBOutlet var eventURLLbl: UILabel?
    @IBOutlet var totalAmountINCLGSTLbl: UILabel?
    @IBOutlet var priceListDeviatedLbl: UILabel?
    @IBOutlet var paymentPlandeviatedLbl: UILabel?
    @IBOutlet var paymentNotApprovedLbl: UILabel?
    @IBOutlet var projectInformationView: UIView?
    @IBOutlet var projectInfoVerticalStack: UIStackView?
    @IBOutlet var projectInfoHoriStack: UIStackView?
    
    
    //Applicant
    @IBOutlet var applicantTableView: UITableView?
    @IBOutlet var tablesHeaderView: UIView?
    @IBOutlet var totalApplicantLbl: UILabel?
    @IBOutlet var addNewBtn: UIButton?
    var ApplicantArr = [ApplicantRecord]()
    var filteredApplicantRecord = [ApplicantRecord]()
    
    //Files
    @IBOutlet var fileHeaderView: UIView?
    @IBOutlet var totalFileLbl: UILabel?
    @IBOutlet var fileTableView: UITableView?
    @IBOutlet var tableViewsHeader: UIView?
    @IBOutlet var uploadFilesBtn: UIButton?
    
    //Payment
    @IBOutlet var paymentSearchVw: UISearchBar?
    @IBOutlet var paymentView: UIView?
    @IBOutlet var paymentHeaderView: UIView?
    @IBOutlet var totalPaymentRecordLbl: UILabel?
    @IBOutlet var paymentTableView: UITableView?
    @IBOutlet var addPaymentBtn: UIButton?
    var paymentArr = [PaymentModel]()
    var filteredPaymentRecord = [PaymentModel]()
    var contentDocArr = [ContentDocModel]()
    
    //Property Details
    @IBOutlet var propertySearchVw: UISearchBar?
    @IBOutlet var propertyView: UIView?
    @IBOutlet var totalPropertyLbl: UILabel?
    @IBOutlet var propertyHeaderView: UIView?
    @IBOutlet var propertyTableView: UITableView?
    @IBOutlet var addpropertyBtn: UIButton?
    var propertyArr = [PropertyModel]()
    var filteredPropertyRecord = [PropertyModel]()
    
    //Approval
    @IBOutlet var ApprovalSearchVw: UISearchBar?
    @IBOutlet var approvalView: UIView?
    @IBOutlet var approvalHeaderView: UIView?
    @IBOutlet var totalApprovalLbl: UILabel?
    @IBOutlet var approvalTableView: UITableView?
    @IBOutlet var addapprovalBtn: UIButton?
    var approvalArr = [ApprovalModel]()
    var filteredApprovalRecord = [ApprovalModel]()
    
    @IBOutlet var addChoosePaymentView: UIView?
    @IBOutlet var addChoosePaymentInternalView: UIView?
    @IBOutlet var paymnetTypeTxtFld: MDCOutlinedTextField?
    @IBOutlet var paymentHeightConstraint: NSLayoutConstraint?

    let choosePaymentTypeDropDown = DropDown()
    var summaryFilter: EOISummaryFilter = .total
    var selectedFilterType: FilterTypeForEOI = .none
    
    //Model
    var EOiModelDict = EOIModel(dict: [:])
    var previewItemURL: URL?
    var fileArray: [FileModel] = []
    var selectedAttachment: Attachment?
    var loaderView: UIActivityIndicatorView?
    var currentSearchText: String = ""
    var isApplicantEnable: Bool = false
    var isPaymentEnable: Bool = false
    var selectedIndex = 0
    var menuArr: [String] = []
    var isDataUpdated: Bool = false
    var EOIID: String = EMPTY
    var applicantDetailsModel = ApplicantDetailsModel(dict: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topOppNameLbl?.text = EOiModelDict.name
        fetchApplicantData()
        fetchPaymentData()
        fetchApprovalData()
        fetchPropertyData()
        setUpUI()
        fetchAllFiles()
        loaderView = UIActivityIndicatorView(style: .large)
        loaderView?.color = .gray
        loaderView?.center = view.center
        loaderView?.hidesWhenStopped = true
        if let loader = loaderView {
            view.addSubview(loader)
        }
        print(EOiModelDict)
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = .zero
        topCollectionView.collectionViewLayout = layout
        topCollectionView.showsHorizontalScrollIndicator = false
        startCountdown()
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
        resetPaymentPopupUI()
        print("EOIID EOIID EOIID:-\(self.EOIID)")
        if isDataUpdated {
//            isDataUpdated = false
            getEOI()
        }
    }
    
    func fetchPaymentData() {
        Utility.getAllPaymentRecord(oppId: EOiModelDict.id ?? EMPTY) { success in
            if success {
                DispatchQueue.main.async {
                    self.filteredPaymentRecord = GlobalData.allPaymentRecord
                    self.totalPaymentRecordLbl?.text = "Payment Records (\(self.filteredPaymentRecord.count))"
                    if self.filteredPaymentRecord.count > 0 {
                        self.paymentTableView?.reloadData()
                    }
                }
            }
        }
    }
    
    func getEOI() {

        Utility.getAllEOIRecordsForAll(outerClosure: { success in

            DispatchQueue.main.async {

                guard success else {
                    print("❌ Failed to get EOI records")
                    return
                }
                print("EOIID EOIID EOIID:-\(self.EOIID)")
                // Find EOI using EOIID
                guard let updatedEOI = GlobalData.allEOIModelForAll.first(where: {
                    $0.id == self.EOIID
                }) else {
                    print("❌ EOI not found for ID: \(self.EOIID)")
                    return
                }

                // Save matched EOI into detail model
                self.EOiModelDict = updatedEOI

                print("✅ EOI updated successfully")
                print("EOI ID: \(updatedEOI.id ?? "")")
                print("Minutes: \(updatedEOI.project?.minutesToReleaseUnits ?? 0)")

                // Now start countdown using updated model
                self.startCountdown()
            }
        })
    }
    

//    func fetchApprovalData() {
//        Utility.getAllApprovalRecords(oppId: EOiModelDict.id ?? EMPTY) { success in
//            if success {
//                DispatchQueue.main.async {
//                    self.filteredApprovalRecord = GlobalData.allApprovalModel
//                    self.approvalArr = GlobalData.allApprovalModel
//                    self.totalApprovalLbl?.text = "Approval History (\(self.approvalArr.count))"
//                    if self.filteredApprovalRecord.count > 0 {
//                        self.approvalTableView?.reloadData()
//                    }
//                }
//            }
//        }
//    }
    
    
    func fetchApprovalData() {
        Utility.getAllApprovalRecords(oppId: EOiModelDict.id ?? EMPTY) { success in
            if success {
                DispatchQueue.main.async {
                    self.filteredApprovalRecord = GlobalData.allApprovalModel
                    self.approvalArr = GlobalData.allApprovalModel

                    self.totalApprovalLbl?.text =
                        "Approval History (\(self.approvalArr.count))"

                    if self.selectedIndex < self.menuArr.count,
                       self.menuArr[self.selectedIndex] == "Approval History" {

                        self.manageScreen(index: self.selectedIndex)
                    }
                }
            }
        }
    }
    
    func fetchPropertyData() {
        Utility.getAllPropertyRecords(oppId: EOiModelDict.id ?? EMPTY) { success in
            if success {
                DispatchQueue.main.async {
                    self.filteredPropertyRecord = GlobalData.allPropertyModel
                    self.propertyArr = GlobalData.allPropertyModel
                    self.totalPropertyLbl?.text = "Unit (\(self.propertyArr.count))"
                    self.propertyTableView?.reloadData()
                }
            }
        }
    }
    
    func fetchApplicantData() {
        Utility.getAllApplicantRecords(oppId: EOiModelDict.id ?? EMPTY) { result in
            if result {
                DispatchQueue.main.async {
                    self.filteredApplicantRecord =  GlobalData.allApplicantRecord
                    self.ApplicantArr = GlobalData.allApplicantRecord
                    self.totalApplicantLbl?.text = "Applicant Details (\(self.filteredApplicantRecord.count))"
                    if self.ApplicantArr.count > 0 {
                        self.applicantTableView?.reloadData()
                    }
                }
            }
        }
    }
    
    func fetchAllFiles() {
        GlobalData.allContentDocModel.removeAll()
        DispatchQueue.main.async {
            self.loaderView?.startAnimating()
            self.fileTableView?.isHidden = true
            self.noDataFoundVw?.isHidden = true
        }
        
        Utility.getAllContentDoc(oppId: EOiModelDict.id ?? EMPTY) { success in
            if success {
                let contentDocs = GlobalData.allContentDocModel
                DispatchQueue.main.async {
                    self.totalFileLbl?.text = "Files (\(contentDocs.count))"
                }
                guard contentDocs.count > 0 else {
                    DispatchQueue.main.async {
                        self.loaderView?.stopAnimating()
//                        self.noDataFoundVw?.isHidden = false
                        self.fileTableView?.isHidden = true
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
                    self.totalFileLbl?.text = "Files (\(self.fileArray.count))"

                        if self.selectedIndex < self.menuArr.count,

                           self.menuArr[self.selectedIndex] == "Files" {

                            self.manageScreen(index: self.selectedIndex)

                        }
//                    self.fileHeaderView?.isHidden = false
//                    if self.fileArray.count > 0 {
//                        self.noDataFoundVw?.isHidden = true
//                        self.fileTableView?.isHidden = false
//                        self.tableViewsHeader?.isHidden = false
//                        self.fileTableView?.reloadData()
//                    } else {
//                        self.tableViewsHeader?.isHidden = true
//                        self.noDataFoundVw?.isHidden = false
//                        self.fileTableView?.isHidden = true
//                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loaderView?.stopAnimating()
//                    self.noDataFoundVw?.isHidden = false
//                    self.fileTableView?.isHidden = true
                }
            }
        }
    }
    
    func setUpUI() {
        initialUIForDetail()
        setupProjectInformationView()
        addNewBtn?.backgroundColor = ColorConstant.primaryRedishColor
        if EOiModelDict.recordTypeName == "Legacy" {
            Defaults.isFromEOI = false
            menuArr = [
                "Details",
                "Applicant",
                "Property Details",
                "Files",
            ]
            addPaymentBtn?.setTitle("Inventory Selection", for: .normal)
            documenrNRICompanyStack?.isHidden = true
            carpetEOITerraceStack?.isHidden = true
            eventUrlStack?.isHidden = true
            bookedOflinePaymentNotApprovedStack?.isHidden = true
            documenrNRICompanyStackHeight?.constant = 0
            carpetEOITerraceStackHeight?.constant = 0
            eventUrlStackHeight?.constant = 0
            bookedOflinePaymentNotApprovedStackHeight?.constant = 0
            documenrNRICompanyStackTop?.constant = 0
            carpetEOITerraceStackTop?.constant = 0
            eventUrlStackTop?.constant = 0
            bookedOflinePaymentNotApprovedStackTop?.constant = 00
        } else if EOiModelDict.recordTypeName == "EOI" {
            menuArr = [
                "Details",
                "Applicant",
                "Payment",
                "Files",
                "Approval History"
            ]
            addPaymentBtn?.setTitle("Add Payment", for: .normal)
            documenrNRICompanyStack?.isHidden = false
            carpetEOITerraceStack?.isHidden = false
            eventUrlStack?.isHidden = false
            bookedOflinePaymentNotApprovedStack?.isHidden = false
            documenrNRICompanyStackHeight?.constant = 60
            carpetEOITerraceStackHeight?.constant = 106.13
            eventUrlStackHeight?.constant = 13.33
            bookedOflinePaymentNotApprovedStackHeight?.constant = 60
        } else if EOiModelDict.recordTypeName == "Unsold" {
            Defaults.isFromEOI = false
            menuArr = [
                "Details",
                "Property Details",
                "Files",
            ]
//            addPaymentBtn?.setTitle("Inventory Selection", for: .normal)
            addPaymentBtn?.isHidden = true
            documenrNRICompanyStack?.isHidden = true
            carpetEOITerraceStack?.isHidden = true
            eventUrlStack?.isHidden = true
            bookedOflinePaymentNotApprovedStack?.isHidden = true
            documenrNRICompanyStackHeight?.constant = 0
            carpetEOITerraceStackHeight?.constant = 0
            eventUrlStackHeight?.constant = 0
            bookedOflinePaymentNotApprovedStackHeight?.constant = 0
            documenrNRICompanyStackTop?.constant = 0
            carpetEOITerraceStackTop?.constant = 0
            eventUrlStackTop?.constant = 0
            bookedOflinePaymentNotApprovedStackTop?.constant = 00
        } else {
            menuArr = [
                "Details",
                "Applicant",
                "Payment",
                "Files",
                "Approval History"
            ]
            addPaymentBtn?.setTitle("Add Payment", for: .normal)
            documenrNRICompanyStack?.isHidden = false
            carpetEOITerraceStack?.isHidden = false
            eventUrlStack?.isHidden = false
            bookedOflinePaymentNotApprovedStack?.isHidden = false
            documenrNRICompanyStackHeight?.constant = 60
            carpetEOITerraceStackHeight?.constant = 106.13
            eventUrlStackHeight?.constant = 13.33
            bookedOflinePaymentNotApprovedStackHeight?.constant = 60
        }
        view.layoutIfNeeded()
        topCollectionView?.reloadData()
        paymentSearchVw?.delegate = self
        fileTableView?.showsVerticalScrollIndicator = false
        fileTableView?.showsHorizontalScrollIndicator = false
        paymentTableView?.showsVerticalScrollIndicator = false
        paymentTableView?.showsHorizontalScrollIndicator = false
        approvalTableView?.showsVerticalScrollIndicator = false
        approvalTableView?.showsHorizontalScrollIndicator = false
        propertyTableView?.showsVerticalScrollIndicator = false
        propertyTableView?.showsHorizontalScrollIndicator = false
        applicantTableView?.showsVerticalScrollIndicator = false
        applicantTableView?.showsHorizontalScrollIndicator = false
        paymentHeaderView?.isHidden = true
        paymentView?.isHidden = true
        approvalView?.isHidden = true
        propertyView?.isHidden = true
        fileHeaderView?.isHidden = true
        fileTableView?.isHidden = true
        tableViewsHeader?.isHidden = true
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        applicantTableView?.isHidden = true
        tablesHeaderView?.isHidden = true
        uploadFilesBtn?.layer.cornerRadius = 8
        tableViewsHeader?.layer.cornerRadius = 8
        addNewBtn?.layer.cornerRadius = 8
        addPaymentBtn?.layer.cornerRadius = 8
        firstView?.borderWidth = 1
        secondView?.borderWidth = 1
        thirdView?.borderWidth = 1
        firstView?.layer.cornerRadius = 8
        secondView?.layer.cornerRadius = 8
        thirdView?.layer.cornerRadius = 8
        firstView?.borderColor = ColorConstant.buttonBorderLightColor
        secondView?.borderColor = ColorConstant.buttonBorderLightColor
        thirdView?.borderColor = ColorConstant.buttonBorderLightColor
        fourthView?.borderWidth = 1
        fourthView?.layer.cornerRadius = 8
        fourthView?.borderColor = ColorConstant.buttonBorderLightColor
        paymnetTypeTxtFld?.label.text = "Select Type"
        paymnetTypeTxtFld?.setOutlineColor(.darkGray, for: .normal)
        paymnetTypeTxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        paymnetTypeTxtFld?.translatesAutoresizingMaskIntoConstraints = false
        paymnetTypeTxtFld?.delegate = self
        paymnetTypeTxtFld?.inputView = UIView()
    }
    
    func initialUIForDetail() {
        func setValue(_ value: String?) -> String {
            guard let value = value?
                .trimmingCharacters(in: .whitespacesAndNewlines),
                  !value.isEmpty,
                  value.lowercased() != "null",
                  value.lowercased() != "<null>",
                  value.lowercased() != "nil"
            else {
                return "-"
            }
            return value
        }
        
        func setAmount(_ value: Double?) -> String {
            guard let amount = value else {
                return "-"
            }
            return String(format: "%.2f", amount)
        }
        
        print("####################\(EOiModelDict.applicantType ?? EMPTY)")
        
        opportunityNameLbl?.text = setValue(EOiModelDict.name)
        opportunityIDLbl?.text = setValue(EOiModelDict.opportunityId)
        projectLbl?.text = setValue(EOiModelDict.project?.name)
        stageLbl?.text = setValue(EOiModelDict.stage)
        channelPartnerLbl?.text = setValue(EOiModelDict.createdBy?.name)
        priorityNumberLbl?.text = setValue(EOiModelDict.priorityNumber)
        emailLbl?.text = setValue(EOiModelDict.email)
        mobileLbl?.text = setValue(EOiModelDict.mobilePhone)
        applicationNumberLbl?.text = setValue(EOiModelDict.applicationNumber)
        carpetAreaLbl?.text = setValue(EOiModelDict.carpetArea)
        
        totalPaymentLbl?.text = setAmount(EOiModelDict.totalPaymentAmount)
        
        paymentSubmissionLbl?.text = setValue(EOiModelDict.eoiPaymentSubmissionDate)
        terraceAreaLbl?.text = setValue(EOiModelDict.terraceArea)
        
        totalPaymentDetailLbl?.text = setAmount(EOiModelDict.totalPaymentDetail)
        
        totalPriceLbl?.text = setAmount(EOiModelDict.totalPriceListAmount)
        
        if let booked = EOiModelDict.booked {
            bookedLbl?.text = booked ? "Yes" : "No"
        } else {
            bookedLbl?.text = "-"
        }
        
        if let offlineEOI = EOiModelDict.isOfflineEOIForm {
            offlineEOILbl?.text = offlineEOI ? "Yes" : "No"
        } else {
            offlineEOILbl?.text = "-"
        }
        
        projectNamebl?.text = setValue(EOiModelDict.project?.name)
        EOITentativeLbl?.text = setValue(EOiModelDict.eoiTentativePriceRange)
        EOISaleableAreaLbl?.text = setValue(EOiModelDict.eoiSaleableArea)
        submittedByLbl?.text = setValue(EOiModelDict.submittedBy)
        RMNameLbl?.text = setValue(EOiModelDict.rmDetails?.name)
        
        documentNumberLbl?.text = setValue(EOiModelDict.documentNumber)
        NRIStatusLbl?.text = setValue(EOiModelDict.nriStatus)
        companyLbl?.text = setValue(EOiModelDict.companyName)
        applicationDateLbl?.text = setValue(EOiModelDict.applicationDate)
        EOIPaymentSubmissionDateLbl?.text = setValue(EOiModelDict.eoiPaymentSubmissionDate)
        eventURLLbl?.text = setValue(EOiModelDict.eventURL)
        
        totalAmountINCLGSTLbl?.text = setAmount(EOiModelDict.totalAmountInclGST)
        if let priceListDeviated = EOiModelDict.priceListDeviated {
            priceListDeviatedLbl?.text = priceListDeviated ? "Yes" : "No"
        } else {
            priceListDeviatedLbl?.text = "-"
        }
        
        if let paymentPlanDeviated = EOiModelDict.paymentPlanDeviated {
            paymentPlandeviatedLbl?.text = paymentPlanDeviated ? "Yes" : "No"
        } else {
            paymentPlandeviatedLbl?.text = "-"
        }
        
        if let paymentNotApproved = EOiModelDict.paymentNotApproved {
            paymentNotApprovedLbl?.text = paymentNotApproved ? "Yes" : "No"
        } else {
            paymentNotApprovedLbl?.text = "-"
        }
    }
    
    func setupProjectInformationView() {
        
        // Remove old views
        projectInfoVerticalStack?.arrangedSubviews.forEach { subview in
            projectInfoVerticalStack?.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Dynamic Array
        var projectList: [[String: String]] = []
        
        // Main Project
        if let projectName = EOiModelDict.project?.name,
           !projectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            projectList.append([
                "title": "Project",
                "value": projectName
            ])
        }
        
        // Alternate Project 1
        //        if let alternateProject1 = EOiModelDict.alternateProject1,
        //           !alternateProject1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        //
        //            projectList.append([
        //                "title": "Alternate Project 1",
        //                "value": alternateProject1
        //            ])
        //        }
        //
        //        // Alternate Project 2
        //        if let alternateProject2 = EOiModelDict.alternateProject2,
        //           !alternateProject2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        //
        //            projectList.append([
        //                "title": "Alternate Project 2",
        //                "value": alternateProject2
        //            ])
        //        }
        //
        //        // Alternate Project 3
        //        if let alternateProject3 = EOiModelDict.alternateProject3,
        //           !alternateProject3.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        //
        //            projectList.append([
        //                "title": "Alternate Project 3",
        //                "value": alternateProject3
        //            ])
        //        }
        
        // Create UI
        for item in projectList {
            
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.alignment = .top
            horizontalStack.distribution = .fill
            horizontalStack.spacing = 11
            horizontalStack.translatesAutoresizingMaskIntoConstraints = false
            
            let titleLbl = UILabel()
            titleLbl.text = item["title"]
            titleLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            titleLbl.textColor = .black
            titleLbl.numberOfLines = 0
            
            let valueLbl = UILabel()
            valueLbl.text = item["value"]
            valueLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            valueLbl.textColor = .darkGray
            valueLbl.numberOfLines = 0
            valueLbl.textAlignment = .right
            
            titleLbl.widthAnchor.constraint(equalToConstant: 130).isActive = true
            
            horizontalStack.addArrangedSubview(titleLbl)
            horizontalStack.addArrangedSubview(valueLbl)
            
            projectInfoVerticalStack?.addArrangedSubview(horizontalStack)
        }
        
        projectInfoVerticalStack?.layoutIfNeeded()
        projectInformationView?.layoutIfNeeded()
    }
    
    func setupChoosePaymentTypeVIew() {
        addChoosePaymentInternalView?.layer.cornerRadius = 24
        DispatchQueue.main.async {
            self.setupPaymentDropdown()
        }
    }
    
    func resetEOIViewHeight() {
        paymentHeightConstraint?.constant = 148
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func resetPaymentPopupUI() {
        paymnetTypeTxtFld?.text = EMPTY
        choosePaymentTypeDropDown.hide()
        resetEOIViewHeight()
        addChoosePaymentView?.removeFromSuperview()
        addChoosePaymentView?.alpha = 0
        addChoosePaymentView?.transform = .identity
    }
    
    func setupPaymentDropdown() {
        guard let textField = paymnetTypeTxtFld else { return }
        
        // Important
        addChoosePaymentInternalView?.layoutIfNeeded()
        textField.layoutIfNeeded()
        
        choosePaymentTypeDropDown.anchorView = textField
        choosePaymentTypeDropDown.direction = .bottom
        
        // Better offset
        choosePaymentTypeDropDown.bottomOffset = CGPoint(
            x: 0,
            y: textField.bounds.height
        )
        
        choosePaymentTypeDropDown.dataSource = [
            "RTGS",
            "NEFT",
            "Cheque",
            "Demand Draft(DD)",
            "UPI",
            "Easebuzz"
        ]
        
        choosePaymentTypeDropDown.backgroundColor = .white
        choosePaymentTypeDropDown.selectionBackgroundColor = UIColor(hex: "223B30")
        choosePaymentTypeDropDown.selectedTextColor = .white
        choosePaymentTypeDropDown.textColor = .black
        
        // IMPORTANT
        choosePaymentTypeDropDown.dismissMode = .automatic
        //        choosePaymentTypeDropDown.shadowOpacity = 0.2
        //        choosePaymentTypeDropDown.shadowRadius = 5
        //        choosePaymentTypeDropDown.cornerRadius = 10
        
        // THIS FIXES MOST VISIBILITY ISSUES
        DropDown.startListeningToKeyboard()
        
        choosePaymentTypeDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            
            self.paymnetTypeTxtFld?.text = item
            
            self.choosePaymentTypeDropDown.hide()
            self.dismissAddNewEOIView()
            
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
            
            let createPaymentVC = storyboard.instantiateViewController(
                withIdentifier: "CreatePaymentVC"
            ) as! CreatePaymentVC
            
            createPaymentVC.EOiModelDict = self.EOiModelDict
            createPaymentVC.selectedPaymentType = paymnetTypeTxtFld?.text
            
            createPaymentVC.completionalHandler = { EMPTY in
                self.fetchApprovalData()
                self.fetchPaymentData()
            }
            
            self.navigationController?.pushViewController(createPaymentVC, animated: true)
        }
    }
    
    @objc private func dismissAddNewEOIView() {
        guard let addNewEOIView = addChoosePaymentView else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            addNewEOIView.alpha = 0
            addNewEOIView.transform = CGAffineTransform(translationX: 0, y: addNewEOIView.frame.height)
        }, completion: { _ in
            addNewEOIView.removeFromSuperview()
        })
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
    
    @IBAction func addNewBtnAction() {
        Defaults.isOpportunityIDPresent = true
        Defaults.opportunityId = EOiModelDict.id
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let SchemeListVC = storyboard.instantiateViewController(withIdentifier: "PersonalEOIScreenVC") as! PersonalEOIScreenVC
        self.navigationController?.pushViewController(SchemeListVC, animated: true)
    }
    
    @IBAction func addPaymentAction() {
        if addPaymentBtn?.titleLabel?.text == "Inventory Selection" {

            print("Inventory Selection")
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "Inventory", bundle: storyboardBundle)
            let inventroyDetailsVC = storyboard.instantiateViewController(withIdentifier: "InventroyDetailsVC") as! InventroyDetailsVC
            inventroyDetailsVC.selectedProjectId = EOiModelDict.project?.id
            inventroyDetailsVC.isComingFromEOIDetailScreen = true
            inventroyDetailsVC.oppId = EOiModelDict.id ?? EMPTY
            inventroyDetailsVC.EOiModelDict = EOiModelDict
            inventroyDetailsVC.isFromDetails = true
            inventroyDetailsVC.onUnitBlocked = { [weak self] unitId in
                print("✅ onUnitBlocked called. Unit ID: \(unitId)")
                self?.isDataUpdated = true
                print("✅ isDataUpdated set to TRUE")
                self?.addPaymentBtn?.isHidden = true
            }
            self.navigationController?.pushViewController(inventroyDetailsVC, animated: true)

        } else if addPaymentBtn?.titleLabel?.text == "Add Payment" {

            guard let addNewEOIView = addChoosePaymentView else {
                print("addChoosePaymentView nil")
                return
            }

            guard let window = UIApplication.shared.keyWindow else {
                print("window nil")
                return
            }

            addNewEOIView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

            addNewEOIView.translatesAutoresizingMaskIntoConstraints = false

            window.addSubview(addNewEOIView)

            setupChoosePaymentTypeVIew()

            NSLayoutConstraint.activate([
                addNewEOIView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                addNewEOIView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                addNewEOIView.topAnchor.constraint(equalTo: window.topAnchor),
                addNewEOIView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
            ])

            addNewEOIView.alpha = 0

            addNewEOIView.transform = CGAffineTransform(
                translationX: 0,
                y: window.frame.height
            )

            UIView.animate(withDuration: 0.3) {

                addNewEOIView.alpha = 1
                addNewEOIView.transform = .identity
            }

            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(dismissAddNewEOIView)
            )

            tapGesture.cancelsTouchesInView = false
            addChoosePaymentInternalView?.isUserInteractionEnabled = true

            addNewEOIView.addGestureRecognizer(tapGesture)
        }
    }
        
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadFileAction() {
        print("Upload button tapped")
        showUploadOptions(sourceField: "File")
    }
}

extension DetailVC: UICollectionViewDelegate,
                    UICollectionViewDataSource,
                    UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuArr.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TopMenuCollectionCell",
            for: indexPath
        ) as! TopMenuCollectionCell

        let name = menuArr[indexPath.row]

        cell.configure(
            name: name,
            isSelected: selectedIndex == indexPath.row
        )

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        selectedIndex = indexPath.row
        collectionView.reloadData()

        manageScreen(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.frame.width / CGFloat(menuArr.count)) + 25

        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func manageScreen(index: Int) {

        let selectedMenu = menuArr[index]

        // Hide All First
        detailsScrollView?.isHidden = true
        applicantTableView?.isHidden = true
        tablesHeaderView?.isHidden = true
        fileHeaderView?.isHidden = true
        fileTableView?.isHidden = true
        tableViewsHeader?.isHidden = true
        paymentView?.isHidden = true
        approvalView?.isHidden = true
        propertyView?.isHidden = true
        noDataFoundVw?.isHidden = true

        switch selectedMenu {

        case "Details":

            detailsScrollView?.isHidden = false

        case "Applicant":

            if EOiModelDict.applicantType == "Individual" || EOiModelDict.applicantType == "Partnership" {
//                addNewBtn?.isHidden = false
            } else {
//                addNewBtn?.isHidden = true
            }

            tablesHeaderView?.isHidden = false

            if ApplicantArr.count > 0 {
                applicantTableView?.isHidden = false
                applicantTableView?.reloadData()
            } else {
                noDataFoundVw?.isHidden = false
            }

        case "Payment":

            paymentView?.isHidden = false
            paymentHeaderView?.isHidden = false

            if filteredPaymentRecord.count > 0 {
                paymentTableView?.isHidden = false
                paymentTableView?.reloadData()
            } else {
                noDataFoundVw?.isHidden = false
            }

        case "Property Details":

            propertyView?.isHidden = false
            propertyHeaderView?.isHidden = false

            if propertyArr.count > 0 {
                propertyTableView?.isHidden = false
                propertyTableView?.reloadData()
            } else {
                noDataFoundVw?.isHidden = false
            }

        case "Files":

            fileHeaderView?.isHidden = false

            if fileArray.count > 0 {

                noDataFoundVw?.isHidden = true
                fileTableView?.isHidden = false
                tableViewsHeader?.isHidden = false
                fileTableView?.reloadData()

            } else {

                tableViewsHeader?.isHidden = true
                fileTableView?.isHidden = true
                noDataFoundVw?.isHidden = false
            }

        case "Approval History":

            approvalHeaderView?.isHidden = false

            if approvalArr.count > 0 {
                approvalView?.isHidden = false
                approvalTableView?.isHidden = false
                approvalTableView?.reloadData()
                noDataFoundVw?.isHidden = true
            } else {
                noDataFoundVw?.isHidden = false
                approvalView?.isHidden = true
            }

        default:
            break
        }
    }
}

extension DetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
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
            await uploadAttachment(linkedEntityId: EOiModelDict.id ?? EMPTY)
            
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
        
    func startCountdown() {

        guard let holdTimeString = EOiModelDict.Unit_Hold_Date_Time__c,
              let releaseMinutes = EOiModelDict.project?.minutesToReleaseUnits else {

            hideCountdownTimer()
            return
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        // Example:
        // 2026-05-26T11:58:15.000+0000
        //
        // We intentionally ignore +0000 because your requirement
        // treats 11:58:15 as India/local time.

        let apiDateWithoutTimezone = String(holdTimeString.prefix(23))

        guard let holdDate = formatter.date(
            from: apiDateWithoutTimezone
        ) else {

            print("❌ Invalid hold date:", holdTimeString)
            hideCountdownTimer()
            return
        }

        // Hold time + minutesToReleaseUnits
        let releaseDate = holdDate.addingTimeInterval(
            releaseMinutes * 60
        )

        // Get CURRENT INDIA TIME
        let currentIndiaString = formatter.string(from: Date())

        guard let currentIndiaDate = formatter.date(
            from: currentIndiaString
        ) else {

            hideCountdownTimer()
            return
        }

        let remainingSeconds =
            releaseDate.timeIntervalSince(currentIndiaDate)

        print("========== TIMER ==========")
        print("API Hold Time :", holdTimeString)
        print("Hold Time     :", formatter.string(from: holdDate))
        print("Release Time  :", formatter.string(from: releaseDate))
        print("Current India :", currentIndiaString)
        print("Release Min   :", releaseMinutes)
        print("Remaining     :", remainingSeconds)
        print("============================")

        guard remainingSeconds > 0 else {

            countdownTimer?.invalidate()
            countdownTimer = nil
            totalTimeInSeconds = 0

            hideCountdownTimer()

            print("⏰ TIMER EXPIRED")

            return
        }

        totalTimeInSeconds = Int(ceil(remainingSeconds))

        Helper.showTimer(
            timerHeight: timerHeight,
            timerBtn: timerBtn,
            timerLeftImgBtn: timerLeftImgBtn,
            timer1Lbl: timer1Lbl,
            timer2Lbl: timer2Lbl,
            view: view
        )

        updateTimerButtonTitle()

        countdownTimer?.invalidate()

        countdownTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] timer in

            guard let self = self else {
                timer.invalidate()
                return
            }

            let currentIndiaString = formatter.string(from: Date())

            guard let currentIndiaDate = formatter.date(
                from: currentIndiaString
            ) else {
                return
            }

            let remaining =
                releaseDate.timeIntervalSince(currentIndiaDate)

            if remaining > 0 {

                self.totalTimeInSeconds = Int(ceil(remaining))
                self.updateTimerButtonTitle()

            } else {

                timer.invalidate()
                self.countdownTimer = nil

                self.totalTimeInSeconds = 0

                self.hideCountdownTimer()

                print("⏰ TIMER FINISHED")
            }
        }

        RunLoop.main.add(
            countdownTimer!,
            forMode: .common
        )
    }
    
    private func hideCountdownTimer() {

        Helper.hideTimer(
            timerHeight: timerHeight,
            timerBtn: timerBtn,
            timerLeftImgBtn: timerLeftImgBtn,
            timer1Lbl: timer1Lbl,
            timer2Lbl: timer2Lbl,
            view: view
        )
    }
    
//    func startCountdown() {
//
//        guard let holdTimeString = EOiModelDict.Unit_Hold_Date_Time__c,
//              let releaseMinutes = EOiModelDict.project?.minutesToReleaseUnits else {
//
//            Helper.hideTimer(
//                timerHeight: timerHeight,
//                timerBtn: timerBtn,
//                timerLeftImgBtn: timerLeftImgBtn,
//                timer1Lbl: timer1Lbl,
//                timer2Lbl: timer2Lbl,
//                view: view
//            )
//            return
//        }
//
//        // API date is UTC: 2026-08-13T12:55:49.000+0000
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//
//        guard let holdDate = formatter.date(from: holdTimeString) else {
//            print("❌ Invalid hold date:", holdTimeString)
//            return
//        }
//
//        // minutesToReleaseUnits = 2 means 2 minutes
//        let releaseDate = holdDate.addingTimeInterval(
//            releaseMinutes * 60
//        )
//
//        // Date() is an absolute current timestamp.
//        // Timezone does NOT need to be manually added.
//        let remainingSeconds = releaseDate.timeIntervalSinceNow
//
//        print("========== TIMER ==========")
//        print("Hold UTC    :", holdDate)
//        print("Release UTC :", releaseDate)
//        print("Now         :", Date())
//        print("Remaining   :", remainingSeconds)
//        print("============================")
//
//        // Already expired
//        guard remainingSeconds > 0 else {
//
//            countdownTimer?.invalidate()
//            countdownTimer = nil
//            totalTimeInSeconds = 0
//
//            Helper.hideTimer(
//                timerHeight: timerHeight,
//                timerBtn: timerBtn,
//                timerLeftImgBtn: timerLeftImgBtn,
//                timer1Lbl: timer1Lbl,
//                timer2Lbl: timer2Lbl,
//                view: view
//            )
//
//            print("⏰ Timer already expired")
//            return
//        }
//
//        // Show timer
//        Helper.showTimer(
//            timerHeight: timerHeight,
//            timerBtn: timerBtn,
//            timerLeftImgBtn: timerLeftImgBtn,
//            timer1Lbl: timer1Lbl,
//            timer2Lbl: timer2Lbl,
//            view: view
//        )
//
//        countdownTimer?.invalidate()
//
//        countdownTimer = Timer.scheduledTimer(
//            withTimeInterval: 1.0,
//            repeats: true
//        ) { [weak self] timer in
//
//            guard let self = self else {
//                timer.invalidate()
//                return
//            }
//
//            let remaining = releaseDate.timeIntervalSinceNow
//
//            if remaining > 0 {
//
//                self.totalTimeInSeconds = Int(ceil(remaining))
//                self.updateTimerButtonTitle()
//
//            } else {
//
//                timer.invalidate()
//                self.countdownTimer = nil
//                self.totalTimeInSeconds = 0
//
//                Helper.hideTimer(
//                    timerHeight: self.timerHeight,
//                    timerBtn: self.timerBtn,
//                    timerLeftImgBtn: self.timerLeftImgBtn,
//                    timer1Lbl: self.timer1Lbl,
//                    timer2Lbl: self.timer2Lbl,
//                    view: self.view
//                )
//
//                print("⏰ TIMER EXPIRED")
//            }
//        }
//
//        RunLoop.main.add(
//            countdownTimer!,
//            forMode: .common
//        )
//    }
    
    func updateTimerButtonTitle() {

        let hours = totalTimeInSeconds / 3600
        let minutes = (totalTimeInSeconds % 3600) / 60
        let seconds = totalTimeInSeconds % 60

        let timeString = String(
            format: "%02d:%02d:%02d",
            hours,
            minutes,
            seconds
        )

        timerBtn?.setTitle(timeString, for: .normal)
    }
}

extension DetailVC: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItemURL == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItemURL! as QLPreviewItem
    }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == applicantTableView {
            return filteredApplicantRecord.count
        } else if tableView == paymentTableView {
            return filteredPaymentRecord.count
        } else if tableView == propertyTableView {
            return propertyArr.count
        } else if tableView == fileTableView {
            return fileArray.count
        } else if tableView == approvalTableView {
            return approvalArr.count
        } else {
            return 0
        }
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
        } else if tableView == paymentTableView {
            let cell: PaymentCell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
            let paymentDict = filteredPaymentRecord[indexPath.row]
            if paymentDict.paymentMode == "Easebuzz" {
                cell.verifyHeight?.constant = 30
                cell.verifyBtn?.isHidden = false
            } else {
                cell.verifyHeight?.constant = 0
                cell.verifyBtn?.isHidden = true
            }
            cell.receiptLbl?.text = paymentDict.name
            let eoiAmountText = paymentDict.eoiAmount ?? 0.0
            cell.EOIAmountLbl?.text = String(format: "%.2f", eoiAmountText)
            cell.paymenMode?.text = paymentDict.paymentMode
            cell.chequeDDNumber?.text = paymentDict.chequeUTRNumber
            
            cell.onVerifyTapped = {
                print("Verify button tapped at row \(indexPath.row)")
                
                let alert = UIAlertController(
                    title: "Confirm Verify",
                    message: "Are you sure you want to verify this Payment",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Verify", style: .destructive, handler: { _ in
                    Task {
                    }
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            return cell
            
        } else if tableView == applicantTableView {
            let cell: ApplicantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ApplicantTableViewCell", for: indexPath) as! ApplicantTableViewCell
            let applicantDict = filteredApplicantRecord[indexPath.row]
//            if applicantDict.opportunity?.applicantType == "Individual" || applicantDict.opportunity?.applicantType == "Partnership" {
//                if let isPrimary = applicantDict.primary {
//                    cell.primaryLbl?.text = isPrimary ? "Yes" : "No"
//                } else {
//                    cell.primaryLbl?.text = ""
//                }
//            } else {
//                cell.primaryLbl?.text = applicantDict.primary
//            }
            if let isPrimary = applicantDict.primary {
                cell.primaryLbl?.text = isPrimary ? "Yes" : "No"
            }
            if applicantDict.opportunity?.applicantType == "Individual" {
                cell.residentHeadingLbl?.text = "Resident Type"
                cell.residentLblTop?.constant = 10
            } else {
                cell.residentHeadingLbl?.text = EMPTY
                cell.residentLblTop?.constant = 0
            }
            cell.applicantTypeLbl?.text = applicantDict.opportunity?.applicantType
            cell.applicantNameLbl?.text = applicantDict.opportunity?.name
            cell.residentTypeLbl?.text = applicantDict.residentType
            cell.emailLbl?.text = applicantDict.applicantEmailID
            cell.mobileLbl?.text = applicantDict.applicantMobileNumber
            cell.onViewTapped = {
                let applicantDate = self.ApplicantArr[indexPath.row]
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
                let applicantDetailVC = storyboard.instantiateViewController(withIdentifier: "ApplicantDetailVC") as! ApplicantDetailVC
                applicantDetailVC.applicantId = applicantDate.id ?? EMPTY
                applicantDetailVC.applicantEmailId = applicantDict.applicantEmailID ?? EMPTY
                applicantDetailVC.applicantPhoneNumber = applicantDict.applicantMobileNumber ?? EMPTY
                self.navigationController?.pushViewController(applicantDetailVC, animated: true)
            }
            
            cell.onDeleteTapped = {
                print("Delete button tapped at row \(indexPath.row)")
                
                let alert = UIAlertController(
                    title: "Confirm Delete",
                    message: "Are you sure you want to delete this record?",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    Task {
                        do {
                            let request = RestClient.shared.requestForDelete(
                                withObjectType: "Applicant_Details__c",
                                objectId: self.ApplicantArr[indexPath.row].id ?? EMPTY,
                                apiVersion: "v63.0"
                            )
                            
                            let _ = try await RestClient.shared.send(request: request)
                            print("🗑️ Applicant id Deleted Successfully: \(self.ApplicantArr[indexPath.row].id ?? EMPTY)")
                            
                            DispatchQueue.main.async {
                                self.ApplicantArr.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .automatic)
                                
                                Utility.getAllApplicantRecords(oppId: self.EOiModelDict.id ?? EMPTY) { result in
                                    if result {
                                        self.ApplicantArr = GlobalData.allApplicantRecord
                                        if self.ApplicantArr.count > 0 {
                                            self.noDataFoundVw?.isHidden = true
                                            self.applicantTableView?.isHidden = false
                                            self.applicantTableView?.reloadData()
                                        } else {
                                            self.noDataFoundVw?.isHidden = false
                                            self.applicantTableView?.isHidden = true
                                        }
                                    }
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                            }
                        }
                    }
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
//            cell.onEditTapped = {
//                Defaults.isOpportunityIDPresent = true
//                Defaults.opportunityId = self.filteredApplicantRecord[indexPath.row].opportunity?.id
//                let storyboardBundle = Bundle.main
//                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
//                let personalEOIScreenVC = storyboard.instantiateViewController(withIdentifier: "PersonalEOIScreenVC") as! PersonalEOIScreenVC
//                personalEOIScreenVC.isForEditing = true
//                personalEOIScreenVC.applicantRecord = self.filteredApplicantRecord[indexPath.row]
//                Defaults.type = self.filteredApplicantRecord[indexPath.row].opportunity?.applicantType
//                self.navigationController?.pushViewController(personalEOIScreenVC, animated: true)
//            }
            cell.onEditTapped = {

//                let applicantData = self.filteredApplicantRecord[indexPath.row]
                Defaults.isOpportunityIDPresent = true
                Defaults.opportunityId = applicantDict.opportunity?.id
                Defaults.type = applicantDict.opportunity?.applicantType
                let storyboardBundle = Bundle.main
                let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)

                if applicantDict.opportunity?.applicantType == "Individual" {

                    let personalEOIScreenVC = storyboard.instantiateViewController(
                        withIdentifier: "PersonalEOIScreenVC"
                    ) as! PersonalEOIScreenVC

                    personalEOIScreenVC.isForEditing = true
                    personalEOIScreenVC.applicantRecord = applicantDict

                    self.navigationController?.pushViewController(
                        personalEOIScreenVC,
                        animated: true
                    )

                } else {
                    let companyDetailsVC = storyboard.instantiateViewController(
                        withIdentifier: "CompanyDetailsEOIScreenVC"
                    ) as! CompanyDetailsEOIScreenVC

                    companyDetailsVC.isForEditing = true
                    companyDetailsVC.applicantRecord = applicantDict

                    self.navigationController?.pushViewController(
                        companyDetailsVC,
                        animated: true
                    )
                }
            }
            return cell
        } else if tableView == approvalTableView {
            let cell: ApprovalCell = tableView.dequeueReusableCell(withIdentifier: "ApprovalCell", for: indexPath) as! ApprovalCell
            let approvalDict = filteredApprovalRecord[indexPath.row]
            cell.stepName?.text = approvalDict.actorName
            cell.dateLbl?.text = CustomDateFormatter().getApprovalDateTime(dateString: approvalDict.createdDate ?? "")
            cell.statusLbl?.text = approvalDict.stepStatus
            cell.totalPaymentDetailsLbl?.text = "-"
            cell.assignedTo?.text = approvalDict.actorName
            return cell
        } else if tableView == propertyTableView {
            let cell: PropertyCell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as! PropertyCell
            let propertyDict = propertyArr[indexPath.row]
            cell.unitName?.text = propertyDict.name
            cell.projectLbl?.text = EOiModelDict.project?.name
            cell.towerLbl?.text = propertyDict.towerName
            cell.floorNumberLbl?.text = propertyDict.floorName
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == paymentTableView {
            let paymentDict = filteredPaymentRecord[indexPath.row]
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
            let detailsListVC = storyboard.instantiateViewController(withIdentifier: "PaymentDetailVC") as! PaymentDetailVC
            detailsListVC.paymentDict = paymentDict
            detailsListVC.paymentMode = paymentDict.paymentMode ?? EMPTY
            detailsListVC.isFromApproval = false
            self.navigationController?.present(detailsListVC, animated: true)
        }
        
        if tableView == approvalTableView {
//            let paymentDict = filteredPaymentRecord[indexPath.row]
//            let storyboardBundle = Bundle.main
//            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
//            let detailsListVC = storyboard.instantiateViewController(withIdentifier: "PaymentDetailVC") as! PaymentDetailVC
//            detailsListVC.paymentDict = paymentDict
//            detailsListVC.paymentMode = paymentDict.paymentMode ?? EMPTY
//            detailsListVC.isFromApproval = true
//            self.navigationController?.present(detailsListVC, animated: true)
        }
        
        if tableView == propertyTableView {
            let propertArr = propertyArr[indexPath.row]
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
            let detailsListVC = storyboard.instantiateViewController(withIdentifier: "PropertyDetailVc") as! PropertyDetailVc
            detailsListVC.propertyModel = propertArr
            self.navigationController?.present(detailsListVC, animated: true)
        }
    }
}

class ApplicantTableViewCell: UITableViewCell {
    @IBOutlet var primaryLbl: UILabel?
    @IBOutlet var applicantTypeLbl: UILabel?
    @IBOutlet var applicantNameLbl: UILabel?
    @IBOutlet var residentTypeLbl: UILabel?
    @IBOutlet var residentHeadingLbl: UILabel?
    @IBOutlet var emailLbl: UILabel?
    @IBOutlet var mobileLbl: UILabel?
    @IBOutlet var residentLblTop: NSLayoutConstraint?
    @IBOutlet var viewBtn: UIButton?
    @IBOutlet var deleteBtn: UIButton?
    @IBOutlet var editBtn: UIButton?
    @IBOutlet var vw: UIView?
    
    var onViewTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    var onEditTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
        viewBtn?.layer.cornerRadius = 8
        deleteBtn?.layer.cornerRadius = 8
        editBtn?.layer.cornerRadius = 8

        viewBtn?.addTarget(self, action: #selector(viewButtonTapped), for: .touchUpInside)
        deleteBtn?.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        editBtn?.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @objc private func viewButtonTapped() {
        onViewTapped?()
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteTapped?()
    }
    
    @objc private func editButtonTapped() {
        onEditTapped?()
    }
}

class FilelCell: UITableViewCell {
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


class PaymentCell: UITableViewCell {
    @IBOutlet var receiptLbl: UILabel?
    @IBOutlet var EOIAmountLbl: UILabel?
    @IBOutlet var paymenMode: UILabel?
    @IBOutlet var chequeDDNumber: UILabel?
    @IBOutlet var verifyBtn: UIButton?
    @IBOutlet var verifyHeight: NSLayoutConstraint?
    @IBOutlet var vw: UIView?
    
    var onVerifyTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
        verifyBtn?.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func verifyButtonTapped() {
        onVerifyTapped?()
        
    }
}

extension DetailVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchText = searchText
        applyCombinedFilters()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func applyCombinedFilters() {
        var baseList = GlobalData.allPaymentRecord
        if !currentSearchText.isEmpty {
            let lowercasedSearch = currentSearchText.lowercased()
            
            baseList = baseList.filter {
                ($0.name?.lowercased().contains(lowercasedSearch) ?? false) ||
                ($0.paymentMode?.lowercased().contains(lowercasedSearch) ?? false)
            }
        }
        
        filteredPaymentRecord = baseList
        paymentTableView?.reloadData()
        noDataFoundVw?.isHidden = !filteredPaymentRecord.isEmpty
        paymentTableView?.isHidden = filteredPaymentRecord.isEmpty
    }
}

class ApprovalCell: UITableViewCell {
    @IBOutlet var stepName: UILabel?
    @IBOutlet var dateLbl: UILabel?
    @IBOutlet var statusLbl: UILabel?
    @IBOutlet var totalPaymentDetailsLbl: UILabel?
    @IBOutlet var assignedTo: UILabel?
    @IBOutlet var vw: UIView?
    
    var onVerifyTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
    }
    
}

class PropertyCell: UITableViewCell {
    @IBOutlet var unitName: UILabel?
    @IBOutlet var projectLbl: UILabel?
    @IBOutlet var statusLbl: UILabel?
    @IBOutlet var towerLbl: UILabel?
    @IBOutlet var floorNumberLbl: UILabel?
    @IBOutlet var vw: UIView?
    
    var onVerifyTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
    }
    
}

class TopMenuCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var bottomLineView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear

        titleLbl?.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        titleLbl?.textAlignment = .center

        bottomLineView?.layer.cornerRadius = 1.5
    }

    func configure(name: String, isSelected: Bool) {

        titleLbl?.text = name

        if isSelected {
            titleLbl?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
            bottomLineView?.backgroundColor = ColorConstant.primary

        } else {

            titleLbl?.textColor = .black
            titleLbl?.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            bottomLineView?.backgroundColor = ColorConstant.buttonBackgroundWhiteColor
        }
    }
}

extension DetailVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == paymnetTypeTxtFld {
            
            let dropdownHeight = getDropdownHeight()
            paymentHeightConstraint?.constant = 200 + dropdownHeight
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                self.choosePaymentTypeDropDown.show()
            }
            return false
        }
        return true
    }
    
    func getDropdownHeight() -> CGFloat {
        let itemCount = choosePaymentTypeDropDown.dataSource.count
        let cellHeight = choosePaymentTypeDropDown.cellHeight
        let maxVisibleItems = 5
        
        let visibleItems = min(itemCount, maxVisibleItems)
        return CGFloat(visibleItems) * cellHeight
    }
}

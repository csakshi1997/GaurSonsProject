//
//  EOIVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 13/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class EOIVC: UIViewController {
    @IBOutlet var tbleview: UITableView?
    @IBOutlet var tbleViewHeader: UIView?
    @IBOutlet var noDataFoundVw: UIView?
    @IBOutlet var noDataFoundImg: UIImageView?
    @IBOutlet var noDataFoundLblHead: UILabel?
    @IBOutlet var eoiListLbl: UILabel?
    @IBOutlet var noDataFoundLblText: UILabel?
    @IBOutlet var topView: UIView?
    @IBOutlet var mainVw: UIView?
    @IBOutlet var menuBtn: UIButton?
    @IBOutlet var addNewBtn: UIButton?
    @IBOutlet var notificationBtn: UIButton?
    @IBOutlet var backgroundView: UIView?
    @IBOutlet var addNewEOIView: UIView?
    @IBOutlet var addNewEOIInternalView: UIView?
    @IBOutlet var isOfflineEOIYES: UIButton?
    @IBOutlet var isOfflineEOINO: UIButton?
    @IBOutlet var applicantTypeIndividual: UIButton?
    @IBOutlet var applicantTypeCompany: UIButton?
    @IBOutlet var applicantTypePartnership: UIButton?
    @IBOutlet var applicantTypeProprietorship: UIButton?
    @IBOutlet var proceedBtn: UIButton?
    @IBOutlet var proceedBtnHeight: NSLayoutConstraint?
    @IBOutlet var searchVw: UISearchBar?
    
    @IBOutlet var filtersView: UIView?
    @IBOutlet var filtersInternalView: UIView?
    @IBOutlet var todayBtn: UIButton?
    @IBOutlet var digitalBtn: UIButton?
    @IBOutlet var directSalesBtn: UIButton?
    @IBOutlet var LaunchEventBtn: UIButton?
    @IBOutlet var legacy: UIButton?
    @IBOutlet var unsold: UIButton?
    @IBOutlet var recentlyViewedBtn: UIButton?
    @IBOutlet var addFiltersBtn: UIButton?
    
    var createdDateDatePicker = UIDatePicker()
    var isEOISelected: Bool = false
    var isApplicantTypeSelected: Bool = false
    var selectedButtons: Set<Int> = []
    var isOfflineYesEnable: Bool = false
    var isOfflineNoEnable: Bool = false
    var isIndividualEnable: Bool = false
    var isCompanyEnable: Bool = false
    var isPartnershipEnable: Bool = false
    var isProprietorshipEnable: Bool = false
    var isIndividualForFilterEnable: Bool = false
    var isCompanyForFilterEnable: Bool = false
    var isPartnershipForFilterEnable: Bool = false
    var isProprietorshipForFilterEnable: Bool = false
    var EOIModelData = [EOIModel]()
    var filteredRecord = [EOIModel]()
    var currentSearchText: String = ""
    var currentPage = 1
    let recordsPerPage = 5
    var eOIWebServices = EOIWebServices()
    var projectNameDropdown = DropDown()
    var agentNameDropdown = DropDown()
    var projectList: [ProjectModel] = []
    var filterType: String = EMPTY
    var filtersConstraintsActivated = false
    @IBOutlet weak var paginationStack: UIStackView!
    var pageNumber = 1
    var isLoading = false
    let spinner = UIActivityIndicatorView(style: .medium)
    var totalPages: Int {
        return Int(ceil(Double(filteredRecord.count) / Double(recordsPerPage)))
    }
    var summaryFilter: EOISummaryFilter = .total
    var selectedFilterType: FilterTypeForEOI = .none


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        fetchProjects()
//        getEOI()
    }
    
    
    
            
//    func getEOI() {
//        print("Selected Filter =", selectedFilterType)
//        Utility.getAllEOIRecords(
//            pageNumber: pageNumber,
//            summaryFilter: summaryFilter,
//            filterType: selectedFilterType
//        ) { success in
//            
//            if success {
//                DispatchQueue.main.async {
//                    
//                    self.isLoading = false
//                    self.spinner.stopAnimating()
//                    
//                    if self.pageNumber == 1 {
//                        
//                        self.EOIModelData = GlobalData.allEOIModel.sorted {
//                            ($0.createdDate ?? "") > ($1.createdDate ?? "")
//                        }
//                        
//                    } else {
//                        
//                        self.EOIModelData.append(
//                            contentsOf: GlobalData.allEOIModel
//                        )
//                    }
//                    
//                    self.filteredRecord = self.EOIModelData
////                    self.setupPaginationButtons()
//
//                    self.updateUIAfterDataChange()
//                    self.tbleview?.reloadData()
//                    print(self.filteredRecord.count)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    self.spinner.stopAnimating()
//                    
//                    self.filteredRecord = []
//                    self.tbleview?.reloadData()
//                    
//                    self.noDataFoundVw?.isHidden = false
//                    self.tbleview?.isHidden = true
//                }
//            }
//        }
//    }
    
//    func getEOI() {
//        guard InternetConnectionManager.isConnectedToNetwork() else {
//            spinner.stopAnimating()
//            isLoading = false
//            filteredRecord.removeAll()
//            showEmptyState(.noInternet)
//            return
//        }
//
//        hideEmptyState()
//
//        Utility.getAllEOIRecords(
//            pageNumber: pageNumber,
//            summaryFilter: summaryFilter,
//            filterType: selectedFilterType
//        ) { success in
//
//            DispatchQueue.main.async {
//
//                self.isLoading = false
//                self.spinner.stopAnimating()
//
//                if success {
//
//                    if self.pageNumber == 1 {
//                        self.EOIModelData = GlobalData.allEOIModel.sorted {
//                            ($0.createdDate ?? "") > ($1.createdDate ?? "")
//                        }
//                    } else {
//                        self.EOIModelData.append(contentsOf: GlobalData.allEOIModel)
//                    }
//
//                    self.filteredRecord = self.EOIModelData
//
//                    if self.filteredRecord.isEmpty {
//                        self.showEmptyState(.noResults)
//                    } else {
//                        self.hideEmptyState()
//                    }
//
//                    self.tbleview?.reloadData()
//
//                } else {
//
//                    self.filteredRecord.removeAll()
//                    self.showEmptyState(.noResults)
//                }
//            }
//        }
//    }
    
    
    func getEOI() {
        
        guard InternetConnectionManager.isConnectedToNetwork() else {
            spinner.stopAnimating()
            isLoading = false
            filteredRecord.removeAll()
            showEmptyState(.noInternet)
            return
        }

        hideEmptyState()

        Utility.getAllEOIRecords(
            pageNumber: pageNumber,
            summaryFilter: summaryFilter,
            filterType: selectedFilterType
        ) { success in

            DispatchQueue.main.async {

                self.isLoading = false
                self.spinner.stopAnimating()

                if success {

                    if self.pageNumber == 1 {

                        self.EOIModelData = GlobalData.allEOIModel.sorted {
                            ($0.createdDate ?? "") > ($1.createdDate ?? "")
                        }

                    } else {

                        self.EOIModelData.append(
                            contentsOf: GlobalData.allEOIModel
                        )
                    }

                    // Apply current search again
                    self.applyCombinedFilters()

                } else {

                    if self.pageNumber > 1 {
                        // Prevent continuous API calls
                        self.pageNumber -= 1
                    }

                    if self.EOIModelData.isEmpty {
                        self.filteredRecord.removeAll()
                        self.showEmptyState(.noResults)
                    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        Defaults.type = EMPTY
        Defaults.isIndividualEnable = false
        isProprietorshipEnable = false
        isIndividualEnable = false
        isCompanyEnable = false
        isPartnershipEnable = false
        Defaults.isOpportunityIDPresent = false
        Defaults.opportunityId = EMPTY
        OpportunityManager.shared.applicants.removeAll()
        Task {
            await FetchPicklistValue.shared.fetchPicklistValues(
                objectName: "Opportunity__c",
                fieldNames: ["Channel_Partner_Agent_Name__c"]
            )
        }
        setupFilterVIew()
        getEOI()
        
    }
    
    func fetchProjects() {
        eOIWebServices.getProjects { error, projects, status in
            if status == .success, let projects = projects {
                self.projectList = projects
                let projectNames = projects.compactMap { $0.name }
                
                self.projectNameDropdown.dataSource = projectNames
            } else {
                print(error ?? "Failed to load projects")
            }
        }
    }
    
    func showEmptyState(_ state: EmptyState) {
        noDataFoundVw?.isHidden = false
        tbleview?.isHidden = true

        switch state {

        case .noInternet:
            noDataFoundImg?.image = UIImage(named: "NoInternetConnection")
            noDataFoundLblHead?.text = "No Internet Connection"
            noDataFoundLblText?.text = "Please check your Wi-Fi or mobile data and try again."

        case .noResults:
            noDataFoundImg?.image = UIImage(named: "NoResultFound")
            noDataFoundLblHead?.text = "No Results Found"
            noDataFoundLblText?.text = "We couldn’t find any data matching your request."
        }
    }

    func hideEmptyState() {
        noDataFoundVw?.isHidden = true
        tbleview?.isHidden = false
    }
    
    func recordsForCurrentPage() -> [EOIModel] {
        let startIndex = (currentPage - 1) * recordsPerPage
        let endIndex = min(startIndex + recordsPerPage, filteredRecord.count)
        if startIndex < endIndex {
            return Array(filteredRecord[startIndex..<endIndex])
        }
        return []
    }
    
    func setupPaginationButtons() {
        paginationStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard totalPages > 1 else { return }

        let prevBtn = createPaginationButton(title: "‹")
        prevBtn.isEnabled = currentPage > 1
        prevBtn.addTarget(self, action: #selector(previousPageTapped), for: .touchUpInside)
        paginationStack.addArrangedSubview(prevBtn)

        let visiblePages = getVisiblePages()
        for page in visiblePages {
            let button = createPaginationButton(title: "\(page)")
            button.tag = page
            button.addTarget(self, action: #selector(pageButtonTapped(_:)), for: .touchUpInside)

            if page == currentPage {
                button.backgroundColor = UIColor(hex: "7BAE5A") // green
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            }

            paginationStack.addArrangedSubview(button)
        }

        if totalPages > (visiblePages.last ?? 0) {
            let ellipsis = UILabel()
            ellipsis.text = "..."
            ellipsis.textAlignment = .center
            paginationStack.addArrangedSubview(ellipsis)

            let lastButton = createPaginationButton(title: "\(totalPages)")
            lastButton.tag = totalPages
            lastButton.addTarget(self, action: #selector(pageButtonTapped(_:)), for: .touchUpInside)
            paginationStack.addArrangedSubview(lastButton)
        }

        // Next Button
        let nextBtn = createPaginationButton(title: "›")
        nextBtn.isEnabled = currentPage < totalPages
        nextBtn.addTarget(self, action: #selector(nextPageTapped), for: .touchUpInside)
        paginationStack.addArrangedSubview(nextBtn)
    }
    
    func createPaginationButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return button
    }

    func getVisiblePages() -> [Int] {
        if totalPages <= 4 {
            return Array(1...totalPages)
        }

        if currentPage <= 2 {
            return [1, 2, 3]
        } else if currentPage >= totalPages - 1 {
            return [totalPages - 2, totalPages - 1, totalPages]
        } else {
            return [currentPage - 1, currentPage, currentPage + 1]
        }
    }
    
    @objc func pageButtonTapped(_ sender: UIButton) {
        currentPage = sender.tag
        tbleview?.reloadData()
        setupPaginationButtons()
    }

    @objc func previousPageTapped() {
        if currentPage > 1 {
            currentPage -= 1
            tbleview?.reloadData()
            setupPaginationButtons()
        }
    }

    @objc func nextPageTapped() {
        if currentPage < totalPages {
            currentPage += 1
            tbleview?.reloadData()
            setupPaginationButtons()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        tbleview?.keyboardDismissMode = .onDrag
        tbleview?.tableFooterView = createSpinnerFooter()
        searchVw?.delegate = self
        noDataFoundVw?.isHidden = true
        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
        addNewBtn?.layer.cornerRadius = 6
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        spinner.center = CGPoint(x: footerView.center.x, y: 10)
        spinner.hidesWhenStopped = true
        footerView.addSubview(spinner)
        return footerView
    }
    
    func setupFilterVIew() {
        filtersView?.layer.cornerRadius = 24
//        filterapplicantTypeIndividual?.borderWidth = 1
//        filterapplicantTypeIndividual?.borderColor = UIColor(hex: "DFE1E0")
//        filterapplicantTypeIndividual?.layer.cornerRadius = 6
//        filterapplicantTypeCompany?.borderWidth = 1
//        filterapplicantTypeCompany?.borderColor = UIColor(hex: "DFE1E0")
//        filterapplicantTypeCompany?.layer.cornerRadius = 6
//        filterapplicantTypePartnership?.borderWidth = 1
//        filterapplicantTypePartnership?.borderColor = UIColor(hex: "DFE1E0")
//        filterapplicantTypePartnership?.layer.cornerRadius = 6
//        filterapplicantTypeProprietorship?.borderWidth = 1
//        filterapplicantTypeProprietorship?.borderColor = UIColor(hex: "DFE1E0")
//        filterapplicantTypeProprietorship?.layer.cornerRadius = 6
        addFiltersBtn?.layer.cornerRadius = 22.5
    }
    
    func setupAddEOIVIew() {
        addNewEOIInternalView?.layer.cornerRadius = 24
        isOfflineEOIYES?.borderWidth = 1
        isOfflineEOIYES?.borderColor = UIColor(hex: "DFE1E0")
        isOfflineEOIYES?.layer.cornerRadius = 6
        isOfflineEOINO?.borderWidth = 1
        isOfflineEOINO?.borderColor = UIColor(hex: "DFE1E0")
        isOfflineEOINO?.layer.cornerRadius = 6
        applicantTypeIndividual?.borderWidth = 1
        applicantTypeIndividual?.borderColor = UIColor(hex: "DFE1E0")
        applicantTypeIndividual?.layer.cornerRadius = 6
        applicantTypeCompany?.borderWidth = 1
        applicantTypeCompany?.borderColor = UIColor(hex: "DFE1E0")
        applicantTypeCompany?.layer.cornerRadius = 6
        applicantTypePartnership?.borderWidth = 1
        applicantTypePartnership?.borderColor = UIColor(hex: "DFE1E0")
        applicantTypePartnership?.layer.cornerRadius = 6
        applicantTypeProprietorship?.borderWidth = 1
        applicantTypeProprietorship?.borderColor = UIColor(hex: "DFE1E0")
        applicantTypeProprietorship?.layer.cornerRadius = 6
        hideProceedButton()
        proceedBtn?.layer.cornerRadius = 22.5
        [
            todayBtn,
            digitalBtn,
            directSalesBtn,
            LaunchEventBtn,
            legacy,
            unsold,
            recentlyViewedBtn
        ].forEach {

            $0?.layer.cornerRadius = 6
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor(hex: "DFE1E0")?.cgColor
            $0?.backgroundColor = .white
            $0?.setTitleColor(.black, for: .normal)
        }
    }
    
    private func showProceedButton() {
        proceedBtnHeight?.constant = 45
        proceedBtn?.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func filterButtonsTapped(_ sender: UIButton) {

        [
            todayBtn,
            digitalBtn,
            directSalesBtn,
            LaunchEventBtn,
            legacy,
            unsold,
            recentlyViewedBtn
        ].forEach {
            $0?.setTitleColor(.black, for: .normal)
            $0?.backgroundColor = .white
        }

        // assign SINGLE selection
        if sender == todayBtn {
            selectedFilterType = .today
            highlight(sender)
        } else if sender == digitalBtn {
            selectedFilterType = .digital
            highlight(sender)
        } else if sender == directSalesBtn {
            selectedFilterType = .directSales
            highlight(sender)
        } else if sender == LaunchEventBtn {
            selectedFilterType = .launchEvent
            highlight(sender)
        } else if sender == legacy {
            selectedFilterType = .legacy
            highlight(sender)
        } else if sender == unsold {
            selectedFilterType = .unsold
            highlight(sender)
        }
//        applyFilters()
        pageNumber = 1

        currentPage = 1

        getEOI()
    }
    
    func highlight(_ button: UIButton) {
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = UIColor.systemGray6
    }
    
    private func hideProceedButton() {
        proceedBtnHeight?.constant = 0
        proceedBtn?.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    @IBAction func notificationAction() {
        //        let comingSoonAlert = UIAlertController(
        //            title: "Coming soon",
        //            message: "Work is in progress",
        //            preferredStyle: .alert
        //        )
        //        self.present(comingSoonAlert, animated: true, completion: nil)
        //        comingSoonAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
        //        }))
        
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let SchemeListVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(SchemeListVC, animated: true)
    }
    
    @IBAction func eoiOptionTapped(_ sender: UIButton) {
        if sender == isOfflineEOIYES {
            isOfflineYesEnable.toggle()
            isOfflineNoEnable = false
        } else if sender == isOfflineEOINO {
            isOfflineNoEnable.toggle()
            isOfflineYesEnable = false
        }
        
        [isOfflineEOIYES, isOfflineEOINO].forEach { btn in
            btn?.backgroundColor = .white
            btn?.setTitleColor(.black, for: .normal)
        }
        
        if isOfflineYesEnable {
            isOfflineEOIYES?.backgroundColor = UIColor(hex: "223B30")
            isOfflineEOIYES?.setTitleColor(.white, for: .normal)
        }
        if isOfflineNoEnable {
            isOfflineEOINO?.backgroundColor = UIColor(hex: "223B30")
            isOfflineEOINO?.setTitleColor(.white, for: .normal)
        }
        
        checkProceedEligibility()
    }
    
    @IBAction func applicantTypeForFilterTapped(_ sender: UIButton) {
        
    }
        
    @IBAction func applicantTypeTapped(_ sender: UIButton) {
        if sender == applicantTypeIndividual {
            isIndividualEnable.toggle()
            isCompanyEnable = false
            isPartnershipEnable = false
            isProprietorshipEnable = false
        } else if sender == applicantTypeCompany {
            isCompanyEnable.toggle()
            isIndividualEnable = false
            isPartnershipEnable = false
            isProprietorshipEnable = false
        } else if sender == applicantTypePartnership {
            isPartnershipEnable.toggle()
            isIndividualEnable = false
            isCompanyEnable = false
            isProprietorshipEnable = false
        } else if sender == applicantTypeProprietorship {
            isProprietorshipEnable.toggle()
            isIndividualEnable = false
            isCompanyEnable = false
            isPartnershipEnable = false
        }
        
        [applicantTypeIndividual, applicantTypeCompany, applicantTypePartnership, applicantTypeProprietorship].forEach { btn in
            btn?.backgroundColor = .white
            btn?.setTitleColor(.black, for: .normal)
        }
        
        if isIndividualEnable {
            Defaults.type = "Individual"
            applicantTypeIndividual?.backgroundColor = UIColor(hex: "223B30")
            applicantTypeIndividual?.setTitleColor(.white, for: .normal)
        }
        if isCompanyEnable { applicantTypeCompany?.backgroundColor = UIColor(hex: "223B30")
            Defaults.type = "Company"
            applicantTypeCompany?.setTitleColor(.white, for: .normal)
        }
        if isPartnershipEnable { applicantTypePartnership?.backgroundColor = UIColor(hex: "223B30")
            Defaults.type = "Partnership"
            applicantTypePartnership?.setTitleColor(.white, for: .normal)
        }
        if isProprietorshipEnable { applicantTypeProprietorship?.backgroundColor = UIColor(hex: "223B30")
            Defaults.type = "Proprietorship"
            applicantTypeProprietorship?.setTitleColor(.white, for: .normal)
        }
        checkProceedEligibility()
    }
    
    func checkProceedEligibility() {
        let isEOISelected = isOfflineYesEnable || isOfflineNoEnable
        let isApplicantTypeSelected = isIndividualEnable || isCompanyEnable || isPartnershipEnable || isProprietorshipEnable
        
        if isEOISelected && isApplicantTypeSelected {
            showProceedButton()
        } else {
            hideProceedButton()
        }
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
    
    @IBAction func proccedBtnAction() {
        hideAddNewEOIView()
        if isIndividualEnable {
            Defaults.isIndividualEnable = isIndividualEnable
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
            let SchemeListVC = storyboard.instantiateViewController(withIdentifier: "PersonalEOIScreenVC") as! PersonalEOIScreenVC
            self.navigationController?.pushViewController(SchemeListVC, animated: true)
        } else {
            let storyboardBundle = Bundle.main
            let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
            let SchemeListVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailsEOIScreenVC") as! CompanyDetailsEOIScreenVC
            self.navigationController?.pushViewController(SchemeListVC, animated: true)
        }
    }
    
    @IBAction func addNewBtnAction() {
        guard let addNewEOIView = addNewEOIView,
              let window = UIApplication.shared.keyWindow else { return }
        
        if addNewEOIView.superview == nil {
            window.addSubview(addNewEOIView)
            addNewEOIView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addNewEOIView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                addNewEOIView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                addNewEOIView.topAnchor.constraint(equalTo: window.topAnchor),
                addNewEOIView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
            ])
        }
        
        // Reset before showing
        addNewEOIView.alpha = 0
        addNewEOIView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        addNewEOIView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        UIView.animate(withDuration: 0.3) {
            addNewEOIView.alpha = 1
            addNewEOIView.transform = .identity
        }
    }
    
    @IBAction func closeAddNewEOIView(_ sender: UIButton) {
        hideAddNewEOIView()
    }
    
    @objc func hideAddNewEOIView() {
        addNewEOIView?.removeFromSuperview()
    }
    

    @IBAction func filterACtionAction() {
        filtersConstraintsActivated = false
        guard let addNewEOIView = filtersView,
              let window = UIApplication.shared.keyWindow else { return }

        if addNewEOIView.superview == nil {
            window.addSubview(addNewEOIView)
            addNewEOIView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addNewEOIView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                addNewEOIView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                addNewEOIView.topAnchor.constraint(equalTo: window.topAnchor),
                addNewEOIView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
            ])
        }

        // Reset before showing
        addNewEOIView.alpha = 0
        addNewEOIView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        addNewEOIView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        UIView.animate(withDuration: 0.3) {
            addNewEOIView.alpha = 1
            addNewEOIView.transform = .identity
        }
    }

    @IBAction func closeFilterView(_ sender: UIButton) {
        hideFilterView()
    }

    @objc func hideFilterView() {
        filtersView?.removeFromSuperview()
    }
    
    @IBAction func addFiltersBtnTapped(_ sender: UIButton) {
//        self.applyFilters()
        hideFilterView()
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        pageNumber = 1
        getEOI()
    }
    
    @IBAction func clearFilters() {
        [
            todayBtn,
            digitalBtn,
            directSalesBtn,
            LaunchEventBtn,
            legacy,
            unsold,
            recentlyViewedBtn
        ].forEach {

            $0?.setTitleColor(.black, for: .normal)
        }
        
        currentSearchText = ""
        searchVw?.text = ""
        
        filteredRecord = EOIModelData
        
//        currentPage = 1
//        
//        setupPaginationButtons()
//        tbleview?.reloadData()
        selectedFilterType = .none

        pageNumber = 1

        currentPage = 1

        getEOI()
    }

//    func applyFilters() {
//
//        var baseList = EOIModelData
//
//        switch selectedFilterType {
//
//        case .today:
//            let calendar = Calendar.current
//            let formatter = ISO8601DateFormatter()
//
//            baseList = baseList.filter {
//                guard let dateStr = $0.createdDate,
//                      let date = formatter.date(from: dateStr) else { return false }
//                return calendar.isDateInToday(date)
//            }
//
//        case .digital:
//            baseList = baseList.filter { ($0.recordTypeName ?? "").lowercased() == "digital" }
//
//        case .directSales:
//            baseList = baseList.filter { ($0.recordTypeName ?? "").lowercased() == "direct_sales" }
//
//        case .launchEvent:
//            baseList = baseList.filter { ($0.recordTypeName ?? "").lowercased() == "eoi" }
//
//        case .legacy:
//            baseList = baseList.filter { ($0.recordTypeName ?? "").lowercased() == "legacy" }
//
//        case .unsold:
//            baseList = baseList.filter { ($0.recordTypeName ?? "").lowercased() == "unsold" }
//        case .none:
//            break
//        }
//
//        // search still applies
//        if !currentSearchText.isEmpty {
//            let search = currentSearchText.lowercased()
//
//            baseList = baseList.filter {
//                ($0.name?.lowercased().contains(search) ?? false) ||
//                ($0.project?.name?.lowercased().contains(search) ?? false) ||
//                ($0.createdBy?.name?.lowercased().contains(search) ?? false) ||
//                ($0.approvalStatus?.lowercased().contains(search) ?? false)
//            }
//        }
//
//        filteredRecord = baseList
//        currentPage = 1
//
//        setupPaginationButtons()
//        updateUIAfterDataChange()
//    }
    
//    func updateUIAfterDataChange() {
//        DispatchQueue.main.async {
//            let isEmpty = self.filteredRecord.isEmpty
//            
//            self.noDataFoundVw?.isHidden = !isEmpty
//            self.tbleview?.isHidden = isEmpty
//            
//            self.tbleview?.reloadData()
//        }
//    }
    
    func updateUIAfterDataChange() {
        DispatchQueue.main.async {

            if self.filteredRecord.isEmpty {
                self.showEmptyState(.noResults)
            } else {
                self.hideEmptyState()
            }

            self.tbleview?.reloadData()
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        if let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "SideBarVC") as? SideBarVC {
//            presentFromLeft80Percent(sideMenuVC)
//        } else {
//            print("❌ Could not instantiate SideBarVC from Home.storyboard")
//        }
        
        Utility.gotoTabbar()
    }
}

extension EOIVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 50 {
            if !isLoading {
                pageNumber += 1
                isLoading = true
                spinner.startAnimating()
                getEOI()
            }
        }
    }
}

extension EOIVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.eoiListLbl?.text = "EOI Applications List \(filteredRecord.count)"
        return filteredRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: EOICell = tableView.dequeueReusableCell(withIdentifier: "EOICell", for: indexPath) as! EOICell
        let EOIDict = filteredRecord[indexPath.row]
        cell.opportunityName?.text = (EOIDict.name?.isEmpty == false) ? EOIDict.name : "-"
        cell.OppId?.text = (EOIDict.opportunityId?.isEmpty == false) ? EOIDict.opportunityId : "-"
        cell.OppId?.textColor = ColorConstant.primaryRedishColor
        cell.priorityNumber?.text = (EOIDict.priorityNumber?.isEmpty == false) ? EOIDict.priorityNumber : "-"
        cell.projectLbl?.text = (EOIDict.project?.name?.isEmpty == false) ? EOIDict.project?.name : "-"
        cell.agentnameLbl?.text = EOIDict.channelPartnerAgentName ?? "-"
        cell.stageLbl?.text = EOIDict.stage ?? "-"
        cell.approvalStatusLbl?.text = (EOIDict.createdBy?.name?.isEmpty == false) ? EOIDict.createdBy?.name : "-"
//        if let status = EOIDict.approvalStatus?.lowercased() {
//            
//            switch status {
//                
//            case "approved":
//                cell.approvalStatusLbl?.textColor = ColorConstant.primaryRedishColor
//                
//            case "rejected":
//                cell.approvalStatusLbl?.textColor = .systemRed
//                
//            case "pending":
//                cell.approvalStatusLbl?.textColor = .systemOrange
//                
//            default:
//                cell.approvalStatusLbl?.textColor = .label
//            }
//        } else {
//            cell.approvalStatusLbl?.textColor = .label
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 234
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let EOIDict = filteredRecord[indexPath.row]
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let detailsListVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        detailsListVC.EOiModelDict = EOIDict
        detailsListVC.EOIID = EOIDict.id ?? EMPTY
        self.navigationController?.pushViewController(detailsListVC, animated: true)
    }
}

class EOICell: UITableViewCell {
    @IBOutlet var vw: UIView?
    @IBOutlet var opportunityName: UILabel?
    @IBOutlet var OppId: UILabel?
    @IBOutlet var priorityNumber: UILabel?
    @IBOutlet var projectLbl: UILabel?
    @IBOutlet var agentnameLbl: UILabel?
    @IBOutlet var stageLbl: UILabel?
    @IBOutlet var approvalStatusLbl: UILabel?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
    }
}

//extension EOIVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            currentSearchText = searchText
//            applyCombinedFilters()
//        }
//
//        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            searchBar.resignFirstResponder()
//        }
//    
//    func applyCombinedFilters() {
//        var baseList = EOIModelData
//
//        if !currentSearchText.isEmpty {
//            let lowercasedSearch = currentSearchText.lowercased()
//
//            baseList = baseList.filter {
//                ($0.name?.lowercased().contains(lowercasedSearch) ?? false) ||
//                ($0.project?.name?.lowercased().contains(lowercasedSearch) ?? false) ||
//                ($0.createdBy?.name?.lowercased().contains(lowercasedSearch) ?? false) ||
//                ($0.approvalStatus?.lowercased().contains(lowercasedSearch) ?? false)
//            }
//        }
//
//        filteredRecord = baseList
//
//        currentPage = 1
//
//        setupPaginationButtons()
//
//        tbleview?.reloadData()
//
//        noDataFoundVw?.isHidden = !filteredRecord.isEmpty
//        tbleview?.isHidden = filteredRecord.isEmpty
//    }
//}

extension EOIVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchText = searchText
        applyCombinedFilters()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func applyCombinedFilters() {

        let searchText = currentSearchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        // When search is empty, reset the table to the original list
        guard !searchText.isEmpty else {
            filteredRecord = EOIModelData
            currentPage = 1
            hideEmptyState()
            tbleview?.reloadData()
            return
        }

        // Apply search
        filteredRecord = EOIModelData.filter { eoi in

            (eoi.name?.lowercased().contains(searchText) ?? false) ||

            (eoi.opportunityId?.lowercased().contains(searchText) ?? false) ||

            (eoi.priorityNumber?.lowercased().contains(searchText) ?? false) ||

            (eoi.project?.name?.lowercased().contains(searchText) ?? false) ||

            (eoi.channelPartnerAgentName?.lowercased().contains(searchText) ?? false) ||

            (eoi.stage?.lowercased().contains(searchText) ?? false) ||

            (eoi.createdBy?.name?.lowercased().contains(searchText) ?? false) ||

            (eoi.approvalStatus?.lowercased().contains(searchText) ?? false)
        }

        currentPage = 1

        updateUIAfterDataChange()

        // Remove this if pagination UI is no longer being used
        setupPaginationButtons()
    }
}









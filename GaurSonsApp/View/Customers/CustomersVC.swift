//
//  CustomersVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 15/10/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class CustomersVC: UIViewController {
    @IBOutlet var tbleview: UITableView?
    @IBOutlet var tbleViewHeader: UIView?
    @IBOutlet var noDataFoundVw: UIView?
    @IBOutlet var noDataFoundImg: UIImageView?
    @IBOutlet var noDataFoundLblHead: UILabel?
    @IBOutlet var noDataFoundLblText: UILabel?
    @IBOutlet var customerListLbl: UILabel?
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
    @IBOutlet var allBtn: UIButton?
    @IBOutlet var eoiConvertedBtn: UIButton?
    @IBOutlet var eoiNotConvertedBtn: UIButton?
    @IBOutlet var recentlyViewedBtn: UIButton?
    @IBOutlet var thisMonthsBtn: UIButton?
    @IBOutlet var todayBtn: UIButton?
    @IBOutlet var addFiltersBtn: UIButton?
    var createdDateDatePicker = UIDatePicker()
    
    var isEOISelected: Bool = false
    var isApplicantTypeSelected: Bool = false
    var selectedButtons: Set<Int> = []
    var customerModelData = [CustomerModel]()
    var filteredRecord = [CustomerModel]()
    var currentSearchText: String = ""
    var projectList: [ProjectModel] = []
    var eOIWebServices = EOIWebServices()
    var projectNameDropdown = DropDown()
    var agentNameDropdown = DropDown()
    var pageNumber = 1
    var isLoading = false
    let spinner = UIActivityIndicatorView(style: .medium)
    var selectedFilter: FilterType = .all
    var summaryFilter: CustomerSummaryFilter?
    var selectedButton: UIButton?
    var isServerFilterApplied = false
    private var isFilteredListActive = false

    private var activeSOQLFilter: String?

    private let customerFields = """
    Id,
    Name,
    Email__c,
    Mobile__c,
    Masked_Data__c,
    Converted_to_EOI__c,
    Project__r.Id,
    Project__r.Name,
    Project__r.Channel_Partner_Visible__c,
    Project__r.EOI_Declaration__c,
    Owner.Id,
    Owner.Name,
    RecordTypeId,
    Broker_Type__c,
    Verification_Type__c,
    Aadhaar_Name__c,
    Aadhaar_Ending__c,
    Gender__c,
    Date_Of_Birth__c,
    Care_Of__c,
    House__c,
    Landmark__c,
    Street__c,
    VTC__c,
    District__c,
    Subdist__c,
    Pincode__c,
    Post_Office__c,
    Country__c,
    State__c,
    Complete_Address__c,
    Declaration__c,
    Status__c,
    CreatedDate,
    CreatedBy.Id,
    CreatedBy.Name
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("@@@@\(summaryFilter)")
        setUpUI()
        getCustomer()
    }
    
    func getCustomer() {

        guard InternetConnectionManager.isConnectedToNetwork() else {
            isLoading = false
            spinner.stopAnimating()
            showEmptyState(.noInternet)
            return
        }

        guard !isLoading else { return }
        guard !isFilteredListActive else { return }

        isLoading = true

        if pageNumber == 1 {
            hideEmptyState()
        }

        let requestedPage = pageNumber

        let filterToUse: CustomerSummaryFilter? =
            isServerFilterApplied ? nil : summaryFilter

        Utility.getAllCustomerRecords(
            pageNumber: requestedPage,
            summaryFilter: filterToUse
        ) { [weak self] success in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.isLoading = false
                self.spinner.stopAnimating()

                guard success else {

                    if self.pageNumber == requestedPage,
                       requestedPage > 1 {
                        self.pageNumber -= 1
                    }

                    if self.customerModelData.isEmpty {
                        self.showEmptyState(.noResults)
                    }

                    return
                }

                // Utility accumulates all pages in GlobalData.allCustomerModel.
                var seenIDs = Set<String>()

                self.customerModelData =
                    GlobalData.allCustomerModel.filter { customer in

                        guard let id = customer.id else {
                            return true
                        }

                        return seenIDs.insert(id).inserted
                    }

                self.applyCombinedFilters()
            }
        }
    }
    
//    func getCustomer() {
//        guard InternetConnectionManager.isConnectedToNetwork() else {
//            isLoading = false
//            spinner.stopAnimating()
//            showEmptyState(.noInternet)
//            return
//        }
//
//        guard !isLoading else { return }
//        guard !isFilteredListActive else { return }
//
//        // Set loading state only here
//        isLoading = true
//
//        if pageNumber == 1 {
//            hideEmptyState()
//        }
//
//        let requestedPage = pageNumber
//
//        let filterToUse: CustomerSummaryFilter? =
//            isServerFilterApplied ? nil : summaryFilter
//
//        print("Requesting customer page:", requestedPage)
//
//        Utility.getAllCustomerRecords(
//            pageNumber: requestedPage,
//            summaryFilter: filterToUse
//        ) { [weak self] success in
//
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//
//                self.isLoading = false
//                self.spinner.stopAnimating()
//
//                guard success else {
//
//                    if self.pageNumber == requestedPage,
//                       requestedPage > 1 {
//                        self.pageNumber -= 1
//                    }
//
//                    if self.customerModelData.isEmpty {
//                        self.showEmptyState(.noResults)
//                    }
//
//                    return
//                }
//
//                let fetchedCustomers = GlobalData.allCustomerModel
//
//                if requestedPage == 1 {
//                    self.customerModelData.removeAll()
//                }
//
//                var existingIDs = Set(
//                    self.customerModelData.compactMap { $0.id }
//                )
//
//                for customer in fetchedCustomers {
//
//                    guard let customerID = customer.id else {
//                        self.customerModelData.append(customer)
//                        continue
//                    }
//
//                    if existingIDs.insert(customerID).inserted {
//                        self.customerModelData.append(customer)
//                    }
//                }
//
//                print("Requested page:", requestedPage)
//                print("Records returned:", fetchedCustomers.count)
//                print("Unique customers:", self.customerModelData.count)
//
//                self.applyCombinedFilters()
//            }
//        }
//    }
        
//    func getFilteredCustomers(soql: String) {
//
//        if !InternetConnectionManager.isConnectedToNetwork() {
//            showEmptyState(.noInternet)
//            return
//        }
//
//        hideEmptyState()
//
//        Utility.getAllCustomerRecords(
//            pageNumber: 1,
//            soqlFilter: soql
//        ) { success in
//
//            DispatchQueue.main.async {
//
//                self.isLoading = false
//                self.spinner.stopAnimating()
//
//                guard success else {
//                    self.showEmptyState(.noResults)
//                    return
//                }
//
//                self.customerModelData = GlobalData.allCustomerModel
//                self.filteredRecord = GlobalData.allCustomerModel
//
//                if self.filteredRecord.isEmpty {
//                    self.showEmptyState(.noResults)
//                } else {
//                    self.hideEmptyState()
//                    self.tbleview?.reloadData()
//                }
//            }
//        }
//    }
    
    func getFilteredCustomers(soql: String) {

        guard InternetConnectionManager.isConnectedToNetwork() else {
            showEmptyState(.noInternet)
            return
        }

        // Cancel the previous pagination state.
        pageNumber = 1
        isLoading = true

        activeSOQLFilter = soql
        isFilteredListActive = true
        isServerFilterApplied = true

        hideEmptyState()
        spinner.startAnimating()

        Utility.getAllCustomerRecords(
            pageNumber: 1,
            soqlFilter: soql
        ) { [weak self] success in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.isLoading = false
                self.spinner.stopAnimating()

                guard success else {
                    self.customerModelData.removeAll()
                    self.filteredRecord.removeAll()
                    self.showEmptyState(.noResults)
                    return
                }

                // The filtered request starts a new list.
                self.customerModelData = GlobalData.allCustomerModel

                // Deduplicate the filtered result by Salesforce ID.
                var seenIDs = Set<String>()

                self.customerModelData = self.customerModelData.filter { customer in

                    guard let id = customer.id else {
                        return true
                    }

                    return seenIDs.insert(id).inserted
                }

                self.applyCombinedFilters()
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
        Defaults.isOpportunityIDPresent = false
        Defaults.opportunityId = EMPTY
        OpportunityManager.shared.applicants.removeAll()
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
//    func setUpUI() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//        tbleview?.keyboardDismissMode = .onDrag
//        tbleview?.tableFooterView = createSpinnerFooter()
//        searchVw?.delegate = self
//        noDataFoundVw?.isHidden = true
//        mainVw?.backgroundColor = ColorConstant.screensBackgroundColor
//        addNewBtn?.layer.cornerRadius = 6
//        
//    }
    
    func setUpUI() {

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        tbleview?.delegate = self
        tbleview?.dataSource = self
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
    }
    
    private func showProceedButton() {
        proceedBtnHeight?.constant = 45
        proceedBtn?.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideProceedButton() {
        proceedBtnHeight?.constant = 0
        proceedBtn?.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    @IBAction func filterACtionAction() {
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
        filtersView?.removeFromSuperview()
    }
    
//    @IBAction func refreshAction(_ sender: UIButton) {
//        pageNumber = 1
//        if !InternetConnectionManager.isConnectedToNetwork() {
//            
//            showEmptyState(.noInternet)
//            
//            return
//            
//        }
//        getCustomer()
//    }
    
    @IBAction func refreshAction(_ sender: UIButton) {

        // Reset pagination and loading state.
        pageNumber = 1
        isLoading = false

        // Reset all active filters.
        selectedFilter = .all
        isServerFilterApplied = false
        isFilteredListActive = false
        activeSOQLFilter = nil
        summaryFilter = nil

        // Clear the search text.
        currentSearchText = ""
        searchVw?.text = ""

        // Select the All button.
        if let allButton = allBtn {
            updateButtonSelection(allButton, filter: .all)
        }

        // Clear the previous results.
        customerModelData.removeAll()
        filteredRecord.removeAll()
        GlobalData.allCustomerModel.removeAll()

        tbleview?.reloadData()
        hideEmptyState()

        guard InternetConnectionManager.isConnectedToNetwork() else {
            showEmptyState(.noInternet)
            return
        }

        // Reload all customers from page 1.
        getCustomer()
    }
    
//    @IBAction func allBtnTapped(_ sender: UIButton) {
//        updateButtonSelection(sender, filter: .all)
//        pageNumber = 1
//        isServerFilterApplied = false
//
//        getCustomer()
//    }
    
    @IBAction func allBtnTapped(_ sender: UIButton) {

        updateButtonSelection(sender, filter: .all)

        pageNumber = 1

        isServerFilterApplied = false
        isFilteredListActive = false

        activeSOQLFilter = nil

        customerModelData.removeAll()
        filteredRecord.removeAll()

        getCustomer()
    }
    
    @IBAction func eoiConvertedTapped(_ sender: UIButton) {
        let query = """

            SELECT \(customerFields)

            FROM Customer__c

            WHERE Converted_to_EOI__c = true

            ORDER BY CreatedDate DESC


            """
        
        updateButtonSelection(sender, filter: .eoiConverted)
        
        getFilteredCustomers(soql: query)
    }
    
    @IBAction func eoiNotConvertedTapped(_ sender: UIButton) {
        let query = """

            SELECT \(customerFields)

            FROM Customer__c

            WHERE Converted_to_EOI__c = false

            ORDER BY CreatedDate DESC


            """
        
        updateButtonSelection(sender, filter: .eoiNotConverted)
        
        getFilteredCustomers(soql: query)
    }
    
    @IBAction func recentlyViewedTapped(_ sender: UIButton) {
        let query = """
            
            SELECT Id FROM RecentlyViewed WHERE Type = 'Customer__c' ORDER BY LastViewedDate DESC
            
            """
        
        updateButtonSelection(sender, filter: .recentlyViewed)
        
        getFilteredCustomers(soql: query)
    }
    
    @IBAction func thisMonthTapped(_ sender: UIButton) {
        let query = """

            SELECT \(customerFields)

            FROM Customer__c

            WHERE CreatedDate = THIS_MONTH

            ORDER BY CreatedDate DESC


            """
        
        updateButtonSelection(sender, filter: .thisMonth)
        
        getFilteredCustomers(soql: query)
    }
    
    @IBAction func todayTapped(_ sender: UIButton) {
        let query = """

            SELECT \(customerFields)

            FROM Customer__c

            WHERE CreatedDate = TODAY

            ORDER BY CreatedDate DESC


            """
        
        updateButtonSelection(sender, filter: .today)
        
        getFilteredCustomers(soql: query)
    }
    
    func applyFilters() {
        
        let baseList = customerModelData
        
        switch selectedFilter {
            
        case .all:
            filteredRecord = baseList
            
        case .eoiConverted:
            filteredRecord = baseList.filter { $0.convertedToEOI == true }
            
        case .eoiNotConverted:
            filteredRecord = baseList.filter { $0.convertedToEOI == false }
            
        case .recentlyViewed:
            filteredRecord = baseList
            
        case .thisMonth:
            filteredRecord = baseList.filter {
                guard let dateStr = $0.createdDate,
                      let date = convertToDate(dateStr) else { return false }
                
                return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
            }
            
        case .today:
            filteredRecord = baseList.filter {
                guard let dateStr = $0.createdDate,
                      let date = convertToDate(dateStr) else { return false }
                
                return Calendar.current.isDateInToday(date)
            }
        }
        
        self.updateUIAfterFilter()
    }
    
    
    func updateUIAfterFilter() {
        DispatchQueue.main.async {

            if self.filteredRecord.isEmpty {
                self.showEmptyState(.noResults)
            } else {
                self.hideEmptyState()
                self.tbleview?.reloadData()
            }
        }
    }
    
    func updateButtonSelection(_ button: UIButton, filter: FilterType) {
        
        let buttons = [allBtn, eoiConvertedBtn, eoiNotConvertedBtn, recentlyViewedBtn, thisMonthsBtn, todayBtn]
        
        buttons.forEach {
            $0?.setTitleColor(UIColor(hex: "#223B30"), for: .normal)
        }
        
        button.setTitleColor(UIColor(hex: "#8CC540"), for: .normal)
        
        selectedFilter = filter
    }
    
    
    func convertToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
    
    
    @IBAction func notificationAction() {
        
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let SchemeListVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(SchemeListVC, animated: true)
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
    
    @IBAction func addNewBtnAction() {
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
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        //        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        //        if let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "SideBarVC") as? SideBarVC {
        //            presentFromLeft80Percent(sideMenuVC)
        //        } else {
        //            showAlert(with: "Error", message: "❌ Could not instantiate SideBarVC from Home.storyboard")
        //        }
        Utility.gotoTabbar()
    }
    
    func fetchCustomers(soql: String? = nil) {
        
        Utility.getAllCustomerRecords(
            pageNumber: pageNumber,
            soqlFilter: soql
        ) { success in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                self.spinner.stopAnimating()
                
                guard success else {
                    self.customerModelData.removeAll()
                    self.filteredRecord.removeAll()
                    self.updateUIAfterFilter()
                    return
                }
                
                self.customerModelData = GlobalData.allCustomerModel
                self.filteredRecord = self.customerModelData
                self.updateUIAfterFilter()
            }
        }
    }
}

//extension CustomersVC: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let frameHeight = scrollView.frame.size.height
//        
//        if offsetY > contentHeight - frameHeight - 50 {
//            if !isLoading {
//                pageNumber += 1
//                isLoading = true
//                spinner.startAnimating()
//                getCustomer()
//            }
//        }
//    }
//}

extension CustomersVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // Only handle customer table scrolling
        guard scrollView == tbleview else { return }

        // Don't paginate while a custom filtered list is active
        guard !isFilteredListActive else { return }

        // Prevent multiple requests at the same time
        guard !isLoading else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height

        // Make sure the table content is taller than its visible area
        guard contentHeight > frameHeight else { return }

        // Start loading before reaching the very bottom
        if offsetY > contentHeight - frameHeight - 100 {

            pageNumber += 1

            print("Loading customer page:", pageNumber)

            // Do NOT set isLoading = true here.
            // getCustomer() sets it internally.
            spinner.startAnimating()
            getCustomer()
        }
    }
}

extension CustomersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.customerListLbl?.text = "Customers List \(filteredRecord.count)"
        return filteredRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomersCell = tableView.dequeueReusableCell(withIdentifier: "CustomersCell", for: indexPath) as! CustomersCell
        let EOIDict = filteredRecord[indexPath.row]
        cell.customersNameLbl?.text = EOIDict.name
        cell.mobileLbl?.text = EOIDict.mobile
        cell.emailLbl?.text = EOIDict.email
        cell.projectLbl?.text = EOIDict.project?.name
        cell.agentNameLbl?.text = EOIDict.createdBy?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let EOIDict = filteredRecord[indexPath.row]
//        let storyboardBundle = Bundle.main
//        let storyboard = UIStoryboard(name: "Customers", bundle: storyboardBundle)
//        let detailsListVC = storyboard.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
//        detailsListVC.cuatomerDetailsDict = EOIDict
//        print(EOIDict.id)
//        self.navigationController?.pushViewController(detailsListVC, animated: true)
//        
        let EOIDict = filteredRecord[indexPath.row]
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "EOI", bundle: storyboardBundle)
        let detailsListVC = storyboard.instantiateViewController(withIdentifier: "miscellaneousEOIScreenVC") as! miscellaneousEOIScreenVC
        detailsListVC.cuatomerDetailsDict = EOIDict
        print(EOIDict.id)
        self.navigationController?.pushViewController(detailsListVC, animated: true)
        
        
    }
}

class CustomersCell: UITableViewCell {
    @IBOutlet var vw: UIView?
    @IBOutlet var customersNameLbl: UILabel?
    @IBOutlet var mobileLbl: UILabel?
    @IBOutlet var emailLbl: UILabel?
    @IBOutlet var projectLbl: UILabel?
    @IBOutlet var agentNameLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
    }
}

extension CustomersVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchText = searchText
                    applyCombinedFilters()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
//    func applyCombinedFilters() {
//
//        let searchText = currentSearchText
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//            .lowercased()
//
//        // When search is empty, reset the table to the original data
//        guard !searchText.isEmpty else {
//            filteredRecord = customerModelData
//            hideEmptyState()
//            tbleview?.reloadData()
//            return
//        }
//
//        // Apply search
//        filteredRecord = customerModelData.filter {
//            ($0.name?.lowercased().contains(searchText) ?? false) ||
//            ($0.mobile?.lowercased().contains(searchText) ?? false) ||
//            ($0.email?.lowercased().contains(searchText) ?? false) ||
//            ($0.project?.name?.lowercased().contains(searchText) ?? false) ||
//            ($0.createdBy?.name?.lowercased().contains(searchText) ?? false)
//        }
//
//        if filteredRecord.isEmpty {
//            showEmptyState(.noResults)
//        } else {
//            hideEmptyState()
//            tbleview?.reloadData()
//        }
//    }
    
    func applyCombinedFilters() {

        var results = customerModelData

        // Apply the selected local filter.
        switch selectedFilter {

        case .all:
            break

        case .eoiConverted:
            results = results.filter {
                $0.convertedToEOI == true
            }

        case .eoiNotConverted:
            results = results.filter {
                $0.convertedToEOI == false
            }

        case .recentlyViewed:
            // Recently Viewed should come from its own server query.
            break

        case .thisMonth:
            results = results.filter {

                guard let dateString = $0.createdDate,
                      let date = convertToDate(dateString) else {
                    return false
                }

                return Calendar.current.isDate(
                    date,
                    equalTo: Date(),
                    toGranularity: .month
                )
            }

        case .today:
            results = results.filter {

                guard let dateString = $0.createdDate,
                      let date = convertToDate(dateString) else {
                    return false
                }

                return Calendar.current.isDateInToday(date)
            }
        }

        // Apply search on top of the selected filter.
        let searchText = currentSearchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if !searchText.isEmpty {

            results = results.filter {

                ($0.name?.lowercased().contains(searchText) ?? false) ||
                ($0.mobile?.lowercased().contains(searchText) ?? false) ||
                ($0.email?.lowercased().contains(searchText) ?? false) ||
                ($0.project?.name?.lowercased().contains(searchText) ?? false) ||
                ($0.createdBy?.name?.lowercased().contains(searchText) ?? false)
            }
        }

        filteredRecord = results

        DispatchQueue.main.async {

            if self.filteredRecord.isEmpty {
                self.showEmptyState(.noResults)
            } else {
                self.hideEmptyState()
            }

            self.tbleview?.reloadData()
        }
    }
}
















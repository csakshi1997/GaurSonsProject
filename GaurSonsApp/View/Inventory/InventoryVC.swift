//
//  InventoryVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 13/08/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import DropDown

class InventoryVC: UIViewController {
    @IBOutlet var tbleview: UITableView?
    @IBOutlet var tbleViewHeader: UIView?
    @IBOutlet var noDataFoundVw: UIView?
    @IBOutlet var noDataFoundImg: UIImageView?
    @IBOutlet var noDataFoundLblHead: UILabel?
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
    @IBOutlet var projectNametxtFld: MDCOutlinedTextField?
    @IBOutlet var projectStatustxtFld: MDCOutlinedTextField?
    @IBOutlet var addFiltersBtn: UIButton?
    var createdDateDatePicker = UIDatePicker()
    
    var isEOISelected: Bool = false
    var isApplicantTypeSelected: Bool = false
    var selectedButtons: Set<Int> = []
    var filteredRecord = [InventoryProjectModel]()
    var currentSearchText: String = ""
    var projectList: [ProjectModel] = []
    var eOIWebServices = EOIWebServices()
    var projectNameDropdown = DropDown()
    var projectStatusDropdown = DropDown()
    var pageNumber = 1
    var isLoading = false
    let spinner = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getProjects()
//        tbleview?.rowHeight = UITableView.automaticDimension
//
//        tbleview?.estimatedRowHeight = 100
    }
    
//    func getProjects() {
//        Utility.getAllInventoryProject { success in
//            if success {
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    self.spinner.stopAnimating()
//                    self.filteredRecord = GlobalData.allInventoryProjects
//                    if self.filteredRecord.count > 0 {
//                        self.noDataFoundVw?.isHidden = true
//                        self.tbleview?.isHidden = false
//                        self.tbleview?.reloadData()
//                    } else {
//                        self.noDataFoundVw?.isHidden = false
//                        self.tbleview?.isHidden = true
//                    }
//                }
//                
//            }
//        }
//    }
    
    func getProjects() {

        guard InternetConnectionManager.isConnectedToNetwork() else {

            isLoading = false
            spinner.stopAnimating()

            filteredRecord.removeAll()

            showEmptyState(.noInternet)

            return
        }

        hideEmptyState()

        Utility.getAllInventoryProject { success in

            DispatchQueue.main.async {

                self.isLoading = false
                self.spinner.stopAnimating()

                if success {

                    self.filteredRecord = GlobalData.allInventoryProjects

                    if self.filteredRecord.isEmpty {
                        self.showEmptyState(.noResults)
                    } else {
                        self.hideEmptyState()
                        self.tbleview?.reloadData()
                    }

                } else {

                    self.filteredRecord.removeAll()
                    self.showEmptyState(.noResults)
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
        Defaults.isOpportunityIDPresent = false
        Defaults.opportunityId = EMPTY
        OpportunityManager.shared.applicants.removeAll()
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
        
        projectNametxtFld?.label.text = "Project Name"
        projectNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        projectNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        projectNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        projectNametxtFld?.delegate = self
        projectNametxtFld?.inputView = UIView()
        
        projectStatustxtFld?.label.text = "Project Status"
        projectStatustxtFld?.setOutlineColor(.darkGray, for: .normal)
        projectStatustxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        projectStatustxtFld?.translatesAutoresizingMaskIntoConstraints = false
        projectStatustxtFld?.delegate = self
        projectStatustxtFld?.inputView = UIView()
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
    
    @IBAction func backBtnAction() {
        Utility.gotoTabbar()
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
    
    @IBAction func refreshAction(_ sender: UIButton) {
        pageNumber = 1
        getProjects()
    }
    
//    func applyFilters() {
//        filteredRecord = GlobalData.allCustomerModel
//        
//        if let projectName = projectNametxtFld?.text, !projectName.isEmpty {
//            filteredRecord = filteredRecord.filter { $0.project?.name?.lowercased().contains(projectName.lowercased()) == true }
//        }
//        
////        if let projectName = projectNametxtFld?.text, !projectName.isEmpty {
////            filteredRecord = filteredRecord.filter { $0.project?.name?.lowercased().contains(projectName.lowercased()) == true }
////        }
////
//        if filteredRecord.isEmpty {
//            noDataFoundVw?.isHidden = false
//            tbleview?.isHidden = true
//        } else {
//            noDataFoundVw?.isHidden = true
//            tbleview?.isHidden = false
//            tbleview?.reloadData()
//        }
//    }
    
    
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
        guard let addNewEOIView = filtersView else { return }
        guard let window = UIApplication.shared.keyWindow else { return }

        addNewEOIView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addNewEOIView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(addNewEOIView)
//        setupAddEOIVIew()
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
        guard let addNewEOIView = filtersView else { return }

        UIView.animate(withDuration: 0.3, animations: {
            addNewEOIView.alpha = 0
            addNewEOIView.transform = CGAffineTransform(translationX: 0, y: addNewEOIView.frame.height)
        }, completion: { _ in
            addNewEOIView.removeFromSuperview()
        })
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

extension InventoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InventoryCell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        let EOIDict = filteredRecord[indexPath.row]
        cell.availabilityLbl?.text = "availabkilty"
        cell.projectNameLbl?.text = EOIDict.name
        cell.noOfTowelLbl?.text = "\(EOIDict.totalTowers ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let EOIDict = filteredRecord[indexPath.row]
        let storyboardBundle = Bundle.main
        let storyboard = UIStoryboard(name: "Inventory", bundle: storyboardBundle)
        let detailsListVC = storyboard.instantiateViewController(withIdentifier: "InventroyDetailsVC") as! InventroyDetailsVC
        detailsListVC.inventoryProjectDetailsDict = EOIDict
        detailsListVC.isComingFromEOIDetailScreen = false
        self.navigationController?.pushViewController(detailsListVC, animated: true)
    }
}

class InventoryCell: UITableViewCell {
    @IBOutlet var vw: UIView?
    @IBOutlet var projectNameLbl: UILabel?
    @IBOutlet var availabilityLbl: UILabel?
    @IBOutlet var noOfTowelLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vw?.layer.cornerRadius = 12
        vw?.layer.borderWidth = 0.5
        vw?.layer.borderColor = UIColor(hex: "223B30")?.cgColor
        vw?.layer.masksToBounds = false
        vw?.backgroundColor = .clear
    }
}

extension InventoryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            currentSearchText = searchText
            applyCombinedFilters()
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    
    func applyCombinedFilters() {
        var baseList = GlobalData.allInventoryProjects
        if !currentSearchText.isEmpty {
            let lowercasedSearch = currentSearchText.lowercased()

            baseList = baseList.filter {
                ($0.name?.lowercased().contains(lowercasedSearch) ?? false) ||
                ($0.createdBy?.name?.lowercased().contains(lowercasedSearch) ?? false)
            }
        }

        filteredRecord = baseList
//        tbleview?.reloadData()
//        noDataFoundVw?.isHidden = !filteredRecord.isEmpty
//        tbleview?.isHidden = filteredRecord.isEmpty
        filteredRecord = baseList
        if filteredRecord.isEmpty {
            showEmptyState(.noResults)
        } else {
            hideEmptyState()
        }
        tbleview?.reloadData()
    }
}


extension InventoryVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == projectNametxtFld {
            showProjectNameDropdown()
            return false
        } else if textField == projectStatustxtFld {
            showProjectStatuseDropdown()
            return false
        }
        return true
    }
    
    func showProjectNameDropdown() {
        let projectNames = projectList.map { $0.name ?? "" }
        
        projectNameDropdown.anchorView = projectNametxtFld
        projectNameDropdown.dataSource = projectNames
        
        projectNameDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.projectNametxtFld?.text = item
            let selectedProject = self.projectList[index]
//            selectedProjectName = selectedProject.id ?? EMPTY
            print("Selected Project ID: \(selectedProject.id ?? "")")
        }
        projectNameDropdown.show()
    }
    
    func showProjectStatuseDropdown() {
        let options = FetchPicklistValue.shared.picklistOptionsDict["Channel_Partner_Agent_Name__c"] ?? []
        let accountLabel = options.map { $0.label }
        let accountValue = options.map { $0.value }
        
        print("Channel_Partner_Agent_Name__c Labels: \(accountLabel)")
        print("Channel_Partner_Agent_Name__c: \(accountValue)")
        
        projectStatusDropdown.anchorView = projectStatustxtFld
        projectStatusDropdown.dataSource = accountValue
        
        projectStatusDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard index < accountLabel.count else { return }
            self?.projectNametxtFld?.text = item
        }
        projectStatusDropdown.show()
    }
}
















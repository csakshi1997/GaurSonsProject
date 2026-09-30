//
//  TabbarView.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import UIKit
import SideMenu

class TabbarView: UIViewController {
    @IBOutlet var selectedTabOne: UIImageView?
    @IBOutlet var selectedTabTwo: UIImageView?
    @IBOutlet var selectedTabThree: UIImageView?
    @IBOutlet var selectedTabFour: UIImageView?
    @IBOutlet var selectedSmallTabOne: UIImageView?
    @IBOutlet var selectedSmallTabTwo: UIImageView?
    @IBOutlet var selectedSmallTabThree: UIImageView?
    @IBOutlet var selectedSmallTabFour: UIImageView?
    @IBOutlet var fourBtnViewView: UIView?
    @IBOutlet var bottomView: UIView?
    var homeView: UIViewController?
    var eoi: UIViewController?
    var customers: UIViewController?
    var inventory: UIViewController?
    var customTabBar = CustomTabBar()
    var isFromEOI: Bool = false
    var isFromCustomer: Bool = false
    var eoiSummaryFilter: EOISummaryFilter = .total
    var isEOISummaryFilterApplied: Bool = false
    var customerSummaryFilter: CustomerSummaryFilter?

    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromEOI {
            gotoEOIView()
        } else if isFromCustomer {
            gotoCustomerView()
        } else {
            gotoHomeAction()
        }
        fourBtnViewView?.layer.cornerRadius = 30
        bottomView?.layer.cornerRadius = 30
        selectedTabOne?.layer.cornerRadius = 30
        selectedTabTwo?.layer.cornerRadius = 30
        selectedTabThree?.layer.cornerRadius = 30
        selectedTabFour?.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
        
//    func gotoEOIView() {
//        removeAllChildViews()
//        selectedTabThree?.isHidden = false
//        selectedSmallTabThree?.isHidden = true
//        let storyBoard : UIStoryboard = UIStoryboard(name: "EOI", bundle:nil)
//        eoi = storyBoard.instantiateViewController(withIdentifier: "EOIVC") as? EOIVC ?? EOIVC()
//        self.add(eoi ?? EOIVC(), frame: self.view.bounds)
//        self.view.bringSubviewToFront(bottomView ?? UIView())
//    }
    
    func gotoEOIView() {
        removeAllChildViews()

        selectedTabThree?.isHidden = false
        selectedSmallTabThree?.isHidden = true

        let storyBoard = UIStoryboard(name: "EOI", bundle: nil)

        guard let eoiVC = storyBoard.instantiateViewController(
            withIdentifier: "EOIVC"
        ) as? EOIVC else {
            return
        }

        // Pass selected summary filter
        eoiVC.summaryFilter = eoiSummaryFilter

        eoi = eoiVC

        self.add(eoiVC, frame: self.view.bounds)

        self.view.bringSubviewToFront(bottomView ?? UIView())
        eoiSummaryFilter = .total
    }
    
    func gotoInventoryView() {
        removeAllChildViews()
        selectedTabFour?.isHidden = false
        selectedSmallTabFour?.isHidden = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Inventory", bundle:nil)
        inventory = storyBoard.instantiateViewController(withIdentifier: "InventoryVC") as? InventoryVC ?? InventoryVC()
        self.add(inventory ?? InventoryVC(), frame: self.view.bounds)
        self.view.bringSubviewToFront(bottomView ?? UIView())
    }
    
    func resetEOISummaryFilter() {

        eoiSummaryFilter = .total

    }
    
    func resetCustomersSummaryFilter() {

        customerSummaryFilter = .booked

    }
    
//    func gotoCustomerView() {
//        removeAllChildViews()
//        selectedTabTwo?.isHidden = false
//        selectedSmallTabTwo?.isHidden = true
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Customers", bundle:nil)
//        customers = storyBoard.instantiateViewController(withIdentifier: "CustomersVC") as? CustomersVC ?? CustomersVC()
//        self.add(customers ?? CustomersVC(), frame: self.view.bounds)
//        self.view.bringSubviewToFront(bottomView ?? UIView())
//    }
    
    func gotoCustomerView() {
        removeAllChildViews()

        selectedTabTwo?.isHidden = false
        selectedSmallTabTwo?.isHidden = true

        let storyBoard = UIStoryboard(
            name: "Customers",
            bundle: nil
        )

        guard let customersVC = storyBoard.instantiateViewController(
            withIdentifier: "CustomersVC"
        ) as? CustomersVC else {
            return
        }

        customersVC.summaryFilter = customerSummaryFilter

        customers = customersVC

        self.add(
            customersVC,
            frame: self.view.bounds
        )

        self.view.bringSubviewToFront(
            bottomView ?? UIView()
        )
    }
        
    @IBAction func gotoHomeAction() {
        removeAllChildViews()
        selectedTabOne?.isHidden = false
        selectedSmallTabOne?.isHidden = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        homeView = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC ?? HomeVC()
        self.add(homeView ?? HomeVC(), frame: self.view.bounds)
        self.view.bringSubviewToFront(bottomView ?? UIView())
    }
    
    func removeAllChildViews() {
        selectedTabOne?.isHidden = true
        selectedTabTwo?.isHidden = true
        selectedTabThree?.isHidden = true
        selectedTabFour?.isHidden = true
        selectedSmallTabOne?.isHidden = false
        selectedSmallTabTwo?.isHidden = false
        selectedSmallTabThree?.isHidden = false
        selectedSmallTabFour?.isHidden = false
        homeView?.remove()
        eoi?.remove()
        customers?.remove()
        inventory?.remove()
    }
    
    @IBAction func tabSelection(button: UIButton?) {
        if button?.tag ?? 0 == 0 {
            gotoHomeAction()
        } else if button?.tag ?? 0 == 1 {
            gotoCustomerView()
        } else if button?.tag ?? 0 == 2 {
            gotoEOIView()
        } else if button?.tag ?? 0 == 3 {
            gotoInventoryView()
        }
    }
}



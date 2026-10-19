//
//  PropertyDetailVc.swift
//  GaurSonsApp
//
//  Created by Sakshi on 26/05/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit

class PropertyDetailVc: UIViewController {
    
    @IBOutlet var crossBtn: UIButton?
    @IBOutlet var topLbl: UILabel?
    @IBOutlet var UnitView: UIView?
    @IBOutlet var unitInventoryNameLbl: UILabel?
    @IBOutlet var unitBookingDateTimeLbl: UILabel?
    @IBOutlet var ECPAareaLbl: UILabel?
    @IBOutlet var carpetAreaLbl: UILabel?
    @IBOutlet var saleableAreaLbl: UILabel?
    @IBOutlet var basementAreaLbl: UILabel?
    @IBOutlet var builtupAreaLbl: UILabel?
    @IBOutlet var roofAreaLbl: UILabel?
    var propertyModel = PropertyModel(dict: [:])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let dimView = UIView(frame: view.bounds)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(dimView, at: 0)
        setUpUI()
    }
    

    func setUpUI() {
        topLbl?.text = propertyModel.unitNumber
        unitInventoryNameLbl?.text = propertyModel.unitNumber
        unitBookingDateTimeLbl?.text = propertyModel.bookingDate
        ECPAareaLbl?.text = propertyModel.ecpaArea != nil ? "\(propertyModel.ecpaArea!)" : "-"
        carpetAreaLbl?.text = propertyModel.carpetArea != nil ? "\(propertyModel.carpetArea!)" : "-"
        saleableAreaLbl?.text = propertyModel.sellableArea != nil ? "\(propertyModel.sellableArea!)" : "-"
        basementAreaLbl?.text = propertyModel.basementArea != nil ? "\(propertyModel.basementArea!)" : "-"
        builtupAreaLbl?.text = propertyModel.builtupArea != nil ? "\(propertyModel.builtupArea!)" : "-"
        roofAreaLbl?.text = propertyModel.roofArea != nil ? "\(propertyModel.roofArea!)" : "-"
    }
    
    @IBAction func crossAction() {
        self.dismiss(animated: true)
    }

}

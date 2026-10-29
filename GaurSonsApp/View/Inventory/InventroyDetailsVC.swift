//
//  InventroyDetailsVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 26/03/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import DropDown

class InventroyDetailsVC: UIViewController {
    
    @IBOutlet var projectnameLbl: UILabel?
    @IBOutlet var townBlocktxtFld: MDCOutlinedTextField?
    @IBOutlet var floortxtFld: MDCOutlinedTextField?
    @IBOutlet var UnitsView: UIView?
    @IBOutlet var availableView: UIView?
    @IBOutlet var blockedView: UIView?
    @IBOutlet var totalUnitView: UIView?
    @IBOutlet var totalUnitLbl: UILabel?
    @IBOutlet var availableColorView: UIView?
    @IBOutlet var availableLbl: UILabel?
    @IBOutlet var blockedLbl: UILabel?
    @IBOutlet var blockedColorView: UIView?
    var inventoryProjectDetailsDict: InventoryProjectModel?
    var floorDropdown = DropDown()
    var selectedFloorId: String = EMPTY
    var towerDropdown = DropDown()
    var selectedTowerId: String = EMPTY
    var towerList: [InventoryProjectModel.Tower] = []
    var floorList: [InventoryProjectModel.Floor] = []
    var isComingFromEOIDetailScreen: Bool = false
    var selectedProjectId: String?
    var oppId: String = EMPTY
    var onUnitBlocked: ((String) -> Void)?
    var EOiModelDict = EOIModel(dict: [:])
    var isFromDetails: Bool = false
    var isUnitAlreadyBlocked: Bool = false
    
    private struct UnitSection {
        let id: String
        let towerName: String
        let floorName: String
        let units: [InventoryProjectModel]
    }
    
    private var unitSections: [UnitSection] = []
    private var floorCollectionView: UICollectionView?
    private var emptyStateLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInituialUI()
        setUpFloorCollectionView()
        
        resolveProjectAndLoad()
        LocationWebService().getRecordTypeForUnsold(type: "Unsold") { _, data, _ in
            let id = (data?["records"] as? [[String: Any]])?.first?["Id"] as? String
            Defaults.unsoldRecordTypeId = id
        }
    }
        
    func setUpFloorCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        layout.itemSize = CGSize(width: 80, height: 44)
        layout.headerReferenceSize = CGSize(width: 1, height: 32)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UnitPillCell.self,
                                forCellWithReuseIdentifier: UnitPillCell.reuseId)
        
        collectionView.register(FloorHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: FloorHeaderView.reuseId)
        
        view.addSubview(collectionView)
        floorCollectionView = collectionView
        
        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "Please select tower or floor"
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        
        view.addSubview(emptyLabel)
        emptyStateLabel = emptyLabel
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: UnitsView?.bottomAnchor ?? view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    
    private func resolveProjectAndLoad() {
        
        if let project = inventoryProjectDetailsDict {
            selectedProjectId = project.id
        }
        
        guard let projectId = selectedProjectId, !projectId.isEmpty else {
            Utility.showAlert(message: "Project not found")
            return
        }
        
        callProjectDetailsAPI(projectId: projectId)
    }
    
    func callProjectDetailsAPI(projectId: String) {
        
        Utility.getAllProjectDetails(projectId: projectId) { [weak self] success in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                if success {
                    
                    let data = GlobalData.allInventoryProjects
                    
                    if data.isEmpty {
                        Utility.showAlert(message: "No inventory data found")
                        return
                    }
                    
                    
                    self.prepareTowers()
                    self.prepareFloors()
                    self.updateUI()
                    self.updateUnitsVisibility()
                    self.rebuildFloorSections()
                    
                } else {
                    Utility.showAlert(message: "Failed to load inventory")
                }
            }
        }
    }
        
    func updateUI() {
        let data = GlobalData.allInventoryProjects

        let total = data.count

        let available = data.filter {
            let status = $0.unitStatus?.lowercased() ?? ""
            return status == "available" || status == "released"
        }.count

        let blocked = data.filter {
            $0.unitStatus?.lowercased() == "hold"
        }.count

        totalUnitLbl?.text = "\(total)"
        availableLbl?.text = "\(available)"
        blockedLbl?.text = "\(blocked)"
    }
    
    private func updateUnitCounts(for data: [InventoryProjectModel]) {

        let total = data.count

        let available = data.filter {

            let status = $0.unitStatus?.lowercased() ?? ""

            return status == "available" || status == "released"

        }.count

        let blocked = data.filter {

            let status = $0.unitStatus?.lowercased() ?? ""

            return status == "hold"

        }.count

        totalUnitLbl?.text = "\(total)"

        availableLbl?.text = "\(available)"

        blockedLbl?.text = "\(blocked)"

    }
    
    func prepareTowers() {
        
        let towers = GlobalData.allInventoryProjects.compactMap { $0.tower }
        
        let unique = Dictionary(grouping: towers, by: { $0.id ?? "" })
            .compactMap { $0.value.first }
        
        towerList = unique.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
    
    func prepareFloors() {

        var data = GlobalData.allInventoryProjects

        // If tower is selected, only show floors of that tower
        if !selectedTowerId.isEmpty {
            data = data.filter {
                $0.tower?.id == selectedTowerId
            }
        }

        let floors = data.compactMap { $0.floor }

        var uniqueFloors: [InventoryProjectModel.Floor] = []
        var addedFloorIds = Set<String>()

        for floor in floors {

            let floorId = floor.id ?? ""

            guard !floorId.isEmpty else {
                continue
            }

            if !addedFloorIds.contains(floorId) {
                addedFloorIds.insert(floorId)
                uniqueFloors.append(floor)
            }
        }

        floorList = uniqueFloors.sorted { floor1, floor2 in

            let name1 = floor1.name?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let name2 = floor2.name?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let number1 = extractFloorNumber(from: name1)
            let number2 = extractFloorNumber(from: name2)

            if let number1, let number2 {
                return number1 < number2
            }

            if number1 != nil && number2 == nil {
                return true
            }

            if number1 == nil && number2 != nil {
                return false
            }

            return name1.localizedStandardCompare(name2) == .orderedAscending
        }
    }
    
    private func extractFloorNumber(from name: String) -> Int? {

        let pattern = #"(-?\d+)"#

        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(
                in: name,
                range: NSRange(name.startIndex..., in: name)
              ),
              let range = Range(match.range, in: name) else {
            return nil
        }

        return Int(name[range])
    }
    
    private func floorKey(for item: InventoryProjectModel) -> String {
        return item.floor?.id ?? item.floor?.name ?? item.floorNumber ?? "Unknown Floor"
    }

    
    func rebuildFloorSections() {

        let data = GlobalData.allInventoryProjects

        var filteredData = data

        // Tower filter
        if !selectedTowerId.isEmpty {
            filteredData = filteredData.filter {
                $0.tower?.id == selectedTowerId
            }
        }

        // Floor filter
        if !selectedFloorId.isEmpty {
            filteredData = filteredData.filter {
                $0.floor?.id == selectedFloorId
            }
        }

        // Remove units which don't have BOTH Tower and Floor
        filteredData = filteredData.filter { unit in
            guard let towerId = unit.tower?.id,
                  !towerId.isEmpty,
                  let towerName = unit.tower?.name,
                  !towerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  let floorId = unit.floor?.id,
                  !floorId.isEmpty,
                  let floorName = unit.floor?.name,
                  !floorName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else {
                return false
            }

            return true
        }

        updateUnitCounts(for: filteredData)

        guard !filteredData.isEmpty else {
            unitSections = []
            updateUnitsVisibility()
            floorCollectionView?.reloadData()
            return
        }

        // Group by Tower + Floor
        let grouped = Dictionary(grouping: filteredData) { item in

            let towerId = item.tower!.id!
            let floorId = item.floor!.id!

            return "\(towerId)_\(floorId)"
        }

        unitSections = grouped.map { key, items in

            let towerName = items.first?.tower?.name?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let floorName = items.first?.floor?.name?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            return UnitSection(
                id: key,
                towerName: towerName,
                floorName: floorName,
                units: items.sorted {
                    ($0.unitNumber ?? "").localizedStandardCompare(
                        $1.unitNumber ?? ""
                    ) == .orderedAscending
                }
            )
        }
        .sorted { first, second in

            let firstFloor =
                extractFloorNumber(from: first.floorName) ?? Int.max

            let secondFloor =
                extractFloorNumber(from: second.floorName) ?? Int.max

            if firstFloor != secondFloor {
                return firstFloor < secondFloor
            }

            return first.towerName.localizedStandardCompare(
                second.towerName
            ) == .orderedAscending
        }

        updateUnitsVisibility()
        floorCollectionView?.reloadData()
    }
    
    private func updateUnitsVisibility() {

        let shouldShow = !unitSections.isEmpty

        floorCollectionView?.isHidden = !shouldShow
        emptyStateLabel?.isHidden = shouldShow

        if shouldShow {
            emptyStateLabel?.text = ""
        } else {
            emptyStateLabel?.text = "No units available for selected Tower/Floor"
        }
    }
    
    // MARK: - INIT UI
    func setUpInituialUI() {
        if isFromDetails ?? false {
            projectnameLbl?.text = EOiModelDict.project?.name
        } else {
            projectnameLbl?.text = inventoryProjectDetailsDict?.name
        }
       
        
        UnitsView?.layer.cornerRadius = 8
        UnitsView?.clipsToBounds = true
        
        totalUnitView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        townBlocktxtFld?.label.text = "Tower/Block/Street"
        floortxtFld?.label.text = "Floor"
    }
    
    // MARK: - BACK
    @IBAction func backBtnAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension InventroyDetailsVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == townBlocktxtFld {
            showTowerBlockNameDropdown()
            return false
        } else if textField == floortxtFld {
            showFloorDropdown()
            return false
        }
        return true
    }
    
    func showTowerBlockNameDropdown() {
        
        view.endEditing(true)

        if towerList.isEmpty {
            Utility.showAlert(message: "No Towers available")
            return
        }

        let towerNames = towerList.map { $0.name ?? "" }

        towerDropdown.anchorView = townBlocktxtFld
        towerDropdown.dataSource = towerNames

        towerDropdown.direction = .bottom
        towerDropdown.bottomOffset = CGPoint(x: 0, y: townBlocktxtFld?.bounds.height ?? 0)
        towerDropdown.width = townBlocktxtFld?.frame.width ?? 200
        towerDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }

            let selectedTower = self.towerList[index]

            self.townBlocktxtFld?.text = selectedTower.name
            self.selectedTowerId = selectedTower.id ?? ""

            self.prepareFloors()

            self.rebuildFloorSections()
        }

        towerDropdown.show()
    }
        
    func showFloorDropdown() {
        
        view.endEditing(true)

        if floorList.isEmpty {
            Utility.showAlert(message: "No Floors available")
            return
        }

        let floorNames = floorList.map { $0.name ?? "" }

        floorDropdown.anchorView = floortxtFld
        floorDropdown.dataSource = floorNames

        floorDropdown.direction = .bottom
        floorDropdown.bottomOffset = CGPoint(x: 0, y: floortxtFld?.bounds.height ?? 0)
        floorDropdown.width = floortxtFld?.frame.width ?? 200

        floorDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }

            let selectedFloor = self.floorList[index]

            self.floortxtFld?.text = selectedFloor.name
//            self.selectedFloorId = selectedFloor.name ?? selectedFloor.id ?? ""
            self.selectedFloorId = selectedFloor.id ?? ""
            self.rebuildFloorSections()
        }

        floorDropdown.show()
    }
}

extension InventroyDetailsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return unitSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unitSections[section].units.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnitPillCell.reuseId, for: indexPath) as! UnitPillCell
        let unit = unitSections[indexPath.section].units[indexPath.item]
        let title = unit.unitNumber ?? unit.name ?? "-"
        let isBlocked = (unit.unitStatus ?? "").caseInsensitiveCompare("Hold") == .orderedSame
        cell.configure(title: title, isBlocked: isBlocked)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: FloorHeaderView.reuseId,
                                                                     for: indexPath) as! FloorHeaderView
//        let section = unitSections[indexPath.section]
//        let floorName = section.name
//
//        let towerName = section.units.first?.tower?.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//
//        if towerName.isEmpty {
//            header.titleLabel.text = "\(floorName) -"
//        } else {
//            header.titleLabel.text = "\(floorName) - \(towerName)"
//        }
        
        let section = unitSections[indexPath.section]

        header.titleLabel.text = "\(section.towerName): \(section.floorName)"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = min(96, (collectionView.bounds.width - 36) / 3)
        return CGSize(width: width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let selectedUnit = unitSections[indexPath.section].units[indexPath.item]

        let detailsVC = InventoryUnitDetailsBottomSheetVC()

        detailsVC.unitDetails = selectedUnit
        detailsVC.modalPresentationStyle = .overFullScreen
        detailsVC.modalTransitionStyle = .crossDissolve
        detailsVC.isComingFromEOI = isComingFromEOIDetailScreen
        detailsVC.oppId = oppId
        detailsVC.isUnitAlreadyBlocked = isUnitAlreadyBlocked
        
        detailsVC.onUnitBlocked = { [weak self] unitId in
            guard let self = self else { return }

            // Mark that one unit has already been blocked for this EOI.
            self.isUnitAlreadyBlocked = true

            if let index = GlobalData.allInventoryProjects.firstIndex(where: {
                $0.id == unitId
            }) {
                GlobalData.allInventoryProjects[index].unitStatus = "Hold"
            }

            self.updateUI()
            self.rebuildFloorSections()
            self.floorCollectionView?.reloadData()

            self.onUnitBlocked?(unitId)
        }

        present(detailsVC, animated: false)
    }
}

final class UnitPillCell: UICollectionViewCell {
    static let reuseId = "UnitPillCell"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, isBlocked: Bool) {
        titleLabel.text = title
        contentView.backgroundColor = isBlocked ? UIColor(hex: "0B71FA") : UIColor(hex: "8CC540")
    }
}

final class FloorHeaderView: UICollectionReusableView {
    static let reuseId = "FloorHeaderView"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "223B30") ?? .black
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class InventoryUnitDetailsBottomSheetVC: UIViewController {
    var unitDetails: InventoryProjectModel?
    
    private let dimView = UIView()
    private let sheetView = UIView()
    private let grabberView = UIView()
    private let titleLabel = UILabel()
    private let cardView = UIView()
    private let stackView = UIStackView()
    private let closeButton = UIButton(type: .system)
    private var bottomConstraint: NSLayoutConstraint?
    private let cancelButton = UIButton(type: .system)
    private let blockButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    var isComingFromEOI: Bool = false
    var projectWebServices = ProjectWebServices()
    var oppId: String = EMPTY
    var onUnitBlocked: ((String) -> Void)?
    var isUnitAlreadyBlocked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSheet()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        dimView.alpha = 0
        view.addSubview(dimView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        dimView.addGestureRecognizer(tapGesture)
        
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.backgroundColor = UIColor(hex: "F4F3F3") ?? UIColor(white: 0.96, alpha: 1)
        sheetView.layer.cornerRadius = 24
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.clipsToBounds = true
        view.addSubview(sheetView)
        
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        grabberView.backgroundColor = UIColor(hex: "223B30")?.withAlphaComponent(0.7) ?? .darkGray
        grabberView.layer.cornerRadius = 2
        sheetView.addSubview(grabberView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Unit Inventory Details"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "223B30") ?? .black
        titleLabel.textAlignment = .center
        sheetView.addSubview(titleLabel)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(hex: "E5E5E5")?.cgColor
        sheetView.addSubview(cardView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        cardView.addSubview(stackView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        sheetView.addSubview(buttonStackView)

        // Cancel Button
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        cancelButton.backgroundColor = UIColor(hex: "FF144F")
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)

        // Block Button
        blockButton.translatesAutoresizingMaskIntoConstraints = false
        blockButton.setTitle("Block Unit", for: .normal)
        blockButton.setTitleColor(.white, for: .normal)
        blockButton.backgroundColor = UIColor(hex: "0B71FA")
        blockButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        blockButton.layer.cornerRadius = 8
        blockButton.addTarget(self, action: #selector(blockButtonTapped), for: .touchUpInside)

        buttonStackView.addArrangedSubview(cancelButton)
//        let unitStatus = unitDetails?.unitStatus?.lowercased() ?? ""
//
//        if unitStatus == "available" || unitStatus == "released" {
//            buttonStackView.addArrangedSubview(blockButton)
//        }
        
//        let status = unitDetails?.unitStatus?.lowercased() ?? ""
//
//        let isAvailableUnit =
//            status == "available" || status == "released"
//
//        if isComingFromEOI && isAvailableUnit {
//            buttonStackView.addArrangedSubview(blockButton)
//        }
        
        let status = unitDetails?.unitStatus?.lowercased() ?? ""

        let isAvailableUnit =
            status == "available" || status == "released"

        if isComingFromEOI && isAvailableUnit {
            buttonStackView.addArrangedSubview(blockButton)

            // Disable blocking if a unit is already blocked for this EOI.
            blockButton.isEnabled = !isUnitAlreadyBlocked
            blockButton.alpha = isUnitAlreadyBlocked ? 0.5 : 1.0
        }
        
        bottomConstraint = sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 420)
        
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint!,
            
            grabberView.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 8),
            grabberView.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 36),
            grabberView.heightAnchor.constraint(equalToConstant: 4),
            
            titleLabel.topAnchor.constraint(equalTo: grabberView.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20),
            
            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            cardView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),
            
            buttonStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14)
        ])
    }
    
    private func showErrorAndDismiss(_ message: String) {

        let presentingVC = self.presentingViewController

        self.dismiss(animated: false) { [weak presentingVC] in

            guard let presentingVC = presentingVC else {
                return
            }

            Helper.showTopError(
                message,
                in: presentingVC.view
            )
        }
    }
    
    private func populateData() {
        let unitName = [
            unitDetails?.unitNumber,
            unitDetails?.unitType
        ]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " | ")
        
        let status = (unitDetails?.unitStatus ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let rows: [(String, String)] = [
            ("Unit (Number | Type)", unitName.isEmpty ? "NA" : unitName),
            ("Property Type", displayValue(unitDetails?.propertyType)),
            ("Unit Status", status),
            ("Unit Typology", displayValue(unitDetails?.unitTypology)),
            ("Facing", displayValue(unitDetails?.facing)),
            ("Build-up Area", formattedArea(unitDetails?.sellableArea)),
            ("Unit of Measurement", displayValue(unitDetails?.unitOfMeasurement))
        ]
        
        rows.forEach { title, value in
            
            let valueColor: UIColor
            
            if title == "Unit Status" {
                
                if status.caseInsensitiveCompare("Hold") == .orderedSame {
                    valueColor = UIColor(hex: "0B71FA") ?? .blue
                } else if status.caseInsensitiveCompare("Available") == .orderedSame {
                    valueColor = UIColor(hex: "8CC540") ?? .green
                } else {
                    valueColor = UIColor(hex: "223B30") ?? .black
                }
                
            } else {
                valueColor = UIColor(hex: "223B30") ?? .black
            }
            
            let displayStatus: String
            
            if title == "Unit Status" {
                if status.caseInsensitiveCompare("Hold") == .orderedSame {
                    displayStatus = "Blocked"
                } else if status.caseInsensitiveCompare("Available") == .orderedSame {
                    displayStatus = "Available"
                } else {
                    displayStatus = value
                }
            } else {
                displayStatus = value
            }
            
            stackView.addArrangedSubview(
                makeRow(
                    title: title,
                    value: displayStatus,
                    valueColor: valueColor
                )
            )
        }
    }
    
    private func makeRow(title: String,
                         value: String,
                         valueColor: UIColor = UIColor(hex: "223B30") ?? .black) -> UIView {
        
        let rowView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = UIColor(hex: "223B30") ?? .darkText
        titleLabel.text = title
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        valueLabel.textColor = valueColor
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 0
        valueLabel.text = value
        
        rowView.addSubview(titleLabel)
        rowView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: rowView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: rowView.topAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),
            valueLabel.widthAnchor.constraint(lessThanOrEqualTo: rowView.widthAnchor, multiplier: 0.52)
        ])
        
        return rowView
    }
    
    @objc private func blockButtonTapped() {

        let alert = UIAlertController(
            title: "Confirm",
            message: "Are you sure you want to block this unit?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Block", style: .destructive) { [weak self] _ in
            self?.performBlockUnit()
        })

        present(alert, animated: true)
    }
        
    private func performBlockUnit() {
        
        guard blockButton.isEnabled else { return }
        
        blockButton.isEnabled = false
        blockButton.alpha = 0.5

        guard let unitId = unitDetails?.id,
              !oppId.isEmpty else {
            
            Utility.showAlert(message: "Required data missing")
            return
        }
        
        let opportunityId = oppId
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        let currentDateTime = formatter.string(from: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatter.string(from: Date())
        
        
        
        let opportunityBody: [String: Any] = [
            "RecordTypeId": Defaults.unsoldRecordTypeId ?? EMPTY,
            "Stage__c": "Payment Detail",
            "Hold_Counter__c": "1",
            "OwnerId": ownerId,
            "Inventory_Status__c": "Hold",
            "Unit_Hold_Date_Time__c": currentDateTime,
            "Unit__c": unitId
        ]
        
        let unitBody: [String: Any] = [
            "Opportunity__c": opportunityId,
            "Unit_Status__c": "Hold",
            "Unit_Hold_Date__c": currentDate
        ]
        
        print("opportunityBody opportunityBody\(opportunityBody)")
        
        print("unitBody unitBody\(unitBody)")
        
        SwiftLoader.show(animated: true)
        
        SwiftLoader.show(animated: true)
        
        // STEP 1: Hold Unit Inventory
        projectWebServices.updateRecord(
            objectName: "Unit_Inventory__c",
            recordId: unitId,
            body: unitBody
        ) { [weak self] unitSuccess, unitError in
            
            guard let self = self else { return }
            
            guard unitSuccess else {
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.view.makeToast(unitError ?? "Failed to hold Unit Inventory")
                }
                return
            }
            
            
            // STEP 2: Update Opportunity
            self.projectWebServices.updateRecord(
                objectName: "Opportunity__c",
                recordId: opportunityId,
                body: opportunityBody
            ) { [weak self] opportunitySuccess, opportunityError in

                guard let self = self else {
                    print("❌ Self is nil after Opportunity update")
                    return
                }

                print("========== OPPORTUNITY UPDATE RESULT ==========")
                print("Success:", opportunitySuccess)
                print("Error:", opportunityError ?? "nil")
                print("================================================")

                // Opportunity update succeeded.
                if opportunitySuccess {

                    DispatchQueue.main.async {
                        SwiftLoader.hide()

                        self.unitDetails?.unitStatus = "Hold"
                        self.onUnitBlocked?(unitId)

                        self.view.makeToast("Unit blocked successfully")
                        self.dismissSheet()
                    }

                    return
                }

                // STEP 3: Opportunity update failed.
                print("⚠️ Opportunity update failed. Starting rollback...")

                let rollbackBody: [String: Any] = [
                    "Opportunity__c": NSNull(),
                    "Unit_Status__c": "Released",
                    "Unit_Hold_Date__c": NSNull()
                ]

                print("========== ROLLBACK REQUEST ==========")
                print("Object: Unit_Inventory__c")
                print("Record ID:", unitId)
                print("Body:", rollbackBody)
                print("======================================")

                // STEP 4: Roll back Unit Inventory.
                self.projectWebServices.updateRecord(
                    objectName: "Unit_Inventory__c",
                    recordId: unitId,
                    body: rollbackBody
                ) { [weak self] rollbackSuccess, rollbackError in

                    guard let self = self else {
                        print("❌ Self is nil during rollback callback")
                        return
                    }

                    print("========== ROLLBACK RESULT ==========")
                    print("Success:", rollbackSuccess)
                    print("Error:", rollbackError ?? "nil")
                    print("=====================================")

                    DispatchQueue.main.async {

                        SwiftLoader.hide()

                        if rollbackSuccess {

                            self.unitDetails?.unitStatus = "Released"

                            print("✅ Unit Inventory rollback successful")

                        } else {

                            print(
                                "❌ Unit Inventory rollback failed:",
                                rollbackError ?? "Unknown error"
                            )
                        }
                 print("opportunityError opportunityError\(opportunityError)")
                        
                        self.view.makeToast( opportunityError ?? "Failed to update Opportunity")
                    }
                }
            }
            
            // STEP 2: Update Opportunity
//            self.projectWebServices.updateRecord(
//                objectName: "Opportunity__c",
//                recordId: opportunityId,
//                body: opportunityBody
//            ) { [weak self] opportunitySuccess, opportunityError in
//                
//                guard let self = self else { return }
//                
//                // Opportunity update succeeded: blocking completed.
//                if opportunitySuccess {
//                    
//                    DispatchQueue.main.async {
//                        SwiftLoader.hide()
//                        
//                        self.unitDetails?.unitStatus = "Hold"
//                        self.onUnitBlocked?(unitId)
//                        
//                        self.view.makeToast("Unit blocked successfully")
//                        self.dismissSheet()
//                    }
//                    
//                    return
//                }
//                
//                // STEP 3: Opportunity update failed.
//                // STEP 4: Roll back Unit Inventory to Released.
//                let rollbackBody: [String: Any] = [
//                    "Opportunity__c": "",
//                    "Unit_Status__c": "Released",
//                    "Unit_Hold_Date__c": NSNull()
//                ]
//                print("rollbackBody rollbackBody \(rollbackBody)")
//                
//                self.projectWebServices.updateRecord(
//                    objectName: "Unit_Inventory__c",
//                    recordId: unitId,
//                    body: rollbackBody
//                ) { [weak self] rollbackSuccess, rollbackError in
//                    
//                    guard let self = self else { return }
//                    
//                    DispatchQueue.main.async {
//                        
//                        SwiftLoader.hide()
//                        
//                        if rollbackSuccess {
//                            self.unitDetails?.unitStatus = "Released"
//                        } else {
//                            print(
//                                "Unit Inventory rollback failed: " +
//                                (rollbackError ?? "Unknown error")
//                            )
//                        }
//                        
//                        // Display the original Opportunity validation error.
//                        self.showErrorAndDismiss(
//                            opportunityError ??
//                            "Failed to update Opportunity"
//                        )
//                    }
//                }
//            }
        }
    }
        
    private func makeRow(title: String, value: String) -> UIView {
        let rowView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = UIColor(hex: "223B30") ?? .darkText
        titleLabel.text = title
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        valueLabel.textColor = UIColor(hex: "223B30") ?? .black
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 0
        valueLabel.text = value
        
        rowView.addSubview(titleLabel)
        rowView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: rowView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: rowView.topAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),
            valueLabel.widthAnchor.constraint(lessThanOrEqualTo: rowView.widthAnchor, multiplier: 0.52)
        ])
        
        return rowView
    }
    
    private func displayValue(_ value: String?) -> String {
        guard let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "NA"
        }
        return value
    }
    
    private func formattedArea(_ value: Double?) -> String {
        guard let value else { return "NA" }
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }
    
    private func showSheet() {
        view.layoutIfNeeded()
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.28, delay: 0, options: [.curveEaseOut]) {
            self.dimView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissSheet() {
        bottomConstraint?.constant = 420
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseIn]) {
            self.dimView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
}
















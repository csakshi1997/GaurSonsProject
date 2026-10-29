//
//  QR.swift
//  GaurSonsApp
//
//  Created by Sakshi on 16/03/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Photos
import CryptoSwift

class QR: UIViewController {
    @IBOutlet var projectNametxtFld: MDCOutlinedTextField?
    @IBOutlet var projectNametxtFldHeight: NSLayoutConstraint?
    @IBOutlet var projectNameForUnsoldtxtFld: MDCOutlinedTextField?
    @IBOutlet var projectNameForUnsoldtxtFldHeight: NSLayoutConstraint?
    @IBOutlet var nextForUnsoldBtn: UIButton?
    @IBOutlet var downloadQRForUnsoldStack: UIStackView?
    @IBOutlet var backForUnsoldBtn: UIButton?
    @IBOutlet var nextBtn: UIButton?
    @IBOutlet var downloadQRStack: UIStackView?
    @IBOutlet var backBtn: UIButton?
    @IBOutlet var shareLinkSold: UIButton?
    @IBOutlet var checkUnsold: UIButton?
    @IBOutlet var shareLinkUnSold: UIButton?
    @IBOutlet var downloadLinkSold: UIButton?
    @IBOutlet var downloadLinkUnSold: UIButton?
    @IBOutlet weak var qrImageView: UIImageView?
    @IBOutlet weak var searchImg: UIImageView?
    @IBOutlet weak var searchImg2: UIImageView?
    @IBOutlet weak var qrImgHeight: NSLayoutConstraint?
    @IBOutlet var backHeight: NSLayoutConstraint?
    @IBOutlet var downlaodQRStackHeight: NSLayoutConstraint?
    @IBOutlet var nextBtnHeight: NSLayoutConstraint?
    @IBOutlet weak var qrImageForUnsoldView: UIImageView?
    @IBOutlet weak var qrImgForUnsoldHeight: NSLayoutConstraint?
    @IBOutlet var backForUnsoldHeight: NSLayoutConstraint?
    @IBOutlet var downlaodQRStackForUnsoldHeight: NSLayoutConstraint?
    @IBOutlet var nextBtnForUnsoldHeight: NSLayoutConstraint?
    @IBOutlet var unsoldView: UIView?
    @IBOutlet var soldView: UIView?
    @IBOutlet var soldViewHeight: NSLayoutConstraint?
    @IBOutlet var resetBtnUnsold: UIButton?
    @IBOutlet var resetBtnSold: UIButton?
    var projectNameDropdown = DropDown()
    var projectNameForUnsoldDropdown = DropDown()
    var userWebService = UserWebService()
    var projectListSold: [ProjectModelSold] = []
    var projectListUnsold: [ProjectModelUnsold] = []
    var eOIWebServices = EOIWebServices()
    var selectedProjectId: String?
    var selectedAccountEncryptedId: String?
    var selectedProjectIdForUnsold: String?
    var selectedAccountEncryptedIdForUnSold: String?
    var soldQRUrl: String?
    var unsoldQRUrl: String?
    var ischeckUnSold: Bool? = false {
        didSet {
            if ischeckUnSold ?? false {
                checkUnsold?.setImage(UIImage(named: "checkBoxSelected"), for: .normal)
                unsoldView?.isHidden = false
                soldView?.isHidden = true
                soldViewHeight?.constant = 0.0
            } else {
                checkUnsold?.setImage(UIImage(named: "Checkbox"), for: .normal)
                unsoldView?.isHidden = true
                soldView?.isHidden = false
                soldViewHeight?.constant = 416.33
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProjectsSold(searchText: projectNametxtFld?.text ?? EMPTY)
        fetchProjectsunSold(searchText: projectNameForUnsoldtxtFld?.text ?? EMPTY)
        initialUI()
        getUserAccountInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        projectNameDropdown.anchorView = projectNametxtFld
        projectNameDropdown.bottomOffset = CGPoint(
            x: 0,
            y: projectNametxtFld?.bounds.height ?? 0
        )

        projectNameForUnsoldDropdown.anchorView = projectNameForUnsoldtxtFld
        projectNameForUnsoldDropdown.bottomOffset = CGPoint(
            x: 0,
            y: projectNameForUnsoldtxtFld?.bounds.height ?? 0
        )
    }
    
    func getUserAccountInfo() {
        
        userWebService.getLoggedInUserContactId { contactId in
            
            guard let contactId = contactId else {
                print("No Contact Linked")
                return
            }
            
            self.userWebService.getContactDetails(contactId: contactId) { accountId, status in
                
                guard let accountId = accountId else {
                    print("No Account Found")
                    return
                }
                
                if status == "Registered" {
                    print("Valid Account:", accountId)
                    
                    self.selectedAccountEncryptedId = accountId
                    
                } else {
                    print("Invalid Channel Partner Status")
                }
            }
        }
    }
    
    func initialUI() {
        unsoldView?.isHidden = true
        soldView?.isHidden = false
        soldViewHeight?.constant = 416.33
        qrImgHeight?.constant = 0
        downloadQRStack?.isHidden = true
        downlaodQRStackHeight?.constant = 0
        backHeight?.constant = 0
        qrImgForUnsoldHeight?.constant = 0
        downloadQRForUnsoldStack?.isHidden = true
        backForUnsoldBtn?.isHidden = true
        downlaodQRStackForUnsoldHeight?.constant = 0
        backForUnsoldHeight?.constant = 0
        projectNametxtFld?.addTarget(self,
         action: #selector(projectTextChanged(_:)),
         for: .editingChanged)
        projectNametxtFld?.label.text = "Project Name"
        projectNametxtFld?.setOutlineColor(.darkGray, for: .normal)
        projectNametxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        projectNametxtFld?.translatesAutoresizingMaskIntoConstraints = false
        projectNametxtFld?.delegate = self
        projectNameDropdown.anchorView = projectNametxtFld
        projectNameDropdown.direction = .bottom
        projectNameDropdown.bottomOffset = CGPoint(
            x: 0,
            y: projectNametxtFld?.bounds.height ?? 0
        )
        projectNameDropdown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }

            self.projectNametxtFld?.text = item

            let project = self.projectListSold[index]
            self.selectedProjectId = project.id   // Change encryptedId if your model uses another property
            self.projectNametxtFld?.resignFirstResponder()
            self.projectNameDropdown.hide()
        }
        projectNameForUnsoldtxtFld?.label.text = "Project Name"
        projectNameForUnsoldtxtFld?.setOutlineColor(.darkGray, for: .normal)
        projectNameForUnsoldtxtFld?.setOutlineColor(UIColor(hex: "223B30") ?? UIColor(), for: .editing)
        projectNameForUnsoldtxtFld?.translatesAutoresizingMaskIntoConstraints = false
        projectNameForUnsoldtxtFld?.delegate = self
        projectNameForUnsoldDropdown.anchorView = projectNameForUnsoldtxtFld
        projectNameForUnsoldDropdown.direction = .bottom
        projectNameForUnsoldDropdown.bottomOffset = CGPoint(
            x: 0,
            y: projectNameForUnsoldtxtFld?.bounds.height ?? 0
        )
        projectNameForUnsoldDropdown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }

            self.projectNameForUnsoldtxtFld?.text = item

            let project = self.projectListUnsold[index]
            self.selectedProjectIdForUnsold = project.id   // Change encryptedId if needed
            self.projectNameForUnsoldtxtFld?.resignFirstResponder()
            self.projectNameForUnsoldDropdown.hide()
        }
        projectNameForUnsoldtxtFld?.addTarget(self,
          action: #selector(projectUnsoldTextChanged(_:)),
          for: .editingChanged)
        nextBtn?.layer.cornerRadius = 8
        downloadQRStack?.layer.cornerRadius = 8
        shareLinkSold?.borderWidth = 1
        shareLinkSold?.borderColor = UIColor.gray
        shareLinkSold?.layer.cornerRadius = 8
        shareLinkUnSold?.borderWidth = 1
        shareLinkUnSold?.borderColor = UIColor.gray
        shareLinkUnSold?.layer.cornerRadius = 8
        nextForUnsoldBtn?.layer.cornerRadius = 8
        downloadQRForUnsoldStack?.layer.cornerRadius = 8
        backForUnsoldBtn?.borderWidth = 1
        backForUnsoldBtn?.borderColor = UIColor.gray
        backForUnsoldBtn?.layer.cornerRadius = 8
        unsoldView?.borderWidth = 1
        unsoldView?.borderColor = UIColor.gray
        unsoldView?.layer.cornerRadius = 8
        soldView?.borderWidth = 1
        soldView?.borderColor = UIColor.gray
        soldView?.layer.cornerRadius = 8
        downloadLinkSold?.layer.cornerRadius = 8
        downloadLinkUnSold?.layer.cornerRadius = 8
        resetBtnSold?.borderWidth = 1
        resetBtnSold?.borderColor = UIColor.gray
        resetBtnSold?.layer.cornerRadius = 8
        resetBtnUnsold?.borderWidth = 1
        resetBtnUnsold?.borderColor = UIColor.gray
        resetBtnUnsold?.layer.cornerRadius = 8
    }
    
    @objc func projectTextChanged(_ sender: UITextField) {

        let text = sender.text ?? ""

        fetchProjectsSold(searchText: text)

        projectNameDropdown.reloadAllComponents()
        projectNameDropdown.show()
    }
    
    @objc func projectUnsoldTextChanged(_ sender: UITextField) {

        let text = sender.text ?? ""

        fetchProjectsunSold(searchText: text)

        projectNameForUnsoldDropdown.reloadAllComponents()
        projectNameForUnsoldDropdown.show()
    }
    
    func fetchProjectsSold(searchText: String = "") {
        
        let searchKey = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        eOIWebServices.getProjectsSold(searchKey: searchKey) { error, projects, status in
            
            DispatchQueue.main.async {
                
                if status == .success, let projects = projects {
                    
                    self.projectListSold = projects
                    
                    let projectNames = projects.compactMap { $0.name }
                    
                    self.projectNameDropdown.dataSource = projectNames
                    self.projectNameDropdown.reloadAllComponents()
                    
                } else {
                    print(error ?? "Failed to load projects")
                }
            }
        }
    }
    
    func fetchProjectsunSold(searchText: String = "") {
        
        let searchKey = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        eOIWebServices.getProjectsUnSold(searchKey: searchKey) { error, projects, status in
            
            DispatchQueue.main.async {
                
                if status == .success, let projects = projects {
                    
                    self.projectListUnsold = projects
                    
                    let projectNames = projects.compactMap { $0.name }
                    
                    self.projectNameForUnsoldDropdown.dataSource = projectNames
                    self.projectNameForUnsoldDropdown.reloadAllComponents()
                    
                } else {
                    print(error ?? "Failed to load projects")
                }
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        // Add URL encoding for special characters
        guard let data = string.data(using: .utf8) else {
            print("Failed to convert string to data")
            return nil
        }
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            print("Failed to create QR filter")
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        guard let ciImage = filter.outputImage else {
            print("Failed to generate QR image")
            return nil
        }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = ciImage.transformed(by: transform)
        
        let context = CIContext()
        if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    func encryptAES(_ plainText: String) -> String? {

        let key = "1f45b13597bd0c9d770522a6b1bfcb91"

        do {
            let iv = AES.randomIV(AES.blockSize)

            let aes = try AES(
                key: Array(key.utf8),
                blockMode: CBC(iv: iv),
                padding: .pkcs7
            )

            let cipherBytes = try aes.encrypt(Array(plainText.utf8))

            let finalBytes = iv + cipherBytes

            return finalBytes.toHexString()

        } catch {
            print(error)
            return nil
        }
    }
        
    @IBAction func checkIsUnsoldAction() {
        ischeckUnSold = !(ischeckUnSold ?? true)
    }
    
    @IBAction func resetUnsoldAction() {
        projectNameForUnsoldtxtFld?.text = ""
        selectedProjectIdForUnsold = nil
        unsoldQRUrl = nil
        
        qrImageForUnsoldView?.image = nil
        qrImgForUnsoldHeight?.constant = 0
        
        downloadQRForUnsoldStack?.isHidden = true
        downlaodQRStackForUnsoldHeight?.constant = 0
        
        nextBtnForUnsoldHeight?.constant = 36
        projectNameForUnsoldtxtFldHeight?.constant = 56
        
        projectNameForUnsoldtxtFld?.isHidden = false
        searchImg2?.isHidden = false
        
        backForUnsoldBtn?.isHidden = true
    }
    
    @IBAction func resetSoldAction() {
        projectNametxtFld?.text = ""
        selectedProjectId = nil
        soldQRUrl = nil
        
        qrImageView?.image = nil
        qrImgHeight?.constant = 0
        
        downloadQRStack?.isHidden = true
        downlaodQRStackHeight?.constant = 0
        
        nextBtnHeight?.constant = 36
        projectNametxtFldHeight?.constant = 56
        
        projectNametxtFld?.isHidden = false
        searchImg?.isHidden = false
    }
        
    @IBAction func nextButtonTapped(sender: UIButton) {
        let nextBtn = sender.tag
        if nextBtn == 11 {
            if projectNametxtFld?.text?.isEmpty ?? false {
                showAlert(with: "Validation Error", message: "Please Choose the Project First Then you can generate the QR")
                return
            }
            guard let projectId = selectedProjectId,
                  let accountId = selectedAccountEncryptedId else {
                showAlert(with: "Error", message: "Missing Project or Account Info")
                return
            }

            let baseUrl = "https://gaursons.my.site.com/s/newcustomer"
//            let baseUrl = "\(Defaults.instanceUrl ?? EMPTY)/s/newcustomer"

            guard let encryptedProjectId = encryptAES(projectId),
                  let encryptedAccountId = encryptAES(accountId) else {
                showAlert(with: "Error", message: "Failed to encrypt IDs")
                return
            }

            let url = "\(baseUrl)?ref=\(encryptedProjectId)&cp=\(encryptedAccountId)"
            self.soldQRUrl = url

            print("Encrypted Project:", encryptedProjectId)
            print("Encrypted Account:", encryptedAccountId)
            print("URL:", url)
            if let qrImage = generateQRCode(from: url) {
                qrImageView?.image = qrImage
                downloadQRStack?.isHidden = false
//                backBtn?.isHidden = false
                qrImgHeight?.constant = 210
                downlaodQRStackHeight?.constant = 36
                nextBtnHeight?.constant = 0
                projectNametxtFldHeight?.constant = 0
                projectNametxtFld?.isHidden = true
                searchImg?.isHidden = true
            }
        } else if nextBtn == 12 {
            if (projectNameForUnsoldtxtFld?.text?.isEmpty ?? false) {
                showAlert(with: "Validation Error", message: "Please Choose the Project First Then you can generate the QR")
                return
            } else {
                guard let projectId = selectedProjectIdForUnsold,
                      let accountId = selectedAccountEncryptedId else {
                    showAlert(with: "Error", message: "Missing Project or Account Info")
                    return
                }

//                let baseUrl = "https://gaursons--uat.sandbox.my.site.com/s/newcustomer"
                let baseUrl = "https://gaursons.my.site.com/s/newcustomer"

//                let baseUrl = "\(Defaults.instanceUrl ?? EMPTY)/s/newcustomer"
                
                guard let encryptedProjectId = encryptAES(projectId),
                      let encryptedAccountId = encryptAES(accountId) else {
                    showAlert(with: "Error", message: "Failed to encrypt IDs")
                    return
                }

                let url = "\(baseUrl)?ref=\(encryptedProjectId)&cp=\(encryptedAccountId)"
                self.unsoldQRUrl = url

                print("Encrypted Project:", encryptedProjectId)
                print("Encrypted Account:", encryptedAccountId)
                print("URL:", url)
                if let qrImage = generateQRCode(from: url) {
                    qrImageForUnsoldView?.image = qrImage
                    downloadQRForUnsoldStack?.isHidden = false
                    backForUnsoldBtn?.isHidden = false
                    qrImgForUnsoldHeight?.constant = 210
                    downlaodQRStackForUnsoldHeight?.constant = 36
                    nextBtnForUnsoldHeight?.constant = 0
                    projectNameForUnsoldtxtFldHeight?.constant = 0
                    projectNameForUnsoldtxtFld?.isHidden = true
                    searchImg2?.isHidden = true
                }
            }
            
        }
    }

    
    @IBAction func backBtnAction() {
        Utility.gotoTabbar()
    }
    

    func downloadQR(image: UIImage?) {
        guard let image = image else { return }

        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                print("Permission Status:", status.rawValue)

                if status == .authorized || status == .limited {
                    self.saveImage(image)
                } else {
                    self.showPermissionAlert()
                }
            }
        }
    }

    func saveImage(_ image: UIImage) {
        let readStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        let addStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        print("ReadWrite Status:", readStatus.rawValue)
        print("AddOnly Status:", addStatus.rawValue)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    Utility.showAlert(message: "✅ QR Saved Successfully")
                } else {
                    Utility.showAlert(message: "\("Save failed")")
                }
            }
        }
    }
    func showPermissionAlert() {
        showAlert(with: "Permission Required",
                  message: "Please enable Photo access from Settings to save QR")
    }
    
    @IBAction func downloadQRBtnTapped() {
        downloadQR(image: qrImageView?.image)
    }
    
    @IBAction func downloadQRForUnsoldBtnTapped() {
        downloadQR(image: qrImageForUnsoldView?.image)
    }
        
    @IBAction func shareSoldTapped() {
        
        guard let link = soldQRUrl, !link.isEmpty else {
            Utility.showAlert(message: "⚠️ Generate Sold QR first")
            return
        }

        let activityVC = UIActivityViewController(
            activityItems: [link],
            applicationActivities: nil
        )

        // iPad fix
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                        y: self.view.bounds.midY,
                                        width: 0,
                                        height: 0)
            popover.permittedArrowDirections = []
        }

        activityVC.completionWithItemsHandler = { _, completed, _, error in
            
            if let error = error {
                Utility.showAlert(message: "❌ Sharing failed")
                print(error.localizedDescription)
                return
            }

            if completed {
                Utility.showAlert(message: "✅ Link shared successfully")
            }
        }

        present(activityVC, animated: true)
    }
        
    @IBAction func shareUnsoldTapped() {
        
        guard let link = unsoldQRUrl, !link.isEmpty else {
            Utility.showAlert(message: "⚠️ Generate Unsold QR first")
            return
        }

        let activityVC = UIActivityViewController(
            activityItems: [link],
            applicationActivities: nil
        )

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                        y: self.view.bounds.midY,
                                        width: 0,
                                        height: 0)
            popover.permittedArrowDirections = []
        }

        activityVC.completionWithItemsHandler = { _, completed, _, error in
            
            if let error = error {
                Utility.showAlert(message: "❌ Sharing failed")
                return
            }

            if completed {
                Utility.showAlert(message: "✅ Link shared successfully")
            }
        }

        present(activityVC, animated: true)
    }
}

extension QR: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        return true

    }
}
    

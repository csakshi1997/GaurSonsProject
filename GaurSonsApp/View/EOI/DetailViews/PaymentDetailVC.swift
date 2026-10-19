//
//  PaymentDetailVC.swift
//  GaurSonsApp
//
//  Created by Sakshi on 15/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import UIKit
import QuickLook

class PaymentDetailVC: UIViewController, QLPreviewControllerDataSource {
    
    @IBOutlet var crossBtn: UIButton?
    @IBOutlet var topLbl: UILabel?
    //RTGS
    @IBOutlet var RTGSView: UIView?
    @IBOutlet var receiptRTGSLbl: UILabel?
    @IBOutlet var EOIAmountRTGSLbl: UILabel?
    @IBOutlet var paymentModeRTGSLbl: UILabel?
    @IBOutlet var UTSNumberRTGSLbl: UILabel?
    @IBOutlet var drawnBankRTGSLbl: UILabel?
    @IBOutlet var bankAccountNumberRTGSLbl: UILabel?
    @IBOutlet var IFSCCodeRTGSLbl: UILabel?
    @IBOutlet var referenceNumberRTGSLbl: UILabel?
    @IBOutlet var paymentDateRTGSLbl: UILabel?
    @IBOutlet var paymentStatusRTGSLbl: UILabel?
    @IBOutlet var approvalStatusRTGSLbl: UILabel?
    @IBOutlet var notesRTGSLbl: UILabel?
    //Cheque
    @IBOutlet var ChequeView: UIView?
    @IBOutlet var receiptChequeLbl: UILabel?
    @IBOutlet var EOIAmountChequeLbl: UILabel?
    @IBOutlet var paymentModeChequeLbl: UILabel?
    @IBOutlet var DDNumberChequeLbl: UILabel?
    @IBOutlet var DDDateChequeLbl: UILabel?
    @IBOutlet var drawnBankChequeLbl: UILabel?
    @IBOutlet var bankAccountNumberChequeLbl: UILabel?
    @IBOutlet var paymentStatusChequeLbl: UILabel?
    @IBOutlet var approvalStatusChequeLbl: UILabel?
    @IBOutlet var notesChequeLbl: UILabel?
    //UPI
    @IBOutlet var UPIView: UIView?
    @IBOutlet var receiptUPILbl: UILabel?
    @IBOutlet var EOIAmountUPILbl: UILabel?
    @IBOutlet var paymentModeUPILbl: UILabel?
    @IBOutlet var drawnBankUPILbl: UILabel?
    @IBOutlet var UPIIdLbl: UILabel?
    @IBOutlet var referenceNumberUPILbl: UILabel?
    @IBOutlet var paymentDateUPILbl: UILabel?
    @IBOutlet var paymentStatusUPILbl: UILabel?
    @IBOutlet var approvalStatusUPILbl: UILabel?
    @IBOutlet var notesUPILbl: UILabel?
    
    //EaseBuzz
    @IBOutlet var easeBuzzView: UIView?
    @IBOutlet var paymentModeLbl: UILabel?
    @IBOutlet var paymentMethodLbl: UILabel?
    @IBOutlet var EOIAmountEasebuzzLbl: UILabel?
    @IBOutlet var transectionIDLbl: UILabel?
    @IBOutlet var TransactionMessageLbl: UILabel?
    @IBOutlet var referenceNumberEasebuzzLbl: UILabel?
    @IBOutlet var paymentClearingDateUPILbl: UILabel?
    @IBOutlet var paymentStatusEasebuzzLbl: UILabel?
    @IBOutlet var approvalStatusEasebuzzLbl: UILabel?
    @IBOutlet var declarationUPILbl: UILabel?
    //TableView
    @IBOutlet var fileHeaderView: UIView?
    @IBOutlet var tableViewsHeader: UIView?
    @IBOutlet var uploadFilesBtn: UIButton?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var noDataFoundVw: UIView?
    var loaderView: UIActivityIndicatorView?
    var paymentDict = PaymentModel(dict: [:])
    var paymentMode: String = EMPTY
    var fileArray: [FileModel] = []
    var previewItemURL: URL?
    var selectedAttachment: Attachment?
    var isFromApproval: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        tableViewsHeader?.layer.cornerRadius = 8
        loaderView = UIActivityIndicatorView(style: .large)
        loaderView?.color = .gray
        loaderView?.center = view.center
        loaderView?.hidesWhenStopped = true
        if isFromApproval {
            
        } else {
            fetchAllFiles()
        }
    }
    
    func setInitialUI() {
        if isFromApproval {
            topLbl?.text = "Approvals Details"
        } else {
            topLbl?.text = "Payment Details"
        }
        uploadFilesBtn?.layer.cornerRadius = 8
        RTGSView?.isHidden = true
        ChequeView?.isHidden = true
        easeBuzzView?.isHidden = true
        UPIView?.isHidden = true
        if !isFromApproval {
            if paymentMode == "RTGS/NEFT" {
                RTGSView?.isHidden = false
                RTGSView?.borderWidth = 1
                RTGSView?.borderColor = ColorConstant.buttonBorderLightColor
                RTGSView?.layer.cornerRadius = 8
                RTGSUI()
            } else if paymentMode == "NEFT" {
                RTGSView?.isHidden = false
                RTGSView?.borderWidth = 1
                RTGSView?.borderColor = ColorConstant.buttonBorderLightColor
                RTGSView?.layer.cornerRadius = 8
                RTGSUI()
            } else if paymentMode == "RTGS" {
                RTGSView?.isHidden = false
                RTGSView?.borderWidth = 1
                RTGSView?.borderColor = ColorConstant.buttonBorderLightColor
                RTGSView?.layer.cornerRadius = 8
                RTGSUI()
            } else if paymentMode == "Cheque/DD" {
                ChequeView?.isHidden = false
                ChequeView?.borderWidth = 1
                ChequeView?.borderColor = ColorConstant.buttonBorderLightColor
                ChequeView?.layer.cornerRadius = 8
                ChequeUI()
            } else if paymentMode == "DD" {
                ChequeView?.isHidden = false
                ChequeView?.borderWidth = 1
                ChequeView?.borderColor = ColorConstant.buttonBorderLightColor
                ChequeView?.layer.cornerRadius = 8
                ChequeUI()
            } else if paymentMode == "Cheque" {
                ChequeView?.isHidden = false
                ChequeView?.borderWidth = 1
                ChequeView?.borderColor = ColorConstant.buttonBorderLightColor
                ChequeView?.layer.cornerRadius = 8
                ChequeUI()
            } else if paymentMode == "UPI"  {
                UPIView?.isHidden = false
                UPIView?.borderWidth = 1
                UPIView?.borderColor = ColorConstant.buttonBorderLightColor
                UPIView?.layer.cornerRadius = 8
                UPIUI()
                
            } else if paymentMode == "Easebuzz" {
                easeBuzzView?.isHidden = false
                easeBuzzView?.borderWidth = 1
                easeBuzzView?.borderColor = ColorConstant.buttonBorderLightColor
                easeBuzzView?.layer.cornerRadius = 8
                EasebuzzUI()
            }
        }
    }
    
    func RTGSUI() {
        receiptRTGSLbl?.text = paymentDict.name
        let eoiAmountText = paymentDict.eoiAmount ?? 0.0
        EOIAmountRTGSLbl?.text = String(format: "%.2f", eoiAmountText)
        paymentModeRTGSLbl?.text = paymentDict.paymentMode
        UTSNumberRTGSLbl?.text = paymentDict.utrNumber
        drawnBankChequeLbl?.text = paymentDict.drawnBank
        bankAccountNumberChequeLbl?.text = paymentDict.paymentReferenceNumber
        paymentDateRTGSLbl?.text = paymentDict.paymentDate
        paymentStatusRTGSLbl?.text = "-"
        approvalStatusRTGSLbl?.text = "-"
        notesRTGSLbl?.text = paymentDict.notes
    }
    
    func ChequeUI() {
        receiptChequeLbl?.text = paymentDict.name
        let eoiAmountText = paymentDict.eoiAmount ?? 0.0
        EOIAmountChequeLbl?.text = String(format: "%.2f", eoiAmountText)
        paymentModeChequeLbl?.text = paymentDict.paymentMode
        DDNumberChequeLbl?.text = paymentDict.chequeUTRNumber
        DDDateChequeLbl?.text = paymentDict.chequeUTRDate
        drawnBankChequeLbl?.text = paymentDict.drawnBank
        bankAccountNumberChequeLbl?.text = paymentDict.bankAccountNumber
        paymentStatusChequeLbl?.text = "-"
        approvalStatusChequeLbl?.text = "-"
        notesChequeLbl?.text = paymentDict.notes
    }
    
    func EasebuzzUI() {
        let eoiAmountText = paymentDict.eoiAmount ?? 0.0

        EOIAmountEasebuzzLbl?.text = String(format: "%.2f", eoiAmountText)
        paymentModeLbl?.text = Helper.displayValue(paymentDict.paymentMode)

        paymentMethodLbl?.text = Helper.displayValue(paymentDict.paymentMethod)

        transectionIDLbl?.text = Helper.displayValue(paymentDict.transactionId)

        TransactionMessageLbl?.text = Helper.displayValue(paymentDict.transactionalMessage)

        referenceNumberEasebuzzLbl?.text = Helper.displayValue(paymentDict.paymentReferenceNumber)

        paymentClearingDateUPILbl?.text = Helper.displayValue(paymentDict.paymentDateTime)

        paymentStatusEasebuzzLbl?.text = Helper.displayValue(paymentDict.approvalStatus)

        approvalStatusEasebuzzLbl?.text = Helper.displayValue(paymentDict.approvalStatus)

        declarationUPILbl?.text = Helper.displayBoolValue(paymentDict.declaration)
    }
    
    func UPIUI() {
        receiptUPILbl?.text = paymentDict.name
        let eoiAmountText = paymentDict.eoiAmount ?? 0.0
        EOIAmountUPILbl?.text = String(format: "%.2f", eoiAmountText)
        paymentModeUPILbl?.text = paymentDict.paymentMode
        drawnBankChequeLbl?.text = paymentDict.drawnBank
        UPIIdLbl?.text = paymentDict.upiId
        referenceNumberUPILbl?.text = paymentDict.paymentReferenceNumber
        paymentDateUPILbl?.text = paymentDict.paymentDate
        paymentStatusUPILbl?.text = "-"
        approvalStatusUPILbl?.text = "-"
        notesUPILbl?.text = paymentDict.notes
    }
    
    func fetchAllFiles() {
        GlobalData.allContentDocModel.removeAll()
        DispatchQueue.main.async {
            self.loaderView?.startAnimating()
            self.tableView?.isHidden = true
            self.noDataFoundVw?.isHidden = true
        }
        
        Utility.getAllContentDoc(oppId: paymentDict.id ?? EMPTY) { success in
            if success {
                let contentDocs = GlobalData.allContentDocModel
                guard contentDocs.count > 0 else {
                    DispatchQueue.main.async {
                        self.loaderView?.stopAnimating()
                        self.noDataFoundVw?.isHidden = false
                        self.tableView?.isHidden = true
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
                    self.fileHeaderView?.isHidden = false
                    if self.fileArray.count > 0 {
                        self.noDataFoundVw?.isHidden = true
                        self.tableView?.isHidden = false
                        self.tableViewsHeader?.isHidden = false
                        self.tableView?.reloadData()
                    } else {
                        self.tableViewsHeader?.isHidden = true
                        self.noDataFoundVw?.isHidden = false
                        self.tableView?.isHidden = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loaderView?.stopAnimating()
                    self.noDataFoundVw?.isHidden = false
                    self.tableView?.isHidden = true
                }
            }
        }
    }
    
    @IBAction func crossAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadFileAction() {
        showUploadOptions(sourceField: "File")
    }
}

extension PaymentDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
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
            await uploadAttachment(linkedEntityId: paymentDict.id ?? EMPTY)
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
    
    
}

extension PaymentDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < fileArray.count else {
            return UITableViewCell()
        }
        let cell: PaymentDetailsFileCell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailsFileCell", for: indexPath) as! PaymentDetailsFileCell
        let fileDict = self.fileArray[indexPath.row]
        cell.titleLbl?.text = "Attachment \(indexPath.row + 1)"
        cell.sizeLbl?.text = fileDict.fileSize
        cell.onPreviewTapped = { [weak self] in
            self?.previewFile(at: indexPath.row)
        }
        return cell
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
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItemURL == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItemURL! as QLPreviewItem
    }
    
}

class PaymentDetailsFileCell: UITableViewCell {
    @IBOutlet var titleLbl: UILabel?
    @IBOutlet var sizeLbl: UILabel?
    @IBOutlet var previewBtn: UIButton?
    @IBOutlet var deleteBtn: UIButton?
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

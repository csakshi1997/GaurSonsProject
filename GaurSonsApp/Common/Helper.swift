//
//  Helper.swift
//  GaurSonsApp
//
//  Created by Sakshi on 10/08/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class Helper {

    static func valueOrNull(_ value: String?) -> Any {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return NSNull()
        }

        return value
    }

    static func dateOrNull(_ value: String?) -> Any {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return NSNull()
        }

        return value
    }

    static func boolOrNull(_ value: Bool?) -> Any {
        guard let value = value else {
            return NSNull()
        }

        return value
    }

    static func showLoadingDropdown(
        _ dropdown: DropDown,
        anchorView: UIView?,
        message: String = "Loading..."
    ) {
        dropdown.anchorView = anchorView
        dropdown.dataSource = [message]

        dropdown.selectionAction = { _, _ in }

        dropdown.show()
    }

    // MARK: - Timer

    static func showTimer(
        timerHeight: NSLayoutConstraint?,
        timerBtn: UIButton?,
        timerLeftImgBtn: UIButton?,
        timer1Lbl: UILabel?,
        timer2Lbl: UILabel?,
        view: UIView
    ) {
        timerHeight?.constant = 65

        timerBtn?.isHidden = false
        timerLeftImgBtn?.isHidden = false
        timer1Lbl?.isHidden = false
        timer2Lbl?.isHidden = false

        UIView.animate(withDuration: 0.2) {
            view.layoutIfNeeded()
        }
    }

    static func hideTimer(
        timerHeight: NSLayoutConstraint?,
        timerBtn: UIButton?,
        timerLeftImgBtn: UIButton?,
        timer1Lbl: UILabel?,
        timer2Lbl: UILabel?,
        view: UIView
    ) {
        timerHeight?.constant = 0

        timerBtn?.isHidden = true
        timerLeftImgBtn?.isHidden = true
        timer1Lbl?.isHidden = true
        timer2Lbl?.isHidden = true

        UIView.animate(withDuration: 0.2) {
            view.layoutIfNeeded()
        }
    }
    
    static func displayValue(_ value: String?) -> String {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return "-"
        }
        
        return value
    }
    
    static func displayBoolValue(_ value: Bool?) -> String {

        guard let value = value else {

            return "-"

        }

        return value ? "true" : "false"

    }
    
    static var typeDisplayName: String {
        return (Defaults.type ?? EMPTY).replacingOccurrences(of: "_", with: " ")
    }
    

    static func maskMobile(_ mobile: String?) -> String {
        guard let mobile = mobile?.trimmingCharacters(in: .whitespacesAndNewlines),
              !mobile.isEmpty else {
            return "-"
        }
        
        // Keep only digits
        let digits = mobile.filter { $0.isNumber }
        
        guard digits.count >= 4 else {
            return "-"
        }
        
        let lastFour = String(digits.suffix(4))
        return "******\(lastFour)"
    }

    static func maskEmail(_ email: String?) -> String {
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let atIndex = email.firstIndex(of: "@") else {
            return "-"
        }

        let username = String(email[..<atIndex])
        let domain = String(email[email.index(after: atIndex)...])

        guard !username.isEmpty, !domain.isEmpty else {
            return "-"
        }

        let firstCharacter = String(username.prefix(1))

        return "\(firstCharacter)******@\(domain)"
    }
    
    static func showTopError(
        _ message: String,
        in view: UIView
    ) {
        DispatchQueue.main.async {
            view.makeToast(
                message,
                duration: 4.0,
                position: .top
            )
        }
    }

}

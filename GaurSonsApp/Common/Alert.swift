//
//  Alert.swift
//  GaurSonsApp
//

import UIKit
import Toast_Swift

class Alert {

    static func showValidationAlert(message: String, on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Validation Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }

    static func showArrayValidationAlert(on viewController: UIViewController, messages: [String]) {

        let alert = UIAlertController(
            title: "Validation Error",
            message: messages.joined(separator: "\n"),
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }

    static func showAlert(
        title: String = "Alert",
        message: String,
        on viewController: UIViewController
    ) {

        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }

    // MARK: - Success Alert

    static func showSuccess(
        message: String,
        on viewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {

        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })

        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }

    // MARK: - Error Alert

    static func showError(
        step: String,
        error: String,
        on viewController: UIViewController
    ) {

        let alert = UIAlertController(
            title: "\(step) Failed",
            message: error,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
}

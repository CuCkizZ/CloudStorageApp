//
//  UIActionController + ErrorExtension.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 09.09.2024.
//

import UIKit

private let alertMessage = String(localized: "This format is not supported at the moment", table: "Messages+alertsLocalizable")
private let alertTitle = String(localized: "Sorry", table: "Messages+alertsLocalizable")

extension UIAlertController {
    
    static func formatError(view: UIViewController) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(action)
        view.present(alert, animated: true)
    }
}

//
//  UIViewController+ErrorOccured.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 26.08.2024.
//
import YandexLoginSDK
import UIKit.UIViewController

private enum Errors {
    static let loginSDKError = "A LoginSDK Error Occured"
    static let loginError = "An Error Occured"
    static let connectError = "No internet connection"
    static let connectErrorMessage = "Please, try again later"
}

extension UIViewController {
    func errorOccured(_ error: Error) {
        let alertController: UIAlertController
        
        if let yandexLoginSDKError = error as? YandexLoginSDKError {
            alertController = UIAlertController(
                title: "A LoginSDK Error Occured",
                message: yandexLoginSDKError.message,
                preferredStyle: .alert
            )
        } else {
            alertController = UIAlertController(
                title: "An Error Occured",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
        }
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func errorConnection() {
        let alertController = UIAlertController(title: Errors.connectError, 
                                                message: Errors.connectErrorMessage,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
    
}

//
//  CreateNewFolderAction.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.08.2024.
//

import UIKit

extension UIAction {
    
    static func createNewFolder(view: UIViewController,
                                viewModel: BaseCollectionViewModelProtocol) -> UIAction {
        return UIAction { [weak view] action in
            guard let view = view else { return }
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let newFolder = UIAlertAction(title: StrGlobalConstants.AlertsAndActions.newFolderSheetTitle,
                                          style: .default) { _ in
                
                let enterNameAlert = UIAlertController(title: StrGlobalConstants.AlertsAndActions.enterTheName, 
                                                       message: nil, preferredStyle: .alert)
                enterNameAlert.addTextField { textField in
                    textField.placeholder = StrGlobalConstants.AlertsAndActions.enterTheName
                }
                let submitAction = UIAlertAction(title: StrGlobalConstants.AlertsAndActions.submit,
                                                 style: .default) { [unowned enterNameAlert] _ in
                    let answer = enterNameAlert.textFields?[0]
                    viewModel.createNewFolder(answer?.text ?? "")
                }
                enterNameAlert.addAction(submitAction)
                view.present(enterNameAlert, animated: true)
            }
            let cancelAction = UIAlertAction(title: StrGlobalConstants.cancleButton, style: .cancel)
            
            actionSheet.addAction(newFolder)
            actionSheet.addAction(cancelAction)
            view.present(actionSheet, animated: true)
        }
    }
    
    static func deleteFile(view: UIViewController, 
                           viewModel: PresentImageViewModelProtocol,
                           name: String) -> UIAction {
        return UIAction { [weak view] action in
            guard let view = view else { return }
            let actionSheet = UIAlertController(title: StrGlobalConstants.AlertsAndActions.deleteConfirm + name,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: StrGlobalConstants.AlertsAndActions.delete, style: .destructive) { _ in
                viewModel.deleteFile(name: name)
                viewModel.popToRoot()
            }
            let cancelAction = UIAlertAction(title: StrGlobalConstants.cancleButton, style: .cancel)
            
            actionSheet.addAction(deleteAction)
            actionSheet.addAction(cancelAction)
            view.present(actionSheet, animated: true)
        }
    }
}

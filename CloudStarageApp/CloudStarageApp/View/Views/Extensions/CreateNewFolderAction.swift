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
        return UIAction { action in
            let actionSheet = UIAlertController(title: "What to do", message: nil, preferredStyle: .actionSheet)
            let newFolder = UIAlertAction(title: "New Folder", style: .default) { _ in
                
                let enterNameAlert = UIAlertController(title: "New folder", message: nil, preferredStyle: .alert)
                enterNameAlert.addTextField { textField in
                    textField.placeholder = "Enter the name"
                }
                let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned enterNameAlert] _ in
                    let answer = enterNameAlert.textFields?[0]
                    viewModel.createNewFolder(answer?.text ?? "")
                }
                enterNameAlert.addAction(submitAction)
                view.present(enterNameAlert, animated: true)
            }
            let newFile = UIAlertAction(title: "New File", style: .default)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(newFolder)
            actionSheet.addAction(newFile)
            actionSheet.addAction(cancelAction)
            view.present(actionSheet, animated: true)
        }
    }
    
    static func deleteFile(view: UIViewController, 
                           viewModel: PresentImageViewModelProtocol,
                           name: String) -> UIAction {
        return UIAction { action in
            let actionSheet = UIAlertController(title: "Are you sure delete \(name)?", 
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                viewModel.deleteFile(name: name)
                viewModel.popToRoot()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
            actionSheet.addAction(deleteAction)
            actionSheet.addAction(cancelAction)
            view.present(actionSheet, animated: true)
        }
    }
    
//    static func shareFile() -> UIAction {
//        return UIAction { action in
//            let actionSheet = UIAlertController(title: "What you want to share?", 
//                                                message: nil,
//                                                preferredStyle: .actionSheet)
//            
//            let linkAction = UIAlertAction(title: "Share a link", style: .default)
//        }
//    }
}

//
//  CreateNewFolderAction.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.08.2024.
//

import UIKit

extension UIAction {
    static func createNewFolder(view: UIViewController, viewModel: BaseCollectionViewModelProtocol) -> UIAction {
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
            let cancle = UIAlertAction(title: "Cancle", style: .cancel)
            
            actionSheet.addAction(newFolder)
            actionSheet.addAction(newFile)
            actionSheet.addAction(cancle)
            view.present(actionSheet, animated: true)
        }
    }
}

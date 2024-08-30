//
//  CSContextMenu.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.08.2024.
//

import UIKit

enum ModelType {
    case last
    case full
    case publish
}

extension UIContextMenuConfiguration {
    
    //    TODO: PublicUrl accses
    //    TODO: Передать модель а не кучу свойств
    
    static func contextMenuConfiguration(for modelType: ModelType,
                                         viewModel: BaseCollectionViewModelProtocol,
                                         model: CellDataModel,
                                         viewController: UIViewController) -> UIContextMenuConfiguration? {
        var menu = UIMenu()
        let name = model.name
        let path = model.path
        let file = model.file
        let publicUrl = model.publicUrl
        let type = model.type
        switch modelType {
        case .last:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: "Share a link", image: UIImage(systemName: "link.badge.plus")) { _ in
                    viewModel.publishResource(path)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        guard let publicUrl = publicUrl else { return }
                        viewModel.presentAvc(item: publicUrl)
                    }
                }
                let shareFileAction = UIAction(title: "Share a file", image: UIImage(systemName: "arrow.up.doc")) { _ in
                    viewModel.publishResource(path)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file)
                }
                let unpublishAction = UIAction(title: "Unpublish", image: UIImage(systemName: "link")) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil.circle")) { _ in
                    let enterNameAlert = UIAlertController(title: "New name", message: nil, preferredStyle: .alert)
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = "Enter the name"
                    }
                    let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }
                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                let shareMenu = UIMenu(title: "Share",image: UIImage(systemName: "square.and.arrow.up"), children: [shareLinkAction, shareFileAction])
                if publicUrl != nil {
                    return UIMenu(title: "", children: [deleteAction, shareMenu, unpublishAction, renameAction])
                } else {
                    return UIMenu(title: "", children: [deleteAction, shareMenu, renameAction])
                }
            }
        case .full:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: "Share a link", image: UIImage(systemName: "link.badge.plus")) { _ in
                    viewModel.publishResource(path)
                    if let publicUrl = publicUrl {
                        viewModel.presentAvc(item: publicUrl)
                    }
                }
                let shareFileAction = UIAction(title: "Share a file", image: UIImage(systemName: "arrow.up.doc")) { _ in
                    viewModel.publishResource(path)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file)
                }
                let unpublishAction = UIAction(title: "Unpublish", image: UIImage(systemName: "link")) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil.circle")) { _ in
                    let enterNameAlert = UIAlertController(title: "New name", message: nil, preferredStyle: .alert)
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = "Enter the name"
                    }
                    let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }

                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                let shareMenu = UIMenu(title: "Share",image: UIImage(systemName: "square.and.arrow.up"), children: [shareLinkAction, shareFileAction])
                
                if type == "file" && publicUrl != nil {
                    menu = UIMenu(title: "", children: [deleteAction, shareMenu, unpublishAction, renameAction])
                } else if type == "dir" && publicUrl != nil {
                    menu = UIMenu(title: "", children: [deleteAction, shareLinkAction, unpublishAction, renameAction])
                } else if type == "dir"  {
                    menu = UIMenu(title: "", children: [deleteAction, shareLinkAction, renameAction])
                } else {
                    menu = UIMenu(title: "", children: [deleteAction, shareMenu, renameAction])
                }
                return menu
            }
        case .publish:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: "Share a link", image: UIImage(systemName: "link.badge.plus")) { _ in
                    if let publicUrl = publicUrl {
                        viewModel.presentAvc(item: publicUrl)
                    }
                }
                let shareFileAction = UIAction(title: "Share a file", image: UIImage(systemName: "arrow.up.doc")) { _ in
                    viewModel.publishResource(path)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file)
                }
                let unpublishAction = UIAction(title: "Unpublish", image: UIImage(systemName: "link")) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil.circle")) { _ in
                    let enterNameAlert = UIAlertController(title: "New name", message: nil, preferredStyle: .alert)
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = "Enter the name"
                    }
                    let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }
                    
                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                
                if type == "file" {
                    let shareMenu = UIMenu(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), children: [shareLinkAction, shareFileAction])
                    return UIMenu(title: "", children: [deleteAction, unpublishAction, shareMenu, renameAction])
                } else {
                    return UIMenu(title: "", children: [deleteAction, unpublishAction, shareLinkAction, renameAction])
                }
            }
        }
    }
}

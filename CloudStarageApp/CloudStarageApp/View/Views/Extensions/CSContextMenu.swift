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
    
    static func contextMenuConfiguration(for modelType: ModelType,
                                         viewModel: BaseViewModelProtocol,
                                         name: String,
                                         path: String,
                                         file: String,
                                         publicUrl: String?,
                                         type: String = "file",
                                         viewController: UIViewController) -> UIContextMenuConfiguration? {
        var menu = UIMenu()
        var newAction = menu.children
        switch modelType {
        case .last:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                
                let shareLinkAction = UIAction(title: "Share a link", image: UIImage(systemName: "link.badge.plus")) { _ in
                    viewModel.publishFile(path)
                    guard let publicUrl = publicUrl else { return }
                    viewModel.presentAvc(item: publicUrl)
                }
                
                let shareFileAction = UIAction(title: "Share a file", image: UIImage(systemName: "arrow.up.doc")) { _ in
                    viewModel.presentAvc(item: file)
                }
                
                let unpublishAction = UIAction(title: "Unpublish", image: UIImage(systemName: "link")) { _ in
                    viewModel.unpublishFile(path)
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
                    viewModel.publishFile(path)
                    if let publicUrl = publicUrl {
                        viewModel.presentAvc(item: publicUrl)
                    }
                }
                
                let shareFileAction = UIAction(title: "Share a file", image: UIImage(systemName: "arrow.up.doc")) { _ in
                    viewModel.presentAvc(item: file)
                }
                
                let unpublishAction = UIAction(title: "Unpublish", image: UIImage(systemName: "link")) { _ in
                    viewModel.unpublishFile(path)
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
                var shareMenu = UIMenu(title: "Share",image: UIImage(systemName: "square.and.arrow.up"), children: [shareLinkAction, shareFileAction])
                
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
                
                let unpublishAction = UIAction(title: "Unpublish", image: UIImage(systemName: "link")) { _ in
                    viewModel.unpublishFile(path)
                }
                
                let shareLinkAction = UIAction(title: "Share a link", image: UIImage(systemName: "link.badge.plus")) { _ in
                    guard let publicUrl = publicUrl else { return }
                    viewModel.presentAvc(item: publicUrl)
                }
                let shareFileAction = UIAction(title: "Share a file", image: UIImage(systemName: "arrow.up.doc")) { _ in
                    viewModel.presentAvc(item: file)
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



// На всякий случай


//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
//            guard let self = self else { return UIMenu() }
//            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//                self.viewModel.deleteFile(name)
//            }
//            let shareLinkAction = UIAction(title: "Share link", image: UIImage(systemName: "square.and.arrow.up")) { _ in
//                self.viewModel.publishFile(path)
//                let avc = UIActivityViewController(activityItems: [model.publicUrl ?? ""], applicationActivities: nil)
//                self.present(avc, animated: true)
//            }
//            let shareFileAction = UIAction(title: "Share file", image: UIImage(systemName: "square.and.arrow.up")) { _ in
//                //self.viewModel.publicFile(path)
//
//                let avc = UIActivityViewController(activityItems: [model.file], applicationActivities: nil)
//                self.present(avc, animated: true)
//            }
//            let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil.circle")) { _ in
//                let enterNameAlert = UIAlertController(title: "New name", message: nil, preferredStyle: .alert)
//                enterNameAlert.addTextField { textField in
//                    textField.placeholder = "Enter the name"
//
//                }
//                let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned enterNameAlert] _ in
//                    if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
//                        self.viewModel.renameFile(oldName: name, newName: newName)
//                    }
//                }
//                enterNameAlert.addAction(submitAction)
//                self.present(enterNameAlert, animated: true)
//            }
//            let shareMenu = UIMenu(title: "Share", children: [shareLinkAction, shareFileAction])
//            return UIMenu(title: "", children: [deleteAction, shareMenu, renameAction])
//        }
//    }

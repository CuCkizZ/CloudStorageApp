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

private enum Constants {
    
    static let defaultType = "file"
    static let dirType = "dir"
    
    enum Images {
        static let trash = "trash"
        static let plusLink = "link.badge.plus"
        static let doc = "arrow.up.doc"
        static let link = "link"
        static let rename = "pencil.circle"
        static let share = "square.and.arrow.up"
    }
}

extension UIContextMenuConfiguration {
    
    static func contextMenuConfiguration(for modelType: ModelType,
                                         viewModel: BaseCollectionViewModelProtocol,
                                         model: CellDataModel,
                                         indexPath: IndexPath,
                                         viewController: UIViewController) -> UIContextMenuConfiguration? {
        var menu = UIMenu()
        let name = model.name
        let path = model.path
        let file = model.file
        let publicUrl = model.publicUrl
        let type = model.type
        switch modelType {
        case .last:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak viewModel] _ in
                guard let viewModel = viewModel else { return UIMenu() }
                let deleteAction = UIAction(title: StrGlobalConstants.AlertsAndActions.delete,
                                            image: UIImage(systemName: Constants.Images.trash),
                                            attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: StrGlobalConstants.AlertsAndActions.shareLink,
                                               image: UIImage(systemName: Constants.Images.plusLink)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)
                }
                let shareFileAction = UIAction(title: StrGlobalConstants.AlertsAndActions.shareFile,
                                               image: UIImage(systemName: Constants.Images.doc)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file, name: name)
                }
                let unpublishAction = UIAction(title: StrGlobalConstants.AlertsAndActions.unpublish,
                                               image: UIImage(systemName: Constants.Images.link)) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: StrGlobalConstants.AlertsAndActions.rename,
                                            image: UIImage(systemName: Constants.Images.rename)) { _ in
                    let enterNameAlert = UIAlertController(title: StrGlobalConstants.AlertsAndActions.newName,
                                                           message: nil,
                                                           preferredStyle: .alert)
                    
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = StrGlobalConstants.AlertsAndActions.enterTheName
                    }
                    let submitAction = UIAlertAction(title: StrGlobalConstants.AlertsAndActions.submit, 
                                                     style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }
                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                let shareMenu = UIMenu(title: StrGlobalConstants.AlertsAndActions.shareMenu, 
                                       image: UIImage(systemName: Constants.Images.share),
                                       children: [shareLinkAction, shareFileAction])
                if publicUrl != nil {
                    return UIMenu(title: "", children: [shareMenu, unpublishAction, renameAction, deleteAction])
                } else {
                    return UIMenu(title: "", children: [shareMenu, renameAction, deleteAction,])
                }
            }
        case .full:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let deleteAction = UIAction(title: StrGlobalConstants.AlertsAndActions.delete,
                                            image: UIImage(systemName: Constants.Images.trash),
                                            attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: StrGlobalConstants.AlertsAndActions.shareLink,
                                               image: UIImage(systemName: Constants.Images.plusLink)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)

                }
                let shareFileAction = UIAction(title: StrGlobalConstants.AlertsAndActions.shareFile,
                                               image: UIImage(systemName: Constants.Images.doc)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file, name: name)
                }
                let unpublishAction = UIAction(title: StrGlobalConstants.AlertsAndActions.unpublish,
                                               image: UIImage(systemName: Constants.Images.link)) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: StrGlobalConstants.AlertsAndActions.rename,
                                            image: UIImage(systemName: Constants.Images.rename)) { _ in
                    let enterNameAlert = UIAlertController(title: StrGlobalConstants.AlertsAndActions.newName, 
                                                           message: nil,
                                                           preferredStyle: .alert)
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = StrGlobalConstants.AlertsAndActions.enterTheName
                    }
                    let submitAction = UIAlertAction(title: StrGlobalConstants.AlertsAndActions.submit, 
                                                     style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }

                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                let shareMenu = UIMenu(title: StrGlobalConstants.AlertsAndActions.shareMenu,
                                       image: UIImage(systemName: Constants.Images.share),
                                       children: [shareLinkAction, shareFileAction])
                
                if type == Constants.defaultType && publicUrl != nil {
                    menu = UIMenu(title: "", children: [shareMenu, unpublishAction, renameAction, deleteAction])
                } else if type == Constants.dirType && publicUrl != nil {
                    menu = UIMenu(title: "", children: [shareLinkAction, unpublishAction, renameAction, deleteAction])
                } else if type == Constants.dirType  {
                    menu = UIMenu(title: "", children: [shareLinkAction, renameAction, deleteAction])
                } else {
                    menu = UIMenu(title: "", children: [shareMenu, renameAction, deleteAction])
                }
                return menu
            }
        case .publish:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let deleteAction = UIAction(title: StrGlobalConstants.AlertsAndActions.delete,
                                            image: UIImage(systemName: Constants.Images.trash),
                                            attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: StrGlobalConstants.AlertsAndActions.shareLink,
                                               image: UIImage(systemName: Constants.Images.plusLink)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)

                }
                let shareFileAction = UIAction(title: StrGlobalConstants.AlertsAndActions.shareFile,
                                               image: UIImage(systemName: Constants.Images.doc)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file, name: name)
                }
                let unpublishAction = UIAction(title: StrGlobalConstants.AlertsAndActions.unpublish,
                                               image: UIImage(systemName: Constants.Images.link)) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: StrGlobalConstants.AlertsAndActions.rename,
                                            image: UIImage(systemName: Constants.Images.rename)) { _ in
                    let enterNameAlert = UIAlertController(title: StrGlobalConstants.AlertsAndActions.newName,
                                                           message: nil, preferredStyle: .alert)
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = StrGlobalConstants.AlertsAndActions.enterTheName
                    }
                    let submitAction = UIAlertAction(title: StrGlobalConstants.AlertsAndActions.submit,
                                                     style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }
                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                
                if type == Constants.defaultType {
                    let shareMenu = UIMenu(title: StrGlobalConstants.AlertsAndActions.shareMenu,
                                           image: UIImage(systemName: Constants.Images.share),
                                           children: [shareLinkAction, shareFileAction])
                    
                    return UIMenu(title: "", children: [shareMenu, unpublishAction, renameAction, deleteAction])
                } else {
                    return UIMenu(title: "", children: [shareLinkAction, unpublishAction, renameAction, deleteAction])
                }
            }
        }
    }
}

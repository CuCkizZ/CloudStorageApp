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
    
    enum Images {
        static let trash = "trash"
        static let plusLink = "link.badge.plus"
        static let doc = "arrow.up.doc"
        static let link = "link"
        static let rename = "pencil.circle"
        static let share = "square.and.arrow.up"
    }
    
    enum Titles {
        static let delete = "Delete"
        static let shareLink = "Share a link"
        static let shareFile = "Share a file"
        static let unpublish = "Unpublish"
        static let rename = "Rename"
        static let shareMenu = "Share"
        static let newName = "New name"
        static let enterTheName = "Enter the name"
        static let submit = "Submite"
    }
    
}

extension UIContextMenuConfiguration {
    
    //    TODO: PublicUrl accses
    //    TODO: Передать модель а не кучу свойств
    
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
        var viewModel = viewModel
        switch modelType {
        case .last:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let deleteAction = UIAction(title: Constants.Titles.delete,
                                            image: UIImage(systemName: Constants.Images.trash),
                                            attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: Constants.Titles.shareFile,
                                               image: UIImage(systemName: Constants.Images.plusLink)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)
                }
                let shareFileAction = UIAction(title: Constants.Titles.shareFile,
                                               image: UIImage(systemName: Constants.Images.doc)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file)
                }
                let unpublishAction = UIAction(title: Constants.Titles.unpublish,
                                               image: UIImage(systemName: Constants.Images.link)) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: Constants.Titles.rename,
                                            image: UIImage(systemName: Constants.Images.rename)) { _ in
                    let enterNameAlert = UIAlertController(title: Constants.Titles.newName,
                                                           message: nil,
                                                           preferredStyle: .alert)
                    
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = Constants.Titles.enterTheName
                    }
                    let submitAction = UIAlertAction(title: Constants.Titles.submit, 
                                                     style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }
                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                let shareMenu = UIMenu(title: Constants.Titles.shareMenu, 
                                       image: UIImage(systemName: Constants.Images.share),
                                       children: [shareLinkAction, shareFileAction])
                if publicUrl != nil {
                    return UIMenu(title: "", children: [deleteAction, shareMenu, unpublishAction, renameAction])
                } else {
                    return UIMenu(title: "", children: [deleteAction, shareMenu, renameAction])
                }
            }
        case .full:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let deleteAction = UIAction(title: Constants.Titles.delete,
                                            image: UIImage(systemName: Constants.Images.trash),
                                            attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: Constants.Titles.shareLink,
                                               image: UIImage(systemName: Constants.Images.plusLink)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)

                }
                let shareFileAction = UIAction(title: Constants.Titles.shareFile,
                                               image: UIImage(systemName: Constants.Images.doc)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file)
                }
                let unpublishAction = UIAction(title: Constants.Titles.unpublish,
                                               image: UIImage(systemName: Constants.Images.link)) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: Constants.Titles.rename,
                                            image: UIImage(systemName: Constants.Images.rename)) { _ in
                    let enterNameAlert = UIAlertController(title: Constants.Titles.newName, 
                                                           message: nil,
                                                           preferredStyle: .alert)
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = Constants.Titles.enterTheName
                    }
                    let submitAction = UIAlertAction(title: Constants.Titles.submit, 
                                                     style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }

                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                let shareMenu = UIMenu(title: Constants.Titles.shareMenu,
                                       image: UIImage(systemName: Constants.Images.share),
                                       children: [shareLinkAction, shareFileAction])
                
                if type == Constants.defaultType && publicUrl != nil {
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
                let deleteAction = UIAction(title: Constants.Titles.delete,
                                            image: UIImage(systemName: Constants.Images.trash),
                                            attributes: .destructive) { _ in
                    viewModel.deleteFile(name)
                }
                let shareLinkAction = UIAction(title: Constants.Titles.shareLink,
                                               image: UIImage(systemName: Constants.Images.plusLink)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)

                }
                let shareFileAction = UIAction(title: Constants.Titles.shareFile,
                                               image: UIImage(systemName: Constants.Images.doc)) { _ in
                    viewModel.publishResource(path, indexPath: indexPath)
                    guard let file = URL(string: file) else { return }
                    viewModel.presentAvcFiles(path: file)
                }
                let unpublishAction = UIAction(title: Constants.Titles.unpublish,
                                               image: UIImage(systemName: Constants.Images.link)) { _ in
                    viewModel.unpublishResource(path)
                }
                let renameAction = UIAction(title: Constants.Titles.rename,
                                            image: UIImage(systemName: Constants.Images.rename)) { _ in
                    let enterNameAlert = UIAlertController(title: Constants.Titles.newName,
                                                           message: nil, preferredStyle: .alert)
                    enterNameAlert.addTextField { textField in
                        textField.placeholder = Constants.Titles.enterTheName
                    }
                    let submitAction = UIAlertAction(title: Constants.Titles.submit,
                                                     style: .default) { [unowned enterNameAlert] _ in
                        if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                            viewModel.renameFile(oldName: name, newName: newName)
                        }
                    }
                    
                    enterNameAlert.addAction(submitAction)
                    viewController.present(enterNameAlert, animated: true)
                }
                
                if type == Constants.defaultType {
                    let shareMenu = UIMenu(title: Constants.Titles.shareMenu,
                                           image: UIImage(systemName: Constants.Images.share),
                                           children: [shareLinkAction, shareFileAction])
                    
                    return UIMenu(title: "", children: [deleteAction, unpublishAction, shareMenu, renameAction])
                } else {
                    return UIMenu(title: "", children: [deleteAction, unpublishAction, shareLinkAction, renameAction])
                }
            }
        }
    }
}

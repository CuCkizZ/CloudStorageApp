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
                                         name: String,
                                         path: String,
                                         file: String = "dir",
                                         publicUrl: String?,
                                         type: String = "file",
                                         viewController: UIViewController) -> UIContextMenuConfiguration? {
        let view = UIViewController()
        var menu = UIMenu()
        var imageShare = UIImage()
        switch modelType {
        case .last:
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
                    viewModel.presentAvc(item: file)
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
                
                let unpublishAction = UIAction(title: "Unpublish", image: UIImage(systemName: "link")) { _ in
                    viewModel.unpublishResource(path)
                }
                
                let shareLinkAction = UIAction(title: "Share a link", image: UIImage(systemName: "link.badge.plus")) { _ in
                    if let publicUrl = publicUrl {
                        viewModel.presentAvc(item: publicUrl)
                    }
                }
                let shareFileAction = UIAction(title: "Share a file", image: UIImage(systemName: "arrow.up.doc")) { _ in
                    viewModel.publishResource(path)
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
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Создаем URLSessionDataTask для загрузки данных из URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Проверяем наличие ошибок
            if let error = error {
                print("Ошибка загрузки изображения: \(error)")
                completion(nil)
                return
            }
            
            // Проверяем, что данные были получены
            guard let data = data, let image = UIImage(data: data) else {
                print("Не удалось преобразовать данные в изображение")
                completion(nil)
                return
            }
            
            // Возвращаем изображение через completion handler
            completion(image)
        }
        // Запускаем задачу
        task.resume()
    }
    
//LSta

    func shareImage(_ image: UIImage, from viewController: UIViewController) {
        // Создаем временный URL для сохранения изображения
        guard let imageData = image.jpegData(compressionQuality: 1.0),
              let tempURL = createTemporaryFile(with: imageData) else {
            print("Ошибка создания временного файла для изображения")
            return
        }
        
        // Инициализируем UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        
        // Настройка для iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // Отображаем UIActivityViewController
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    private func createTemporaryFile(with data: Data) -> URL? {
        // Генерация временного URL для сохранения файла
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        do {
            // Запись данных в файл
            try data.write(to: tempFileURL)
            return tempFileURL
        } catch {
            print("Ошибка записи данных в файл: \(error)")
            return nil
        }
    }
}


// LSfdfsasdsa

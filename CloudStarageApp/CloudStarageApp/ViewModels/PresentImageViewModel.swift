//
//  PresentImageViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 01.08.2024.
//

import Foundation

protocol PresentImageViewModelProtocol {
    func fetchData(path: String)
    func sizeFormatter(bytes: Int) -> String
    func popToRoot()
    func publishFile(path: String)
    func deleteFile(name: String)
    func shareLink(link: String)
    func shareFile(path: URL, name: String)
    
    var onButtonShareTapped: (() -> Void)? { get set }
    var isDataLoading: Observable<Bool> { get set }
    var OnButtonTapped: Observable<Bool> { get set }
    var shareViewModel: Observable<Item> { get set }
    func hideShareView()
}

final class PresentImageViewModel {
    
    var onButtonShareTapped: (() -> Void)?
    var isDataLoading: Observable<Bool> = Observable(nil)
    var OnButtonTapped: Observable<Bool> = Observable(nil)
    var shareViewModel: Observable<Item> = Observable(nil)

    private var model: Item?
    private let coordinator: Coordinator
    private let networkManager: NetworkManagerProtocol?
    
    init(coordinator: Coordinator, networkManager: NetworkManagerProtocol? = nil) {
        self.coordinator = coordinator
        self.networkManager = networkManager
    }
    
    func publishFile(path: String) {
        if OnButtonTapped.value ?? true {
            networkManager?.toPublicFile(path: path)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.isDataLoading.value = true
                self.fetchData(path: path)
            }
        }
    }
}

extension PresentImageViewModel: PresentImageViewModelProtocol {
   
    func fetchData(path: String) {
        if isDataLoading.value == true {
            networkManager?.fetchCurentItem(path: path) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let item):
                        self.model = item
                        self.mapModel()
                        self.isDataLoading.value = false
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func mapModel() {
        shareViewModel.value = model
    }
    
    func hideShareView() {
        onButtonShareTapped?()
    }
    
    func popToRoot() {
        coordinator.popTo()
    }
    
    func sizeFormatter(bytes: Int) -> String {
        let kilobytes = Double(bytes) / 1024
        let megabytes = kilobytes / 1024
        if megabytes >= 1 {
            let roundedMegabytes = String(format: "%.2f", megabytes)
            return String(localized: "Size \(roundedMegabytes) MB", table: "InfoViewLocalizable")
        } else {
            let roundedKilobytes = String(format: "%.2f", kilobytes)
            return String(localized: "Size \(roundedKilobytes) KB", table: "InfoViewLocalizable")
        }
    }
    
    func deleteFile(name: String) {
        networkManager?.deleteReqest(name: name)
    }
    
    func shareLink(link: String) {
        coordinator.presentAtivityVc(item: link)
    }
//     TODO: NameFile
    func shareFile(path: URL, name: String) {
        networkManager?.shareFile(with: path) { result in
            print("file name", name)
            switch result {
            case .success((let response, let data)):
                do {
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let fileExtension = (response.suggestedFilename as NSString?)?.pathExtension ?? path.pathExtension
                    let tempFileURL = tempDirectory.appendingPathComponent(name).appendingPathExtension(fileExtension)
                    try data.write(to: tempFileURL)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        coordinator.presentAtivityVcFiles(item: tempFileURL)
                    }
                } catch {
                    let error = error
                    print(error.localizedDescription)
                }
            case .failure(_):
                break
            }
        }
    }
}

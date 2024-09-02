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
    func shareFile(path: URL)
    
    var onButtonShareTapped: (() -> Void)? { get set }
    var isDataLoaded: Observable<Bool> { get set }
    func hideShareView()
}

final class PresentImageViewModel {
    
    var onButtonShareTapped: (() -> Void)?
    
    var isDataLoaded: Observable<Bool> = Observable(nil)
    var OnButtonTapped: Observable<Bool> = Observable(nil)

    private var model: [Item] = []
    private let coordinator: Coordinator
    
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func publishFile(path: String) {
        NetworkManager.shared.toPublicFile(path: path)
    }
}

extension PresentImageViewModel: PresentImageViewModelProtocol {
   
    func fetchData(path: String) {
        print(path)
        NetworkManager.shared.fetchCurentData(path: path) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let file):
                    self.model = file
                    print("parsed")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
            return "Размер \(roundedMegabytes) МБ"
        } else {
            let roundedKilobytes = String(format: "%.2f", kilobytes)
            return "Размер \(roundedKilobytes) КБ"
        }
    }
    
    func deleteFile(name: String) {
        NetworkManager.shared.deleteReqest(name: name)
    }
    
    func shareLink(link: String) {
        coordinator.presentAtivityVc(item: link)
    }
    
    func shareFile(path: URL) {
        NetworkManager.shared.shareFile(with: path) { result in
            switch result {
            case .success((let response, let data)):
                do {
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let fileExtension = (response.suggestedFilename as NSString?)?.pathExtension ?? path.pathExtension
                    let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
                    try data.write(to: tempFileURL)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        coordinator.presentAtivityVcFiles(item: tempFileURL)
                    }
                } catch {
                    print ("viewModel error")
                }
            case .failure(_):
                break
            }
        }
    }
}

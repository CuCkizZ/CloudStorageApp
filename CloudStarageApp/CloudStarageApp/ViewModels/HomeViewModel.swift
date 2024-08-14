//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Foundation

protocol HomeViewModelProtocol: BaseViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[LastUploadedCellDataModel]> { get set }
    func presentDocumet(name: String, type: ConfigureTypes, fyleType: String)
    func presentShareView(shareLink: String)
    func publishFile(_ path: String)
}

final class HomeViewModel {
    
    private let coordinator: HomeCoordinator
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[LastUploadedCellDataModel]> = Observable(nil)
    private var model: [LastItem] = []
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        fetchData()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { LastUploadedCellDataModel($0) }
    }

}
    
extension HomeViewModel: HomeViewModelProtocol {
    
    func fetchData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.fetchLastData { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let file):
                    self.model = file
                    self.mapModel()
                    self.isLoading.value = false
                case .failure(let error):
                    print("model failrue: \(error)")
                }
            }
        }
    }
    
    func deleteFile(_ name: String) {
        NetworkManager.shared.deleteReqest(name: name)
    }
    
    func createNewFolder(_ name: String) {
        NetworkManager.shared.createNewFolder(name)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func publishFile(_ path: String) {
        NetworkManager.shared.toPublicFile(path: path)
    }
    
    func unpublishFile(_ path: String) {
        NetworkManager.shared.unpublishFile(path)
    }
    
    func renameFile(oldName: String, newName: String) {
        NetworkManager.shared.renameFile(oldName: oldName, newName: newName)
        fetchData()
    }
    
    func numbersOfRowInSection() -> Int {
        model.count
    }
    
    func presentShareView(shareLink: String) {
        coordinator.presentShareScene(shareLink: shareLink)
    }
    
    func presentDocumet(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.goToDocument(name: name, type: type, fileType: fileType)
    }
    
    func presentImage(url: URL) {
        coordinator.presentImageScene(url: url)
    }
    
}

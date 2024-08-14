//
//  PublicStorageViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import Foundation

protocol PublickStorageViewModelProtocol: BaseViewModelProtocol, AnyObject {
    
    var isLoading: Observable<Bool> { get set }
    var cellDataSource: Observable<[PublicItem]> { get set }

    func presentDetailVC(path: String)
    func unpublicResource()
    func presentShareView(shareLink: String)
    
}
final class PublicStorageViewModel {
    private var coordinator: PublicCoordinator?
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[PublicItem]> = Observable(nil)
    var model: [PublicItem] = []
    
    
    init(coordinator: PublicCoordinator? = nil) {
        self.coordinator = coordinator
        fetchData()
    }
    
    func mapModel() {
        cellDataSource.value = model
    }
}

extension PublicStorageViewModel: PublickStorageViewModelProtocol {
    func presentAvc(item: String) {
        
    }
    
    func presentImage(url: URL) {
        
    }
    
    func presentDocumet(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        
    }
    
    func publishFile(_ path: String) {
        NetworkManager.shared.toPublicFile(path: path)
    }
    
    func fetchData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.fetchPublicData { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.model = data
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
    
    func unpublicResource() {
        
    }
    
    func numbersOfRowInSection() -> Int {
        model.count
    }
    
    func presentDetailVC(path: String) {
        
    }
    
    func presentShareView(shareLink: String) {
        //coordinator.presentShareScene(shareLink: shareLink)
    }
    
    func unpublishFile(_ path: String) {
        NetworkManager.shared.unpublishFile(path)
    }
    
    func renameFile(oldName: String, newName: String) {
        NetworkManager.shared.renameFile(oldName: oldName, newName: newName)
        fetchData()
    }
    
    func sortData() {
        
    }
}

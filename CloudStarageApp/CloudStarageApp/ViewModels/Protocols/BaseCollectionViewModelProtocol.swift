//
//  BaseViewModelProtocol.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.08.2024.
//

import Foundation
import CoreData

protocol BaseCollectionViewModelProtocol {
    //    Observable
    var isLoading: Observable<Bool> { get set }
    var isConnected: Observable<Bool> { get set }
    var isPublished: (() -> IndexPath)? { get set }
    var isSharing: Observable<Bool> { get set }
    
    

    //    DataSource
    func numbersOfRowInSection() -> Int
    //   Network
    func fetchData()
    func startMonitoringNetwork()
    func createNewFolder(_ name: String)
    func deleteFile(_ name: String)
    func unpublishResource(_ path: String)
    func publishResource(_ path: String, indexPath: IndexPath)
    func renameFile(oldName: String, newName: String)
    func loadFile(from path: String, completion: @escaping (URL?) -> Void)
    //    Navigation
    func presentImage(model: CellDataModel)
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String)
    func presentAvc(indexPath: IndexPath)
    func presentAvcFiles(path: URL)
    func logout()
    
//    CoreData
    func FetchedResultsController()
    func numberOfRowInCoreDataSection() -> Int    
//    func publishResource2(_ path: String, completion: @escaping (URL?) -> Void)
}

//
//  BaseViewModelProtocol.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.08.2024.
//

import Foundation

protocol BaseViewModelProtocol {
    var isLoading: Observable<Bool> { get set }
    var isConnected: Observable<Bool> { get set }
    
    func numbersOfRowInSection() -> Int
    func fetchData()
    func startMonitoringNetwork()
    func mapModel()
    func unpublishFile(_ path: String)
    func createNewFolder(_ name: String)
    func deleteFile(_ name: String)
    func publishFile(_ path: String)
    func renameFile(oldName: String, newName: String)
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String)
    func presentImage(url: URL)
    func presentAvc(item: String)
}

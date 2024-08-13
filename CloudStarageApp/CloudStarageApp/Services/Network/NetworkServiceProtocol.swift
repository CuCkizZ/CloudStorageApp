//
//  NetworkServiceProtocol.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.08.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func getToket()
    func fetchDataWithAlamofire(completion: @escaping (Result<Data, NetworkErrors>) -> Void)
    func fetchAccountData(completion: @escaping (Result<Data, Error>) -> Void)
    func createNewFolder(_ name: String)
    func deleteFolder(urlString: String, name: String)
    func fetchLastData(completion: @escaping (Result<Data, Error>) -> Void)
    func fetchPublicData(completion: @escaping (Result<Data, Error>) -> Void)
    func fetchCurrentData(path: String, completion: @escaping (Result<Data, Error>) -> Void)
    func toPublicFile(path: String)
    func unpublishFile(path: String)
    func renameFile(oldName: String, newName: String)
}

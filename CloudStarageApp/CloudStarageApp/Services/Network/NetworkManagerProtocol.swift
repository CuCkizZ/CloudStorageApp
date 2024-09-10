//
//  NetworkManagerProtocol.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 03.09.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData(completion: @escaping (Result<[Item], Error>) -> Void)
    func fetchAccountData(completion: @escaping (Result<ProfileDataSource, Error>) -> Void)
    func createNewFolder(_ name: String)
    func deleteReqest(name: String)
    func fetchLastData(completion: @escaping (Result<[Item], Error>) -> Void)
    func fetchPublicData(completion: @escaping (Result<[Item], Error>) -> Void)
    func fetchCurentData(path: String, completion: @escaping (Result<[Item], Error>) -> Void)
    func fetchCurentItem(path: String, completion: @escaping (Result<Item, Error>) -> Void)
    func toPublicFile(path: String)
    func unpublishFile(_ path: String)
    func renameFile(oldName: String, newName: String)
    func shareFile(with url: URL, completion: @escaping (Result<(URLResponse, Data), Error>) -> Void)
}

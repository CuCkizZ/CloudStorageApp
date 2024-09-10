//
//  NetworkService.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation
import Alamofire

private enum NetworkConstants {
    static let path = "path"
    static let defaultParams = ["path": "disk:/"]
    
    static let resoursesUrl =  "https://cloud-api.yandex.net/v1/disk/resources"
    static let lastUploadedUrl = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded"
    static let diskInfoUrl = "https://cloud-api.yandex.net/v1/disk"
    static let publicFilesUrl = "https://cloud-api.yandex.net/v1/disk/resources/public?type=file"
    
    static let createUrl = "https://cloud-api.yandex.net/v1/disk/resources?path=disk:/"
    static let publishUrl = "https://cloud-api.yandex.net/v1/disk/resources/publish?path="
    static let unpublishUrl = "https://cloud-api.yandex.net/v1/disk/resources/unpublish?path="
}

final class NetworkService: NetworkServiceProtocol {
    
    private let keychain = KeychainManager.shared
    private var headers: HTTPHeaders = [ : ]
    private var token: String? {
        didSet {
            if let token = token {
                headers = ["Authorization" : "OAuth \(token)"]
            }
        }
    }
    
    init() {
        updateToken()
    }
   
    private func updateToken() {
        if let savedToken = self.keychain.get(forKey: StrGlobalConstants.keycheinKey) {
            self.token = savedToken
            headers = ["Authorization" : "OAuth \(savedToken)"]
        }
    }

    func fetchDataWithAlamofire(completion: @escaping (Result<Data, NetworkErrors>) -> Void) {
        let urlParams = NetworkConstants.defaultParams
        let urlString = NetworkConstants.resoursesUrl
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: urlParams, headers: headers).validate().response {  response in
            if let _ = response.error {
                completion(.failure(.internetError))
                return
            }
            guard let data = response.data else { return }
            completion(.success(data))
        }
    }
    
    func fetchCurrentData(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlParams = [NetworkConstants.path: path]
        let urlString = NetworkConstants.resoursesUrl
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: urlParams, headers: headers).validate().response {  response in
            if let error = response.error {
                completion(.failure(error))
                print("Url error")
                return
            }
            guard let data = response.data else { return }
            completion(.success(data))
        }
    }
    
    func fetchLastData(completion: @escaping (Result<Data, Error>) -> Void) {
        updateToken()
        let urlParams = NetworkConstants.defaultParams
        let urlString = NetworkConstants.lastUploadedUrl
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: urlParams, headers: self.headers).validate().response { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }
            guard let data = response.data else { return }
            completion(.success(data))
        }
    }
    
    func fetchAccountData(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = NetworkConstants.diskInfoUrl
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, headers: headers).response { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }
            guard let data = response.data else { return }
            completion(.success(data))
        }
    }
    
    func fetchPublicData(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlStirng = NetworkConstants.publicFilesUrl
        guard let url = URL(string: urlStirng) else { return }
        
        AF.request(url, method: .get, headers: headers).response { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }
            guard let data = response.data else { return }
            completion(.success(data))
        }
    }
    
    func createNewFolder(name: String) {
        let urlString = NetworkConstants.createUrl + name
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .put, headers: headers).validate().response { response in
            guard let _ = response.response?.statusCode else {
                return
            }
            if let data = response.data {
                let _ = String(data: data, encoding: .utf8)
                return 
            }
        }
    }
    
    func deleteFile(urlString: String, name: String) {
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .delete, headers: headers).response { response in
        }
    }
    
    func toPublicFile(path: String) {
        let urlSting = NetworkConstants.publishUrl + path
        guard let url = URL(string: urlSting) else { return }
        
        AF.request(url, method: .put, headers: headers).validate().response { response in
        }
    }
    
    func unpublishFile(path: String) {
        let urlString = NetworkConstants.unpublishUrl + path
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .put, headers: headers).validate().response { response in
        }
    }
    
    func renameFile(oldName: String, newName: String) {
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources/move?from=\(oldName)&path=\(newName)"
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .post, headers: headers).validate().response { response in
            guard let statusCode = response.response?.statusCode else {
                print("Error: no response")
                return
            }
            print("status code: \(statusCode)")
            if let error = response.error {
                print("Error: \(error)")
            }
            if let data = response.data {
                let str = String(data: data, encoding: .utf8)
                print("Data: \(String(describing: str))")
            }
        }
    }       
}

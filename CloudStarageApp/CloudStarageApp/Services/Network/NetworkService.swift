//
//  NetworkService.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation
import YandexLoginSDK
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


final class NetworkService: NetworkServiceProtocol, YandexLoginSDKObserver {
    
    private let keychain = KeychainManager.shared
    private var loginResult: LoginResult?
    private var token = "" {
            didSet {
                headers["Authorization"] = "OAuth \(token)"
                print("Haader from didset: \(token)")
            }
        }
        private var headers: HTTPHeaders = [
            "Accept" : "application/json"
        ]
        
        init() {
            YandexLoginSDK.shared.add(observer: self)
            // Изначальная инициализация токена, например, загрузка из keychain
            if let savedToken = loginResult?.token {
                self.token = savedToken
                self.headers["Authorization"] = "OAuth \(token)"
            }
        }
        
    func getOAuthToken(result: String) {
//        if let savedToken = keychain.get(forKey: "token") {
//            self.token = savedToken
//            //print(savedToken)
//            self.headers["Authorization"] = "OAuth \(token)"
//            //print(headers)
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
        let urlParams = NetworkConstants.defaultParams
        let urlString = NetworkConstants.lastUploadedUrl
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
    
    func fetchAccountData(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = NetworkConstants.diskInfoUrl
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, headers: headers).response { response in
            if let error = response.error {
                completion(.failure(error))
                print("URL error")
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
                print("URL error")
                return
            }
            guard let data = response.data else { return }
            completion(.success(data))
        }
    }
    
    func searchFiles(keyword: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlParams = ["path": keyword]
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
    
    func createNewFolder(name: String) {
        let urlString = NetworkConstants.createUrl + name
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .put, headers: headers).validate().response { response in
            guard let statusCode = response.response?.statusCode else {
                print("Error: no response")
                return
            }
            //completion(statusCode)
            print("status code: \(statusCode)")
            if let error = response.error {
                print("Error: \(error)")
            }
            if let data = response.data {
                let str = String(data: data, encoding: .utf8)
                print("Data: \(str ?? "")")
            }
        }
    }
    
    func deleteFile(urlString: String, name: String) {
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .delete, headers: headers).response { response in
            guard let statusCode = response.response?.statusCode else { return }
            print("status code: \(statusCode)")
        }
    }
    
    func toPublicFile(path: String) {
        let urlSting = NetworkConstants.publishUrl + path
        guard let url = URL(string: urlSting) else { return }
        
        AF.request(url, method: .put, headers: headers).validate().response { response in
            guard let statusCode = response.response?.statusCode else {
                print("Error: no response")
                return
            }
            print("status code: \(statusCode)")
            if let error = response.error {
                print("Error: \(error)")
            }
        }
    }
    
    func unpublishFile(path: String) {
        let urlString = NetworkConstants.unpublishUrl + path
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .put, headers: headers).validate().response { response in
            guard let statusCode = response.response?.statusCode else {
                print("Error: no response")
                return
            }
            print("status code: \(statusCode)")
            if let error = response.error {
                print("Error: \(error)")
            }
            if let data = response.data {
                _ = String(data: data, encoding: .utf8)
            }
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

extension NetworkService {
    func didFinishLogin(with result: Result<LoginResult, any Error>) {
        switch result {
        case .success(let loginResult):
            self.loginResult = loginResult
            token = keychain.get(forKey: "token") ?? "nope"
            print("Token from KC NS, \(token)")
        case .failure(_):
            print("Network service token error")
        }
    }
}
                                              

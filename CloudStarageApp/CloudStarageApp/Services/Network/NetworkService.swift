//
//  NetworkService.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation
import YandexLoginSDK
import Alamofire

private enum Constants {
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
            // Изначальная инициализация токена, например, загрузка из keychain
            let result = keychain.get(forKey: "token")
            if let savedToken = keychain.get(forKey: "token") {
                self.token = savedToken
                self.headers["Authorization"] = "OAuth \(token)"
            }
        }
        
    func getOAuthToken(result: String) {
        if let savedToken = keychain.get(forKey: "token") {
            self.token = savedToken
            //print(savedToken)
            self.headers["Authorization"] = "OAuth \(token)"
            //print(headers)
        }
    }
    
    
    func setOAuthToken() {
        
    }
    
     
    
    func setToken() -> String {
        //        do {
        //            token = try keychain.get(forKey: "token") ?? "no token"
        //            print("token:\(token) was setted")
        //            return token
        //        } catch {
        //            print("cant set token")
        //        }
        //        return ""
        return ""
    }
    
    func fetchDataWithAlamofire(completion: @escaping (Result<Data, NetworkErrors>) -> Void) {
        let urlParams = Constants.defaultParams
        let urlString = Constants.resoursesUrl
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
        let urlParams = [Constants.path: path]
        let urlString = Constants.resoursesUrl
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
        let urlParams = Constants.defaultParams
        let urlString = Constants.lastUploadedUrl
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
        let urlString = Constants.diskInfoUrl
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
        let urlStirng = Constants.publicFilesUrl
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
        let urlString = Constants.resoursesUrl
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
        let urlString = Constants.createUrl + name
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
        let urlSting = Constants.publishUrl + path
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
        let urlString = Constants.unpublishUrl + path
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
                                              

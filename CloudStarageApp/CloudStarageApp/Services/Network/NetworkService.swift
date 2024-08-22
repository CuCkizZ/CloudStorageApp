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
//    static let token = "OAuth y0_AgAAAAB3PvZkAADLWwAAAAELlSb3AADQZy6bNutAiZm4EhJkt3zSpFwhuQ"
    static let header = "Authorization"
    static let idClient = "fb1d2080334243be9be6f947fcde3fa9"
}



final class NetworkService: NetworkServiceProtocol {
    private var newtoken = ""
    static var token = "" 
    var headers: HTTPHeaders = [:]
    
    init() {
        self.headers = [
            "Accept" : "application/json",
            "Authorization" : "OAuth \(NetworkService.token)"
        ]
    }
    
    
    
//cucki327   y0_AgAAAAA_XDUnAAOVdwAAAAENaADxAABTMXcP7xNOjKzXv96i4_Qc-NPOvQ


    
//        y0_AgAAAAB3PvZkAAwfCAAAAAEKyWfKAACyM_xVEBFElqpZe9E8ZcBEdWIOfw
    
    func getToket() {
        
        let oauthToken = "<OAuth-токен>"
       // let jwtSecret = LoginResult.jwt
        
        let headers: HTTPHeaders = [
            "Authorization": "OAuth \(oauthToken)"
        ]
        
        let parameters: Parameters = [
            "format": "json",
           // "jwt_secret": jwtSecret
        ]
        
        AF.request("https://login.yandex.ru/info", parameters: parameters, headers: headers).response { response in
            switch response.result {
            case .success(let value):
                print("Response: \(String(describing: value))")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func fetchDataWithAlamofire(completion: @escaping (Result<Data, NetworkErrors>) -> Void) {
        let urlParams = ["path": "disk:/"]
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources"
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
        let urlParams = ["path": path]
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources"
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
        let urlParams = ["path": "disk:/"]
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded"
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
        let urlString = "https://cloud-api.yandex.net/v1/disk"
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
        let urlStirng = "https://cloud-api.yandex.net/v1/disk/resources/public?type=file"
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
    
    func createNewFolder(name: String) {
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk:/\(name)"
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
        let urlSting = "https://cloud-api.yandex.net/v1/disk/resources/publish?path=\(path)"
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
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources/unpublish?path=\(path)"
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
}


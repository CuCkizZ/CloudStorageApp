//
//  NetworkService.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation
import YandexLoginSDK
import Alamofire

protocol NetworkServiceProtocol {
    func fetchDataWithAlamofire(completion: @escaping (Result<Data, Error>) -> Void)
    func fetchAccountData(completion: @escaping (Result<Data, Error>) -> Void)
    func createNewFolder(_ name: String)
    func deleteFolder(urlString: String, name: String)
    func renameFile(from oldName: String, to newName: String)
    func fetchLastData(completion: @escaping (Result<Data, Error>) -> Void)
}

private enum Constants {
    static let token = "OAuth y0_AgAAAAB3PvZkAADLWwAAAAELlSb3AADQZy6bNutAiZm4EhJkt3zSpFwhuQ"
    static let header = "Authorization"
}



final class NetworkService: NetworkServiceProtocol {
    let headers: HTTPHeaders = [
        "Accept" : "application/json",
        "Authorization" : "OAuth y0_AgAAAAB3PvZkAADLWwAAAAELlSb3AADQZy6bNutAiZm4EhJkt3zSpFwhuQ"
    ]
    
    func fetchDataWithAlamofire(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlParams = ["path": "disk:/"]
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk%3A%2F"
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
//        let urlParams = ["path": "disk:/"]
        let urlString = "hhttps://cloud-api.yandex.net/v1/disk/resources/last-uploaded"
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, /*parameters: urlParams,*/ headers: headers).validate().response {  response in
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
    
    func createNewFolder(_ name: String) {
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk:/\(name)"
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
                let str = String(data: data, encoding: .utf8)
                print("Data: \(str ?? "")")
            }
        }
    }
    
    func deleteFolder(urlString: String, name: String) {
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .delete, headers: headers).response { response in
            guard let statusCode = response.response?.statusCode else { return }
            print("status code: \(statusCode)")
        }
    }
    
    func renameFile(from name: String, to newName: String) {
        let headers: HTTPHeaders = [
            "Authorization": "OAuth your_access_token"
        ]
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources/disk=\(name)"
        let body: [String: String] = [
            "name": newName
        ]

        AF.request(urlString, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().response { response in
            switch response.result {
            case .success:
                print("File renamed successfully")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}



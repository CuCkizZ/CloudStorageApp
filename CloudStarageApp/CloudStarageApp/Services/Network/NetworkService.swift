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
        let urlParams = ["path": "disk:/",]
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
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources"
        guard let url = URL(string: urlString) else { return }
        let urlParams = ["path": "disk:/+\(name)",
                         "cache-control": "no-cache",
                         "content-length": "\(name.count)",
                         "content-type": "application/json; charset=utf-8"]
        
        
        AF.request(url, method: .put, parameters: urlParams, headers: headers).response { response in
            guard let statusCode = response.response?.statusCode else { return }
            print("status code: \(statusCode)")
        }
    }
    
    func deleteFolder(urlString: String, name: String) {
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .delete, headers: headers).response { response in
            guard let statusCode = response.response?.statusCode else { return }
            print("status code: \(statusCode)")
        }
    }
    
}



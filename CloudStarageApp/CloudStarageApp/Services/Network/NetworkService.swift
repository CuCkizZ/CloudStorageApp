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
    static let token = "OAuth y0_AgAAAAB3PvZkAADLWwAAAAELlSb3AADQZy6bNutAiZm4EhJkt3zSpFwhuQ"
    static let header = "Authorization"
}

// https://cloud-api.yandex.net/v1/disk'


class NetworkService {
    
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk%3A%2F"
        guard let url = URL(string: urlString) else { return }
        AF.request("https://api.example.com/endpoint").responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    print(json)
                }
            case .failure(let error):
                print("Ошибка при выполнении запроса: \(error)")
            }
        }
    }
    
    func fetchDataWithAlamofire(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlParams = ["path": "disk:/",]
        
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Authorization" : "OAuth y0_AgAAAAB3PvZkAADLWwAAAAELlSb3AADQZy6bNutAiZm4EhJkt3zSpFwhuQ"
        ]
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk%3A%2F"
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: urlParams, headers: headers).validate().responseData {  response in
            if let error = response.error {
                completion(.failure(error))
                print("Url error")
                return
            }
            guard let data = response.data else { return }
            completion(.success(data))
            print("Alamofire url works")
        }
    }
}



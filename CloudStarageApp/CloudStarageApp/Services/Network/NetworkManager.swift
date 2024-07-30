//
//  NetworkManager.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 26.07.2024.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.allowsJSON5 = true
        return decoder
    }()
    
    private let mapper = Mapper()
    private let client = NetworkService()
    static let shared = NetworkManager()
    
    func fetchData(completion: @escaping (Result<[Item], Error>) -> Void) {
        client.fetchDataWithAlamofire { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(Welcome.self, from: data)
                    completion(.success(result.embedded.items))
                } catch {
                    completion(.failure(error))
                    print("Ошибка при парсе: \(error.localizedDescription)")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Нечего парсить")
            }
        }
    }
    
    func fetchAccountData(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        client.fetchAccountData { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(Account.self, from: data)
                    let profile = self.mapper.mappingProfile(result)
                    completion(.success(profile))
                    print("Acouunt data is okay")
                } catch {
                    completion(.failure(error))
                    print("Ошибка при парсе: \(error.localizedDescription)")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Нечего парсить")
            }
        }
    }
    
    func createNewFolder(_ name: String) {
        let headers: HTTPHeaders = [
            "Authorization" : "OAuth y0_AgAAAAB3PvZkAADLWwAAAAELlSb3AADQZy6bNutAiZm4EhJkt3zSpFwhuQ",
        ]
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk:/\(name)"
        guard let url = URL(string: urlString) else { return }
//        let urlParams = ["path": "disk:/228"]
        
        AF.request(url, method: .put, /*parameters: urlParams,*/ headers: headers).validate().response { response in
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
    
    func deleteReqest(name: String) {
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk:/\(name)"
        client.deleteFolder(urlString: urlString, name: name)
    }
    
}

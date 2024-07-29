//
//  NetworkManager.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 26.07.2024.
//

import Foundation


class NetworkManager {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.allowsJSON5 = true
        return decoder
    }()
    private let client = NetworkService()
    static let shared = NetworkManager()
    
    func fetchData(completion: @escaping (Result<[Item], Error>) -> Void) {
        //client.sendRequest2Request()
        client.fetchDataWithAlamofire { result in
            switch result {
            case .success(let data):
                do {
                   
                    let result = try self.decoder.decode(Welcome.self, from: data)
                    completion(.success(result.embedded.items))
                   // let str = String(data: data, encoding: .utf8)
                    
                    print(result.embedded.items.count)
                } catch {
                    completion(.failure(error))
                    print("Ошибка при парсе: \(error.localizedDescription)")
                    let str = String(data: data, encoding: .utf8)
                    print(str)
                   
                    debugPrint(error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("Нечего парсить")
            }
        }
        
    }
}

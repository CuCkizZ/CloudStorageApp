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
        client.fetchDataWithAlamofire { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(Welcome.self, from: data)
                    completion(.success(result.embedded.items))
                    print(result.embedded.items.count)
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
}

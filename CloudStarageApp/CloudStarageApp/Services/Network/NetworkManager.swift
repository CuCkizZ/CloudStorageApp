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
        client.createNewFolder(name)
    }
    
    func deleteReqest(name: String) {
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk:/\(name)"
        client.deleteFolder(urlString: urlString, name: name)
    }
    
    func renameFile(oldName: String, newName: String) {
        client.renameFile(from: oldName, to: newName)
    }
    
}

//
//  NetworkManager.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 26.07.2024.
//
import YandexLoginSDK
import Foundation
import Alamofire
import UIKit

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
    
    private init() {}
    
    func getToken() {
        client.getToket()
    }
    
    func fetchLastData(completion: @escaping (Result<[LastItem], Error>) -> Void) {
        client.fetchLastData { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(LastWelcome.self, from: data)
                    completion(.success(result.items))
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
    
    func fetchData(completion: @escaping (Result<[Item], Error>) -> Void) {
        client.fetchDataWithAlamofire() { result in
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
    
    func fetchPublicData(completion: @escaping (Result<[PublicItem], Error>) -> Void) {
        client.fetchPublicData { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(PublicWelcome.self, from: data)
                    completion(.success(result.items))
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
    
    func fetchCurentData(path: String, completion: @escaping (Result<[Item], Error>) -> Void) {
        client.fetchCurrentData(path: path) { result in
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
    
    func fetchAccountData(completion: @escaping (Result<ProfileDataSource, Error>) -> Void) {
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
        client.createNewFolder(name: name)
    }
    
    func toPublicFile(path: String) {
        client.toPublicFile(path: path)
    }
    
    
    func unpublishFile(_ path: String) {
        client.unpublishFile(path: path)
    }
    
    func deleteReqest(name: String) {
        let urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=disk:/\(name)"
        client.deleteFolder(urlString: urlString, name: name)
    }
    
    func renameFile(oldName: String, newName: String) {
        client.renameFile(oldName: oldName, newName: newName)
    }
    
    
    
//    func saveLoginResult(_ loginResult: LoginResult) {
//        do {
//            try SharedStorages.loginResultStorage.save(object: loginResult.asDictionary)
//        } catch {
//            print("Failed to save login result: \(error)")
//        }
//    }
//    
//    func getLoginResult() -> LoginResult? {
//        guard let loginResultAsDictionary = try? SharedStorages.loginResultStorage.loadObject() else {
//            return nil
//        }
//        return LoginResult(dictionary: loginResultAsDictionary)
//    }
//    
//    func authenticateAndNavigateToHome(from viewController: UIViewController) {
//        // Проверяем, сохранен ли результат логина
//        guard let loginResult = self.getLoginResult() else {
//            print("No login result found, user might need to login.")
//            return
//        }
//    }
}

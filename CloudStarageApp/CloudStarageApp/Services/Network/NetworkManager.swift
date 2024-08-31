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

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.allowsJSON5 = true
        return decoder
    }()

    private let mapper = Mapper()
    private let client = NetworkService()
    
    private init() {}
    
    func shareFile(with url: URL, completion: @escaping (Result<(URLResponse, Data), Error>) -> Void) {
        AF.request(url, method: .get).validate().response {  response in
            if let error = response.error {
                completion(.failure(error))
            }
            guard let data = response.data, let response = response.response else {
                return
            }
            completion(.success((response, data)))
        }
    }
    
    func fetchLastData(completion: @escaping (Result<([Item]), Error>) -> Void) {
        client.fetchLastData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(Embedded.self, from: data)
                    self.mapper.mapLastCoreData(result)
                    completion(.success((result.items)))
                    print("NetworkDataManagerSaved")
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
                    self.mapper.mapStorageCoreData(result.embedded)
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
    
    func fetchPublicData(completion: @escaping (Result<[Item], Error>) -> Void) {
        client.fetchPublicData() { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(Embedded.self, from: data)
                    completion(.success(result.items))
                    self.mapper.mapPublishedCoreData(result)
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
                    let profile = self.mapper.mapProfile(result)
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
    
    func searchFile(keyword: String, completion: @escaping (Result<[Item], Error>) -> Void) {
        client.searchFiles(keyword: keyword) { result in
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
        client.deleteFile(urlString: urlString, name: name)
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

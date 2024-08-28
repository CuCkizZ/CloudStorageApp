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
    
    func shareFile(with url: URL, completion: @escaping (Result<(URLResponse, Data), Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data, let response = response else {
                print("No data or response")
                return
            }
            completion(.success((response, data)))
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileExtension = (response.suggestedFilename as NSString?)?.pathExtension ?? url.pathExtension
            var tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
        })
        task.resume()
    }
    
    func fetchLastData(completion: @escaping (Result<[Item], Error>) -> Void) {
        client.fetchLastData { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(Embedded.self, from: data)
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
    
    func fetchPublicData(completion: @escaping (Result<[Item], Error>) -> Void) {
        client.fetchPublicData() { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(Embedded.self, from: data)
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

//
//  imageView+NetExtension.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.09.2024.
//

import UIKit
import Alamofire

extension UIImageView {
    
    func afload(urlString: String) {
        let keychain = KeychainManager.shared
        guard let token: String = keychain.get(forKey: StrGlobalConstants.keycheinKey) else { return }
        guard let url = URL(string: urlString) else { return }
        let headers: HTTPHeaders = [
            "Authorization": "OAuth \(token)"
        ]
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            if let image = UIImage(data: cachedResponse.data) {
                DispatchQueue.main.async {
                    self.image = image
                }
                return
            }
        }
                
        AF.request(url, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    print("Failed to convert data to image")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

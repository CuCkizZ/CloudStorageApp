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
        let token = keychain.get(forKey: StrGlobalConstants.keycheinKey)
        guard let url = URL(string: urlString) else { return }
        let headers: HTTPHeaders = [
            "Authorization": "OAuth \(String(describing: token))"
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

//
//  WebViewViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.08.2024.
//

import UIKit
import SnapKit
import WebKit

class WebViewViewController: UIViewController {
    
    private lazy var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
}

private extension WebViewViewController {
    
    func setupLayout() {
        setupView()
        configure()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(webView)
    }
    
    func configure() {
        guard let url = URL(string: "https://downloader.disk.yandex.ru/disk/fac5f44274aa4772a74d55d7015ad8adab2483984dedc7fc636d57f242de9216/66b10228/r9xd80VVeT4Z4J7Fh0iK054hELkeHxrikIUJVoj4CBwTH44pKdtOZI2jImHL0bhcupYtSXcE-1P2Og8vj3vxnQ%3D%3D?uid=2000615012&filename=%D0%90%D0%BA%D1%82%D1%83%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B8%CC%86%20%D1%80%D0%BE%D0%B0%D0%B4%D0%BC%D0%B0%D0%BF%20%D0%BD%D0%B0%20iOS-%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%87%D0%B8%D0%BA%D0%B0%202023_24%20%D0%B3%D0%BE%D0%B4%D0%BE%D0%B2.docx&disposition=attachment&hash=&limit=0&content_type=application%2Fvnd.openxmlformats-officedocument.wordprocessingml.document&owner_uid=2000615012&fsize=485410&hid=2e57cb2a50edcd53d96991b65c7c3968&media_type=document&tknv=v2&etag=696666de7f3d15d880a538c980ff88ca") else { return }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
        
    }
    
    func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


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
    
    func configure(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
}

private extension WebViewViewController {
    
    func setupLayout() {
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(webView)
    }
    
    
    func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


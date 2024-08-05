//
//  PDF.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.08.2024.
//

import UIKit
import PDFKit
import WebKit
import SnapKit

class PDFViewController: UIViewController {
    
    private lazy var pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
    private lazy var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    func configure(_ fileType: String) {
        guard let url = URL(string: fileType) else { return }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let document = PDFDocument(data: data) {
                DispatchQueue.main.async {
                    self.pdfView.document = document
                }
            }
        }
    }
}

private extension PDFViewController {
    
    func setupLayout() {
        setupView()
        //configure()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(pdfView)
    }
    
    
    func setupConstraints() {
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

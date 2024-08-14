//
//  PDF.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.08.2024.
//

import UIKit
import PDFKit
import SnapKit
import WebKit

enum TypeOfConfigDocumentVC {
    case pdf
    case web
}

final class DocumentViewController: UIViewController {
    
    private let viewModel: DocumentViewModel
    private var typeOfView: TypeOfConfigDocumentVC?
    
    private lazy var webView = WKWebView()
    private lazy var pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
    
    init(viewModel: DocumentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func configure(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        title = name
        self.typeOfView = type
        guard let url = URL(string: fileType) else { return }
        switch type {
        case .pdf:
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                if let data = try? Data(contentsOf: url),
                   let document = PDFDocument(data: data) {
                    DispatchQueue.main.async {
                        self.pdfView.document = document
                    }
                }
            }
        case .web:
            let myRequest = URLRequest(url: url)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.webView.load(myRequest)
            }
        }
    }
}

private extension DocumentViewController {
    
    func setupLayout() {
        guard let typeOfView = typeOfView else { return }
        setupView(type: typeOfView)
        setupConstraints(type: typeOfView)
    }
    
    func setupView(type: TypeOfConfigDocumentVC) {
        switch type {
        case .pdf:
            view.addSubview(pdfView)
            pdfView.backgroundColor = .white
        case .web:
            view.addSubview(webView)
            webView.backgroundColor = .white
        }
    }
    
    func setupConstraints(type: TypeOfConfigDocumentVC) {
        switch type {
        case .pdf:
            pdfView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case .web:
            webView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}

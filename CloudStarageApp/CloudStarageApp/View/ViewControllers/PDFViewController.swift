//
//  PDF.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.08.2024.
//

import UIKit
import PDFKit
import SnapKit

class PDFViewController: UIViewController {
    
    private let viewModel: PDFViewModel
    private lazy var pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
    
    init(viewModel: PDFViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupLayout()
    }
    
    func configure() {
        let fyleType = viewModel.fyleType
        guard let url = URL(string: fyleType) else { return }
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

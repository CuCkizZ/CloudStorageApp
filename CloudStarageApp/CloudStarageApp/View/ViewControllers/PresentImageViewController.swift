//
//  PresenImageViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 01.08.2024.
//

import UIKit
import SnapKit
import SDWebImage


final class PresentImageViewController: UIViewController {
    
    private let viewModel: PresentImageViewModelProtocol
    
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var imageView = UIImageView()
    private lazy var shareButton = UIButton()
    private lazy var deleteButton = UIButton()
    

    init(viewModel: PresentImageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        setupLayout()
    }
    
    func configure(_ url: URL) {
        DispatchQueue.main.async {
            self.imageView.sd_setImage(with: url)
            self.activityIndicator.stopAnimating()
            //self.activityIndicator.isHidden = true
        }
        //self.activityIndicator.hidesWhenStopped = true
    }
}

private extension PresentImageViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        setupViews()
        setupButtons()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(imageView)
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        view.addSubview(activityIndicator)
    }
    
    func setupButtons() {
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(300)
        }
        shareButton.snp.makeConstraints { make in
            make.left.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
}

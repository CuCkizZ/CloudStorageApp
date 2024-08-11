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
    private lazy var shareButton = UIButton()
    private lazy var deleteButton = UIButton()
    var viewImage = UIView()
    
    private lazy var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        return scrollView
    }()

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
        viewImage = viewForZooming(in: scrollView)
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        view.addSubview(activityIndicator)
        scrollView.addSubview(imageView)
        scrollView.addSubview(viewImage)
        scrollView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    func setupButtons() {
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView {
        return imageView
    }

    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .changed {
            scrollView.zoomScale *= gestureRecognizer.scale
            gestureRecognizer.scale = 1
        }
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

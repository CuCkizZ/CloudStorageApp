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
    
    private var initialSize: CGSize!
       private let minimumSize: CGFloat = 100.0 // Установите минимальное значение размера здесь

    private lazy var viewImage = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    // private lazy var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
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
        
        setupLayout()
        addGesture()
    }

    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePanGesture))
        viewImage.addGestureRecognizer(pinchGesture)
    }
    
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .changed:
            let newSize = CGSize(width: viewImage.frame.width * gestureRecognizer.scale,
                                 height: viewImage.frame.height * gestureRecognizer.scale)
            
            if newSize.width >= minimumSize && newSize.height >= minimumSize {
                viewImage.transform = viewImage.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
                gestureRecognizer.scale = 1
            } else {
                resetViewSize()
            }
        case .ended, .cancelled, .failed:
            resetViewSize()
        default:
            break
        }
    }
    private func resetViewSize() {
        UIView.animate(withDuration: 0.3) {
            self.viewImage.transform = CGAffineTransform.identity
            self.viewImage.frame.size = self.initialSize
        }
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
        viewImage.backgroundColor = .blue
        setupViews()
        setupButtons()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        view.addSubview(activityIndicator)
        view.addSubview(viewImage)
        viewImage.addSubview(imageView)
        initialSize = viewImage.frame.size
        viewImage.center = view.center
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
            make.edges.equalToSuperview()
        }
        shareButton.snp.makeConstraints { make in
            make.left.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
}

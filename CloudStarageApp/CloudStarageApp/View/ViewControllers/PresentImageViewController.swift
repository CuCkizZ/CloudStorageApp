//
//  PresenImageViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 01.08.2024.
//

import UIKit
import SnapKit
import SDWebImage

enum TypeOfConfigure {
    case lastItem
    case storageItem
    case publicItem
}

final class PresentImageViewController: UIViewController {
    
    private let viewModel: PresentImageViewModelProtocol
    var model: CellDataModel?
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private lazy var nameLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var sizeLabel = UILabel()
    private lazy var infoView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2))
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, dateLabel, sizeLabel])
        stack.axis = .vertical
        stack.alignment = .center
        //stack.backgroundColor = .gray
        return stack
    }()
    
    
    private lazy var infoButton = UIButton()
    private lazy var shareButton = UIButton()
    private lazy var deleteButton = UIButton()
    
    
    private lazy var contentView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var initialSize = CGSize()
    private let minimumSize: CGFloat = 200.0

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
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture))
        doubleTapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(pinchGesture)
        contentView.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func handleDoubleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let isZoomed = contentView.transform.a > 1.0 
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                if isZoomed {
                    self.resetViewSize()
                } else {
                    self.contentView.transform = self.contentView.transform.scaledBy(x: 3, y: 3)
                }
            }
        }
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        switch gestureRecognizer.state {
        case .changed, .ended:
            let newSize = CGSize(width: contentView.frame.width * gestureRecognizer.scale,
                                 height: contentView.frame.height * gestureRecognizer.scale)
            
            if newSize.width >= minimumSize && newSize.height >= minimumSize {
                contentView.transform = contentView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
                gestureRecognizer.scale = 1
            } else {
                resetViewSize()
            }
        case .cancelled, .failed:
            resetViewSize()
        default:
            break
        }
    }
    
    private func resetViewSize() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = CGAffineTransform.identity
            self.contentView.frame.size = self.initialSize
        }
    }
    
    
    func configure(model: CellDataModel) {
        
        nameLabel.text = model.name
        dateLabel.text = model.date + String(describing: model.size)
//        guard let url = URL(string: model.name) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            //self.activityIndicator.isHidden = true
            
            let urlString = model.sizes
            if let originalUrlString = urlString.first(where: { $0.name == "ORIGINAL" })?.url {
                if let url = URL(string: originalUrlString) {
                    self.imageView.sd_setImage(with: url)
                }
            }
        }
        //self.activityIndicator.hidesWhenStopped = true
    }
}

private extension PresentImageViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        infoView.backgroundColor = .gray
//        contentView.backgroundColor = .blue
        setupViews()
        setupButtons()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(activityIndicator)
        view.addSubview(contentView)
        view.addSubview(infoButton)
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        view.addSubview(infoView)
        contentView.addSubview(imageView)
        infoView.addSubview(infoStackView)
        initialSize = contentView.frame.size
        contentView.center = view.center
    }
    
    func setupButtons() {
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up.circle"), for: .normal)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        deleteButton.setImage(UIImage(systemName: "trash.circle"), for: .normal)
    }
    
    @objc func shareButtonTapped() {
        
    }
    
    @objc func deleteButtonTapped() {
        
    }
    
    @objc func infoButtonTapped() {
        UIView.animate(withDuration: 0.4, animations: {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height * 0.33)
        })
    }
    
    private func hideInfoView() {
           UIView.animate(withDuration: 0.4, animations: {
               self.infoView.transform = .identity
           })
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
        infoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        infoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

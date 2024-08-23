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
    
    private lazy var nameLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var sizeLabel = UILabel()
    
    private lazy var nameIcon = UIImageView(image: UIImage(systemName: "doc.richtext"))
    private lazy var dateIcon = UIImageView(image: UIImage(systemName: "calendar.badge.plus"))
    private lazy var sizeIcon = UIImageView(image: UIImage(systemName: "externaldrive"))
    private lazy var infoView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2))
    
    private lazy var iconStacView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameIcon, dateIcon, sizeIcon])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, dateLabel, sizeLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconStacView, infoStackView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    
    
    private lazy var infoButton = UIButton()
    private lazy var shareButton = UIButton()
    private lazy var deleteButton = UIButton()
    
    
    private lazy var view2 = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupLayout()
        addGesture()
    }

    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func handleDoubleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let locationInView = gestureRecognizer.location(in: imageView)
            let isZoomed = imageView.transform.a > 1.0
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                if isZoomed {
                    self.resetViewSize()
                } else {
                    let newSize = self.imageView.transform
                        .translatedBy(x: locationInView.x - self.imageView.bounds.midX, y: locationInView.y - self.imageView.bounds.midY)
                        .scaledBy(x: 3, y: 3)
                        .translatedBy(x: -(locationInView.x - self.imageView.bounds.midX),
                                      y: -(locationInView.y - self.imageView.bounds.midY))
                    self.imageView.transform = newSize

                }
            }
        }
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        switch gestureRecognizer.state {
        case .changed, .ended:
            let newSize = CGSize(width: imageView.frame.width * gestureRecognizer.scale,
                                 height: imageView.frame.height * gestureRecognizer.scale)
            
            if newSize.width >= minimumSize && newSize.height >= minimumSize {
                imageView.transform = imageView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
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
            self.imageView.transform = CGAffineTransform.identity
            self.imageView.frame.size = self.initialSize
        }
    }
    
    
    func configure(model: CellDataModel) {
        nameLabel.text = model.name
        dateLabel.text = model.date
        sizeLabel.text = String(describing: model.size)
        self.activityIndicator.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
//            if let originalUrlString = model.sizes.first(where: { $0.name == "XS" })?.url,
              if let url = URL(string: model.file) {
                
                self.imageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
                    guard let self = self, let image = image else { return }
//                    self.imageView.snp.updateConstraints { make in
//                        make.width.equalTo(image.size.width)
//                        make.height.equalTo(image.size.height)
//                    }
                 
                  self.activityIndicator.stopAnimating()
                  self.activityIndicator.isHidden = true
                    
                }
            }
        }
    }
}

private extension PresentImageViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        setupInfoView()
        setupViews()
        setupButtons()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(activityIndicator)
        view.addSubview(imageView)
        infoView.addSubview(mainStackView)
        initialSize = view.frame.size
        view.addSubview(infoButton)
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        view.addSubview(infoView)
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
    
    func setupInfoView() {
        mainStackView.backgroundColor = .white
    }
    
    @objc func infoButtonTapped() {
        UIView.animate(withDuration: 0.4, animations: {
           self.infoView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height * 0.25)
        })
    }
    
    func hideInfoView() {
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
            make.bottom.equalToSuperview().inset(-120)
            make.height.equalTo(200)
            make.width.equalToSuperview()
        }
        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

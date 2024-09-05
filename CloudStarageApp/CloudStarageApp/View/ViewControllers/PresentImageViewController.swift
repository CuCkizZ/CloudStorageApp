//
//  PresenImageViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 01.08.2024.
//

import UIKit
import SnapKit
import SDWebImage

protocol PresentImageViewControllerProtocol {
    func hideShareView()
}

final class PresentImageViewController: UIViewController {
    
    private var viewModel: PresentImageViewModelProtocol
    
    private var isHidden = true
    private let minimumSize: CGFloat = 300.0
    private lazy var initialSize = CGSize()
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var infoButton = UIButton()
    private lazy var shareButton = UIButton()
    private lazy var deleteButton = UIButton()
    private lazy var shareView = ShareView(viewModel: viewModel, frame: .zero)
    private lazy var infoView = InfoView(viewModel: viewModel, frame: .zero)
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        addGesture()
    }
    
    func configure(model: CellDataModel) {
        self.activityIndicator.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let url = URL(string: model.file) {
                self.imageView.sd_setImage(with: url) { [weak self] _,_,_,_ in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
        infoView.configure(model: model)
        deleteButtonTapped(name: model.name)
        shareButtonTapped(link: model.publicUrl ?? "no url", 
                          file: model.file, 
                          path: model.path,
                          name: model.name)
    }
    
    func path(name: String) {
        viewModel.fetchData(path: name)
        print(path)
    }
    
}

private extension PresentImageViewController {
    
    func setupLayout() {
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .black
        activityIndicator.color = .white
        setupViews()
        hideShareViewByViewModel()
        setupButtons()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(activityIndicator)
        view.addSubview(imageView)
        initialSize = view.frame.size
        
        view.addSubview(infoView)
        view.addSubview(infoButton)
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        view.addSubview(shareView)
    }
    
    func setupButtons() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig), 
                             for: .normal)
        shareButton.addTarget(self, action: #selector(showAndHideShareView), for: .touchUpInside)
       
        infoButton.setImage(UIImage(systemName: "info", withConfiguration: imageConfig), for: .normal)
        infoButton.addTarget(self, action: #selector(showAndHideInfoView), for: .touchUpInside)
        
        deleteButton.setImage(UIImage(systemName: "trash", withConfiguration: imageConfig), for: .normal)
        
    }
    
    func shareButtonTapped(link: String, file: String, path: String, name: String) {
        shareView.configure(link: link, file: file, path: path, name: name)
    }
    
    func deleteButtonTapped(name: String) {
        deleteButton.addAction(UIAction.deleteFile(view: self, viewModel: viewModel, name: name), 
                               for: .touchUpInside)
    }
    
    @objc func showAndHideInfoView() {
        if isHidden == true {
            showInfoView()
        } else {
            hideInfoView()
        }
    }
    
    @objc func showAndHideShareView() {
        if isHidden == true {
            showShareView()
        }
    }
    
    func showInfoView() {
        isHidden = false
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            infoView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(200)
                make.width.equalToSuperview()
            }
            imageView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().inset(-200)
                make.bottom.equalTo(self.infoView.snp.top).inset(-IntConstants.defaultPadding)
            }
            navigationController?.navigationBar.alpha = 0
            shareButton.alpha = 0
            infoButton.alpha = 0
            deleteButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideInfoView() {
        isHidden = true
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            infoView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(-300)
                make.height.equalTo(200)
                make.width.equalToSuperview()
            }
            imageView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            navigationController?.navigationBar.alpha = 1
            shareButton.alpha = 1
            infoButton.alpha = 1
            deleteButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func showShareView() {
        isHidden = false
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.shareView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func hideShareViewByViewModel() {
        viewModel.onButtonShareTapped = { [weak self] in
            guard let self = self else { return }
            self.hideShareView()
        }
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        shareView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(-230)
            make.width.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(-200)
            make.height.equalTo(200)
            make.width.equalToSuperview()
        }
        shareButton.snp.makeConstraints { make in
            make.left.bottom.equalTo(view.safeAreaLayoutGuide).inset(IntConstants.defaultPadding)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(IntConstants.defaultPadding)
        }
        infoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(IntConstants.defaultPadding)
        }
    }
}

//    MARK: GestureRecognizerExtension

private extension PresentImageViewController {
    
    func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture))
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUpGesture))
        let swipeDownToHideInfoGestureImage = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownToHideInfoGesture))
        let swipeDownToHideInfoGestureInfo = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownToHideInfoGesture))
        let tapToHideInfoGesture = UITapGestureRecognizer(target: self, action: #selector(handleSwipeDownToHideInfoGesture))
        let swipeDownToRoot = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownToRoot))
        swipeUpGesture.direction = .up
        swipeDownToHideInfoGestureImage.direction = .down
        swipeDownToHideInfoGestureInfo.direction = .down
        swipeDownToRoot.direction = .down
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(tapToHideInfoGesture)
        imageView.addGestureRecognizer(doubleTapGesture)
        imageView.addGestureRecognizer(swipeUpGesture)
        infoView.addGestureRecognizer(swipeDownToHideInfoGestureInfo)
        imageView.addGestureRecognizer(swipeDownToRoot)
    }
    
    @objc func handleSwipeDownToRoot(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if isHidden == true {
            switch gestureRecognizer.state {
            case .ended:
                swipeToRoot()
            default:
                break
            }
        } else {
            return
        }
    }
    
    @objc func handleSwipeUpGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            showInfoView()
        case .changed:
            showInfoView()
        case .ended:
            showInfoView()
        case .failed, .cancelled, .possible:
            resetViewSize()
        @unknown default:
            break
        }
    }
    
    @objc func handleSwipeDownToHideInfoGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began, .possible:
            hideInfoView()
        case .changed:
            hideInfoView()
        case .ended:
            hideInfoView()
        case .cancelled, .failed, .recognized:
            resetViewSize()
        @unknown default:
            break
        }
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
    
    func resetViewSize() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.imageView.transform = CGAffineTransform.identity
            self.imageView.frame.size = self.initialSize
        }
    }
    
    func swipeToRoot() {
        guard let navigationController = navigationController else { return }
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromBottom
        navigationController.view.layer.add(transition, forKey: kCATransition)
        viewModel.popToRoot()
    }
}


extension PresentImageViewController: PresentImageViewControllerProtocol {
    
    func hideShareView() {
        isHidden = true
        UIView.animate(withDuration: 0.4) {
            self.shareView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(-230)
                make.width.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
}

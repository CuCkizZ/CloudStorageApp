import UIKit
import SnapKit

private let linkImage = "link.badge.plus"
private let fileImage = "arrow.up.doc"
private let linkButtonTitle = String(localized: "Share a link", table: "ButtonsLocalizable")
private let gettinButtonTitle = String(localized: "Getting link", table: "ButtonsLocalizable")
private let fileButtonTitle = String(localized: "Share file", table: "ButtonsLocalizable")

final class ShareView: UIView {
    
    private let viewModel: PresentImageViewModelProtocol
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var stackView = UIStackView(arrangedSubviews: [linkView, fileView])
    private lazy var linkView = UIView()
    private lazy var fileView = UIView()
    private lazy var shareLinkButton = UIButton()
    private lazy var shareFileButton = UIButton()
    private var shareViewModel: Item?
    
    private var link: String?
    private var file: String?
    private var path: String?
    private var name: String?
    
    init(viewModel: PresentImageViewModelProtocol, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupLayout()
        bindView()
        bindShareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(link: String, file: String, path: String, name: String) {
        self.link = link
        self.file = file
        self.path = path
        self.name = name
    }
    
    func bindView() {
        viewModel.shareViewModel.bind { [weak self] item in
            guard let self = self else { return }
            self.shareViewModel = item
        }
    }
    
    func bindShareView() {
        viewModel.isDataLoading.bind { [weak self] isDataLoading in
            guard let self = self, let isDataLoading = isDataLoading else { return }
            DispatchQueue.main.async {
                if isDataLoading {
                    self.activityIndicator.startAnimating()
                    self.shareLinkButton.titleLabel?.text = gettinButtonTitle
                  
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.viewModel.shareLink(link: self.shareViewModel?.publicUrl ?? StrGlobalConstants.linkGettingError)
                    self.viewModel.hideShareView()
                    self.setupButtons()
                }
            }
        }
    }
}

private extension ShareView {
    
    func setupLayout() {
        setupView()
        setupButtons()
        setupShareViews()
        setupStackView()
        addGesture()
        setupConstraints()
    }
    
    func setupView() {
        layer.cornerRadius = 20
        layer.borderWidth = 0.5
        layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        addSubview(stackView)
        linkView.addSubview(shareLinkButton)
        fileView.addSubview(shareFileButton)
        activityIndicator.isHidden = true
        activityIndicator.color = .white
        addSubview(activityIndicator)
    }
    
    func addGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeToHide))
        swipeDown.direction = .down
        self.addGestureRecognizer(swipeDown)
    }
    
    func setupButtons() {
        var linkConfig = UIButton.Configuration.filled()
        var fileConfig = UIButton.Configuration.filled()
        let font = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.Inter.light.size(of: 16)
            return outgoing
        }

        linkConfig.title = linkButtonTitle
        linkConfig.image = UIImage(systemName: linkImage)
        linkConfig.baseBackgroundColor = AppColors.standartBlue
        linkConfig.baseForegroundColor = .white
        linkConfig.titleTextAttributesTransformer = font
        linkConfig.imagePlacement = .leading
        linkConfig.imagePadding = 8
        linkConfig.background.cornerRadius = 12
//        another button
        fileConfig.title = fileButtonTitle
        fileConfig.image = UIImage(systemName: fileImage)
        fileConfig.baseBackgroundColor = .systemGray6
        fileConfig.baseForegroundColor = .black
        fileConfig.titleTextAttributesTransformer = font
        fileConfig.imagePlacement = .leading
        fileConfig.imagePadding = 8
        fileConfig.background.cornerRadius = 12
        
        shareLinkButton.configuration = linkConfig
        shareFileButton.configuration = fileConfig
        
        shareLinkButton.addTarget(self, action: #selector(shareLink), for: .touchUpInside)
        shareFileButton.addTarget(self, action: #selector(shareFile), for: .touchUpInside)
    }
    
    
    func setupShareViews() {
        linkView.backgroundColor = .white
        linkView.layer.cornerRadius = 20
        
        fileView.backgroundColor = .white
        fileView.layer.cornerRadius = 20
    }
    
    func setupStackView() {
        stackView.layer.cornerRadius = 20
        stackView.backgroundColor = .systemGray6
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.layer.cornerRadius = 20
    }
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(shareLinkButton.snp.centerY)
            make.right.equalTo(shareLinkButton.snp.right).inset(90)
        }
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        linkView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(110)
        }
        fileView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(110)
        }
        shareLinkButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
        shareFileButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    //    MARK: @ObjcFunc
    
    @objc func swipeToHide(_ gestureRecgnizer: UISwipeGestureRecognizer) {
        if gestureRecgnizer.state == .ended {
            viewModel.hideShareView()
        }
    }
    
    @objc func shareLink() {
        viewModel.OnButtonTapped.value = true
        guard let path = path else { return }
        viewModel.publishFile(path: path)
    }
    
    @objc func shareFile() {
        guard let file = file,
                let path = path,
                let name = name else
        {
            return
        }
        viewModel.publishFile(path: path)
        viewModel.hideShareView()
        if let file = URL(string: file) {
            viewModel.shareFile(path: file, name: name)
        }
    }
}


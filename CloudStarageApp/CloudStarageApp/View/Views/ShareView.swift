import UIKit
import SnapKit

final class ShareView: UIView {
    
    private let viewModel: PresentImageViewModelProtocol
    
    private lazy var stackView = UIStackView(arrangedSubviews: [linkView, fileView])
    private lazy var linkView = UIView()
    private lazy var fileView = UIView()
    private lazy var shareLinkButton = UIButton()
    private lazy var shareFileButton = UIButton()
    
    var link: String?
    var file: String?
    var path: String?
    
    init(viewModel: PresentImageViewModelProtocol, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(link: String, file: String, path: String) {
        self.link = link
        self.file = file
        self.path = path
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
        
        linkConfig.title = "Share a link"
        linkConfig.image = UIImage(systemName: "link.badge.plus")
        linkConfig.baseBackgroundColor = AppColors.standartBlue
        linkConfig.baseForegroundColor = .white
        linkConfig.titleTextAttributesTransformer = font
        linkConfig.imagePlacement = .leading
        linkConfig.imagePadding = 8
        linkConfig.background.cornerRadius = 12
//        another button
        fileConfig.title = "Share file"
        fileConfig.image = UIImage(systemName: "arrow.up.doc")
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
    
//    TODO: close after tap
    
    @objc func swipeToHide(_ gestureRecgnizer: UISwipeGestureRecognizer) {
        if gestureRecgnizer.state == .ended {
            viewModel.hideShareView()
        }
    }
    
    @objc func shareLink() {
        guard let link = link, let path = path else { return }
        viewModel.publishFile(path: path)
        viewModel.hideShareView()
        viewModel.shareLink(link: link)
    }
    
    @objc func shareFile() {
        guard let file = file, let path = path else { return }
        viewModel.publishFile(path: path)
        viewModel.hideShareView()
        if let file = URL(string: file) {
            viewModel.shareFile(path: file)
        }
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
}


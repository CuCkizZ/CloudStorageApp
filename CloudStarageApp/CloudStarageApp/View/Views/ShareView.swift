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
    
    init(viewModel: PresentImageViewModelProtocol, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(link: String, file: String) {
        self.link = link
        self.file = file
    }
}

private extension ShareView {
    
    func setupLayout() {
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        self.layer.cornerRadius = 20
        self.addSubview(stackView)
        linkView.addSubview(shareLinkButton)
        fileView.addSubview(shareFileButton)
        setupButtons()
        setupShareViews()
        setupStackView()
    }
    
    
    func setupButtons() {
        var linkConfig = UIButton.Configuration.filled()
        var fileConfig = UIButton.Configuration.filled()
        let font = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.Inter.regular.size(of: 16)
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
    
    @objc func shareLink() {
        guard let link = link else { return }
        viewModel.shareLink(link: link)
    }
    
    @objc func shareFile() {
        guard let file = file else { return }
        viewModel.shareFile(file: file)
    }
    
    func setupShareViews() {
        linkView.backgroundColor = .white
        linkView.layer.cornerRadius = 20
        
        fileView.backgroundColor = .white
        fileView.layer.cornerRadius = 20
    }
    
    func setupStackView() {
        stackView.backgroundColor = .systemGray6
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.layer.cornerRadius = 20
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(10)
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


import UIKit
import SnapKit
import Alamofire
import SDWebImage

enum OfflineConfiguration {
    case last
    case storage
    case published
}

final class CollectionViewCell: UICollectionViewCell {
    
    private let viewModel: CellViewModelProtocol = CellViewModel()
    static let reuseID = String(describing: CollectionViewCell.self)
    
    private let activityIndicator = UIActivityIndicatorView()
    private lazy var publishIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "link")
        imageView.tintColor = AppColors.customGray
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.color = .red
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel = UILabel()
    private lazy var sizeLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var timeLabel = UILabel()
    
    private lazy var stackLabel: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.backgroundColor = .clear
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [contentImageView, stackLabel])
        stack.spacing = 16
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentStyle()
    }
    
    func configure(_ model: CellDataModel) {
        nameLabel.attributedText = viewModel.setMaxCharacters(text: model.name)
        
        if let size = model.size {
            dateLabel.text = model.date + viewModel.sizeFormatter(bytes:size)
        } else {
            dateLabel.text = model.date
        }
        
        if model.previewImage == nil {
            contentImageView.image = UIImage(resource: .file)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        } else {
            DispatchQueue.main.async {
                if let urlString = model.previewImage {
                    self.contentImageView.afload(urlString: urlString)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
        if model.publickKey != nil {
            publishIcon.isHidden = false
        } else {
            publishIcon.isHidden = true
        }
    }
    
    func offlineConfigure(_ model: OfflineItems) {
        nameLabel.text = model.name
        dateLabel.text = model.date
        sizeLabel.text = model.size
    }
    
    func storageOffline(_ model: OfflineStorage) {
        nameLabel.text = model.name
        dateLabel.text = model.date
        sizeLabel.text = model.size
    }
    
    func publishedOffline(_ model: OfflinePublished) {
        nameLabel.text = model.name
        dateLabel.text = model.date
        sizeLabel.text = model.size
    }
}

// MARK: PrivateLayoutSetup

private extension CollectionViewCell {
    
    func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.addSubview(stackView)
        contentView.addSubview(publishIcon)
        contentImageView.addSubview(activityIndicator)
        stackView.backgroundColor = .white
        setupLabels()
        setupStackView()
    }
    
    func setupLabels() {
        nameLabel.font = .Inter.regular.size(of: 17)
        sizeLabel.font = .Inter.extraLight.size(of: 14)
        dateLabel.font = .Inter.extraLight.size(of: 14)
        
        nameLabel.textColor = .black
        sizeLabel.textColor = AppColors.customGray
        dateLabel.textColor = AppColors.customGray
        
        dateLabel.backgroundColor = .clear
        sizeLabel.backgroundColor = .clear
    }
    
    func animatedShareIcon() {
        UIView.transition(with: publishIcon, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.publishIcon.isHidden = false
        })
    }
    
    func setupStackView() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.left.equalTo(contentView).inset(30)
            make.top.equalTo(contentView)
        }
        contentImageView.snp.makeConstraints { make in
            make.height.width.equalTo(38)
        }
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        publishIcon.snp.makeConstraints { make in
            make.centerY.right.equalTo(contentView).inset(30)
        }
    }
}
    
extension CollectionViewCell {
    
    func updateContentStyle() {
        let isHorizontalStyle = bounds.width > 2 * bounds.height
        let oldAxis = stackView.axis
        let newAxis: NSLayoutConstraint.Axis = isHorizontalStyle ? .horizontal : .vertical
        guard oldAxis != newAxis else { return }
        
        stackView.axis = newAxis
        stackView.spacing = isHorizontalStyle ? 16 : 4
        nameLabel.textAlignment = isHorizontalStyle ? .left : .center
        dateLabel.textAlignment = isHorizontalStyle ? .left : .center
        let imageSize: CGSize
        if isHorizontalStyle {
            imageSize = CGSize(width: 38, height: 38)
            stackView.snp.updateConstraints() { make in
                make.left.equalTo(contentView).inset(30)
            }
        } else {
            imageSize = CGSize(width: 100, height: 78)
            stackView.snp.updateConstraints() { make in
                make.left.equalTo(contentView)
            }
            stackLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        }
        self.contentImageView.snp.remakeConstraints { make in
            make.size.equalTo(imageSize)
        }
        let fontTransform: CGAffineTransform = isHorizontalStyle ? .identity : CGAffineTransform(scaleX: 0.8, y: 0.8)
        animateLabelTransform(fontTransform: fontTransform)
    }
}

// MARK: AnimationExtension

private extension CollectionViewCell {
    
    func animateLabelTransform(fontTransform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.nameLabel.transform = fontTransform
            self.dateLabel.transform = fontTransform
            self.layoutIfNeeded()
        }
    }
    
    func animatedPublishIcon() {
        UIView.animate(withDuration: 0.3) {
            self.publishIcon.alpha = 1.0
            self.publishIcon.isHidden = false
        }
    }
    func animatedPublishIconTrue() {
        UIView.animate(withDuration: 0.3) {
            self.publishIcon.alpha = 0
            self.publishIcon.isHidden = true
        }
    }
}

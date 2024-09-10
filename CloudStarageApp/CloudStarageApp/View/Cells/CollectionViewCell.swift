import UIKit
import SnapKit

fileprivate let txtType = "text/plain"
fileprivate let pdfType = "application/pdf"
fileprivate let msWordType = "application/msword"
fileprivate let docType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
fileprivate let pngType = "image/png"
fileprivate let jpegType = "image/jpeg"
fileprivate let jpgType = "image/jpg"
fileprivate let xlsType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
fileprivate let videoType = "video/mp4"

final class CollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: CollectionViewCell.self)
    private let viewModel: CellViewModelProtocol = CellViewModel()
    private let linkImage = "link.circle.fill"
    
    
    private let activityIndicator = UIActivityIndicatorView()
    private lazy var defaultImage = UIImage(resource: .folder).withTintColor(AppColors.standartBlue)
    private lazy var publishIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: linkImage)
        imageView.backgroundColor = .white
        imageView.tintColor = AppColors.customGray
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.color = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private var currentImageURL: String?
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
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        DispatchQueue.main.async {
            if let urlString = model.previewImage {
                self.contentImageView.afload(urlString: urlString)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            } else {
                self.contentImageView.image = self.defaultImage
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        if model.publickKey != nil {
            publishIcon.isHidden = false
        } else {
            publishIcon.isHidden = true
        }
    }

    override func prepareForReuse() {
        
    }
    
    private func offlineImages(mimeType: String) {
        switch mimeType {
        case msWordType, docType:
            contentImageView.image = UIImage(resource: .doc).withTintColor(AppColors.standartBlue)
        case jpegType:
            contentImageView.image = UIImage(resource: .image).withTintColor(AppColors.standartBlue)
        case xlsType:
            contentImageView.image = UIImage(resource: .xls).withTintColor(AppColors.standartBlue)
        case pdfType:
            contentImageView.image = UIImage(resource: .pdf).withTintColor(AppColors.standartBlue)
        case videoType:
            contentImageView.image = UIImage(resource: .video).withTintColor(AppColors.standartBlue)
        case txtType:
            contentImageView.image = UIImage(resource: .txt).withTintColor(AppColors.standartBlue)
        default:
            contentImageView.image = defaultImage
        }
    }
    
    func offlineConfigure(_ model: OfflineItems) {
        isOffline()
        guard let name  = model.name else { return }
        guard let date  = model.date else { return }
        nameLabel.attributedText = viewModel.setMaxCharacters(text: name)
        
        if let sizeString = model.size {
            let cleanedSizeString = viewModel.optionalRemove(sizeString: sizeString)
            
            if let size = Int(cleanedSizeString) {
                let formattedDate = viewModel.dateFormatter(dateString: date)
                let formattedSize = viewModel.sizeFormatter(bytes: size)
                dateLabel.text = formattedDate + formattedSize
            } else {
                dateLabel.text = viewModel.dateFormatter(dateString: date)
            }
        } else {
            dateLabel.text = viewModel.dateFormatter(dateString: date)
        }
        guard let type = model.mimeType else { return }
        offlineImages(mimeType: type)
    }
    
    func storageOffline(_ model: OfflineStorage) {
        isOffline()
        guard let name  = model.name else { return }
        guard let date  = model.date else { return }
        nameLabel.attributedText = viewModel.setMaxCharacters(text: name)
        if let sizeString = model.size {
            let cleanedSizeString = viewModel.optionalRemove(sizeString: sizeString)
            
            if let size = Int(cleanedSizeString) {
                let formattedDate = viewModel.dateFormatter(dateString: date)
                let formattedSize = viewModel.sizeFormatter(bytes: size)
                dateLabel.text = formattedDate + formattedSize
            } else {
                dateLabel.text = viewModel.dateFormatter(dateString: date)
            }
        } else {
            dateLabel.text = viewModel.dateFormatter(dateString: date)
        }
        guard let type = model.mimeType else { return }
        offlineImages(mimeType: type)
    }
    
    func publishedOffline(_ model: OfflinePublished) {
        isOffline()
        guard let name  = model.name else { return }
        guard let date  = model.date else { return }
        nameLabel.attributedText = viewModel.setMaxCharacters(text: name)
        if let sizeString = model.size {
            let cleanedSizeString = viewModel.optionalRemove(sizeString: sizeString)
            
            if let size = Int(cleanedSizeString) {
                let formattedDate = viewModel.dateFormatter(dateString: date)
                let formattedSize = viewModel.sizeFormatter(bytes: size)
                dateLabel.text = formattedDate + formattedSize
            } else {
                dateLabel.text = viewModel.dateFormatter(dateString: date)
            }
        } else {
            dateLabel.text = viewModel.dateFormatter(dateString: date)
        }
        guard let type = model.mimeType else { return }
        offlineImages(mimeType: type)
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
    
    func isOffline() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        publishIcon.isHidden = true
    }
    
    func setupStackView() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.left.equalTo(contentView).inset(30)
        }
        contentImageView.snp.makeConstraints { make in
            make.height.width.equalTo(38)
        }
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        publishIcon.snp.makeConstraints { make in
            make.centerY.right.equalTo(contentView).inset(18)
        }
    }
}
    
extension CollectionViewCell {
    
    func updateContentStyle() {
        let isHorizontalStyle = bounds.width > 2 * bounds.height
        let oldAxis = stackView.axis
        let newAxis: NSLayoutConstraint.Axis = isHorizontalStyle ? .horizontal : .vertical
        let imageSize: CGSize
        guard oldAxis != newAxis else { return }
        
        stackView.axis = newAxis
        stackView.spacing = isHorizontalStyle ? 16 : 4
        nameLabel.textAlignment = isHorizontalStyle ? .left : .center
        dateLabel.textAlignment = isHorizontalStyle ? .left : .center
        contentImageView.contentMode = isHorizontalStyle ? .scaleAspectFill : .scaleAspectFit
        if isHorizontalStyle {
            imageSize = CGSize(width: 38, height: 38)
            publishIcon.snp.remakeConstraints { make in
                make.centerY.right.equalTo(contentView).inset(18)
            }
            stackView.snp.updateConstraints() { make in
                make.left.equalTo(contentView).inset(30)
            }
        } else {
            imageSize = CGSize(width: 100, height: 78)
            stackView.snp.updateConstraints() { make in
                make.left.equalTo(contentView)
            }
            publishIcon.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(5)
                make.bottom.equalToSuperview().inset(12)
            }
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
}

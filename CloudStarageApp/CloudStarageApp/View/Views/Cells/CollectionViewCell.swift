import UIKit
import SnapKit
import Kingfisher
import SDWebImage

final class CollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: CollectionViewCell.self)
    
    private lazy var publishIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "link")
        imageView.tintColor = AppColors.customGray
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var nameLabel = UILabel()
    private lazy var sizeLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var timeLabel = UILabel()
    
    private lazy var stackLabel: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        stack.axis = .vertical
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
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentStyle()
    }
    
    func configure(_ model: CellDataModel) {
        if let size = model.size {
            dateLabel.text = model.date + " \(size / 1000) кб"
        } else {
            dateLabel.text = model.date
        }
        nameLabel.text = model.name
        DispatchQueue.main.async {
            if let previewImage = model.previewImage, let url = URL(string: previewImage) {
                self.contentImageView.load(url: url)
            } else {
                self.contentImageView.image = nil
            }
        }
        if model.publickKey != nil {
            publishIcon.isHidden = false
        } else {
            publishIcon.isHidden = true
        }
    }
}

// MARK: PrivateLayoutSetup

private extension CollectionViewCell {
    
    func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.addSubview(stackView)
        contentView.addSubview(publishIcon)
        stackView.backgroundColor = .white
        setupLabels()
    }
    
    func setupLabels() {
        nameLabel.font = .Inter.regular.size(of: 17)
        sizeLabel.font = .Inter.extraLight.size(of: 14)
        dateLabel.font = .Inter.extraLight.size(of: 14)
        
        nameLabel.textColor = .black
        sizeLabel.textColor = AppColors.customGray
        dateLabel.textColor = AppColors.customGray
    }
    
    func setupStackView() {
        stackView.snp.makeConstraints { make in
            make.left.top.equalTo(contentView)
        }
        contentImageView.snp.makeConstraints { make in
            make.height.width.equalTo(33)
        }
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        publishIcon.snp.makeConstraints { make in
            make.right.centerY.equalTo(contentView).inset(30)
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
            imageSize = CGSize(width: 33, height: 33)
        } else {
            imageSize = CGSize(width: 78, height: 75)
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImageView {
    func setImage(urlString: String) {
        self.kf.setImage(with: URL(string: urlString))
    }
}

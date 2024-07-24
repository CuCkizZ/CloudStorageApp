import UIKit
import SnapKit

final class CollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: CollectionViewCell.self)
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .file)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel = UILabel()
    private lazy var sizeLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var timeLabel = UILabel()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [contentImageView, nameLabel])
        stack.spacing = 16
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupStackView()
        clipsToBounds = true
       
        //setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentStyle()
    }
    
    func setupCell() {
        contentView.backgroundColor = .white
        
        contentView.layer.masksToBounds = true
       
        contentView.addSubview(stackView)
        stackView.backgroundColor = .white
//        contentView.addSubview(contentImageView)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(sizeLabel)
//        contentView.addSubview(dateLabel)
        
        setupLabels()
        
    }
    
    func configure(_ model: Files) {
        nameLabel.text = model.name
        sizeLabel.text = model.size
        dateLabel.text = model.date
        contentImageView.image = model.icon
    }
    
}

private extension CollectionViewCell {
    
    func setupLabels() {
        nameLabel.font = .Inter.regular.size(of: 15)
        sizeLabel.font = .Inter.extraLight.size(of: 13)
        dateLabel.font = .Inter.extraLight.size(of: 13)
        
        nameLabel.textColor = .black
        sizeLabel.textColor = AppColors.customGray
        dateLabel.textColor = AppColors.customGray
    }
    
    func setupStackView() {
        stackView.snp.makeConstraints { make in
            make.left.top.equalTo(contentView)
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
        let imageSize: CGSize
        if isHorizontalStyle {
            // horizontal orientation
            imageSize = CGSize(width: 25, height: 22)
        } else {
            // vertical orientation
            imageSize = CGSize(width: 78, height: 75)
        }
        self.contentImageView.snp.remakeConstraints { make in
            make.size.equalTo(imageSize)
        }
    
        
        let fontTransform: CGAffineTransform = isHorizontalStyle ? .identity : CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3) {
            self.nameLabel.transform = fontTransform
            
            self.layoutIfNeeded()
    }
}
    
//    func setupConstraints() {
//        
//        contentImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().inset(16)
//            make.height.equalTo(22)
//            make.width.equalTo(25)
//        }
//        nameLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.equalTo(contentImageView.snp.right).inset(-16)
//        }
//        sizeLabel.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().inset(1)
//            make.left.equalTo(contentImageView.snp.right).inset(-16)
//        }
//        dateLabel.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().inset(1)
//            make.left.equalTo(sizeLabel.snp.right).inset(-5)
//        }
//    }
    
}

import UIKit
import SnapKit
import Kingfisher
import SDWebImage

final class CollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: CollectionViewCell.self)
    
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
        setupCell()
        setupStackView()
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
    
    func configure(_ model: CellDataModel) {
        nameLabel.text = model.name
        //        sizeLabel.text = model.size
        dateLabel.text = model.date
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: "https://downloader.disk.yandex.ru/preview/f5aec057c18393a4537999e10b9d09b8545d66d4b2d73f4b9a1574b0b17cf9fe/inf/hSygf6tcyNZAohUKEgjoiKvzyIaBVUhB68HRB3_xAmpWurmS45p3rImzhATaQbHxgvaizAOzGn5vu5d_CyfHHQ%3D%3D?uid=2000615012&filename=%D0%A2%D0%B5%D1%85%D0%BD%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B5%20%D0%B7%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5%20%281%29.pdf&disposition=inline&hash=&limit=0&content_type=image%2Fjpeg&owner_uid=2000615012&tknv=v2&size=S&crop=0") else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                self.contentImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    func publickConfigure(_ model: PublicItem) {
        nameLabel.text = model.name
        dateLabel.text = model.created
    }
    
}

private extension CollectionViewCell {
    
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
        
        UIView.animate(withDuration: 0.3) {
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

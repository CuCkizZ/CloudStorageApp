import UIKit
import SnapKit

//protocol PageProtocol: AnyObject {
//    func configure(_ text: String, _ image: String) -> UIViewController
//}

final class OnboardingPageViewController: UIViewController {
        
    private lazy var greetingImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .Inter.light.size(of: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [greetingImage, textLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    func configure(_ text: String, _ image: String) {
        textLabel.text = text
        greetingImage.image = UIImage(named: image)
    }
}

private extension OnboardingPageViewController {
    
    func setupView() {
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        textLabel.snp.makeConstraints { make in
            make.width.equalTo(243)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

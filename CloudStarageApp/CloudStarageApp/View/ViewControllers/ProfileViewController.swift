import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModelProtocol
    private var dataSource = Profile.get()
    
    private lazy var titleLabel: TitleLabel = {
        let label = TitleLabel()
        label.text = "Profile"
        return label
    }()
    
    private var totalStorageLabel = UILabel()
    private let usedStorageLabel = UILabel()
    private let leftStorageLabel = UILabel()
    
    private let usedImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let storageCircleView = UIImageView()
    
    private lazy var totalShapeLayer = CAShapeLayer()
    private lazy var usageShapeLayer = CAShapeLayer()
    private let downloadButton = UIButton()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupLayout()
        updateViewLayer()
        setupLabel()
    }
}

private extension ProfileViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(totalStorageLabel)
        view.addSubview(usedStorageLabel)
        view.addSubview(leftStorageLabel)
        view.addSubview(usedImageView)
        view.addSubview(leftImageView)
        view.addSubview(downloadButton)
        setupViews()
        setupConstraints()
        setupShapeLayer()
        configure(model: dataSource)
    }
    
    func setupViews() {
        setupButton()
        leftImageView.image = UIImage(resource: .playstore)
        usedImageView.image = UIImage(resource: .playstore)
    
        
    }
    
    func configure(model: ProfileModel) {
        
        let intT = Int(model.total)
        let intL = Int(model.left)
        let intU = Int(model.usage)
        totalStorageLabel.text = String(describing: intT) + "гб"
        leftStorageLabel.text = "\(intL) гб - свободно"
        usedStorageLabel.text = "\(intU) гб - занято"
    }
    
    func setupLabel() {
        totalStorageLabel.textColor = .black
        leftStorageLabel.textColor = .black
        usedStorageLabel.textColor = .black
        
        totalStorageLabel.font = .Inter.regular.size(of: 50)
        leftStorageLabel.font = .Inter.regular.size(of: 12)
        usedStorageLabel.font = .Inter.regular.size(of: 12)
        totalStorageLabel.layer.zPosition = 1
    }
    
    func setupButton() {
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.black, for: .normal)
        downloadButton.backgroundColor = .white
        downloadButton.layer.cornerRadius = 12
        downloadButton.layer.shadowColor = UIColor.black.cgColor
        downloadButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        downloadButton.layer.shadowRadius = 4
        downloadButton.layer.shadowOpacity = 0.3
        downloadButton.layer.masksToBounds = false
        
        //downloadButton.addTarget(self, action: #selector(updateShapeLayer), for: .touchUpInside)
    }
    
    func updateViewLayer() {
        let usageSt = CGFloat(dataSource.usage / 20)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = totalShapeLayer.strokeEnd
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        totalShapeLayer.strokeEnd = 1
        totalShapeLayer.add(animation, forKey: "strokeEnd")
        
        animation.fromValue = usageShapeLayer.strokeEnd
        animation.toValue = usageSt
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        usageShapeLayer.strokeEnd = usageSt
        usageShapeLayer.add(animation, forKey: "strokeEnd")
    }
    
//    MARK: ButtonMethod

    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(16)
        }
        totalStorageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        
        usedImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(usedImageView.snp.bottom).inset(-10)
            make.height.width.equalTo(30)
        }
        usedStorageLabel.snp.makeConstraints { make in
            make.left.equalTo(usedImageView.snp.right).inset(-10)
            make.centerY.equalToSuperview()
        }
        leftStorageLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).inset(-10)
            make.top.equalTo(usedStorageLabel.snp.bottom).inset(-20)
        }
        downloadButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(leftStorageLabel.snp.bottom).inset(-50)
            
        }
    }
}

// MARK: ShapeLayoutSetupExtension

extension ProfileViewController {
    func setupShapeLayer() {
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 150)
        let radius = min(view.bounds.width, view.bounds.height) / 4
        let usagePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        let totalPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        usageShapeLayer.path = usagePath.cgPath
        usageShapeLayer.fillColor = UIColor.clear.cgColor
        usageShapeLayer.lineJoin = .round
        usageShapeLayer.strokeColor = AppColors.storagePink.cgColor
        usageShapeLayer.lineWidth = 40
        usageShapeLayer.strokeStart = 0.000001
        usageShapeLayer.strokeEnd = 0.000000
    
        totalShapeLayer.path = totalPath.cgPath
        totalShapeLayer.fillColor = UIColor.white.cgColor
        totalShapeLayer.strokeColor = AppColors.customGray.cgColor
        totalShapeLayer.lineWidth = 40
        totalShapeLayer.strokeStart = 0.000001
        totalShapeLayer.strokeEnd = 1

        view.layer.addSublayer(totalShapeLayer)
        view.layer.addSublayer(usageShapeLayer)
    }
}

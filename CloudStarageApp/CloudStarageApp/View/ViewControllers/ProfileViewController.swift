import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModelProtocol
    private var dataSource: ProfileModel?
    private let activityIndicator = UIActivityIndicatorView()
    
    private var totalStorageLabel = UILabel()
    private let usedStorageLabel = UILabel()
    private let leftStorageLabel = UILabel()
    private let usedImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let storageCircleView = UIImageView()
    private let downloadButton = UIButton()
    private lazy var totalShapeLayer = CAShapeLayer()
    private lazy var usageShapeLayer = CAShapeLayer()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupLayout()
        updateViewLayer()
        setupLabel()
        bindViewModel()
        bindView()
    }
    
    private func bindView() {
        viewModel.onDataLoaded = { [weak self] in
            guard let self = self else { return }
            self.configure()
        }
    }
    
    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

// MARK: Private Methods

private extension ProfileViewController {
    
    func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(totalStorageLabel)
        view.addSubview(usedStorageLabel)
        view.addSubview(leftStorageLabel)
        view.addSubview(usedImageView)
        view.addSubview(leftImageView)
        view.addSubview(downloadButton)
        setupViews()
        SetupNavBar()
        setupConstraints()
        setupShapeLayer()
        //configure(model: dataSource!)
    }
    
    func setupViews() {
        setupButton()
        leftImageView.image = UIImage(resource: .playstore)
        usedImageView.image = UIImage(resource: .playstore)
    }
    
    func SetupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .actions, style: .plain, target: self, action: #selector(rightBarButtonAction))
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Profile"
    }
    
    @objc func rightBarButtonAction() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { action in
            self.viewModel.logOut()
        }))
        present(alert, animated: true)
    }
    
    func configure() {
        guard let model = viewModel.dataSource else { return }
        let intT = Int((model.totalSpace) / 1000000000)
        let intL = Float(model.leftSpace) / 1000000000
        let intU = Float(model.usedSpace) / 1000000000
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
        downloadButton.setTitle("Public Files", for: .normal)
        downloadButton.setTitleColor(.black, for: .normal)
        downloadButton.backgroundColor = .white
        downloadButton.layer.cornerRadius = 12
        downloadButton.layer.shadowColor = UIColor.black.cgColor
        downloadButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        downloadButton.layer.shadowRadius = 4
        downloadButton.layer.shadowOpacity = 0.3
        downloadButton.layer.masksToBounds = false
        
        downloadButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func updateViewLayer() {
        guard let model = viewModel.dataSource else { return }
        let totalSpace = (model.totalSpace / 1000000000) 
        let usageSt = CGFloat(model.usedSpace / 1000000000) / 4
        print(totalSpace)
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
    
    @objc func buttonTapped() {
       
    }

    func setupConstraints() {
        totalStorageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(110)
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

//extension Float {
//    func rounded(toPlaces places: Int) -> Float {
//        let divisor = pow(10.0, Float(places))
//        return (self * divisor).rounded() / divisor
//    }


import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModelProtocol
    private var dataSource: ProfileDataSource?
    private let activityIndicator = UIActivityIndicatorView()
    
    private var totalStorageLabel = UILabel()
    private let usedStorageLabel = UILabel()
    private let leftStorageLabel = UILabel()
    private let usedImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let storageCircleView = UIImageView()
    private let goToPublicButton = UIButton()
    private lazy var totalShapeLayer = CAShapeLayer()
    private lazy var usageShapeLayer = CAShapeLayer()
    
    private let networkStatusView = UIView()
    
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
        
        bindNetworkMonitor()
        setupNetworkStatusView(networkStatusView)
        
        setupLayout()
        updateViewLayer()
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
    
    func bindNetworkMonitor() {
        setupNetworkStatusView(networkStatusView)
        viewModel.isConnected.bind { [weak self] isConnected in
            guard let self = self, let isConndeted = isConnected else { return }
            DispatchQueue.main.async {
                if isConndeted {
                    self.hideNetworkStatusView(self.networkStatusView)
                } else {
                    self.showNetworkStatusView(self.networkStatusView)
                }
            }
        }
    }
    
    @objc func rightBarButtonAction() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            self.viewModel.logout()
        }))
        present(alert, animated: true)
    }
    
    @objc func logout() {
        viewModel.logout()
    }
}

// MARK: Private Methods

private extension ProfileViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(totalStorageLabel)
        view.addSubview(usedStorageLabel)
        view.addSubview(leftStorageLabel)
        view.addSubview(usedImageView)
        view.addSubview(leftImageView)
        view.addSubview(goToPublicButton)
        setupViews()
        SetupNavBar()
        setupConstraints()
        setupShapeLayer()
        setupLabel()
        //configure(model: dataSource!)
    }
    
    func setupViews() {
        setupButton()
        leftImageView.image = UIImage(resource: .playstore)
        usedImageView.image = UIImage(resource: .playstore)
    }
    
    func SetupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationItem.leftBarButtonItem = navigationController.setLeftButton()
        navigationController.navigationBar.prefersLargeTitles = true
        title = "Profile"
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
        goToPublicButton.setTitle("Public Files", for: .normal)
        goToPublicButton.setTitleColor(.black, for: .normal)
        goToPublicButton.backgroundColor = .white
        goToPublicButton.layer.cornerRadius = 12
        goToPublicButton.layer.shadowColor = UIColor.black.cgColor
        goToPublicButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        goToPublicButton.layer.shadowRadius = 4
        goToPublicButton.layer.shadowOpacity = 0.3
        goToPublicButton.layer.masksToBounds = false
        
        goToPublicButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    //    MARK: Present Published Files
    
    @objc func buttonTapped() {
        viewModel.pushToPublic()
    }
    
    func updateViewLayer() {
        guard let model = viewModel.dataSource else { return }
        
        // let totalSpaceInGB = CGFloat(model.totalSpace) / 1000000000
        let usedSpaceFraction = CGFloat(model.usedSpace) / CGFloat(model.totalSpace)
        
        animateLayer(layer: totalShapeLayer, toValue: 1)
        animateLayer(layer: usageShapeLayer, toValue: usedSpaceFraction)
    }
    
    private func animateLayer(layer: CAShapeLayer, toValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = layer.strokeEnd
        animation.toValue = toValue
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.strokeEnd = toValue
        layer.add(animation, forKey: "strokeEnd")
    }
    
    
    func setupShapeLayer() {
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 150)
        let radius = min(view.bounds.width, view.bounds.height) / 4
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi - CGFloat.pi / 2
        
        configureShapeLayer(shapeLayer: totalShapeLayer, center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, strokeColor: AppColors.customGray.cgColor)
        configureShapeLayer(shapeLayer: usageShapeLayer, center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, strokeColor: AppColors.storagePink.cgColor, lineCap: .round)
        
        view.layer.addSublayer(totalShapeLayer)
        view.layer.addSublayer(usageShapeLayer)
    }
    
    private func configureShapeLayer(shapeLayer: CAShapeLayer, 
                                     center: CGPoint,
                                     radius: CGFloat,
                                     startAngle: CGFloat,
                                     endAngle: CGFloat, 
                                     strokeColor: CGColor,
                                     lineCap: CAShapeLayerLineCap = .butt) {
        let path = UIBezierPath(arcCenter: center, radius: radius,
                                startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = 40
        shapeLayer.lineCap = .round
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0
    }
    
    func setupConstraints() {
        totalStorageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(110)
        }
        usedImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        leftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(usedImageView.snp.bottom).offset(10)
            make.size.equalTo(30)
        }
        usedStorageLabel.snp.makeConstraints { make in
            make.left.equalTo(usedImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        leftStorageLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.top.equalTo(usedStorageLabel.snp.bottom).offset(20)
        }
        goToPublicButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(leftStorageLabel.snp.bottom).offset(50)
        }
    }
}

extension ProfileViewController {
    func setupLogout() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .profileTab, style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc func logoutTapped() {
        viewModel.logout()
    }
}

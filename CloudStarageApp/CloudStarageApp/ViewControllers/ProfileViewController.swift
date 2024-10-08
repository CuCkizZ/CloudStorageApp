import UIKit
import SnapKit

private let goToPublicTitle = String(localized: "Published files", table: "ButtonsLocalizable")
private let animationKey = "strokeEnd"
private let startAnimation = "start"
private let endAnimation = "end"

final class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModelProtocol
    private var dataSource: ProfileDataSource? = nil
    private var isOffline: Bool = false
    private lazy var totalLabelActivityIndicator = UIActivityIndicatorView()
    private lazy var usageLabelActivityIndicator = UIActivityIndicatorView()
    private lazy var leftLabelActivityIndicator = UIActivityIndicatorView()
    
    private lazy var totalStorageLabel = UILabel()
    private lazy var usedStorageLabel = UILabel()
    private lazy var leftStorageLabel = UILabel()
    private lazy var buttonTitleLabel = UILabel()
    private lazy var usedImageView = UIImageView()
    private lazy var leftImageView = UIImageView()
    private lazy var storageCircleView = UIView(frame: CGRect(x: 0, y: 0, width: 210, height: 210))
    private lazy var arrowImageView = UIImageView()
    private lazy var goToPublicButton = UIButton()
    private lazy var totalShapeLayer = CAShapeLayer()
    private lazy var usageShapeLayer = CAShapeLayer()
    
    private lazy var networkStatusView = UIView()
    
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
        bindViewModel()
        bindView()
    }
}
    
//    MARK: BindViewExtension
    
private extension ProfileViewController {
    
    func bindView() {
        viewModel.onDataLoaded = { [weak self] in
            guard let self = self else { return }
            self.dataSource = viewModel.dataSource
        }
    }
    
    func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.configureWhileIsLoading(state: startAnimation)
                } else {
                    self.configureWhileIsLoading(state: endAnimation)
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
                    self.isOffline = false
                    self.updateViewLayer()
                    self.configure()
                } else {
                    self.showNetworkStatusView(self.networkStatusView)
                    self.isOffline = true
                    self.updateViewLayer()
                    self.viewModel.FetchedResultsController()
                    self.configure()
                }
            }
        }
    }
}

// MARK: Private Methods

private extension ProfileViewController {
    
    func setupLayout() {
        setupViews()
        SetupNavBar()
        setupLogout()
        setupLabel()
        setupButton()
        setupImages()
        setupShapeLayer()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(totalStorageLabel)
        view.addSubview(usedStorageLabel)
        view.addSubview(leftStorageLabel)
        view.addSubview(usedImageView)
        view.addSubview(leftImageView)
        view.addSubview(goToPublicButton)
        view.addSubview(storageCircleView)
        view.addSubview(usageLabelActivityIndicator)
        view.addSubview(leftLabelActivityIndicator)
        storageCircleView.addSubview(totalLabelActivityIndicator)
        goToPublicButton.addSubview(arrowImageView)
        goToPublicButton.addSubview(buttonTitleLabel)
    }
    
    func SetupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        title = StrGlobalConstants.profileTitle
    }
    
    func configure() {
        switch isOffline {
        case false:
            let formatter = viewModel.labelsFormatter()
            totalStorageLabel.text = formatter[0]
            leftStorageLabel.text = formatter[1]
            usedStorageLabel.text =  formatter[2]
        case true:
            let formatter = viewModel.labelsFormatter()
            totalStorageLabel.text = formatter[0]
            leftStorageLabel.text = formatter[1]
            usedStorageLabel.text =  formatter[2]
        }
    }
    
    func configureWhileIsLoading(state: String) {
        switch state {
        case startAnimation:
            totalStorageLabel.isHidden = true
            usedStorageLabel.isHidden = true
            leftStorageLabel.isHidden = true
            totalLabelActivityIndicator.startAnimating()
            usageLabelActivityIndicator.startAnimating()
            leftLabelActivityIndicator.startAnimating()
        case endAnimation:
            totalLabelActivityIndicator.isHidden = true
            usageLabelActivityIndicator.isHidden = true
            leftLabelActivityIndicator.isHidden = true
            totalLabelActivityIndicator.stopAnimating()
            usageLabelActivityIndicator.stopAnimating()
            leftLabelActivityIndicator.stopAnimating()
            totalStorageLabel.isHidden = false
            usedStorageLabel.isHidden = false
            leftStorageLabel.isHidden = false
        default:
            break
        }
    }
    
    func setupLabel() {
        totalStorageLabel.textColor = .black
        leftStorageLabel.textColor = .black
        usedStorageLabel.textColor = .black
        buttonTitleLabel.textColor = .black
        
        totalStorageLabel.font = .Inter.medium.size(of: 19)
        leftStorageLabel.font = .Inter.regular.size(of: 15)
        usedStorageLabel.font = .Inter.regular.size(of: 15)
        buttonTitleLabel.font = .Inter.regular.size(of: 17)
        totalStorageLabel.layer.zPosition = 1
    }
    
    func setupImages() { /*TODO: Change image to HD*/
        leftImageView.image = UIImage(resource: .leftEllipse)
        usedImageView.image = UIImage(resource: .usageEllipse)
        arrowImageView.image = UIImage(resource: .arrow)
    }
    
    func setupButton() {
        buttonTitleLabel.text = goToPublicTitle
        goToPublicButton.setTitleColor(.black, for: .normal)
        goToPublicButton.backgroundColor = .white
        goToPublicButton.layer.cornerRadius = 10
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
        switch isOffline {
        case true:
            guard let offline = viewModel.fetchOfflineProfile() else { return }
            let usedSpaceFraction = CGFloat(offline.usedSpace) / CGFloat(offline.totalSpace)
            
            animateLayer(layer: totalShapeLayer, toValue: 1)
            animateLayer(layer: usageShapeLayer, toValue: usedSpaceFraction)
        case false:
            guard let model = viewModel.dataSource else { return }
            let usedSpaceFraction = CGFloat(model.usedSpace) / CGFloat(model.totalSpace)
            
            animateLayer(layer: totalShapeLayer, toValue: 1)
            animateLayer(layer: usageShapeLayer, toValue: usedSpaceFraction)
        }
    }
    
    private func animateLayer(layer: CAShapeLayer, toValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: animationKey)
        animation.fromValue = layer.strokeEnd
        animation.toValue = toValue
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.strokeEnd = toValue
        layer.add(animation, forKey: animationKey)
    }
    
    
    func setupShapeLayer() {
        let center = CGPoint(x: storageCircleView.bounds.midX, y: storageCircleView.bounds.midY)
        let radius = min(storageCircleView.bounds.width, storageCircleView.bounds.height) / 3 + 10
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi - CGFloat.pi / 2
        
        configureShapeLayer(shapeLayer: totalShapeLayer, center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, strokeColor: AppColors.customGray.cgColor)
        configureShapeLayer(shapeLayer: usageShapeLayer, center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, strokeColor: AppColors.storagePink.cgColor, lineCap: .round)
        storageCircleView.layer.addSublayer(totalShapeLayer)
        storageCircleView.layer.addSublayer(usageShapeLayer)
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
        totalLabelActivityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        usageLabelActivityIndicator.snp.makeConstraints { make in
            make.top.equalTo(storageCircleView.snp.bottom).inset(-30)
            make.left.equalTo(usedImageView.snp.right).offset(50)
        }
        leftLabelActivityIndicator.snp.makeConstraints { make in
            make.top.equalTo(usedStorageLabel.snp.bottom).offset(24)
            make.left.equalTo(leftImageView.snp.right).offset(50)
        }
        storageCircleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        storageCircleView.widthAnchor.constraint(equalToConstant: 210),
        storageCircleView.heightAnchor.constraint(equalToConstant: 210),
        storageCircleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        storageCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
        totalStorageLabel.snp.makeConstraints { make in
            make.center.equalTo(storageCircleView.snp.center)
        }
        usedImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(35)
            make.top.equalTo(storageCircleView.snp.bottom).inset(-30)
            make.size.equalTo(21)
        }
        leftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(35)
            make.top.equalTo(usedImageView.snp.bottom).offset(21)
            make.size.equalTo(21)
        }
        usedStorageLabel.snp.makeConstraints { make in
            make.top.equalTo(storageCircleView.snp.bottom).inset(-30)
            make.left.equalTo(usedImageView.snp.right).offset(8)
        }
        leftStorageLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).offset(8)
            make.top.equalTo(usedStorageLabel.snp.bottom).offset(24)
        }
        goToPublicButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(leftStorageLabel.snp.bottom).offset(50)
            make.height.equalTo(45)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(goToPublicButton.snp.right).inset(18)
        }
        buttonTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(goToPublicButton.snp.left).inset(18)
        }
    }
}

extension ProfileViewController {
    func setupLogout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .profileTab, style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: StrGlobalConstants.logoutSheetTitle,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: StrGlobalConstants.cancleButton, style: .cancel, handler: { action in
            return
        }))
        alert.addAction(UIAlertAction(title: StrGlobalConstants.logoutTitle, style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            let confirmAlert = UIAlertController(title: StrGlobalConstants.logoutTitle,
                                                 message: StrGlobalConstants.AlertsAndActions.logOutAlertTitle,
                                                 preferredStyle: .alert)
            confirmAlert.addAction(UIAlertAction(title: StrGlobalConstants.yes, style: .default, handler: { action in
                self.viewModel.logout()
            }))
            confirmAlert.addAction(UIAlertAction(title: StrGlobalConstants.no, style: .destructive))
            present(confirmAlert, animated: true)
        }))
        present(alert, animated: true)
    }
}


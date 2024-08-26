import UIKit
import SnapKit
import YandexLoginSDK
import Alamofire

protocol LoginViewInput: AnyObject {
    func onSighInTapped()
    func onSignUpTapped()
}

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewOutput
    
    private var customValues: [String: String] = [:]
    
    private var loginResult: LoginResult? {
        didSet {
            logoutButton.isEnabled = (loginResult != nil)
        }
    }
    
    private lazy var bottomButtomCT = NSLayoutConstraint()
    private lazy var bottomStackViewCT = NSLayoutConstraint()
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingView = UIView()
    
    
    private let loginButton = CSBlueButton()
    
    private let yandexButton = YandexButton()
    private let infoButton = CSBlueButton()
    private let logoutButton = CSBlueButton()
    
    
    
    init(viewModel: LoginViewOutput) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.setTitle("logout")
        yandexButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        YandexLoginSDK.shared.add(observer: self)
        setupView()
    }
    
    func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.loadAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                    self.stopAnimating()
                }
            }
        }
    }
}

// MARK: Private Setup Methods

private extension LoginViewController {
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(loadingView)
        view.addSubview(activityIndicator)
        
        view.addSubview(infoButton)
        view.addSubview(loginButton)
        view.addSubview(logoutButton)
        view.addSubview(yandexButton)
        
        setupButton()
        setupConstraints()
        bindViewModel()
        SetupNavBar()
    }
    
    func SetupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Drive In"
    }
    
    func setupButton() {
        loginButton.action = { [weak self] in
            guard let self = self else { return }
            self.buttonPressed()
        }
        logoutButton.action = { [weak self] in
            guard let self = self else { return }
            self.logoutButtonPressed()
        }
    }
    
    @objc func presentLogin() {
        let alertController: UIAlertController
        
        if let loginResult = loginResult {
            alertController = UIAlertController(
                title: "Login Result",
                message: loginResult.asString,
                preferredStyle: .alert
            )
            let copyAction = UIAlertAction(title: "Copy and Close", style: .default) { _ in
                UIPasteboard.general.string = loginResult.asString
            }
            alertController.addAction(copyAction)
        } else {
            alertController = UIAlertController(
                title: "Login Result",
                message: "There is no login result.",
                preferredStyle: .alert
            )
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    
    @objc func buttonPressed() {
        viewModel.login()
    }
    
    func loadAnimating() {
        loadingView.isHidden = false
        loadingView.backgroundColor = .gray.withAlphaComponent(0.5)
    }
    
    func stopAnimating() {
        loadingView.isHidden = true
    }

    
    func setupConstraints() {
        yandexButton.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.top).inset(-16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        infoButton.setTitle("Info", for: .normal)
        infoButton.addTarget(self, action: #selector(presentLogin), for: .touchUpInside)
        infoButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(260)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(200)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: Yandex

extension LoginViewController: YandexLoginSDKObserver {
    
    func didFinishLogin(with result: Result<LoginResult, Error>) {
        switch result {
        case .success(let loginResult):
            KeychainManager.save(loginResult.token, forKey: "token")
            viewModel.setToken()
        case .failure(let error):
            print("Login error: \(error)")
        }
    }
    
    @objc func loginButtonPressed() {
        
        let authorizationStrategy: YandexLoginSDK.AuthorizationStrategy = .default
        do {
            try YandexLoginSDK.shared.authorize(
                with: self,
                customValues: self.customValues.isEmpty ? nil : self.customValues,
                authorizationStrategy: authorizationStrategy
            )
        } catch {
            errorOccured(error)
        }
    }
    
    
    @objc func logoutButtonPressed() {
        viewModel.logout()
    }
    
    func presentLogouted() {
        let alert = UIAlertController(title: "Logout", message: "You have been logged out.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Protocol Methods

extension LoginViewController: LoginViewInput {
    
    func onSighInTapped() {
           // viewModel.login()
    }
    
    func onSignUpTapped() {
        
    }
}

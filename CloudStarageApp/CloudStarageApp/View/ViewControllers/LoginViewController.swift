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
    private let keychain = KeychainManager.shared
    private weak var yandex: YandexLoginSDK?
//    private var customValues: [String: String] = [:]
    
    private var loginResult: LoginResult?
    
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
    
    deinit {
        print("deinited looooogin")
    }
    
    
    //    MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButtonPressed()
        logoutButton.setTitle("logout")
        yandexButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        yandex = YandexLoginSDK.shared
        yandex?.add(observer: self)
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

extension LoginViewController {
    
    @objc func loginButtonPressed() {
        guard let yandex = yandex else { return }
        
        let authorizationStrategy: YandexLoginSDK.AuthorizationStrategy = .default
        do {
            try yandex.authorize(
                with: self,
                customValues: nil,
                authorizationStrategy: authorizationStrategy
            )
        } catch {
            errorOccured(error)
        }
    }

    
    @objc func logoutButtonPressed() {
        do {
            try yandex?.logout()
        } catch {
            return
        }
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

extension LoginViewController: YandexLoginSDKObserver {
    
    func didFinishLogin(with result: Result<LoginResult, Error>) {
        switch result {
        case .success(let loginResult):
            self.loginResult = loginResult
            let result = loginResult.token
            viewModel.saveToken(token: result)
            print("token from viewControllerKeychain", keychain.get(forKey: "token"))
        case .failure(let error):
            print("Login error: \(error)")
        }
    }
}

extension LoginViewController: LoginViewInput {
    
    func onSighInTapped() {
        try? yandex?.logout()
           // viewModel.login()
    }
    
    func onSignUpTapped() {
        
    }
}

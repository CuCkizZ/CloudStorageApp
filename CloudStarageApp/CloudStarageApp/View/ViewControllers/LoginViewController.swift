import UIKit
import SnapKit
import YandexLoginSDK

protocol LoginViewInput: AnyObject {
    func onSighInTapped()
    func onSignUpTapped()
}

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewOutput
    
    private var customValues: [String: String] = [:]
    private let authorizationSource: YandexLoginSDK.AuthorizationStrategy = .default
    private var loginResult: LoginResult? {
        didSet {
            //logoutButton.isEnabled = (loginResult != nil)
        }
    }
    
    private lazy var bottomButtomCT = NSLayoutConstraint()
    private lazy var bottomStackViewCT = NSLayoutConstraint()
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingView = UIView()
    private let blackButton = YandexButton()
    private let loginButton = CSBlueButton()
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
        blackButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)

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
        view.addSubview(loginButton)
        view.addSubview(logoutButton)
        view.addSubview(blackButton)
        setupButton()
        setupConstraints()
        bindViewModel()
        SetupNavBar()
        //setupObservers()
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
            self.logout()
        }
    }
    
    func presentLogin() {
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
       // print(loginResult)
        onSighInTapped()
    }
    
    func loadAnimating() {
        loadingView.isHidden = false
        loadingView.backgroundColor = .gray.withAlphaComponent(0.5)
    }
    
    func stopAnimating() {
        loadingView.isHidden = true
    }

    
    func setupConstraints() {
        blackButton.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.top).inset(-16)
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
            self.loginResult = loginResult
            NetworkService.token = loginResult.token
            print(NetworkService.token)
            print(loginResult.jwt)
        case .failure(let error):
            self.errorOccured(error)
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
        //onSighInTapped()
        //            print(YandexLoginSDK)
    }
    
    @objc func logout() {
        do {
            try YandexLoginSDK.shared.logout()
            loginResult = nil
            presentLogouted()
        } catch {
            errorOccured(error)
        }
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
            viewModel.login(login: "", password: "")
    }
    
    func onSignUpTapped() {
        
    }
}

extension LoginViewController {
    
    func errorOccured(_ error: Error) {
        let alertController: UIAlertController
        if let yandexLoginSDKError = error as? YandexLoginSDKError {
            alertController = UIAlertController(
                title: "A LoginSDK Error Occured",
                message: yandexLoginSDKError.message,
                preferredStyle: .alert
            )
        } else {
            alertController = UIAlertController(
                title: "An Error Occured",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
        }
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

import UIKit
import SnapKit
import YandexLoginSDK
import Alamofire

protocol LoginViewControllerProtocol: AnyObject {}

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModelProtocol
    private let keychain = KeychainManager.shared
    private var loginResult: LoginResult?
    private weak var yandex: YandexLoginSDK?
    private lazy var yandexButton = YandexButton()
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButtonPressed()
        setupLayout()
    }
}

// MARK: Private Setup Methods

private extension LoginViewController {
    
    func setupLayout() {
        yandex = YandexLoginSDK.shared
        yandex?.add(observer: self)
        setupView()
        setupNavBar()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(yandexButton)
        yandexButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    func setupNavBar() {
        title = StrGlobalConstants.loginTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupConstraints() {
        yandexButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}

// MARK: Yandex

extension LoginViewController: YandexLoginSDKObserver {
    
    func didFinishLogin(with result: Result<LoginResult, Error>) {
        switch result {
        case .success(let loginResult):
            self.loginResult = loginResult
            let result = loginResult.token
            viewModel.saveToken(token: result)
            viewModel.login()
        case .failure(let error):
            self.errorOccured(error)
        }
    }
    
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
}

import UIKit
import SnapKit
import YandexLoginSDK

private enum Placeholder {
    static let user = "Введите логин"
    static let password = "Введите пароль"
}


protocol LoginViewInput: AnyObject {
    func onSighInTapped()
    func onSignUpTapped()
}

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewOutput
    private var yandex = YandexLoginSDK.shared
    
    
    private lazy var bottomButtomCT = NSLayoutConstraint()
    private lazy var bottomStackViewCT = NSLayoutConstraint()
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingView = UIView()
    private let blackButton = YandexButton()
//    private let loginTextField = CSTextField()
//    private let passwordTextFiled = CSTextField()
    private let loginButton = CSBlueButton()
    
//    private lazy var stackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [loginTextField, passwordTextFiled])
//        stack.axis = .vertical
//        stack.spacing = 20
//        stack.alignment = .center
//        loginTextField.placeholder = Placeholder.user
//        passwordTextFiled.placeholder = Placeholder.password
//        return stack
//    }()
    
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
        view.backgroundColor = .systemBackground
        view.addSubview(loadingView)
        view.addSubview(activityIndicator)
        //view.addSubview(stackView)
        view.addSubview(loginButton)
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
    }
    
    @objc func buttonPressed() {
        onSighInTapped()
    }
    
    func loadAnimating() {
        loadingView.isHidden = false
        loadingView.backgroundColor = .gray.withAlphaComponent(0.5)
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func stopAnimating() {
        loadingView.isHidden = true
    }

    
    func setupConstraints() {
//        stackView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.horizontalEdges.equalToSuperview().inset(20)
//        }
//        loginTextField.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(stackView)
//            make.height.equalTo(50)
//        }
//        passwordTextFiled.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(stackView)
//            make.height.equalTo(50)
//        }
        
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
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: Yandex

// MARK: - Protocol Methods

extension LoginViewController: LoginViewInput {
    
    func onSighInTapped() {
        viewModel.login(login: "", password: "")
    }
    
    func onSignUpTapped() {
        
    }
}



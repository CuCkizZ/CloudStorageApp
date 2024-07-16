//
//  LoginViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 15.07.2024.
//

import UIKit
import SnapKit

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
    
    private lazy var bottomButtomCT = NSLayoutConstraint()
    private lazy var bottomStackViewCT = NSLayoutConstraint()
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    private let welcomeLabel = UILabel()
    private let loginTextField = CSTextField()
    private let passwordTextFiled = CSTextField()
    private let loginButton = CSBlueButton()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginTextField, passwordTextFiled])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        loginTextField.placeholder = Placeholder.user
        passwordTextFiled.placeholder = Placeholder.password
        return stack
    }()
    
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
    
    deinit {
        stopKeybordListener()
    }
    
    func bindViewModel() {
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

// MARK: Private Setup Methods

private extension LoginViewController {
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(activityIndicator)
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(loginButton)
        setupButton()
        setupWelcomeLabel()
        setupConstraints()
        bindViewModel()
    }
    
    func setupWelcomeLabel() {
        welcomeLabel.text = "Drive in"
        welcomeLabel.font = .Inter.bold.size(of: 40)
        welcomeLabel.textColor = .black
    }
    
    func setupButton() {
        loginButton.action = { [weak self] in
            guard let self = self else { return }
            self.buttonPressed()
        }
    }
        
    @objc func buttonPressed() {
        print("taped")
        onSighInTapped()
    }
    
    func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        loginTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
            make.height.equalTo(50)
        }
        passwordTextFiled.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
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

// MARK: Keybord

private extension LoginViewController {
    func setupObservers() {
        startKeybordListener()
    }
    
    func startKeybordListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func stopKeybordListener() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keybordWillShow(_ notification: Notification) {
        //        guard let keybordFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        //        let keyboardHeight = keybordFrame.cgRectValue.height
        
    }
    
    @objc func keybordWillHide(_ notification: Notification) {
        
    }
}

// MARK: - Protocol Methods

extension LoginViewController: LoginViewInput {
    func onSighInTapped() {
        viewModel.login(login: loginTextField.text ?? "", password: loginTextField.text ?? "")
    }
    
    func onSignUpTapped() {
        
    }
}




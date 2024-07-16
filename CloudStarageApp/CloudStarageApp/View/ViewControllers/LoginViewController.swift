//
//  LoginViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 15.07.2024.
//

import UIKit
import SnapKit

protocol LoginViewInput: AnyObject {
    func onSighInTapped()
    func onSignUpTapped()
}

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewOutput
    
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
        
        // Do any additional setup after loading the view.
    }
}

// MARK: Private Setup Methods

private extension LoginViewController {
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(loginButton)
        setupWelcomeLabel()
        setupConstraints()
    }
    
    func setupWelcomeLabel() {
        welcomeLabel.text = "Drive in"
        welcomeLabel.font = .Inter.bold.size(of: 40)
        welcomeLabel.textColor = .black
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
    }
}

private enum Placeholder {
    static let user = "Введите логин"
    static let password = "Введите пароль"
}



// MARK: - Protocol Methods

extension LoginViewController: LoginViewInput {
    func onSighInTapped() {
        
    }
    
    func onSignUpTapped() {
        
    }
}


//
//  OnboardingViewController.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 05.11.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "WELCOME_TEXT".localized
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ACCOUNT_BUTTON".localized, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .trBlue
        button.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .gray
        label.text = "PROMPT_LABEL".localized
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN".localized, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = .trBlue
        button.addTarget(self, action: #selector(didTapLogin) , for: .touchUpInside)
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trBlack
        addSubviews()
        setConstraints()
    }
    
    @objc
    private func didTapCreateAccount() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func didTapLogin() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Add subviews / Set constraints

extension OnboardingViewController {
    
    private func addSubviews() {
        [welcomeLabel, createAccountButton, 
         promptLabel, loginButton].forEach { view.addViewWithNoTAMIC($0) }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60),
            
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: 10)
        ])
    }
}

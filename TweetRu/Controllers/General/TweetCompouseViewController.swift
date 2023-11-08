//
//  TweetCompouseViewController.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 08.11.2023.
//

import UIKit
import Combine

final class TweetCompouseViewController: UIViewController {
    
    private let viewModel = TweetCompouseViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trBlue
        button.tintColor = .white
        button.setTitle("TWEET".localized, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
        return button
    }()
    
    private let tweetTextView: UITextView = {
        let textView = UITextView()
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "TWEET_TEXT".localized
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .gray
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        viewModel.gerUserData()
        bindViews()
        
        view.backgroundColor = .trBlack
        title = "TWEET".localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL".localized,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        
        tweetTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        viewModel.gerUserData()
        bindViews()
    }
    
    @objc
    private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapToTweet() {
        viewModel.dispatchTweet()
    }
    
    private func bindViews() {
        viewModel.$isValidToTweet.sink { [weak self] state in
            self?.tweetButton.isEnabled = state
        }
        .store(in: &subscriptions)
        viewModel.$shouldDismissComposer.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
}

extension TweetCompouseViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "TWEET_TEXT".localized
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.change(content: textView.text)
        viewModel.validateToTweet()
    }
}


// MARK: - Add subviews / Set constraints

extension TweetCompouseViewController {
    
    private func addSubviews() {
        [tweetButton, tweetTextView].forEach { view.addViewWithNoTAMIC($0) }
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tweetButton.widthAnchor.constraint(equalToConstant: 120),
            tweetButton.heightAnchor.constraint(equalToConstant: 40),
            
            tweetTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tweetTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tweetTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tweetTextView.bottomAnchor.constraint(equalTo: tweetButton.topAnchor, constant: -10)
        ])
    }
}

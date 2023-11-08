//
//  HomeViewController.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 03.11.2023.
//

import UIKit
import FirebaseAuth
import Combine

final class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let timelineTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, 
                           forCellReuseIdentifier: TweetTableViewCell.identifierCell)
        return tableView
    }()
    
    private lazy var composeTweetButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
            self?.navigateToTweetComposer()
        })
        button.backgroundColor = .trBlue
        button.tintColor = .white
        let plusSing = UIImage(systemName: "plus",
                               withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 18, weight: .bold))
        button.setImage(plusSing, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true 
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        
        configureNavigationBar()
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retreiveUser()
        bindViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    @objc
    private func didTapSingOut() {
       try? Auth.auth().signOut()
        handleAuthentication()
    }
    
    @objc
    private func didTapProfile() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func completeUserOnboarding() {
        let vc = ProfileDataFromViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    
    private func navigateToTweetComposer() {
        let vc = UINavigationController(rootViewController: TweetCompouseViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user else { return }
            if !user.isUserOnboarded {
                self?.completeUserOnboarding()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timelineTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func handleAuthentication() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
        
    private func configureNavigationBar() {
        let size: CGFloat = 36
        let logoIamgeView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoIamgeView.contentMode = .scaleAspectFill
        logoIamgeView.image = UIImage.logoImage
        
        let midleView =  UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        midleView.addSubview(logoIamgeView)
        navigationItem.titleView = midleView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.profileImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapProfile))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.logout,
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(didTapSingOut))
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifierCell, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        let tweetModel = viewModel.tweets[indexPath.row]
        cell.configureTweet(with: tweetModel.author.displayName,
                            username: tweetModel.author.userName,
                            tweetText: tweetModel.tweetContent,
                            avatarImage: tweetModel.author.avatarPath)
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: TweetTableViewCellDelegate {
    func tweetTableViewCellDidReplay() {
        print("Replay")
       //TODO
    }
    
    func tweetTableViewCellDidRetweet() {
        print("Retweet")
        //TODO
    }
    
    func tweetTableViewCellDidLike() {
        print("Like")
        //TODO
    }
    
    func tweetTableViewCellDidShare() {
        print("Share")
        //TODO
    }
}


// MARK: - Add subviews / Set constraints

extension HomeViewController {
    
    private func addSubviews() {
        [timelineTableView, composeTweetButton].forEach {view.addViewWithNoTAMIC($0)}
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            composeTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            composeTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            composeTweetButton.widthAnchor.constraint(equalToConstant: 60),
            composeTweetButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

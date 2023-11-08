//
//  ProfileViewController.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 03.11.2023.
//

import UIKit
import Combine
import SDWebImage

final class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    private var isStatusBarHidden = true
    
    private let profileTavleView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self,
                           forCellReuseIdentifier: TweetTableViewCell.identifierCell)
        return tableView
    }()
    
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.opacity = 0
        return view
    }()
    
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: profileTavleView.frame.width,
                                                                  height: 380))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trBlack
        navigationItem.title = "PROFILE".localized

        addSubviews()
        setConstraints()
        viewModel.retreiveUser()
        bindViews()
        
        profileTavleView.delegate = self
        profileTavleView.dataSource = self
        profileTavleView.tableHeaderView = headerView
        profileTavleView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.retreiveUser()
    }
    
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user else { return }
            self?.headerView.updateProfile(name: user.displayName,
                                           username: user.userName,
                                           bio: user.bio,
                                           following: "\(user.followingCount)",
                                           followers: "\(user.followersCount)",
                                           avataImage: user.avatarPath, date: (user.createdOn)
                .formatted(date: .abbreviated, time: .omitted))
        }
        .store(in: &subscriptions)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifierCell, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            }
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
}

// MARK: - Add subviews / Set constraints

extension ProfileViewController {
    
    private func addSubviews() {
        [profileTavleView, statusBar].forEach{ view.addViewWithNoTAMIC($0) }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileTavleView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTavleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileTavleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTavleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ])
    }
}

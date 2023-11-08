//
//  TweetTableViewCell.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 03.11.2023.
//

import UIKit

protocol TweetTableViewCellDelegate: AnyObject {
    func tweetTableViewCellDidReplay()
    func tweetTableViewCellDidRetweet()
    func tweetTableViewCellDidLike()
    func tweetTableViewCellDidShare()
}

final class TweetTableViewCell: UITableViewCell {
    
    static let identifierCell = Constants.tweetTableCell
    
    weak var delegate: TweetTableViewCellDelegate?
    private let actionSpacing: CGFloat = 60
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.profileImage
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Andrey Bezrukov"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@Andrey"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let tweetTextContentLabel: UILabel = {
        let label = UILabel()
        label.text = "Это первый твит текст в русском твиттере :)"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var replayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.replayImage, for: .normal)
        button.addTarget(self, action: #selector(didTapReplay), for: .touchUpInside)
        button.tintColor = .systemGray2
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.retweetImage, for: .normal)
        button.addTarget(self, action: #selector(didTapRetween), for: .touchUpInside)
        button.tintColor = .systemGray2
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.heartImage, for: .normal)
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        button.tintColor = .systemGray2
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.shareImage, for: .normal)
        button.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        button.tintColor = .systemGray2
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc
    private func didTapReplay() {
        delegate?.tweetTableViewCellDidReplay()
    }
    
    @objc
    private func didTapRetween() {
        delegate?.tweetTableViewCellDidRetweet()
    }
    
    @objc
    private func didTapLike() {
        delegate?.tweetTableViewCellDidLike()
    }
    
    @objc
    private func didTapShare() {
        delegate?.tweetTableViewCellDidShare()
    }
    
    func configureTweet(
        with displayName: String,
        username: String,
        tweetText: String,
        avatarImage: String
    ) {
        displayNameLabel.text = displayName
        userNameLabel.text = "@\(username)"
        tweetTextContentLabel.text = tweetText
        avatarImageView.sd_setImage(with: URL(string: avatarImage))
    }
}

// MARK: - Add subviews / Set constraints

extension TweetTableViewCell {
    
    private func addSubviews() {
        [avatarImageView, displayNameLabel, userNameLabel,
         tweetTextContentLabel, replayButton, retweetButton,
         likeButton, shareButton].forEach {
            contentView.addViewWithNoTAMIC($0)
        }
    }
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            displayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor, constant: 20),
            userNameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            tweetTextContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            tweetTextContentLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 10),
            tweetTextContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            replayButton.leadingAnchor.constraint(equalTo: tweetTextContentLabel.leadingAnchor),
            replayButton.topAnchor.constraint(equalTo: tweetTextContentLabel.bottomAnchor, constant: 10),
            replayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            retweetButton.leadingAnchor.constraint(equalTo: replayButton.trailingAnchor, constant: actionSpacing),
            retweetButton.centerYAnchor.constraint(equalTo: replayButton.centerYAnchor),
            
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: actionSpacing),
            likeButton.centerYAnchor.constraint(equalTo: retweetButton.centerYAnchor),
            
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: actionSpacing),
            shareButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor)
        ])
    }
}

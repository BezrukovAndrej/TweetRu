//
//  TweetCompouseViewViewModel.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 08.11.2023.
//

import Foundation
import Combine
import FirebaseAuth


final class TweetCompouseViewViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    private var user: TwitterUser?
    private var tweetContent = ""
    
    @Published var isValidToTweet: Bool = false
    @Published var error: String?
    @Published var shouldDismissComposer: Bool = false
    
    func gerUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retreive: userID)
            .sink {  [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] tweetterUser in
                self?.user = tweetterUser
            }
            .store(in: &subscriptions)
    }
    
    func validateToTweet() {
        isValidToTweet = !tweetContent.isEmpty
    }
    
    func change(content: String) {
        tweetContent = content
    }
    
    func dispatchTweet() {
        guard let user else { return }
        let tweet = Tweet(author: user,
                          authorID: user.id, 
                          tweetContent: tweetContent,
                          likesCount: 0,
                          likers: [],
                          isReplay: false,
                          parentReferance: nil)
        DatabaseManager.shared.collectonTweets(dispatch: tweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismissComposer = state 
            }
            .store(in: &subscriptions)
    }
}

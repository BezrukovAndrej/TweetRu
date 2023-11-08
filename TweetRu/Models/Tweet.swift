//
//  Tweet.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 08.11.2023.
//

import Foundation

struct Tweet: Codable, Identifiable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authorID: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReplay: Bool
    let parentReferance: String?
}

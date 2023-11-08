//
//  String + Extensions.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 03.11.2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

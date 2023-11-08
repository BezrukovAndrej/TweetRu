//
//  UIView + Extensions.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 03.11.2023.
//

import UIKit

extension UIView {
    func addViewWithNoTAMIC(_ views: UIView) {
        self.addSubview(views)
        views.translatesAutoresizingMaskIntoConstraints = false
    }
}

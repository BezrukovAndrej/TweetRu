//
//  AlertPresenter.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 07.11.2023.
//

import UIKit

final class AlertPresenter {
    
    func presentAlert(controller: UIViewController?, with error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okButton)
        controller?.present(alert, animated: true)
    }
}



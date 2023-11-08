//
//  ViewController.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 03.11.2023.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trBlack
        viewControllers = generateViewControllers()
    }
    
    private func generateViewControllers() -> [UIViewController] {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let notificationsVC = UINavigationController(rootViewController: NotificationsViewController())
        let directMessagesVC = UINavigationController(rootViewController: DirectMessagesViewController())
        
        
        homeVC.tabBarItem.image = UIImage.homeImage
        homeVC.tabBarItem.selectedImage = UIImage.homeImageFill
        
        searchVC.tabBarItem.image = UIImage.searchImage
        
        notificationsVC.tabBarItem.image = UIImage.notificationImage
        notificationsVC.tabBarItem.selectedImage = UIImage.notificationImageFill
        
        directMessagesVC.tabBarItem.image = UIImage.directImage
        directMessagesVC.tabBarItem.selectedImage = UIImage.directImageFill
        
        return [homeVC, searchVC, notificationsVC,directMessagesVC]
    }
}

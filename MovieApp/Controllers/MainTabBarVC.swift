//
//  ViewController.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 5.03.2023.
//

import UIKit

class MainTabBarVC: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        setupViewControllers()
    }
    
    func setupViewControllers() {
          viewControllers = [
            createNavigationController(HomeVC(), title: "Home", UIImage(systemName:"house")!),
            createNavigationController(SearchVC(), title: "Search", UIImage(systemName:"magnifyingglass")!),
            createNavigationController(LikesVC(), title: "Likes", UIImage(systemName:"hand.thumbsup.fill")!)
          ]
      }
    
    private func createNavigationController(_ rootViewController: UIViewController, title: String, _ image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            return navController
        }

}


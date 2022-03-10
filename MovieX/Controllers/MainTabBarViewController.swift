//
//  ViewController.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    //MARK: - Properties
    
    private let vc1 = UINavigationController(rootViewController: HomeViewController())
    private let vc2 = UINavigationController(rootViewController: UpcomingViewController())
    private let vc3 = UINavigationController(rootViewController: SearchViewController())
    private let vc4 = UINavigationController(rootViewController: DownloadsViewController())
    
    //MARK: - VC Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarViewControllers()
    }
    
    //MARK: - Helper Functions
    
    private func setupTabBarViewControllers(){
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Top Search"
        vc4.title = "Downloads"
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}


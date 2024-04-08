//
//  TopHeadlinesCoordinator.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import UIKit

final class TopNewsCoordinator: Coordinator {
    
    private let navigationController = UINavigationController()
    
    func start() -> UIViewController {
        return showTopNews()
    }
    
}

extension TopNewsCoordinator {
    
    private func showTopNews() -> UIViewController {
        let vm = TopNewsViewModel()
        let vc = TopNewsViewController()
        vc.viewModel = vm
        
        vc.tabBarItem = UITabBarItem(title: "Headlines", image:UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))
        
        
        navigationController.viewControllers = [vc]
        return navigationController
    }
}

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
        let vm = TopNewsViewModel(newsApiService: ServiceFactory.newsApiService)
        let vc = TopNewsViewController()
        vc.viewModel = vm
        
        vm.onGoToDetails = { [weak self] article in
            self?.goToDetails(article)
        }
        
        vc.tabBarItem = UITabBarItem(title: "Headlines", image:UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))
        
        
        navigationController.viewControllers = [vc]
        return navigationController
    }
    
    private func goToDetails(_ article : Article) {
        let vm = DetailsViewModel(article: article)
        let vc = DetailsViewController()
        vc.viewModel = vm
        
        navigationController.pushViewController(vc, animated: true)
    }
}

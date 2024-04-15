//
//  SearchNewsCoordinator.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import UIKit


final class SearchNewsCoordinator: Coordinator {
    
    private let navigationController = UINavigationController()
    
    func start() -> UIViewController {
        return showSearchNews()
    }
    
}

extension SearchNewsCoordinator {
    
    private func showSearchNews() -> UIViewController {
        let vm = SearchNewsViewModel(newsApiService: ServiceFactory.newsApiService)
        let vc = SearchNewsViewController()
        vc.viewModel = vm
        
        vm.onGoToDetails = { [weak self] article in
            self?.goToDetails(article)
        }
        
        vc.tabBarItem = UITabBarItem(title: "Search", image:UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        
        
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

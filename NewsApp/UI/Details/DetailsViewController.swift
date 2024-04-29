//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by Miran Mendelski on 13.04.2024..
//

import UIKit

final class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
//        setup
    }
    
    
    private lazy var newsImage: UIImageView = {
        let newsImage = UIImageView()
        newsImage.setImage(with: viewModel.newsImage, placeholder: UIImage.placeholderImage!)
        newsImage.contentMode = .scaleToFill
        
        newsImage.layer.cornerRadius = 8
        newsImage.clipsToBounds = true
        view.addSubview(newsImage)
        return newsImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.numberOfLines = 0
        titleLabel.style(.headline3, color: .white)
        view.addSubview(titleLabel)
        return titleLabel
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .darkRed
        view.addSubview(line)
        return line
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .black
        view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .black
        scrollView.addSubview(container)
        return container
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = viewModel.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.style(.body1Medium, color: .darkGray)
        containerView.addSubview(descriptionLabel)
        return descriptionLabel
    }()
    
    
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.numberOfLines = 2
        authorLabel.text = "Author: \(viewModel.author)"
        authorLabel.style(.headline4, color: .darkRed, alignment: .left)
        containerView.addSubview(authorLabel)
        return authorLabel
    }()
}

extension DetailsViewController {
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setupConstraints() {
        
        newsImage.anchor(top: (view.topAnchor, 0), leading: (view.leadingAnchor, 0), trailing: (view.trailingAnchor,0), size: CGSize(width: 0, height: UIScreen.main.bounds.height * 0.40))
        
        titleLabel.anchor(top: (newsImage.bottomAnchor, 12), leading: (view.leadingAnchor, 20), trailing: (view.trailingAnchor, 20))
        lineView.anchor(top: (titleLabel.topAnchor, 0), bottom: (titleLabel.bottomAnchor, 0), size: CGSize(width: 5, height: 0))
        
        scrollView.anchor(top: (titleLabel.bottomAnchor, 8), bottom: (view.safeAreaLayoutGuide.bottomAnchor, 0),leading: (view.leadingAnchor, 0), trailing: (view.trailingAnchor,0))
        
        containerView.anchor(top: (scrollView.topAnchor, 0), bottom: (scrollView.bottomAnchor, 0), leading: (scrollView.leadingAnchor, 0), trailing: (scrollView.trailingAnchor, 0))
        
        containerView.anchor(size: CGSize(width: view.frame.width, height: 0))
        
        descriptionLabel.anchor(top: (containerView.topAnchor, 8),leading: (containerView.leadingAnchor, 12), trailing: (containerView.trailingAnchor, 12))
        
        authorLabel.anchor(top: (descriptionLabel.bottomAnchor, 8),bottom: (containerView.bottomAnchor,8) ,leading: (containerView.leadingAnchor, 12), trailing: (containerView.trailingAnchor, 12))
        
    }
}


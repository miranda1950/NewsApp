//
//  SearchNewsEmptyView.swift
//  NewsApp
//
//  Created by Miran Mendelski on 16.04.2024..
//

import UIKit


final class NoResultsView: UIView {
    
    enum NoResultType {
        case noInternet
        case empty
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var type: NoResultType = .empty {
        didSet {
            switch type {
            case .empty:
                titleLabel.text = "There is no news with that topic"
                imageView.image = UIImage(named: "no-news")
                imageView.alpha = 1
            case .noInternet:
                titleLabel.text = "No Internet"
                descriptionLabel.text = "Please check your internet connection"
                imageView.image = UIImage(systemName: "wifi.slash")?.withTintColor(.darkRed, renderingMode: .alwaysOriginal)
                imageView.alpha = 1
            }
        }
    }

    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.style(.headline4, color: .darkRed)
        addSubview(titleLabel)
        return titleLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.style(.body3Medium, color: .white, alignment: .center)
        self.addSubview(descriptionLabel)
        return descriptionLabel
    }()
    
}

extension NoResultsView {
    
    private func setupConstraints() {
        
        titleLabel.anchor(top: (topAnchor, 12))
        titleLabel.centerXInSuperview()
        
        imageView.anchor(top: (titleLabel.bottomAnchor, 18), size: CGSize(width: 150, height: 150))
        imageView.centerXInSuperview()
        
        descriptionLabel.anchor(top: (imageView.bottomAnchor, 12))
        descriptionLabel.centerXInSuperview()
        
    }
}

//
//  TopNewsTableViewCell.swift
//  NewsApp
//
//  Created by Miran Mendelski on 09.04.2024..
//

import UIKit


class TopNewsTableViewCell: UITableViewCell {
    
    var article: Article? {
        didSet {
            guard let article = article else { return }
            titleLabel.text = article.title
            dateLabel.text = article.trimmedDate
            authorLabel.text = article.author
            if let url = URL(string: article.urlToImage ?? "") {
                newsImage.setImage(with: url, placeholder: UIImage.news)
            } else {
                newsImage.image = UIImage.news
            }
        }
    }
    
    private lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .darkGray2
        container.layer.cornerRadius = 16
        container.layer.borderColor = UIColor.darkRed.cgColor
        container.layer.borderWidth = 2
        addSubview(container)
        return container
    }()
    
    
    private lazy var newsImage: UIImageView = {
        let newsImage = UIImageView()
        newsImage.isUserInteractionEnabled = true
        newsImage.contentMode = .scaleToFill
        newsImage.layer.cornerRadius = 8
           newsImage.clipsToBounds = true
        containerView.addSubview(newsImage)
        return newsImage
    }()
    
    private lazy var infoImage: UIImageView = {
        let infoImage = UIImageView()
        infoImage.image = UIImage(systemName: "info.circle")?.withTintColor(.darkRed, renderingMode: .alwaysOriginal)
        containerView.addSubview(infoImage)
        return infoImage
    }()
    
    
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.numberOfLines = 1
        authorLabel.style(.body1Medium, color: .darkRed)
        containerView.addSubview(authorLabel)
        return authorLabel
        
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 3
        titleLabel.style(.newsTitle, color: .white)
        containerView.addSubview(titleLabel)
        return titleLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.numberOfLines = 1
        dateLabel.style(.newsTitle, color: .grayText, alignment: .right)
        containerView.addSubview(dateLabel)
        return dateLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

    private func setupConstraints() {
        
        containerView.anchor(top: (self.topAnchor, 9),bottom: (self.bottomAnchor, 9) ,leading: (self.leadingAnchor, 20), trailing: (self.trailingAnchor, 20),size: CGSize(width: 0, height: 120))
        
        newsImage.anchor(top: (containerView.topAnchor, 12), bottom: (containerView.bottomAnchor, 12), leading: (containerView.leadingAnchor, 12), trailing: (containerView.trailingAnchor, 200))
        
        authorLabel.anchor(top: (containerView.topAnchor, 12), leading: (newsImage.trailingAnchor, 8), trailing: (containerView.trailingAnchor, 12))
        
        titleLabel.anchor(top: (authorLabel.bottomAnchor, 8), leading: (newsImage.trailingAnchor, 8), trailing: (containerView.trailingAnchor, 12))

        infoImage.anchor(bottom: (containerView.bottomAnchor, 12), leading: (newsImage.trailingAnchor, 12))
        
        dateLabel.anchor(bottom: (containerView.bottomAnchor, 8),leading: (newsImage.trailingAnchor, 8), trailing: (containerView.trailingAnchor, 8))
        
    }
}


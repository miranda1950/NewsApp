//
//  TopHeadlinesViewController.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import UIKit


final class TopNewsViewController: UIViewController {
    
    var viewModel: TopNewsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupConstraints()
        addCallbacks()
        
        viewModel.loadNews()
        
    }
    
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Top News"
        titleLabel.numberOfLines = 2
        titleLabel.style(.headline1,color: .darkRed ,alignment: .left)
        view.addSubview(titleLabel)
        return titleLabel
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let largeBoldIcon = UIImage(systemName: "line.3.horizontal.circle", withConfiguration: largeConfig)?.withTintColor(.darkRed, renderingMode: .alwaysOriginal)
        button.setImage(largeBoldIcon, for: .normal)
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(TopNewsTableViewCell.self, forCellReuseIdentifier: "topNewsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        return tableView
    }()
    
   private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkRed
        view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    private lazy var noInternetView: NoResultsView = {
        let noInternetView = NoResultsView()
        noInternetView.type = .noInternet
        noInternetView.isUserInteractionEnabled = true
        noInternetView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkInternetConnection)))
        noInternetView.isHidden = true
        view.addSubview(noInternetView)
        return noInternetView
    }()
    
}


extension TopNewsViewController {
    
    private func setupConstraints() {
        
        titleLabel.anchor(top: (view.safeAreaLayoutGuide.topAnchor, 12), leading: (view.leadingAnchor, 20), trailing: (view.trailingAnchor, 20))
        
        settingsButton.anchor( trailing: (view.trailingAnchor, 20))
        settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        tableView.anchor(top: (titleLabel.bottomAnchor, 12),bottom: (view.safeAreaLayoutGuide.bottomAnchor, 20) ,leading: (view.safeAreaLayoutGuide.leadingAnchor, 20), trailing: (view.safeAreaLayoutGuide.trailingAnchor, 20))
        
        activityIndicator.centerIn(view)
        
        noInternetView.anchor(top: (titleLabel.bottomAnchor, 12),bottom: (view.safeAreaLayoutGuide.bottomAnchor, 20) ,leading: (view.leadingAnchor, 20), trailing: (view.trailingAnchor, 20))
    }
    
    private func addCallbacks() {
        
        viewModel.onStartedActivty = {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        viewModel.onEndedActivity = { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
        
        viewModel.onGotData = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onNoInternet = { [weak self] in
            self?.noInternetView.isHidden = false
            self?.tableView.isHidden = true
        }
    }
    
    @objc private func settingsTapped() {
        viewModel.showHamburgerModal?()
    }
    
    @objc private func checkInternetConnection() {
        viewModel.reloadData()
        guard !viewModel.article.isEmpty else {
            return
        }
        self.noInternetView.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
}

extension TopNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topNewsTableViewCell", for: indexPath) as? TopNewsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        guard indexPath.row < viewModel.article.count else {
                return cell
            }
            let article = viewModel.article[indexPath.row]
            cell.article = article
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onGoToDetails?(viewModel.article[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if viewModel.article.isEmpty {
            return
        }
        if indexPath.row == lastRowIndex - 1 {
            viewModel.loadMoreNews()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -120 {
            viewModel.reloadData()
            self.tableView.reloadData()
        }
    }
}

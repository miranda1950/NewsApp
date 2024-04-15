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
//        { [weak self] in
//            self?.tableView.reloadData()
//        }
        
    }
    
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Top News"
        titleLabel.numberOfLines = 2
        titleLabel.style(.headline1, alignment: .left)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        return titleLabel
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
    
}


extension TopNewsViewController {
    
    private func setupConstraints() {
        
        titleLabel.anchor(top: (view.safeAreaLayoutGuide.topAnchor, 12), leading: (view.leadingAnchor, 20), trailing: (view.trailingAnchor, 20))
        
        tableView.anchor(top: (titleLabel.bottomAnchor, 12),bottom: (view.safeAreaLayoutGuide.bottomAnchor, 20) ,leading: (view.safeAreaLayoutGuide.leadingAnchor, 20), trailing: (view.safeAreaLayoutGuide.trailingAnchor, 20))
        
        activityIndicator.centerIn(view)
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
        
    }
}

extension TopNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("mirantotal\(viewModel.article.count)")
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

//
//  SearchNewsViewController.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import UIKit

final class SearchNewsViewController: UIViewController {
    
    var viewModel: SearchNewsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrains()
        addCallbacks()
        
    }
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.barTintColor = .black
        search.delegate = self
        let textFieldInsideSearchBar = search.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.lightGray
        textFieldInsideSearchBar?.leftView?.tintColor = .darkRed
        view.addSubview(search)
        return search
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


extension SearchNewsViewController {
    
    private func setupConstrains() {
        
        searchBar.anchor(top: (view.safeAreaLayoutGuide.topAnchor, 20), leading: (view.leadingAnchor, 20), trailing: (view.trailingAnchor, 20), size: CGSize(width: 0, height: 52))
        
        tableView.anchor(top: (searchBar.bottomAnchor, 12),bottom: (view.safeAreaLayoutGuide.bottomAnchor, 20) ,leading: (view.safeAreaLayoutGuide.leadingAnchor, 20), trailing: (view.safeAreaLayoutGuide.trailingAnchor, 20))
        
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
    
    @objc private func searchTapped() {
        print("search")
    }
    
}

extension SearchNewsViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadData), object: nil)
        self.perform(#selector(loadData(_:)), with: searchText, afterDelay: 1.0)
    }
    
    @objc private func loadData(_ searchText: String) {
        viewModel.queryText = searchText.lowercased()
        viewModel.loadNews(searchText)
    }
}

extension SearchNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            viewModel.loadMoreNews(viewModel.queryText)
        }
    }
}

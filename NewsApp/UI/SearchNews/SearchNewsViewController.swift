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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboardIfNeeded(_:)))
            view.addGestureRecognizer(tapGesture)
            
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboardIfNeeded)))
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
    
    private lazy var sortIcon: UIImageView = {
        let sortIcon = UIImageView()
        sortIcon.image = UIImage(systemName: "arrow.down.circle")?.withTintColor(.darkRed, renderingMode: .alwaysOriginal)
        sortIcon.isUserInteractionEnabled = true
        sortIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sortNews)))
        view.addSubview(sortIcon)
        return sortIcon
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
    
    private lazy var emptyView: NoResultsView = {
        let emptyView = NoResultsView()
        emptyView.type = .empty
        emptyView.isHidden = true
        view.addSubview(emptyView)
        return emptyView
    }()
    
    private lazy var noInternetView: NoResultsView = {
        let noInternetView = NoResultsView()
        noInternetView.type = .noInternet
        noInternetView.isHidden = true
        view.addSubview(noInternetView)
        return noInternetView
    }()
}


extension SearchNewsViewController {
    
    private func setupConstrains() {
        
        searchBar.anchor(top: (view.safeAreaLayoutGuide.topAnchor, 20), leading: (view.leadingAnchor, 20), trailing: (view.trailingAnchor, 20), size: CGSize(width: 0, height: 52))
        
        sortIcon.anchor(top: (searchBar.bottomAnchor, 0), trailing: (view.trailingAnchor, 20), size: CGSize(width: 30, height: 30))
        
        tableView.anchor(top: (searchBar.bottomAnchor, 30),bottom: (view.safeAreaLayoutGuide.bottomAnchor, 20) ,leading: (view.safeAreaLayoutGuide.leadingAnchor, 20), trailing: (view.safeAreaLayoutGuide.trailingAnchor, 20))
        
        activityIndicator.centerIn(view)
        
        emptyView.anchor(top: (searchBar.bottomAnchor, 12),bottom: (view.safeAreaLayoutGuide.bottomAnchor, 20) ,leading: (view.leadingAnchor, 20), trailing: (view.trailingAnchor, 20))
        noInternetView.anchor(top: (searchBar.bottomAnchor, 12),bottom: (view.safeAreaLayoutGuide.bottomAnchor, 20) ,leading: (view.leadingAnchor, 20), trailing: (view.trailingAnchor, 20))
    }
    
    private func addCallbacks() {
        
        viewModel.onStartedActivty = {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        viewModel.onEndedActivity = { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
        
        viewModel.onGotData = { [weak self] in
            if self?.viewModel.article.isEmpty == true {
                self?.emptyView.isHidden = false
                self?.noInternetView.isHidden = true
                self?.tableView.isHidden = true
            } else {
                self?.noInternetView.isHidden = true
                self?.emptyView.isHidden = true
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onGotTotalResults = { [ weak self] search in
            self?.viewModel.loadMoreNews(search)
        }
        
        viewModel.onNoInternet = { [weak self ] in
            self?.noInternetView.isHidden = false
            self?.emptyView.isHidden = true
            self?.tableView.isHidden = true
        }
    }
    
    
    @objc private func sortNews(_ sender: UITapGestureRecognizer) {
        
        switch viewModel.sortType {
        case .ascending:
            viewModel.sortType = .descending
        case .descending:
            viewModel.sortType = .ascending
        }
        viewModel.isSortAscending.toggle()
        sortIcon.image = viewModel.isSortAscending ? UIImage(systemName: "arrow.up.circle")?.withTintColor(.darkRed, renderingMode: .alwaysOriginal) : UIImage(systemName: "arrow.down.circle")?.withTintColor(.darkRed, renderingMode: .alwaysOriginal)
        
        guard  viewModel.queryText != "" else {
            return
        }
        
        if viewModel.sortType == .ascending {
            viewModel.getTotalResults(viewModel.queryText)
        } else {
            viewModel.loadNews(viewModel.queryText)
        }
    }
    
}

extension SearchNewsViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.performedSearch = true
        
        if searchText.isEmpty {
            emptyView.isHidden = false
            noInternetView.isHidden = true
           tableView.isHidden = true
            viewModel.queryText = ""
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.loadData(_:)), object: searchBar)
        self.perform(#selector(self.loadData(_:)), with: searchBar, afterDelay: 0.5)

        }
    
    @objc private func loadData(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            return
        }
        viewModel.queryText = query.lowercased()
        
        switch viewModel.sortType {
        case .ascending:
            viewModel.getTotalResults(viewModel.queryText)
        case .descending:
            viewModel.loadNews(viewModel.queryText)
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.performedSearch = false
        searchBar.resignFirstResponder()
    }
    
    @objc private func closeKeyboardIfNeeded(_ sender: UITapGestureRecognizer) {
        guard searchBar.isFirstResponder else {
            return
        }
        searchBar.resignFirstResponder()
        sender.cancelsTouchesInView = false

    }
}

extension SearchNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if !viewModel.performedSearch {
            viewModel.onGoToDetails?(viewModel.article[indexPath.row])
        } else {
            searchBar.resignFirstResponder()
        }
        viewModel.performedSearch = false
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -120 {
            viewModel.reloadData()
            self.tableView.reloadData()
        }
    }

}

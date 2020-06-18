//
//  ListUsersViewController.swift
//  Phonebook
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation
import UIKit
import Domain
import Combine

class ListUsersViewController: BaseViewController<ListUsersView, ListUsersViewModel> {
    
    private var cancellableSet: Set<AnyCancellable> = []

    private let searchController =  UISearchController(searchResultsController: nil)
    
    private var isFirstLoad = true
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find user"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        
        self.setTableViewSettings()
        self.bindingSearchTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLoad {
            self._viewModel.loadUsers()
            self.bindingTableView()
            
            isFirstLoad = false
        }
    }
    
    
    // MARK: binding on searchTextField
    /*
     After 500 milliseconds, the method is called to get users by name
    */
    private func bindingSearchTextField() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .compactMap { $0.object as? UISearchTextField }
            .map { $0.text ?? "" }
            .assign(to: \.publishedUserName, on: _viewModel)
            .store(in: &cancellableSet)
    }
    
    private func bindingTableView(){
        _viewModel.$publishedUsers
            .receive(on: DispatchQueue.main)
            .sink { (users) in
                self._view?.tableView.reloadData()
            }
            .store(in: &cancellableSet)
    }
    
    // MARK: customizes TableView
    private func setTableViewSettings() {
        _view!.tableView.register(UINib(nibName: "UserViewCell", bundle: nil), forCellReuseIdentifier: "UserViewCell")
        
        _view?.tableView.delegate = self
        _view?.tableView.dataSource = self
        _view?.tableView.rowHeight = 72
    }
    
    // MARK: open detail user view
    private func goToDetail(_ index: Int){
        let vc = DetailUserViewController(_viewModel.publishedUsers[index])
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(_viewModel.publishedUsers.count)")
        return _viewModel.publishedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
        let item = _viewModel.publishedUsers[indexPath.row]
        
        cell.setData(imageUrl: item.picture?.medium ?? "", firstName: item.name?.first ?? "", lastName: item.name?.last ?? "", secondName: "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.goToDetail(indexPath.row)
    }
    
}

extension ListUsersViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self._viewModel.publishedUserName = ""
    }
}

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
    
    private var cancellablePublishedUsers: AnyCancellable?
    
    private var cancellableSearchTextField: AnyCancellable?

    private let searchController =  UISearchController()
    
    private var users: [User] = [User]()
    
    private var isFirstLoad = true
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        
        self.setTableViewSettings()
        self.bindingSearchTextField()
        self.publishedUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLoad {
            self._viewModel.loadUsers()
            
            isFirstLoad = false
        }
    }
    
    // MARK: gets new users and then reload tableView
    private func publishedUsers(){
        cancellablePublishedUsers?.cancel()
        cancellablePublishedUsers = _viewModel.$publishedUsers.sink() { data in
            self.users = data
            self._view?.tableView.reloadData()
        }
    }
    
    // MARK: binding on searchTextField
    /*
     After 500 milliseconds, the method is called to get users by name
    */
    private func bindingSearchTextField() {
        cancellableSearchTextField?.cancel()
        cancellableSearchTextField = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .map( { ($0.object as! UITextField).text } )
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { complete in

            }, receiveValue: { value in
                self._viewModel.loadUsers(name: value)
            })
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
        let vc = DetailUserViewController(users[index])
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
        let item = users[indexPath.row]
        
        cell.setData(imageUrl: item.picture.medium, firstName: item.name.first, lastName: item.name.last, secondName: "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.goToDetail(indexPath.row)
    }
    
}

//
//  ListUsersViewModel.swift
//  Phonebook
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation
import Combine
import Domain

class ListUsersViewModel: BaseViewModel {
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var publishedUsers: [User] = []
    
    @Published var publishedUserName: String = ""
    
    required init(_ data: Any?) {
        // when change search query
        // make request to find user
        self.$publishedUserName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (name: String) -> AnyPublisher<[User], Never> in
                self.loadUsers(name: name)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.publishedUsers, on: self)
            .store(in: &cancellableSet)
    }
    
    deinit {
        cancellableSet.removeAll()
    }
    
    func loadUsers(){
        Application.shared.network.getUsers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complete in
                switch complete{
                case .failure(let error):
                   print("ERROR: \(error)")
                case .finished:
                   break
                }
            }, receiveValue: { data in
                self.publishedUsers = data
            })
            .store(in: &cancellableSet)
    }
    
    
    func loadUsers(name: String?) -> AnyPublisher<[User], Never>{
        return Application.shared.network.getUsers(name: name)
    }
}

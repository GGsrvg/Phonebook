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
    
    private var cancellable: AnyCancellable?
    
    @Published var publishedUsers: [User] = [User]()
    
    required init(_ data: Any?) { }
    
    deinit {
        cancellable?.cancel()
    }
    
    func loadUsers(){
        cancellable?.cancel()
        cancellable = Application.shared.network.getUsers()
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
    }
    
    
    func loadUsers(name: String?){
        let _ = Application.shared.network.getUsers(name: name)
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
    }
}

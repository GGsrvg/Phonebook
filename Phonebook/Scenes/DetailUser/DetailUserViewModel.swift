//
//  DetailUserViewModel.swift
//  Phonebook
//
//  Created by GGsrvg on 10.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation
import MessageUI
import UIKit
import Domain

class DetailUserViewModel: BaseViewModel {
    
    let user: User
    
    required init(_ data: Any?) {
        if let user = data as? User {
            self.user = user
        } else {
            fatalError("Its no user type")
        }
    }
    
    @objc func call() {
        Application.shared.call(user.phone)
    }
    
    @objc func write() {
        Application.shared.write()
    }
}

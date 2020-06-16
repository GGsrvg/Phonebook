//
//  DetailUserViewModel.swift
//  Phonebook
//
//  Created by GGsrvg on 10.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation
import MessageUI
import Domain

class DetailUserViewModel: BaseViewModel {
    
    weak var delegateMessage: MFMessageComposeViewControllerDelegate? = nil
    
    let imagePath: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let email: String
    
    required init(_ data: Any?) {
        if let user = data as? User {
            imagePath = user.picture?.large ?? ""
            firstName = user.name?.first ?? ""
            lastName = user.name?.last ?? ""
            phoneNumber = user.phone ?? ""
            email = user.email ?? ""
        } else {
            fatalError("Its no user type")
        }
    }
    
    @objc func call() {
        Application.shared.call(phoneNumber)
    }
    
    @objc func write() {
        if let delegateMessage = delegateMessage {
            Application.shared.writeMessage(recipients: [phoneNumber], delegate: delegateMessage)
        }
    }
}

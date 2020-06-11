//
//  Application.swift
//  Phonebook
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation
import Domain
import RandomUserApi
import MessageUI

class Application {
    
    static let shared = Application()

    let network: Domain.Network

    private init() {
        self.network = RandomUserApi.Network()
    }
       
    func call(_ phone: String) {
            if let phoneCallURL = URL(string: "tel://\(phone)") {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        
    func writeMessage(recipients: [String], delegate: MFMessageComposeViewControllerDelegate) {
        if MFMailComposeViewController.canSendMail() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "Message String"
            messageVC.recipients = [] // Optionally add some tel numbers
            messageVC.messageComposeDelegate = delegate
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }

                topController.present(messageVC, animated: true)
            }
        } else {
            print("Error write")
        }
    }
}

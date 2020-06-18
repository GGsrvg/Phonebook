//
//  DetailUserViewController.swift
//  Phonebook
//
//  Created by GGsrvg on 10.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import UIKit
import MessageUI
import Domain
import Dante

class DetailUserViewController: BaseViewController<DetailUserView, DetailUserViewModel> {

    init(_ user: User) {
        super.init(user)
        _viewModel.delegateMessage = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _view?.userFaceImageView.loadImage(_viewModel.imagePath)
        
        _view?.fullNameLabel.text = "\(_viewModel.firstName) \(_viewModel.lastName)"
        _view?.phoneLabel.text = _viewModel.phoneNumber
        _view?.mailLabel.text = _viewModel.email
        
        _view?.callButton.addTarget(_viewModel, action: #selector(_viewModel.call), for: .touchUpInside)
        _view?.writeButton.addTarget(_viewModel, action: #selector(_viewModel.write), for: .touchUpInside)
    }
    
}

extension DetailUserViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

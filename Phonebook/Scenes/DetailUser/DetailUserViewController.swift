//
//  DetailUserViewController.swift
//  Phonebook
//
//  Created by GGsrvg on 10.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import UIKit
import Domain
import Dante

class DetailUserViewController: BaseViewController<DetailUserView, DetailUserViewModel> {

    init(_ user: User) {
        super.init(user)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _view?.userFaceImageView.loadImage(_viewModel.user.picture.large)
        
        _view?.fullNameLabel.text = "\(_viewModel.user.name.last) \(_viewModel.user.name.first)"
        _view?.phoneLabel.text = _viewModel.user.phone
        _view?.mailLabel.text = _viewModel.user.email
        
        _view?.callButton.addTarget(_viewModel, action: #selector(_viewModel.call), for: .touchUpInside)
        _view?.writeButton.addTarget(_viewModel, action: #selector(_viewModel.write), for: .touchUpInside)
    }
    
}

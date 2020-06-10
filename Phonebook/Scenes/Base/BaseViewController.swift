//
//  BaseViewController.swift
//  Yorome
//
//  Created by GGsrvg on 28.05.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import UIKit

class BaseViewController<V : UIView, VM: BaseViewModel>: UIViewController {
    
    var _view: V?
    
    let _viewModel: VM
    
    init(_ data: Any? = nil) {
        _viewModel = VM(data)
        
        super.init(nibName: nil, bundle: nil)
        
        let nameView = "\(V.self)"
        
        guard let view = UINib(nibName: nameView, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? V else {
            fatalError("\(nameView) not found")
        }
        self._view = view
    }
    
    override func loadView() {
        self.view = _view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

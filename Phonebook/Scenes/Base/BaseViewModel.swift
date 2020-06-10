//
//  BaseViewModel.swift
//  Yorome
//
//  Created by GGsrvg on 28.05.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation

protocol BaseViewModel: ObservableObject {
    
    init(_ data: Any?)
    
    func haveInternetConnection()
}

extension BaseViewModel {
    func haveInternetConnection() {
        
    }
}

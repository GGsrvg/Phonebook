//
//  NameClass.swift
//  Domain
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation

public struct NameClass: Codable {
    public let title, first, last: String?
    
    public func fullName() -> String {
        var fullName = ""
        
        if let first = first {
            fullName += first
        }
        
        if let last = last {
            if fullName.count > 0 {
                fullName += " "
            }
            
            fullName += last
        }
        
        return fullName
    }
}

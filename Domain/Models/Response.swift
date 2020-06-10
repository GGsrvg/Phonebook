//
//  Response.swift
//  Domain
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation

public struct Response: Codable {
    public let results: [User]
    public let info: Info
}

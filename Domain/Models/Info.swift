//
//  Info.swift
//  Domain
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation

public struct Info: Codable {
    public let seed: String
    public let results, page: Int?
    public let version: String?
}

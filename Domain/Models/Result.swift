//
//  Result.swift
//  Domain
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let gender: String
    public let name: NameClass
    public let email: String
    public let dob, registered: Dob
    public let phone, cell: String
    public let picture: Picture
}

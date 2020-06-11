//
//  GetUsersCase.swift
//  Domain
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation
import Combine

public protocol Network {
    func getUsers() -> AnyPublisher<[User], Error>
    func getUsers(name: String?) -> Future<[User], Error>
}

//
//  GetUsersCase.swift
//  RandomUserApi
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import Foundation
import Domain
import Combine

fileprivate let apiURL = "https://randomuser.me/api/?results=1000"

final public class Network: Domain.Network {
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var users: [User] = []
    
    private func absoluteUrl(queryParams: [String: String]? = nil) -> URL? {
        let queryURL = URL(string: apiURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        if let params = queryParams {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url?.absoluteURL else { return nil }
        return url
    }
    
    private func request(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.unknown
                }
                return data
            })
            .mapError { error in
                if let error = error as? ApiError {
                    return error
                } else {
                    return ApiError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func getUsers() -> AnyPublisher<[User], Error> {
        guard let url = absoluteUrl() else {
            let users: [User] = []
            return Just(users)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let response = request(url: url)
            .decode(type: Domain.Response.self, decoder: JSONDecoder())
            .map {
                return $0.results ?? []
            }
            .eraseToAnyPublisher()
        
        
        response
//            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complete in
                switch complete{
                case .failure(let error):
                    print("ERROR: \(error)")
                    self.users.removeAll()
                case .finished:
                    break
                }
            }, receiveValue: {
                self.users = $0
            })
            .store(in: &cancellableSet)
//
        return response
    }
    
    public func getUsers(name: String?) -> Future<[User], Error> {
        
        return Future<[User], Error> { promise in
            if name == nil || name == "" {
                promise(.success(self.users))
            } else {
                let lowerCaseName = name!.lowercased()

                let _users = self.users.filter({
                    "\($0.name?.last?.lowercased() ?? "") \($0.name?.first?.lowercased() ?? "")".contains(lowerCaseName)
                })
                
                promise(.success(_users))
            }
        }
    }
}

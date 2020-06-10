//
//  Dante.swift
//  Dante
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import UIKit
import Combine

public extension UIImageView {
    func loadImage(_ urlPath: String) {
        imageLoad(urlPath, to: self)
    }
}


fileprivate func imageLoad(_ imagePath: String, to imageView: UIImageView){
    imageView.image = nil
    
    let _ = Future<URL, Error>.init({ promise in
        if let url = URL(string: imagePath) {
            promise(.success(url))
        }
        promise(.failure(LoadingError.loading(reason: "Url equail nil")))
    })
    .subscribe(on: DispatchQueue.global(qos: .background))
    .tryMap({ url in
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        throw LoadingError.loading(reason: "Data or UIImage equail nil")
    })
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { error in
        
    }, receiveValue: { image in
        imageView.image = image
    })
}


enum LoadingError: Error {
    case unknown, loading(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .loading(let reason):
            return reason
        }
    }
}

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

// images cache
// Url address : UIImage
let memoryCache = MemoryCache()
//var memoryImageCache: [String: UIImage] = [:]

fileprivate func imageLoad(_ imagePath: String, to imageView: UIImageView){
    // remove image
    imageView.image = nil
    
    // check have image on memory
    if let image = memoryCache.get(imagePath) {
        // use image from memory
        imageView.image = image
    } else {
        // load image
        let _ = Future<URL, Error>.init({ promise in
                // check image path
                if let url = URL(string: imagePath) {
                    // pass on
                    promise(.success(url))
                }
                // if path incorrect
                promise(.failure(LoadingError.loading(reason: "Url equail nil")))
            })
            // switch to background thread
            .subscribe(on: DispatchQueue.global(qos: .background))
            // map from Url to UIImage
            // otherwise giwean error
            .tryMap({ url in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        memoryCache.append(key: imagePath, value: image)
                        return image
                    }
                }
                throw LoadingError.loading(reason: "Data or UIImage equail nil")
            })
            // switch to main thread
            .receive(on: RunLoop.main)
            // set UIImage in UIImageView
            .sink(receiveCompletion: { error in
                
            }, receiveValue: { image in
                imageView.image = image
            })
    }
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

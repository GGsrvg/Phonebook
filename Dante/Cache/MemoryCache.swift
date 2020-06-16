//
//  MemoryCache.swift
//  Dante
//
//  Created by GGsrvg on 15.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import UIKit

class MemoryCache {
    private var items: [String: UIImage] = [:]
    
    // MARK: setting
    private var _count: Int = 40
    
    public var Count: Int {
        get { return _count }
        set (value) { _count = value }
    }
    
    // how much use memory in megabyte
//    private var _size: Int = 40
//
//    public var Size: Int {
//        get { return _size }
//        set (value) { _size = value }
//    }
    
    // MARK: work with items
    public func get(_ key: String) -> UIImage? {
        return items[key]
    }
    
    public func append(key: String, value: UIImage) {
        if items.count > Count {
            let firstKey = Array(items.keys)[0]
            items.removeValue(forKey: firstKey)
        }
        
        self.items[key] = value
    }
    
    public func removeValue(forKey key: String){
        self.items.removeValue(forKey: key)
    }
    
    public func clear() {
        self.items.removeAll()
    }
}

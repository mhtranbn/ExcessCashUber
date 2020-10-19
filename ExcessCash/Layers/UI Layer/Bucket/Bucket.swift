//
//  Bucket.swift
//  ExcessCash
//
//  Created by 서상의 on 2020/10/15.
//

class Bucket<Element> {
    private var bucket: Element?
    
    var isEmpty: Bool { bucket == nil }
    var isFilled: Bool { bucket != nil }
    
    func fill(_ element: Element) {
        self.bucket = element
    }
    func pour() -> Element? {
        defer { bucket = nil }
        return bucket
    }
    func peak() -> Element? {
        return bucket
    }
}

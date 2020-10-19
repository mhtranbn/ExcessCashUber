//
//  Bool+Extension.swift
//  ExcessCash
//
//  Created by 서상의 on 2020/10/06.
//

extension Bool {
    var ison: Bool { return self == true }
    var isoff: Bool { return self == false }
    
    mutating func on() { self = true }
    mutating func off() { self = false }
}

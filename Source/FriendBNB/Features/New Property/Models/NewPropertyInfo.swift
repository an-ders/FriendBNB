//
//  NewPropertyInfo.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-10.
//

import Foundation

struct NewPropertyInfo {
    var rooms: Int
    var people: Int
    
    var dictonary: [String: Any] {
        [
            "rooms": rooms,
            "people": people
        ]
    }
}

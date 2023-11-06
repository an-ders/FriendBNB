//
//  PropertyModel.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-03.
//

import Foundation

class Property: Identifiable {
    let id: String
    var title: String
    var owner: String
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? "No Title"
        self.owner = data["owner"] as? String ?? "No Owner"
    }
}

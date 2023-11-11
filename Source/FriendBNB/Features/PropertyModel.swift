//
//  PropertyModel.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-03.
//

import Foundation

struct Property: Identifiable {
    let id: String
    var title: String
    var owner: String
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.owner = data["owner"] as? String ?? ""
    }
    
    init(id: String = "", title: String = "", owner: String = "") {
        self.id = id
        self.title = title
        self.owner = owner
    }
    
    func isEmpty() -> Bool {
        return id.isEmpty && title.isEmpty && owner.isEmpty
    }
}

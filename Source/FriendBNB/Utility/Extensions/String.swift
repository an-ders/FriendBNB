//
//  String.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-01.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

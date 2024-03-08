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
	
	func formatPhoneNumber() -> String {
		let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		
		let mask = "(XXX) XXX-XXXX"
		
		var result = ""
		var startIndex = cleanNumber.startIndex
		var endIndex = cleanNumber.endIndex
		
		for char in mask where startIndex < endIndex {
			if char == "X" {
				result.append(cleanNumber[startIndex])
				startIndex = cleanNumber.index(after: startIndex)
			} else {
				result.append(char)
			}
		}
		
		return result
	}
}

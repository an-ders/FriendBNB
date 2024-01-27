//
//  InputField.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-25.
//

import Foundation

struct InputField<T> {
	var value: T
	var error: String
	
	init(_ value: T) {
		self.value = value
		self.error = ""
	}
}

//
//  NewPropertyInfo.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-10.
//

import Foundation

class NewPropertyInfo: ObservableObject {
	@Published var rooms: Int
	@Published var people: Int
	@Published var notes: String
	@Published var error: String
	
	var dictonary: [String: Any] {
		[
			"rooms": rooms,
			"people": people,
			"notes": notes
		]
	}
	
	init() {
		self.rooms = 1
		self.people = 4
		self.notes = ""
		self.error = ""
	}
}

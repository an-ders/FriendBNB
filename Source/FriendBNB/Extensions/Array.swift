//
//  Array.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import Foundation

extension Array where Element == Booking {
	func dict() -> [String: [Booking]] {
		var dict: [String: [Booking]] = [:]
		
		for booking in self {
			let startString = booking.start.monthYearString()
			let endString = booking.end.monthYearString()
			
			// Adding start date to booking
			if dict.keys.contains(startString) {
				dict[startString]?.append(booking)
			} else {
				dict[startString] = [booking]
			}
			
			// Adding end date if start and end date are different
			if startString != endString {
				if dict.keys.contains(endString) {
					dict[endString]?.append(booking)
				} else {
					dict[endString] = [booking]
				}
			}
		}
		
		return dict
	}
	
	func current() -> [Booking] {
		self.filter({ $0.end > Date() })
	}
	
	func withId(id: String) -> [Booking] {
		self.filter({ $0.userId == id})
	}
}

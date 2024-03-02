//
//  Availability.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-21.
//

import Foundation
import FirebaseFirestore

protocol DateRange {
	var start: Date { get set }
	var end: Date { get set }
}

struct Availability: DateRange, Identifiable, Equatable {
	let id = UUID()
	var type: ScheduleType = .available
	var start = Date()
	var end = Date()
	
	init() {}
	
	init(type: ScheduleType, data: [String: Any]) {
		self.type = type
		if let newStart = data["start"] as? Timestamp {
			self.start = newStart.dateValue().stripTime()
		}
		if let newEnd = data["end"] as? Timestamp {
			self.end = newEnd.dateValue().stripTime()
		}
	}
	
	var range: (ClosedRange<Date>) {
		(start ... end)
	}
	
	func overlaps(date: Date) -> Bool {
		//print(start)
		return (start ... end).contains(date)
	}
	
	static func == (lhs: Availability, rhs: Availability) -> Bool {
		return lhs.start == rhs.start && lhs.end == rhs.end
	}
}

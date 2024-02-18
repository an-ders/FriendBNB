//
//  Date.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import Foundation

extension Date {
    public var removeTimeStamp: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return self
        }
        return date
    }
    
    func stripTime() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
		components.hour = 0
        let date = Calendar.current.date(from: components)
        return date!
    }

    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func monthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL yyyy"
        return dateFormatter.string(from: self)
    }
    
    func plusMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
    func minusMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
	
	func plusDay() -> Date {
		return Calendar.current.date(byAdding: .day, value: 1, to: self)!
	}
	
	func minusDay() -> Date {
		return Calendar.current.date(byAdding: .day, value: -1, to: self)!
	}
    
    func daysInMonth() -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        return range.count
    }
    
    func dayOfMonth() -> Int {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day!
    }
    
    func firstOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func weekDay() -> Int {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        return components.weekday! - 1
    }
    
	func formattedDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		return dateFormatter.string(from: self)
	}
}

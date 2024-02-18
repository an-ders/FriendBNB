//
//  Booking.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import Foundation
import FirebaseFirestore

enum BookingStatus: String {
	case declined = "DECLINED"
	case pending = "PENDING"
	case confirmed = "CONFIRMED"
}

struct Booking: Equatable, Identifiable, Hashable {
    var id = UUID()
	var start: Date
	var end: Date
	var userId: String
	var email: String
	var name: String
	var status: BookingStatus
	var statusMessage: String
    
    init(data: [String: Any]) {
		self.start = Date()
        if let newStart = data["start"] as? Timestamp {
            self.start = newStart.dateValue().stripTime()
        }
		self.end = Date()
        if let newEnd = data["end"] as? Timestamp {
            self.end = newEnd.dateValue().stripTime()
        }
        
        self.userId = data["userId"] as? String ?? ""
		self.email = data["email"] as? String ?? ""
		self.name = data["name"] as? String ?? ""
		self.status = BookingStatus(rawValue: data["status"] as? String ?? "PENDING") ?? .pending
		self.statusMessage = data["statusMessage"] as? String ?? ""
    }
    
	init(start: Date, end: Date, userId: String, email: String, name: String, status: BookingStatus, statusMessage: String) {
        self.start = start
        self.end = end
        self.userId = userId
		self.email = email
		self.name = name
		self.status = status
		self.statusMessage = statusMessage
    }
    
    var bookingDates: (ClosedRange<Date>) {
        (start ... end)
    }
	
	var title: String {
		name.isEmpty ? email : name
	}
    
    func overlaps(date: Date) -> Bool {
        //print(start)
        return (start ... end).contains(date)
    }
    
    static func == (lhs: Booking, rhs: Booking) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}

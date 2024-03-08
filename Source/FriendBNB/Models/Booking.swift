//
//  Booking.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import Foundation
import FirebaseFirestore
import SwiftUI

struct Booking: DateRange, Identifiable, Hashable {
	var id: String
	var start: Date
	var end: Date
	var userId: String
	var email: String
	var name: String
	var status: BookingStatus
	var statusMessage: String
	var sensitiveInfo: [String]
	var isRequested: Bool = false
    
	init(id: String, data: [String: Any]) {
		self.id = id
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
		self.isRequested = data["isRequested"] as? Bool ?? false
		
		self.sensitiveInfo = []
		let infoArray = data["sensitiveInfo"] as? [String] ?? []
		for info in infoArray {
			sensitiveInfo.append(info)
		}
    }
    
	init(id: String, start: Date, end: Date, userId: String, email: String?, name: String?, status: BookingStatus, statusMessage: String, sensitiveInfo: [String], isRequested: Bool) {
		self.id = id
        self.start = start
        self.end = end
        self.userId = userId
		self.email = email ?? "MISSING EMAIL"
		self.name = name ?? "MISSING NAME"
		self.status = status
		self.statusMessage = statusMessage
		self.sensitiveInfo = sensitiveInfo
		self.isRequested = isRequested
    }
    
    var range: (ClosedRange<Date>) {
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
        return lhs.start == rhs.start && lhs.end == rhs.end && lhs.status == rhs.status && lhs.statusMessage == rhs.statusMessage && lhs.sensitiveInfo == rhs.sensitiveInfo && lhs.id == rhs.id
    }
}

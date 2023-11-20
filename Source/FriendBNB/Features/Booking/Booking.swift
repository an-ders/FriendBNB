//
//  Booking.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import Foundation
import FirebaseFirestore

struct Booking: Equatable, Identifiable {
    var id = UUID()
    var start: Date = Date()
    var end: Date = Date()
    var userId: String = ""
    
    init(data: [String: Any]) {
        if let newStart = data["start"] as? Timestamp {
            self.start = newStart.dateValue().stripTime()
        }
        if let newEnd = data["end"] as? Timestamp {
            self.end = newEnd.dateValue().stripTime()
        }
        
        self.userId = data["userId"] as? String ?? ""
    }
    
    init(start: Date, end: Date, userId: String) {
        self.start = start
        self.end = end
        self.userId = userId
    }
    
    func overlaps(date: Date) -> Bool {
        //print(start)
        return (start ... end).contains(date)
    }
    
    static func == (lhs: Booking, rhs: Booking) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}

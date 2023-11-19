//
//  Booking.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import Foundation
import FirebaseFirestore

struct Booking: Equatable {
    var start: Date
    //var startTimeStamp: Timestamp
    var end: Date
    //var endTimeStamp: Timestamp
    
    init(data: [String: Any]) {
        self.start = Date()
        if let newStart = data["start"] as? Timestamp {
            self.start = newStart.dateValue().stripTime()
        }
        self.end = Date()
        if let newEnd = data["end"] as? Timestamp {
            self.end = newEnd.dateValue().stripTime()
        }
    }
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
    
    func overlaps(date: Date) -> Bool {
        //print(start)
        return (start ... end).contains(date)
    }
    
    static func == (lhs: Booking, rhs: Booking) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}

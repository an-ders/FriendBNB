//
//  Booking.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import Foundation
import FirebaseFirestore

struct Booking {
    var start: Date
    //var startTimeStamp: Timestamp
    var end: Date
    //var endTimeStamp: Timestamp
    
    func overlaps(date: Date) -> Bool {
        //print(start)
        return (start ... end).contains(date)
    }
}

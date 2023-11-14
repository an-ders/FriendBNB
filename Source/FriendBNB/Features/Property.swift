//
//  Property.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-03.
//

import Foundation
import FirebaseFirestore

class Property: Identifiable, ObservableObject {
    let id: String
    @Published var title: String
    @Published var owner: String
    @Published var people: Int
    @Published var rooms: Int
    
    @Published var location: Location
    @Published var bookings: [String: [Booking]]
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.owner = data["owner"] as? String ?? ""
        self.people = data["people"] as? Int ?? 0
        self.rooms = data["rooms"] as? Int ?? 0
        
        self.location = Location(data: data)
        self.bookings = [:]
        
        let bookings = data["bookings"] as? [[String: Any]] ?? [[:]]
        bookings.map { rawBooking in
            var start = Date()
            if let newStart = rawBooking["start"] as? Timestamp {
                start = newStart.dateValue().stripTime()
            }
            var end = Date()
            if let newEnd = rawBooking["end"] as? Timestamp {
                end = newEnd.dateValue().stripTime()
            }
            
            //let booking = Booking(start: start, end: end)
            let startString = start.monthYearString()
            let endString = end.monthYearString()
            
            if self.bookings.keys.contains(startString) {
                self.bookings[startString]?.append(Booking(start: start, end: end))
            } else {
                self.bookings[startString] = [Booking(start: start, end: end)]
            }
            
            if startString != endString {
                if self.bookings.keys.contains(endString) {
                    self.bookings[endString]?.append(Booking(start: start, end: end))
                } else {
                    self.bookings[endString] = [Booking(start: start, end: end)]
                }
            }
            
            let booking = Booking(start: start, end: end)
            
//            print(someDateTime)
//            print(booking.overlaps(date: someDateTime!))
        }
    }
    
    init(
        id: String = "",
        title: String = "",
        owner: String = "",
        people: Int = 0,
        rooms: Int = 0,
        location: Location = Location(),
        bookings: [String: [Booking]] = [:]
    ) {
        self.id = id
        self.title = title
        self.owner = owner
        self.people = people
        self.rooms = rooms
        self.location = location
        self.bookings = bookings
    }
}

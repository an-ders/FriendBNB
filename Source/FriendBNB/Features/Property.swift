//
//  Property.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-03.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct PropertyTest {
    var owner: String
}

struct Property: Identifiable {
    let id: String
    var title: String
    var owner: String
    var people: Int
    var rooms: Int
    
    var location: Location
    var bookings: [Booking]
    var bookingsDict: [String: [Booking]]
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.owner = data["owner"] as? String ?? ""
        self.people = data["people"] as? Int ?? 0
        self.rooms = data["rooms"] as? Int ?? 0
        
        self.location = Location(data: data)
        
        self.bookings = []
        let bookingDataArray = data["bookings"] as? [[String: Any]] ?? []
        for bookingData in bookingDataArray {
            bookings.append(Booking(data: bookingData))
        }
        self.bookingsDict = [:]
        for booking in bookings {
            let startString = booking.start.monthYearString()
            let endString = booking.end.monthYearString()
            
            if self.bookingsDict.keys.contains(startString) {
                self.bookingsDict[startString]?.append(booking)
            } else {
                self.bookingsDict[startString] = [booking]
            }
            
            if startString != endString {
                if self.bookingsDict.keys.contains(endString) {
                    self.bookingsDict[endString]?.append(booking)
                } else {
                    self.bookingsDict[endString] = [booking]
                }
            }
        }
    }
    
    init(
        id: String = "",
        title: String = "",
        owner: String = "",
        people: Int = 0,
        rooms: Int = 0,
        location: Location = Location(),
        bookings: [Booking] = [],
        bookingsDict: [String: [Booking]] = [:]
    ) {
        self.id = id
        self.title = title
        self.owner = owner
        self.people = people
        self.rooms = rooms
        self.location = location
        self.bookings = bookings
        self.bookingsDict = bookingsDict
    }
    
//    init(asyncId: String) async {
//        let db = Firestore.firestore()
//        let ref = db.collection("Properties").document(asyncId)
//        var bookings: [Booking] = []
//        var data: [String: Any] = [:]
//        do {
//            let documentsInfo = try await ref.getDocument()
//            if let updatedData = documentsInfo.data() {
//                data = updatedData
//            }
//
//            let bookingsSnapshot = try await ref.collection("Bookings").getDocuments()
//            for document in bookingsSnapshot.documents {
//                let bookingData = document.data()
//                bookings.append(Booking(data: bookingData))
//            }
//        } catch {
//            print("Error getting document \(asyncId)")
//        }
//        self.id = asyncId
//        self.title = data["title"] as? String ?? ""
//        self.owner = data["owner"] as? String ?? ""
//        self.people = data["people"] as? Int ?? 0
//        self.rooms = data["rooms"] as? Int ?? 0
//
//        self.location = Location(data: data)
//        self.bookings = bookings
//        self.bookingsDict = [:]
//
//        for booking in bookings {
//            let startString = booking.start.monthYearString()
//            let endString = booking.end.monthYearString()
//
//            if self.bookingsDict.keys.contains(startString) {
//                self.bookingsDict[startString]?.append(booking)
//            } else {
//                self.bookingsDict[startString] = [booking]
//            }
//
//            if startString != endString {
//                if self.bookingsDict.keys.contains(endString) {
//                    self.bookingsDict[endString]?.append(booking)
//                } else {
//                    self.bookingsDict[endString] = [booking]
//                }
//            }
//        }
//    }
    
    mutating func test() {
        self.owner = "test"
    }
    
    func updateBooking(_ data: [String: Any]) {
        
    }
    
    mutating func updateData(_ data: [String: Any]) {
        self.title = data["title"] as? String ?? ""
        self.owner = data["owner"] as? String ?? ""
        self.people = data["people"] as? Int ?? 0
        self.rooms = data["rooms"] as? Int ?? 0
        
        self.location = Location(data: data)
        
        self.bookings = []
        let bookingDataArray = data["bookings"] as? [[String: Any]] ?? []
        for bookingData in bookingDataArray {
            bookings.append(Booking(data: bookingData))
        }
        self.bookingsDict = [:]
        for booking in bookings {
            let startString = booking.start.monthYearString()
            let endString = booking.end.monthYearString()
            
            if self.bookingsDict.keys.contains(startString) {
                self.bookingsDict[startString]?.append(booking)
            } else {
                self.bookingsDict[startString] = [booking]
            }
            
            if startString != endString {
                if self.bookingsDict.keys.contains(endString) {
                    self.bookingsDict[endString]?.append(booking)
                } else {
                    self.bookingsDict[endString] = [booking]
                }
            }
        }
    }
}

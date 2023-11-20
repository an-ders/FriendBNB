//
//  BookingManager.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-16.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class BookingManager: ObservableObject {
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var date = Date()
    @Published var property: Property
    
    @Published var showExistingBookingSheet = false
    @Published var showNewBookingSheet = false {
        didSet {
            self.startDate = nil
            self.endDate = nil
        }
    }
    
    @Published var error: String?
    var listener: ListenerRegistration?
    
    init(_ property: Property) {
        self.property = property
    }
    
    var filteredBookings: [Booking] {
        self.property.bookings.filter({ $0.userId == Auth.auth().currentUser?.uid ?? "" })
    }
    
    func subscribe() {
        print("Adding listener in BOOKING MANAGER")
        
        let db = Firestore.firestore()
        self.listener = db.collection("Properties").document(property.id)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                if let newData = document.data() {
                    print("Updating data BOOKING MANAGER")
                    self.property.updateData(newData)
                    
                } else {
                }
            }
    }
    
    func unsubscribe() {
        print("Removing listener from BOOKING MANAGER")
        self.listener?.remove()
    }
    
    func createBooking() async {
        guard startDate != nil else {
            error = "Please choose a start date."
            return
        }
        guard endDate != nil else {
            error = "Please choose an end date."
            return
        }
        
        for booking in property.bookings where (booking.start ... booking.end).overlaps(startDate! ... endDate!) {
            error = "One or more of your dates is already booked."
            return
        }
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let db = Firestore.firestore()
        do {
            try await db.collection("Properties").document(property.id).updateData([
                "bookings": FieldValue.arrayUnion([["start": startDate as Any, "end": endDate as Any, "userId": id]])
              ])
            print("Booking from \(String(describing: startDate)) to \(String(describing: endDate))")
        } catch {
            print("Error booking: \(error)")
        }
        self.error = ""
        self.showNewBookingSheet = false
        unsubscribe()
    }
    
    func deleteBooking(_ booking: Booking) async {
        print("Attempting to delete booking")
        let db = Firestore.firestore()
        do {
            try await db.collection("Properties").document(property.id).updateData([
                "bookings": FieldValue.arrayRemove([["start": booking.start as Any, "end": booking.end as Any, "userId": booking.userId]])
              ])
            print("Deleting booking from \(String(describing: startDate)) to \(String(describing: endDate))")
        } catch {
            print("Error deleting booking: \(error)")
        }
    }
    
    func previousMonth() {
        self.date = date.minusMonth()
    }
    
    func nextMonth() {
        self.date = date.plusMonth()
    }
    
    func dateClicked(_ date: Date) {
        if startDate != nil && endDate != nil {
            startDate = date
            endDate = nil
        } else if startDate == nil && endDate == nil {
            startDate = date
            endDate = nil
        } else {
            guard startDate != nil else {
                return
            }
            if date < startDate! {
                endDate = startDate
                startDate = date
            } else {
                endDate = date
            }
        }
    }
    
    func isHightlighted(_ date: Date) -> Bool {
        var highlighted = false
        
        if let start = startDate {
            highlighted = start == date
        } else if let end = endDate {
            highlighted = end == date
        }
        
        if let start = startDate, let end = endDate {
            highlighted = (start...end).contains(date)
        }
        
        return highlighted
    }
    
    func isBooked(_ date: Date) -> Bool {
        let monthYear = date.monthYearString()
        guard property.bookingsDict.keys.contains(monthYear) else {
            return false
        }
        
        for booking in property.bookingsDict[monthYear]! where booking.overlaps(date: date) {
            return true
        }
        
        return false
    }
}

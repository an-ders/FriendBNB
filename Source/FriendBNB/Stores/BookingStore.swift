//
//  bookingStore.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-16.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum BookingType: String {
	case available
	case unavailable
	case booking = "bookings"
}

@MainActor
class BookingStore: ObservableObject {
	func addSchedule(startDate: Date?, endDate: Date?, property: Property, type: BookingType) async -> String? {
		guard let startDate = startDate else {
			return "Please choose a start date."
		}
		guard let endDate = endDate else {
			return "Please choose an end date."
		}
		
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(property.id).updateData([
				type.rawValue: FieldValue.arrayUnion([["start": startDate as Any, 
														   "end": endDate as Any]])
			])
			print("Booking from \(String(describing: startDate)) to \(String(describing: endDate))")
		} catch {
			print("Error booking: \(error)")
			return error.localizedDescription
		}
		
		return nil
	}
	
	func createBooking(startDate: Date?, endDate: Date?, property: Property, message: String = "") async -> String? {
		
		if let error = checkBookingAvailable(startDate: startDate, endDate: endDate, property: property) {
			return error
		}
		
		let user = Auth.auth().currentUser!
		let id = user.uid
		
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(property.id).updateData([
				"bookings": FieldValue.arrayUnion([
					["start": startDate as Any,
					 "end": endDate as Any,
					 "userId": id,
					 "email": user.email ?? "",
					 "name": user.displayName ?? "",
					 "status": BookingStatus.pending.rawValue,
					 "statusMessage": message]])
			])
			print("Booking from \(String(describing: startDate)) to \(String(describing: endDate))")
		} catch {
			print("Error booking: \(error)")
			return error.localizedDescription
		}
		
		return nil
	}
	
	func checkBookingAvailable(startDate: Date?, endDate: Date?, property: Property) -> String? {
		guard var startDate = startDate else {
			return "Please choose a start date."
		}
		guard var endDate = endDate else {
			return "Please choose an end date."
		}
		
		guard startDate >= Date().stripTime() else {
			return "Please choose a current date"
		}
		
		let bookingDates = (startDate ... endDate)
		
		for booking in property.bookings where (booking.start ... booking.end).overlaps(bookingDates) {
			return "One or more of your dates is already booked."
		}
		
		for booking in property.unavailable where (booking.bookingDates).overlaps(bookingDates) {
			return "One or more of your dates is unavailable."
		}
		
		var bookingDays = [Date]()
		while startDate <= endDate {
			bookingDays.append(startDate)
			startDate = startDate.plusDay()
		}
		
		for available in property.available.dateSorted() {
			while let date = bookingDays.first, available.overlaps(date: date) {
				bookingDays.removeFirst()
			}
		}
		
		if bookingDays.isEmpty {
			return nil
		}
		
//		for booking in property.available where booking.bookingDates.contains(startDate) && booking.bookingDates.contains(endDate) {
//			return nil
//		}
		
		return "One or more of your dates is not available"
	}
	
	func deleteBooking(_ booking: Booking, type: BookingType, property: Property) async {
		print("Attempting to delete booking")
		let db = Firestore.firestore()
		do {
			switch type {
			case .available:
				try await db.collection("Properties").document(property.id).updateData([
					type.rawValue: FieldValue.arrayRemove([["start": booking.start as Any, "end": booking.end as Any]])
				])
			case .booking:
				try await db.collection("Properties").document(property.id).updateData([
					type.rawValue: FieldValue.arrayRemove([
						["start": booking.start as Any,
						 "end": booking.end as Any,
						 "userId": booking.userId,
						 "email": booking.email,
						 "name": booking.name,
						 "status": booking.status.rawValue,
						 "statusMessage": booking.statusMessage]
					])
				])
			case .unavailable:
				try await db.collection("Properties").document(property.id).updateData([
					type.rawValue: FieldValue.arrayRemove([["start": booking.start as Any, "end": booking.end as Any]])
				])
			}
			print("Deleting booking from \(String(describing: booking.start)) to \(String(describing: booking.end))")
		} catch {
			print("Error deleting booking: \(error)")
		}
	}
	
	func updateBooking(booking: Booking,
					   property: Property,
					   status: BookingStatus,
					   message: String) async -> String? {
		
		let user = Auth.auth().currentUser!
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(property.id).updateData([
				"bookings": FieldValue.arrayRemove([
					["start": booking.start as Any,
					 "end": booking.end as Any,
					 "userId": booking.userId,
					 "email": booking.email,
					 "name": booking.name,
					 "status": booking.status.rawValue,
					 "statusMessage": booking.statusMessage]
				])
			])
			
			try await db.collection("Properties").document(property.id).updateData([
				"bookings": FieldValue.arrayUnion([
					["start": booking.start as Any,
					 "end": booking.end as Any,
					 "userId": booking.userId,
					 "email": booking.email,
					 "name": booking.name,
					 "status": status.rawValue,
					 "statusMessage": message]])
			])
			print("Booking updated to \(status.rawValue)")
		} catch {
			print("Error booking: \(error)")
			return error.localizedDescription
		}
		
		return nil
	}
}

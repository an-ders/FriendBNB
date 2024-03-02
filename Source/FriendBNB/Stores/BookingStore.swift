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

@MainActor
class BookingStore: ObservableObject {
	func createBooking(startDate: Date?, endDate: Date?, property: Property, message: String = "", sensitiveInfo: [String] = []) async -> String? {
		
		if let error = checkBookingDates(startDate: startDate, endDate: endDate, property: property) {
			return error
		}
		
		let user = Auth.auth().currentUser!
		
		let db = Firestore.firestore()
		do {
			let id = db.collection("Properties").document(property.id).collection("Bookings").document().documentID
			try await db.collection("Properties").document(property.id).collection("Bookings").document(id).setData(
				["id": id,
				 "start": startDate as Any,
				 "end": endDate as Any,
				 "userId": user.uid,
				 "email": user.email ?? "",
				 "name": user.displayName ?? "",
				 "status": BookingStatus.pending.rawValue,
				 "statusMessage": message,
				 "sensitiveInfo": sensitiveInfo])
			print("Booking from \(String(describing: startDate)) to \(String(describing: endDate))")
		} catch {
			print("Error booking: \(error)")
			return error.localizedDescription
		}
		
		return nil
	}
	
	func checkBookingDates(startDate: Date?, endDate: Date?, property: Property) -> String? {
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
		
		for unavailable in property.unavailable where (unavailable.range).overlaps(bookingDates) {
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
		
		return "One or more of your dates is not available"
	}
	
	func deleteBooking(_ booking: Booking, propertyId: String) async {
		print("Attempting to delete booking")
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(propertyId).collection("Bookings").document(booking.id).delete()
			
			print("Deleting booking from \(String(describing: booking.start)) to \(String(describing: booking.end))")
		} catch {
			print("Error deleting booking: \(error)")
		}
	}
	
	func updateBooking(booking: Booking,
					   property: Property,
					   status: BookingStatus,
					   message: String,
					   sensitiveInfo: [String]) async -> String? {
		
		let user = Auth.auth().currentUser!
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(property.id).collection("Bookings").document(booking.id).updateData(
				["status": status.rawValue,
				 "statusMessage": message,
				 "sensitiveInfo": sensitiveInfo])
			print("Booking updated to \(status.rawValue)")
		} catch {
			print("Error booking: \(error)")
			return error.localizedDescription
		}
		
		return nil
	}
}

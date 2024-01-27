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
	var notes: String
	
	var location: Location
	var bookings: [Booking]
	var available: [Booking]
	var unavailable: [Booking]
	
	init(
		id: String,
		title: String = "",
		owner: String = "",
		people: Int = 0,
		rooms: Int = 0,
		location: Location = Location(),
		notes: String = "",
		bookings: [Booking] = [],
		available: [Booking] = [],
		unavailable: [Booking] = []
	) {
		self.id = id
		self.title = title
		self.owner = owner
		self.people = people
		self.rooms = rooms
		self.notes = notes
		self.location = location
		self.bookings = bookings
		self.available = available
		self.unavailable = unavailable
	}
	
	init(id: String, data: [String: Any]) {
		self.id = id
		self.title = data["title"] as? String ?? ""
		self.owner = data["owner"] as? String ?? ""
		self.people = data["people"] as? Int ?? 0
		self.rooms = data["rooms"] as? Int ?? 0
		self.notes = data["notes"] as? String ?? ""
		
		self.location = Location(data: data)
		
		self.bookings = []
		self.available = []
		self.unavailable = []

		let bookingDataArray = data["bookings"] as? [[String: Any]] ?? []
		for bookingData in bookingDataArray {
			bookings.append(Booking(data: bookingData))
		}
		
		let availabilityDataArray = data["available"] as? [[String: Any]] ?? []
		for availabilityData in availabilityDataArray {
			available.append(Booking(data: availabilityData))
		}
		
		let busyDataArray = data["unavailable"] as? [[String: Any]] ?? []
		for busyData in busyDataArray {
			unavailable.append(Booking(data: busyData))
		}
	}
}

//
//  Property.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-03.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Property: Identifiable, Hashable {
	var id: String = ""
	var ownerId: String = ""
	var ownerName: String = ""
	
	var info: PropertyInfo = PropertyInfo()
	
	var location: Location = Location()
	var bookings: [Booking] = []
	var available: [Availability] = []
	var unavailable: [Availability] = []
	
	init() {}
	
	init(id: String, propertyData: [String: Any], bookingDocuments: [QueryDocumentSnapshot]) {
		self.id = id
		self.ownerId = propertyData["ownerId"] as? String ?? ""
		self.ownerName = propertyData["ownerName"] as? String ?? ""
		
		self.info = PropertyInfo(data: propertyData["info"] as? [String: Any] ?? [:])
		
		self.location = Location(data: propertyData["location"] as? [String: Any] ?? [:])

		for document in bookingDocuments {
			let data = document.data()
			let newBooking = Booking(id: document.documentID, data: data)
			self.bookings.append(newBooking)
		}
		
		let availabilityDataArray = propertyData["available"] as? [[String: Any]] ?? []
		for availabilityData in availabilityDataArray {
			available.append(Availability(type: .available, data: availabilityData))
		}
		
		let busyDataArray = propertyData["unavailable"] as? [[String: Any]] ?? []
		for busyData in busyDataArray {
			unavailable.append(Availability(type: .unavailable, data: busyData))
		}
	}
	
	init(property: Property, propertyData: [String: Any]) {
		self.id = property.id
		self.ownerId = propertyData["ownerId"] as? String ?? ""
		self.ownerName = propertyData["ownerName"] as? String ?? ""
		
		self.info = PropertyInfo(data: propertyData["info"] as? [String: Any] ?? [:])
		
		self.location = Location(data: propertyData["location"] as? [String: Any] ?? [:])

		self.bookings = property.bookings
		
		let availabilityDataArray = propertyData["available"] as? [[String: Any]] ?? []
		for availabilityData in availabilityDataArray {
			available.append(Availability(type: .available, data: availabilityData))
		}
		
		let busyDataArray = propertyData["unavailable"] as? [[String: Any]] ?? []
		for busyData in busyDataArray {
			unavailable.append(Availability(type: .unavailable, data: busyData))
		}
	}
	
	init(property: Property, bookingDocuments: [QueryDocumentSnapshot]) {
		self.id = property.id
		self.ownerId = property.ownerId
		self.ownerName = property.ownerName
		self.info = property.info
		self.location = property.location
		self.available = property.available
		self.unavailable = property.unavailable
		
		for document in bookingDocuments {
			let data = document.data()
			let newBooking = Booking(id: document.documentID, data: data)
			self.bookings.append(newBooking)
		}
	}
	
	var shareMessage: String {
		"""
		Install FriendBNB on the app store and add my property!
		I've got a place you can check out.
		
		\(self.info.nickname.isEmpty ? self.ownerName + "'s Place" : self.info.nickname) in \(self.location.city) \(self.location.state)
		Months available:
		\(availableMonths)
		Property id: \(self.id)
		"""
	}
	
	var availableMonths: String {
		var string = ""
		var count = 0
		for month in available.current().dateSorted().dict().keys {
			string += "   -\(month)\n"
			if count >= 4 {
				string += "    And more..."
				break
			}
			count += 1
		}
		return string
	}
	
	var shareLink: URL? {
		URL(string: "FriendBNB://id=\(self.id)")
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: Property, rhs: Property) -> Bool {
		lhs.id == rhs.id
	}
}

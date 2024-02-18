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

struct Property: Identifiable, Hashable {
	let id: String
	var nickname: String
	var ownerId: String
	var ownerName: String
	var people: Int
	
	var notes: String
	var cleaningNotes: String
	var wifi: String
	var securityCode: String
	var contactInfo: String
	
	var payment: PaymentFee
	var cost: Int
	var paymentNotes: String
	
	var location: Location
	var bookings: [Booking]
	var available: [Booking]
	var unavailable: [Booking]
	
	init(
		id: String,
		nickname: String = "",
		ownerId: String = "",
		ownerName: String = "",
		people: Int = 0,
		cleaningNotes: String = "",
		wifi: String = "",
		securityCode: String = "",
		payment: PaymentFee = .free,
		cost: Int = 0,
		paymentNotes: String = "",
		contactInfo: String = "",
		notes: String = "",
		location: Location = Location(),
		bookings: [Booking] = [],
		available: [Booking] = [],
		unavailable: [Booking] = []
	) {
		self.id = id
		self.nickname = nickname
		self.ownerId = ownerId
		self.ownerName = ownerName
		self.people = people
		
		self.notes = notes
		self.cleaningNotes = cleaningNotes
		self.wifi = wifi
		self.securityCode = securityCode
		self.contactInfo = contactInfo
		
		self.payment = payment
		self.cost = cost
		self.paymentNotes = paymentNotes
		
		self.location = location
		self.bookings = bookings
		self.available = available
		self.unavailable = unavailable
	}
	
	init(id: String, data: [String: Any]) {
		self.id = id
		self.nickname = data["nickname"] as? String ?? ""
		self.ownerId = data["ownerId"] as? String ?? ""
		self.ownerName = data["ownerName"] as? String ?? ""
		self.people = data["people"] as? Int ?? 0
		
		self.notes = data["notes"] as? String ?? ""
		self.cleaningNotes = data["cleaningNotes"] as? String ?? ""
		self.wifi = data["wifi"] as? String ?? ""
		self.securityCode = data["securityCode"] as? String ?? ""
		self.contactInfo = data["contactInfo"] as? String ?? ""
		
		self.payment = PaymentFee(rawValue: data["payment"] as? String ?? "") ?? .free
		self.cost = data["cost"] as? Int ?? 0
		self.paymentNotes = data["paymentNotes"] as? String ?? ""
		
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
	
	var shareMessage: String {
		"""
		Install FriendBNB on the app store and add my property!
		I've got a place you can check out.
		
		\(self.nickname.isEmpty ? ownerName + "'s Place" : self.nickname) in \(self.location.city) \(self.location.state)
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

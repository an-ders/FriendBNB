//
//  PropertyStore.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-13.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class PropertyStore: ObservableObject {
	@Published var showTabBar = true
	@Published var selectedTab: RootTabs = .owned
	
	@Published var ownedProperties: [Property] = []
	@Published var friendsProperties: [Property] = []
	
	// OWNED PAGE
	@Published var showOwnedAvailabilitySheet = false
	@Published var showOwnedExistingBookingsSheet = false
	@Published var ownedSelectedBooking: PropertyBookingGroup?
	@Published var ownedSelectedProperty: Property? {
		didSet {
			showTabBar = ownedSelectedProperty == nil
		}
	}
	
	// FRIEND PAGE
	@Published var showFriendNewBookingSheet = false
	@Published var friendSelectedBookingInDetail: Booking?
	@Published var friendSelectedBooking: PropertyBookingGroup?
	@Published var friendSelectedProperty: Property? {
		didSet {
			showTabBar = friendSelectedProperty == nil
		}
	}
	
	@Published var showNewPropertySheet = false
	@Published var showAddPropertySheet = false
	
	@Published var selectedAddToCalendar: PropertyBookingGroup?
	
	@Published var addPropertyID: String?
	
	@Published var loading = false
	
	var propertyListener: ListenerRegistration?
	var bookingListener: ListenerRegistration?
	
	var numberPending: Int {
		var count = 0
		for properties in ownedProperties {
			for booking in properties.bookings {
				if booking.status == .pending {
					count += 1
				}
			}
		}
		return count
	}
	
	func showProperty(_ property: Property, type: PropertyType, showAvailability: Bool = false) {
		self.selectedTab = type == .owned ? .owned : .friends
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			switch type {
			case .owned:
				self.ownedSelectedProperty = property
			case .friend:
				self.friendSelectedProperty = property
			}
		}
		
		if showAvailability {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
				switch type {
				case .owned:
					self.showOwnedAvailabilitySheet = showAvailability
				case .friend: break
				}
			}
		}
	}
	
	func dismissProperty() {
		self.ownedSelectedProperty = nil
		self.friendSelectedProperty = nil
	}
	
	func getSelectedProperty(_ type: PropertyType) -> Property? {
		switch type {
		case .owned:
			return self.ownedSelectedProperty
		case .friend: 
			return self.friendSelectedProperty
		}
	}
	
	func showBooking(booking: Booking, property: Property, type: PropertyType) {
		self.selectedTab = type == .owned ? .owned : .friends
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			switch type {
			case .owned:
				self.ownedSelectedBooking = PropertyBookingGroup(property: property, booking: booking)
			case .friend:
				self.friendSelectedBooking = PropertyBookingGroup(property: property, booking: booking)
			}
		}
	}
	
	func dismissBooking() {
		self.ownedSelectedBooking = nil
		self.friendSelectedBooking = nil
	}
	
	func getSelectedBooking(_ type: PropertyType) -> Booking? {
		switch type {
		case .owned:
			return self.ownedSelectedBooking?.booking
		case .friend:
			return self.friendSelectedBooking?.booking
		}
	}
	
	func subscribe(type: PropertyType) {
		print("SUBSCRIBING: \(type.rawValue)")
		guard let property = type == .owned ? ownedSelectedProperty : friendSelectedProperty else {
			return
		}
		let db = Firestore.firestore()
		self.propertyListener = db.collection("Properties").document(property.id)
			.addSnapshotListener { documentSnapshot, error in
				guard let document = documentSnapshot else {
					print("Error fetching document: \(error!)")
					return
				}
				
				if let newData = document.data() {
					switch type {
					case .friend:
						self.friendSelectedProperty = Property(property: property, propertyData: newData)
					case .owned:
						self.ownedSelectedProperty = Property(property: property, propertyData: newData)
					}
				} else {
					self.dismissProperty()
					switch type {
					case .friend:
						Task {
							await self.fetchProperties(.friend)
						}
					case .owned:
						Task {
							await self.fetchProperties(.owned)
						}
					}
				}
			}
		
		self.bookingListener = db.collection("Properties").document(property.id).collection("Bookings")
			.addSnapshotListener { documentsSnapshot, error in
				guard let documents = documentsSnapshot?.documents else {
					print("Error fetching documents: \(error!)")
					return
				}
				
				switch type {
				case .friend:
					self.friendSelectedProperty = Property(property: property, bookingDocuments: documents)
				case .owned:
					self.ownedSelectedProperty = Property(property: property, bookingDocuments: documents)
				}
			}
	}
	
	func unsubscribe() {
		print("Removing listener from DETAIL VIEW")
		self.propertyListener?.remove()
	}
	
	func getProperty(id: String) async -> Property? {
		let db = Firestore.firestore()
		
		print("Fetching properties: \(id)")
		
		guard await self.checkValidId(id) != nil else { return nil }
		
		do {
			let document = try await db.collection("Properties").document(id).getDocument()
			
			guard let data = document.data() else {
				return nil
			}
			
			let bookingSnapshot = try await db.collection("Properties").document(id).collection("Bookings").getDocuments()
			return Property(id: document.documentID, propertyData: data, bookingDocuments: bookingSnapshot.documents)
			
		} catch {
			return nil
		}
	}
	
	func fetchProperties(_ type: PropertyType) async {
		self.loading = true
		let db = Firestore.firestore()
		
		guard Auth.auth().currentUser != nil else {
			print("User not found")
			self.loading = false
			return
		}
		
		// Get list of property Ids
		var propertyIds = [String]()
		print("Attempting to fetch property Ids")
		do {
			let document = try await db.collection("Accounts").document(Auth.auth().currentUser!.uid).getDocument()
			let data = document.data() ?? [:]
			propertyIds = data[type.rawValue] as? [String] ?? [String]()
			
			print("Successfully fetched \(type.rawValue) Ids")
		} catch {
			print("Error getting Ids \(error.localizedDescription)")
		}
		
		print("Fetching properties: \(propertyIds)")
		var newProperties: [Property] = []
		
		for propertyId in propertyIds {
			do {
				let document = try await db.collection("Properties").document(propertyId).getDocument()
				
				guard let data = document.data() else {
					continue
				}
				
				let bookingSnapshot = try await db.collection("Properties").document(propertyId).collection("Bookings").getDocuments()
				
				newProperties.append(Property(id: document.documentID, propertyData: data, bookingDocuments: bookingSnapshot.documents))
			} catch {				
				self.loading = false
				return
			}
		}
		let newPropertiesIds = newProperties.map { $0.id }
		
		print("Attempting to write new property Ids")
		do {
			try await db.collection("Accounts").document(Auth.auth().currentUser!.uid).setData([
				type.rawValue: newPropertiesIds
			], merge: true)
			print("Successfully set \(type.rawValue) Ids")
		} catch {
			print("Error setting Ids \(error.localizedDescription)")
		}
		
		if type == .owned {
			self.ownedProperties = newProperties
		} else {
			self.friendsProperties = newProperties
		}
		self.loading = false
	}
	
	func addPropertyToUser(_ id: String, type: PropertyType) async {
		let db = Firestore.firestore()
		let ref = db.collection("Accounts")
		
		guard Auth.auth().currentUser != nil else {
			print("User not found")
			return
		}
		
		print("Attempting to add Id: \(id) to user \(Auth.auth().currentUser!.uid)")
		do {
			try await ref.document(Auth.auth().currentUser!.uid).updateData([
				type.rawValue: FieldValue.arrayUnion([id])
			])
			print("Successfully added Id to \(type.rawValue)")
			
		} catch {
			print("Error adding Id: \(error.localizedDescription)")
		}
		
		Task {
			await fetchProperties(type)
		}
	}
	
	func removePropertyFromUser(_ id: String, type: PropertyType) async {
		let db = Firestore.firestore()
		let ref = db.collection("Accounts")
		
		guard Auth.auth().currentUser != nil else {
			print("User not found")
			return
		}
		
		print("Attempting to remove Id \(id) from user \(Auth.auth().currentUser!.uid)")
		do {
			try await ref.document(Auth.auth().currentUser!.uid).updateData([
				type.rawValue: FieldValue.arrayRemove([id])
			])
			print("Successfully removed Id from \(type.rawValue)")
		} catch {
			print("Error removing Id: \(error.localizedDescription)")
		}
		
		Task {
			await fetchProperties(type)
		}
	}
	
	func createProperty(location: Location, info: NewPropertyInfo) async -> String {
		if info.nickname == "", let name = Auth.auth().currentUser?.displayName {
			info.nickname = name + "'s Property"
		}
		var newDict = location.dictonary.merging(info.dictonary) { (_, new) in new }
		if let user = Auth.auth().currentUser {
			newDict = newDict.merging([
				"ownerId": user.uid,
				"ownerName": user.displayName ?? ""
			]) { (_, new) in new }
		}
		
		let db = Firestore.firestore()
		let id = db.collection("Properties").document().documentID
		do {
			try await db.collection("Properties").document(id).setData(newDict)
			print("Document successfully written!")
		} catch {
			print("Error writing document: \(error)")
		}
		
		return id
	}
	
	func deleteProperty(id: String) async {
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(id).delete()
			print("Document successfully removed \(id)!")
		} catch {
			print("Error removing document: \(error)")
		}
	}
	
	func resetProperty(_ type: PropertyType) async {
		let db = Firestore.firestore()
		let ref = db.collection("Accounts")
		
		guard Auth.auth().currentUser != nil else {
			print("User not found")
			return
		}
		
		print("Attempting to reset \(Auth.auth().currentUser!) properties")
		do {
			try await ref.document(Auth.auth().currentUser!.uid).setData([
				type.rawValue: []
			])
			print("Successfully reset \(type.rawValue) Ids")
		} catch {
			print("Error resetting Ids: \(error.localizedDescription)")
		}
	}
	
	func checkValidId(_ propertyId: String) async -> String? {
		var id: String?
		guard !propertyId.isEmpty else {
			return id
		}
		
		let db = Firestore.firestore()
		let ref = db.collection("Properties").document(propertyId)
		do {
			try await Task.sleep(nanoseconds: 500000000)
			let document = try await ref.getDocument()
			if document.exists {
				id = document.documentID
			}
		} catch {
			print(error.localizedDescription)
		}
		
		return id
	}
	
	func addSchedule(startDate: Date?, endDate: Date?, type: ScheduleType, property: Property) async -> String? {
		guard let startDate = startDate else {
			return "Please choose a start date."
		}
		
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(property.id).updateData([
				type.rawValue: FieldValue.arrayUnion([["start": startDate as Any,
													   "end": endDate ?? startDate as Any]])
			])
			print("Booking from \(String(describing: startDate)) to \(String(describing: endDate))")
		} catch {
			print("Error booking: \(error)")
			return error.localizedDescription
		}
		
		return nil
	}
	
	func deleteSchedule(_ schedule: Availability, propertyId: String) async {
		print("Attempting to delete booking")
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(propertyId).updateData([
				schedule.type.rawValue: FieldValue.arrayRemove([["start": schedule.start as Any, "end": schedule.end as Any]])
			])
			print("Deleting booking from \(String(describing: schedule.start)) to \(String(describing: schedule.end))")
		} catch {
			print("Error deleting booking: \(error)")
		}
	}
	
	func readNotification(_ data: [AnyHashable: Any]) {
		guard let bookingId = data["bookingId"] as? String else { return }
		guard let propertyId = data["propertyId"] as? String else { return }
		guard let userId = Auth.auth().currentUser?.uid else { return }
		
		if let type = data["type"] as? String, type == "owned" {
			Task { @MainActor in
				if let property = await self.getProperty(id: propertyId), property.ownerId == userId, let booking = property.bookings.filter({ $0.id == bookingId }).first {
					self.dismissProperty()
					self.dismissBooking()
					await self.fetchProperties(.owned)
					self.showBooking(booking: booking, property: property, type: .owned)
				}
			}
		} else if let type = data["type"] as? String, type == "friend" {
			Task { @MainActor in
				if let property = await self.getProperty(id: propertyId), let booking = property.bookings.filter({ $0.id == bookingId }).first, booking.userId == userId {
					self.dismissProperty()
					self.dismissBooking()
					await self.fetchProperties(.friend)
					self.showBooking(booking: booking, property: property, type: .friend)
				}
			}
		}
		
	}
}

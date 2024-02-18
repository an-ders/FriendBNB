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
enum PropertyType: String {
	case owned = "ownedProperties"
	case friend = "friendsProperties"
}

@MainActor
class PropertyStore: ObservableObject {
	@Published var showTabBar = true
	@Published var selectedTab: RootTabs = .owned
	
	@Published var ownedProperties: [Property] = []
	@Published var friendsProperties: [Property] = []
	
	@Published var showOwnedAvailability = false
	@Published var showOwnedBooking = false
	@Published var selectedOwnedProperty: Property? {
		didSet {
			showTabBar = selectedOwnedProperty == nil
		}
	}
	
	@Published var showFriendExistingBooking: Booking? 
	@Published var showFriendNewBooking = false
	@Published var selectedFriendProperty: Property? {
		didSet {
			showTabBar = selectedFriendProperty == nil
		}
	}
	
	@Published var showNewPropertySheet = false
	@Published var showAddPropertySheet = false
	
	@Published var loading = false
	
	var listener: ListenerRegistration?
	
	func showOwnedProperty(_ property: Property, showAvailability: Bool = false) {
		self.selectedTab = .owned
		self.selectedOwnedProperty = property
		//subscribe(type: .owned)
		//showTabBar = false
		
		if showAvailability {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.showOwnedAvailability = showAvailability
			}
		}
	}
	
	func showFriendProperty(_ property: Property, delay: Bool = false) {
		self.selectedTab = .friends
		//subscribe(type: .friend)
		//showTabBar = false
		
		if delay {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.selectedFriendProperty = property
			}
		} else {
			self.selectedFriendProperty = property
		}
	}
	
	func subscribe(type: PropertyType) {
		print("SUBSCRIBING: \(type.rawValue)")
		guard let property = type == .owned ? selectedOwnedProperty : selectedFriendProperty else {
			return
		}
		let db = Firestore.firestore()
		self.listener = db.collection("Properties").document(property.id)
			.addSnapshotListener { documentSnapshot, error in
				guard let document = documentSnapshot else {
					print("Error fetching document: \(error!)")
					return
				}

				if let newData = document.data() {
					switch type {
					case .friend:
						self.selectedFriendProperty = Property(id: property.id, data: newData)
					case .owned:
						self.selectedOwnedProperty = Property(id: property.id, data: newData)
					}
				} else {
					switch type {
					case .friend:
						self.selectedFriendProperty = nil
						Task {
							await self.fetchProperties(.friend)
						}
					case .owned:
						self.selectedOwnedProperty = nil
						Task {
							await self.fetchProperties(.owned)
						}
					}
				}
			}
	}
	
	func unsubscribe() {
		print("Removing listener from DETAIL VIEW")
		self.listener?.remove()
	}
	
	// MARK: SERVICE FUNCTIONS
	
	func getProperty(id: String) async -> Property? {
		let db = Firestore.firestore()
		
		guard Auth.auth().currentUser != nil else {
			print("User not found")
			return nil
		}
		
		print("Fetching properties: \(id)")

		do {
			let snapshot = try await db.collection("Properties").whereField(FirebaseFirestore.FieldPath.documentID(), isEqualTo: id).getDocuments()
			
			for document in snapshot.documents {
				let data = document.data()
				return Property(id: document.documentID, data: data)
			}
		} catch {
			return nil
		}
		
		return nil
	}
	
	func fetchProperties(_ type: PropertyType) async {
		self.loading = true
		let db = Firestore.firestore()
		
		guard Auth.auth().currentUser != nil else {
			print("User not found")
			self.loading = false
			return
		}
		
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
		//try? await Task.sleep(nanoseconds: 500000000)
		
		for propertyId in propertyIds {
			do {
				let snapshot = try await db.collection("Properties").whereField(FirebaseFirestore.FieldPath.documentID(), isEqualTo: propertyId).getDocuments()
				
				for document in snapshot.documents {
					let data = document.data()
					newProperties.append(Property(id: document.documentID, data: data))
				}
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
	
	func addProperty(_ id: String, type: PropertyType) async {
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
	
	func removeProperty(_ id: String, type: PropertyType) async {
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
	
	func deleteProperty(id: String, type: PropertyType) async {
		let db = Firestore.firestore()
		do {
			try await db.collection("Properties").document(id).delete()
			print("Document successfully removed \(id) from \(type.rawValue)!")
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
}

//
//  PropertyStore.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-13.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum PropertyType {
	case owned
	case friend
	
	var firestoreKey: String {
		switch self {
		case .owned:
			return "ownedProperties"
		case .friend:
			return "friendsProperties"
		}
	}
}

@MainActor
class PropertyStore: ObservableObject {
	@Published var selectedTab: RootTabs = .owned
	
	@Published var ownedProperties: [Property] = []
	@Published var friendsProperties: [Property] = []
	
	@Published var showOwnedProperty = false
	@Published var showOwnedAvailability = false
	@Published var showOwnedBooking = false
	@Published var selectedOwnedProperty: Property?
	
	@Published var showNewPropertySheet = false
	@Published var showAddPropertySheet = false
	
	@Published var loading = false
	
	var listener: ListenerRegistration?
	
	func showProperty(_ property: Property, showAvailability: Bool = false) {
		selectedOwnedProperty = property
		showOwnedProperty = true
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.showOwnedAvailability = showAvailability
		}
	}
	
	func subscribe() {
		print("Adding listener in DETAIL VIEW")
		guard let property = selectedOwnedProperty else {
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
					print("Updating data DETAIL VIEW")
					self.selectedOwnedProperty = Property(id: property.id, data: newData)
				} else {
					self.selectedOwnedProperty = nil
					self.showOwnedProperty = false
					Task {
						await self.fetchProperties(.owned)
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
		//self.loading = true
		let db = Firestore.firestore()
		
		guard Auth.auth().currentUser != nil else {
			print("User not found")
			return
		}
		
		var propertyIds = [String]()
		print("Attempting to fetch property Ids")
		do {
			let document = try await db.collection("Accounts").document(Auth.auth().currentUser!.uid).getDocument()
			let data = document.data() ?? [:]
			propertyIds = data[type.firestoreKey] as? [String] ?? [String]()
			
			print("Successfully fetched \(type.firestoreKey) Ids")
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
				return
			}
		}
		let newPropertiesIds = newProperties.map { $0.id }
		
		print("Attempting to write new property Ids")
		do {
			try await db.collection("Accounts").document(Auth.auth().currentUser!.uid).setData([
				type.firestoreKey: newPropertiesIds
			], merge: true)
			print("Successfully set \(type.firestoreKey) Ids")
		} catch {
			print("Error setting Ids \(error.localizedDescription)")
		}
		
		if type == .owned {
			self.ownedProperties = newProperties
		} else {
			self.friendsProperties = newProperties
		}
		//self.loading = false
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
				type.firestoreKey: FieldValue.arrayUnion([id])
			])
			print("Successfully added Id to \(type.firestoreKey)")
			
			
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
				type.firestoreKey: FieldValue.arrayRemove([id])
			])
			print("Successfully removed Id from \(type.firestoreKey)")
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
				"owner": user.uid
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
			print("Document successfully removed \(id) from \(type.firestoreKey)!")
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
				type.firestoreKey: []
			])
			print("Successfully reset \(type.firestoreKey) Ids")
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

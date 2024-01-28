//
//  CalendarViewModel.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class CalendarViewModel: ObservableObject {
	@Published var date = Date()
	@Published var startDate: Date?
	@Published var endDate: Date?
	@Published var isAvailableMode = true
	@Published var manualUpdate = true
	@Published var error = ""
	
	@Published var property: Property
	
	var listener: ListenerRegistration?
	
	init(property: Property) {
		self.property = property
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
					self.property = Property(id: self.property.id, data: newData)
				} else {
				}
			}
	}
	
	func unsubscribe() {
		print("Removing listener from BOOKING MANAGER")
		self.listener?.remove()
	}
	
	func resetDates() {
		self.startDate = nil
		self.endDate = nil
	}
	
	func previousMonth() {
		self.date = date.minusMonth()
		self.manualUpdate.toggle()
	}
	
	func nextMonth() {
		self.date = date.plusMonth()
		self.manualUpdate.toggle()
	}
	
	func dateClicked(_ date: Date) {
		self.error = ""
		
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
}

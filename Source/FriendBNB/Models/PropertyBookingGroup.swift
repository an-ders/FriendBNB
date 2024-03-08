//
//  PropertyBookingGroup.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-28.
//

import Foundation

struct PropertyBookingGroup: Identifiable {
	var id = UUID()
	
	var type: PropertyType = .owned
	var property: Property
	var booking: Booking
}

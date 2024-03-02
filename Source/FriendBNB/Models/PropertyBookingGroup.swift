//
//  PropertyBookingGroup.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-28.
//

import Foundation

struct PropertyBookingGroup: Identifiable {
	var id = UUID()
	
	var property: Property
	var booking: Booking
}

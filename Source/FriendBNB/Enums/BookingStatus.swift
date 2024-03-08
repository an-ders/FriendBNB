//
//  BookingStatus.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-28.
//

import Foundation
import SwiftUI

enum BookingStatus: String, CaseIterable {
	case declined = "Declined"
	case pending = "Pending"
	case confirmed = "Confirmed"
	
	var colorBG: Color {
		switch self {
		case .confirmed:
			Color.systemGreen.opacity(0.6)
		case .declined:
			Color.systemRed.opacity(0.6)
		case .pending:
			Color.systemYellow.opacity(0.6)
		}
	}
	
	var color: Color {
		switch self {
		case .confirmed:
			Color.systemGreen
		case .declined:
			Color.systemRed
		case .pending:
			Color.systemYellow
		}
	}
	
	var image: String {
		switch self {
		case .confirmed:
			"checkmark.circle.fill"
		case .declined:
			"exclamationmark.triangle.fill"
		case .pending:
			"clock.fill"
		}
	}
}

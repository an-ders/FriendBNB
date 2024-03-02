//
//  ScheduleType.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-28.
//

import Foundation
import SwiftUI

enum ScheduleType: String {
	case available
	case unavailable
	
	var colorBG: Color {
		switch self {
		case .available:
			Color.systemGreen.opacity(0.6)
		case .unavailable:
			Color.systemRed.opacity(0.6)
		}
	}
	
	var color: Color {
		switch self {
		case .available:
			Color.systemGreen
		case .unavailable:
			Color.systemRed
		}
	}
}

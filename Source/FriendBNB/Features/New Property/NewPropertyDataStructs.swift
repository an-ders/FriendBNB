//
//  NewPropertyDataStructs.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-05.
//

import Foundation

enum PaymentType: String, CaseIterable {
	case free = "Free"
	case cash = "Cash"
	case paypal = "Paypal"
	case venmo = "Venmo"
	case interac = "Interac"
	
	var image: String {
		switch self {
		case .free:
			"tag.circle"
		case .cash:
			"dollarsign.circle.fill"
		case .paypal:
			"pesosign.circle.fill"
		case .venmo:
			"shekelsign.circle.fill"
		case .interac:
			"creditcard"
		}
	}
}

class NewPropertyInfo: ObservableObject {
	@Published var nickname: String = ""
	@Published var rooms: Int = 1
	@Published var people: Int = 4
	@Published var notes: String = ""
	@Published var error: String = ""
	
	@Published var payment: PaymentType = .free
	@Published var cost: Double?
	@Published var paymentNotes: String = ""
	
	@Published var cleaningNotes: String = ""
	@Published var wifiName: String = ""
	@Published var wifiPass: String = ""
	@Published var securityCode: String = ""
	@Published var contactInfo: String = ""
	
	var dictonary: [String: Any] {
		["info": [
			"nickname": nickname,
			"rooms": rooms,
			"people": people,
			"cleaningNotes": cleaningNotes,
			"wifiName": wifiName,
			"wifiPass": wifiPass,
			"securityCode": securityCode,
			"contactInfo": contactInfo,
			"payment": payment.rawValue,
			"cost": cost ?? 0,
			"paymentNotes": paymentNotes,
			"notes": notes
		]]
	}
	
	//	init() {
	//		self.rooms
	//		self.people
	//		self.fee
	//		self.notes
	//		self.error
	//	}
}

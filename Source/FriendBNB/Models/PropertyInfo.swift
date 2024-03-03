//
//  PropertyInfo.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-28.
//

import Foundation

struct PropertyInfo: Equatable {
	var nickname: String = ""
	var people: Int = 0
	var notes: String = ""
	var cleaningNotes: String = ""
	var wifi: String = ""
	var securityCode: String = ""
	var contactInfo: String = ""
	var payment: PaymentFee = .free
	var cost: Double = 0
	var paymentNotes: String = ""
	
	init() {}
	
	init(data: [String: Any]) {
		self.nickname = data["nickname"] as? String ?? ""
		self.people = data["people"] as? Int ?? 0
		
		self.notes = data["notes"] as? String ?? ""
		self.cleaningNotes = data["cleaningNotes"] as? String ?? ""
		self.wifi = data["wifi"] as? String ?? ""
		self.securityCode = data["securityCode"] as? String ?? ""
		self.contactInfo = data["contactInfo"] as? String ?? ""
		
		self.payment = PaymentFee(rawValue: data["payment"] as? String ?? "") ?? .free
		self.cost = data["cost"] as? Double ?? 0
		self.paymentNotes = data["paymentNotes"] as? String ?? ""
	}
}

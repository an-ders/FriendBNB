//
//  PropertyDetailList.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-24.
//

import SwiftUI

enum SensitiveInfoType: String {
	case notes
	case paymentNotes
	case contactInfo
	case cleaningNotes
	case wifi
	case securityCode
}

struct PropertyDetailList: View {
	var property: Property
	var sensitiveInfo: [String] = []
	var showAll = false
	
	var body: some View {
		HStack {
			Image(systemName: "person.2.fill")
				.resizable()
				.scaledToFit()
				.frame(width: 25)
			Text("Max number of people: ")
				.styled(.body)
			Text(String(property.info.people))
				.font(.headline).fontWeight(.semibold)
			Spacer()
		}
		VStack {
			HStack {
				Image(systemName: "dollarsign.circle.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 25)
				Text("Cost per night: ")
					.styled(.body)
				Text(property.info.payment == .free ? "FREE" : "\(String(format: "%.2f", property.info.cost)) \(property.info.payment.rawValue)")
					.styled(.bodyBold)
				Spacer()
			}
			if !property.info.paymentNotes.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.paymentNotes.rawValue) || showAll) {
				Text(property.info.paymentNotes.isEmpty ? "" : property.info.paymentNotes)
					.styled(.body)
					.fillLeading()
			}
		}
		
		if !property.info.notes.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.notes.rawValue) || showAll) {
			VStack {
				Text("Notes")
					.styled(.headline)
					.fillLeading()
				
				Text(property.info.notes)
					.styled(.body)
					.fillLeading()
			}
		}
		
		if !property.info.contactInfo.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.contactInfo.rawValue) || showAll) {
			VStack {
				Text("Contact Info")
					.styled(.headline)
					.fillLeading()
				
				Text(property.info.contactInfo)
					.styled(.body)
					.fillLeading()
			}
		}
		
		if !property.info.cleaningNotes.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.cleaningNotes.rawValue) || showAll) {
			VStack {
				Text("Cleaning Notes")
					.styled(.headline)
					.fillLeading()
				
				Text(property.info.cleaningNotes)
					.styled(.body)
					.fillLeading()
			}
		}
		
		if !property.info.wifi.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.wifi.rawValue) || showAll) {
			VStack {
				Text("Wifi")
					.styled(.headline)
					.fillLeading()
				
				Text(property.info.wifi)
					.styled(.body)
					.fillLeading()
			}
		}
		
		if !property.info.securityCode.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.securityCode.rawValue) || showAll) {
			VStack {
				Text("Security Code")
					.styled(.headline)
					.fillLeading()
				
				Text(property.info.securityCode)
					.styled(.body)
					.fillLeading()
			}
		}
		
	}
}

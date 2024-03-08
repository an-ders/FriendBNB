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
	
	var title: String {
		switch self {
		case .notes: 
			"NOTES"
		case .paymentNotes:
			"PAYMENT NOTES"
		case .contactInfo:
			"CONTACT INFO"
		case .cleaningNotes:
			"CLEANING NOTES"
		case .wifi:
			"WIFI DETAILS"
		case .securityCode:
			"SECURITY DETAILS"
		}
	}
	
	var image: String {
		switch self {
		case .notes:
			"doc.text.fill"
		case .paymentNotes:
			"dollarsign.circle"
		case .contactInfo:
			"person.circle.fill"
		case .cleaningNotes:
			"hands.sparkles.fill"
		case .wifi:
			"wifi"
		case .securityCode:
			"lock.fill"
		}
	}
}

struct PropertyDetailList: View {
	var property: Property
	var sensitiveInfo: [String] = []
	var color: Color = .black
	var showAll = false
	
	@State var securityCodeCopied = false
	@State var wifiPassCopied = false
	
	var body: some View {
		VStack(spacing: 0) {
			Text("PROPERTY INFO")
				.styled(.bodyBold)
				.fillLeading()
				.foregroundStyle(Color.systemGray)
				.padding(.bottom, 4)
			
			HStack {
				Image(systemName: "person.2.fill")
					.size(width: 20, height: 20)
				Text("Max number of people: ")
					.styled(.body)
				Text(String(property.info.people))
					.font(.headline).fontWeight(.semibold)
				Spacer()
			}
			.foregroundStyle(color)
			
			VStack {
				HStack {
					Image(systemName: "dollarsign.circle.fill")
						.size(width: 20, height: 20)
					Text("Cost per night: ")
						.styled(.body)
					Text(property.info.payment == .free ? "FREE" : "$\(String(format: "%.2f", property.info.cost)) \(property.info.payment.rawValue)")
						.styled(.bodyBold)
					Spacer()
				}
				.foregroundStyle(color)
				
				if !property.info.paymentNotes.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.paymentNotes.rawValue) || showAll) {
					HStack {
						Image(systemName: "note.text")
						Text(property.info.paymentNotes.isEmpty ? "" : property.info.paymentNotes)
							.styled(.body)
							.fillLeading()
					}
				}
			}
			.foregroundStyle(color)
		}
		
		if !property.info.notes.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.notes.rawValue) || showAll) {
			PropertyDetailListRow(type: .notes, desciption: property.info.notes, color: color)
		}
		
		if !property.info.contactInfo.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.contactInfo.rawValue) || showAll) {
			Button(action: {
				if let url = URL(string: "tel://" + property.info.contactInfo) {
					UIApplication.shared.open(url)
				}
			}, label: {
				PropertyDetailListRow(type: .contactInfo, desciption: property.info.contactInfo, color: color)
			})
		}
		
		if !property.info.cleaningNotes.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.cleaningNotes.rawValue) || showAll) {
			PropertyDetailListRow(type: .cleaningNotes, desciption: property.info.cleaningNotes, color: color)
		}
		
		if !property.info.wifiName.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.wifi.rawValue) || showAll) {
			Button(action: {
				withAnimation {
					wifiPassCopied = true
				}
				UIPasteboard.general.string = property.info.securityCode
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
					withAnimation {
						wifiPassCopied = false
					}
				}
			}, label: {
				VStack(spacing: 4) {
					Text(SensitiveInfoType.wifi.title)
						.styled(.bodyBold)
						.fillLeading()
						.foregroundStyle(Color.systemGray)
					
					HStack {
						Image(systemName: SensitiveInfoType.wifi.image)
							.size(width: 20, height: 20)
						
						Text(property.info.wifiName)
							.styled(.body)
							.fillLeading()
					}
					.foregroundStyle(color)
					
					HStack {
						Image(systemName: "lock.fill")
							.size(width: 20, height: 20)
						
						Text(wifiPassCopied ? "Copied" : property.info.wifiPass)
							.styled(.body)
							.fillLeading()
					}
					.foregroundStyle(color)
				}
			})
		}
		
		if !property.info.securityCode.isEmpty && (sensitiveInfo.contains(SensitiveInfoType.securityCode.rawValue) || showAll) {
			Button(action: {
				withAnimation {
					securityCodeCopied = true
				}
				UIPasteboard.general.string = property.info.securityCode
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
					withAnimation {
						securityCodeCopied = false
					}
				}
			}, label: {
				VStack(spacing: 4) {
					Text(SensitiveInfoType.securityCode.title)
						.styled(.bodyBold)
						.fillLeading()
						.foregroundStyle(Color.systemGray)
					
					HStack {
						Image(systemName: SensitiveInfoType.securityCode.image)
							.size(width: 20, height: 20)
						
						Text(securityCodeCopied ? "Copied" : property.info.securityCode)
							.styled(.body)
							.fillLeading()
					}
					.foregroundStyle(color)
				}
			})
		}
	}
}

struct PropertyDetailListRow: View {
	var type: SensitiveInfoType
	var desciption: String
	var color: Color
	
	var body: some View {
		VStack(spacing: 4) {
			Text(type.title)
				.styled(.bodyBold)
				.fillLeading()
				.foregroundStyle(Color.systemGray)
			
			HStack {
				Image(systemName: type.image)
					.size(width: 20, height: 20)
				
				Text(desciption)
					.styled(.body)
					.fillLeading()
			}
			.foregroundStyle(color)
		}
	}
}

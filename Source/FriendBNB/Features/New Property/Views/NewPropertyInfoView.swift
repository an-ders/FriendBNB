//
//  NewPropertyInfoView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-08.
//

import SwiftUI

struct NewPropertyInfoView: View {
	@Binding var currentTab: NewPropertyTabs
	@ObservedObject var info: NewPropertyInfo
	
	var body: some View {
		PairButtonWrapper(prevText: "Back", prevAction: {
			back()
		}, nextText: "Next", nextAction: {
			next()
		}, content: {
			VStack {
				ScrollView(.vertical, showsIndicators: false) {
					VStack(spacing: Constants.Spacing.regular) {
						Text("Home Details")
							.title()
							.fillLeading()
							.padding(.bottom, Constants.Spacing.small)
						NewPropertyInfoFieldsView(info: info)
												
						PairButtonSpacer()
					}
					.padding(.top, Constants.Padding.regular)
				}
			}
		})
		.padding(.horizontal, Constants.Padding.regular)
	}
	
	func next() {
		withAnimation {
			currentTab = .confirm
		}
	}
	
	func back() {
		withAnimation {
			currentTab = .address
		}
	}
}

struct NewPropertyInfoFieldsView: View {
	@ObservedObject var info: NewPropertyInfo
	
	var body: some View {
		CustomStepperView(text: "Max People", value: $info.people, min: 1)
		Divider()
		HStack {
			Text("Rate Per Night")
				.body()
				.frame(maxWidth: .infinity, alignment: .leading)
			
			ForEach(PaymentFee.allCases, id: \.rawValue) { payment in
				Button(action: {
					withAnimation {
						info.payment = payment
					}
				}, label: {
					Text(payment.rawValue)
						.foregroundStyle(Color.white)
						.body()
						.padding(.horizontal, Constants.Padding.small)
						.padding(.vertical, Constants.Padding.xsmall)
						.background(info.payment == payment ? Color.systemBlue.opacity(0.6) : Color.systemGray3)
						.cornerRadius(5)
				})
			}
		}
		
		if info.payment != .free {
			CurrencyField(title: "Cost", defaultText: "", value: $info.cost)
			
			VStack(spacing: 2) {
				BasicTextField(defaultText: "Payment Details (EMT, Venmo, Cash)", text: $info.paymentNotes)
				Text("Please note we do not handle payments")
					.caption()
					.fillLeading()
					.foregroundStyle(Color.systemGray3)
			}
		}
		
		VStack {
			Text("Extra notes")
				.title()
				.fillLeading()
			Text("All information below will be shared with friends upon booking approval")
				.body()
				.fillLeading()
			BasicTextField(defaultText: "Dont forget to feed the fish!", text: $info.notes)
		}
		.padding(.top, 16)
		
		OptionalInfoField(infoName: "Cleaning Instructions", defaultText: "Run dishwasher before leaving...", text: $info.cleaningNotes)
		
		OptionalInfoField(infoName: "Wifi Password", defaultText: "TopSecretWifiPassword123", text: $info.wifi)
		
		OptionalInfoField(infoName: "Security Code", defaultText: "12345", text: $info.securityCode)
		
		OptionalInfoField(infoName: "Contact Information", defaultText: "Cell: (555)-555-5555", text: $info.contactInfo)
	}
}

enum PaymentFee: String, CaseIterable {
	case free = "FREE"
	case cad = "CAD"
	case usd = "USD"
}
					
class NewPropertyInfo: ObservableObject {
	@Published var rooms: Int = 1
	@Published var people: Int = 4
	@Published var notes: String = ""
	@Published var error: String = ""
	
	@Published var payment: PaymentFee = .free
	@Published var cost: Int = 0
	@Published var paymentNotes: String = ""
	
	@Published var cleaningNotes: String = ""
	@Published var wifi: String = ""
	@Published var securityCode: String = ""
	@Published var contactInfo: String = ""
	
	var dictonary: [String: Any] {
		[
			"rooms": rooms,
			"people": people,
			"cleaningNotes": cleaningNotes,
			"wifi": wifi,
			"securityCode": securityCode,
			"contactInfo": contactInfo,
			"payment": payment.rawValue,
			"cost": cost,
			"paymentNotes": paymentNotes,
			"notes": notes
		]
	}
	
//	init() {
//		self.rooms
//		self.people
//		self.fee
//		self.notes
//		self.error
//	}
}

//struct NewPropertyInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyInfoView()
//    }
//}

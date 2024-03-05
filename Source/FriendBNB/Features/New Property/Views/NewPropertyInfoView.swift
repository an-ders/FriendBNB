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
		VStack(spacing: 0) {
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: Constants.Spacing.regular) {
					Text("Home Details")
						.styled(.title)
						.fillLeading()
					NewPropertyInfoFieldsView(info: info)
				}
				.padding(.top, Constants.Spacing.regular)
				.padding(.bottom, 50)
			}
			.padding(.horizontal, Constants.Spacing.regular)
			.contentShape(Rectangle())
			.onTapGesture {
				hideKeyboard()
			}
			
			VStack(spacing: 8) {
				Divider()
				PairButtonsView(prevText: "Back", prevAction: {
					back()
				}, nextText: "Next", nextCaption: "", nextAction: {
					next()
				})
				.padding(.horizontal, Constants.Spacing.regular)
			}
		}
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
	
	@State var showWifi = false
	@State var showContact = false
	
	var body: some View {
		StyledFloatingTextField(text: $info.nickname, prompt: "Nickname (optional)")
			.padding(.bottom, Constants.Spacing.small)
		CustomStepperView(text: "Max People", value: $info.people, min: 1)
		Divider()
		HStack {
			if info.payment == .free {
				Text("Rate Per Night")
					.styled(.body)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			
			ForEach(PaymentFee.allCases, id: \.rawValue) { payment in
				Button(action: {
					withAnimation {
						info.payment = payment
					}
				}, label: {
					Text(payment.rawValue)
						.foregroundStyle(Color.white)
						.styled(.caption)
						.padding(.horizontal, Constants.Spacing.small)
						.padding(.vertical, Constants.Spacing.xsmall)
						.background(info.payment == payment ? Color.systemBlue.opacity(0.6) : Color.systemGray3)
						.cornerRadius(5)
				})
			}
			
			if info.payment != .free {
				CurrencyTextField("Rate Per Night", value: $info.cost)
					.styled(.bodyBold)
					.padding(.horizontal, Constants.Spacing.small)
					.padding(.vertical, Constants.Spacing.xsmall)
					.overlay(
						RoundedRectangle(cornerRadius: 5)
							.stroke(lineWidth: 1.0)
							.foregroundStyle(Color.systemGray3)
					)
					.frame(maxWidth: .infinity, alignment: .trailing)
			}
		}
		
		if info.payment != .free {
			VStack(spacing: 2) {
				BasicTextField(defaultText: "Payment Details...", text: $info.paymentNotes)
				Text("Add your EMT, Venmo, or cash instructions above. Please note we do not handle payments")
					.styled(.caption)
					.fillLeading()
					.foregroundStyle(Color.systemGray3)
			}
		}
		
		Text("Information below only shared upon approval")
			.styled(.headline)
			.fillLeading()
			.padding(.top, 16)
		
		VStack(spacing: 8) {
			Toggle(isOn: $showContact) {
				Text("Contact Information")
					.styled(.body)
			}
			.padding(.trailing, 4)
			if showContact {
				BasicTextField(defaultText: "(555)-555-5555", text: $info.contactInfo)
					.keyboardType(.numberPad)
					.onChange(of: info.contactInfo) {
						if !info.contactInfo.isEmpty {
							info.contactInfo = info.contactInfo.formatPhoneNumber()
						}
					}
			}
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				if !info.contactInfo.isEmpty {
					showContact = true
				}
			}
		}
		
		OptionalInfoField(infoName: "Cleaning Instructions", defaultText: "Run dishwasher before leaving...", text: $info.cleaningNotes)
		
		VStack(spacing: 8) {
			Toggle(isOn: $showWifi) {
				Text("Wifi Details")
					.styled(.body)
			}
			.padding(.trailing, 4)
			if showWifi {
				BasicTextField(defaultText: "Wifi Name", text: $info.wifiName)
				BasicTextField(defaultText: "Wifi Password", text: $info.wifiPass)
			}
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				if !info.wifiName.isEmpty {
					showWifi = true
				}
			}
		}
		
		OptionalInfoField(infoName: "Security Code", defaultText: "12345", text: $info.securityCode)
	}
}

enum PaymentFee: String, CaseIterable {
	case free = "FREE"
	case cad = "CAD"
	case usd = "USD"
}

class NewPropertyInfo: ObservableObject {
	@Published var nickname: String = ""
	@Published var rooms: Int = 1
	@Published var people: Int = 4
	@Published var notes: String = ""
	@Published var error: String = ""
	
	@Published var payment: PaymentFee = .free
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
		]
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

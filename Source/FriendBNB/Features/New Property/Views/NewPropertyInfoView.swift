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
					VStack(spacing: 0) {
						DetailSheetTitle(title: "HOME DETAILS", showDismiss: false)
							.padding(.leading, Constants.Spacing.medium)
							.padding(.vertical, Constants.Spacing.large)
							.padding(.trailing, Constants.Spacing.large)
						Divider()
							.padding(.horizontal, -Constants.Spacing.large)
					}
					
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
	@State var showPaymentPicker = false
	
	var body: some View {
		VStack(spacing: 50) {
			VStack {
				Text("BASIC INFO")
					.styled(.bodyBold)
					.fillLeading()
					.foregroundStyle(Color.systemGray)
				StyledFloatingTextField(text: $info.nickname, prompt: "Property Nickname")
					.padding(.bottom, Constants.Spacing.medium)
					.padding(.top, -Constants.Spacing.medium)

				CustomStepperView(text: "Maximum guests", value: $info.people, min: 1)
			}
			
			VStack {
				Text("PAYMENT")
					.styled(.bodyBold)
					.fillLeading()
					.foregroundStyle(Color.systemGray)
				
				Button(action: {
					showPaymentPicker.toggle()
				}, label: {
					PaymentTileView(type: info.payment)
				})
			}
			
			VStack {
				VStack(spacing: 0) {
					Text("ADDITIONAL INFORMATION")
						.styled(.bodyBold)
						.fillLeading()
						.foregroundStyle(Color.systemGray)
					HStack(spacing: 4) {
						Image(systemName: "eye")
							.size(height: 12)
						Text("Shared only upon confirmation")
							.styled(.caption)
							.fillLeading()
					}
					.foregroundStyle(Color.systemGray3)
				}
				
				VStack(spacing: 20) {
					OptionalInfoField(infoName: "Contact Information") {
						BasicTextField(defaultText: "(555)-555-5555", text: $info.contactInfo)
							.keyboardType(.numberPad)
							.onChange(of: info.contactInfo) {
								if !info.contactInfo.isEmpty {
									info.contactInfo = info.contactInfo.formatPhoneNumber()
								}
							}
					}
					
					OptionalInfoField(infoName: "Cleaning Instructions") {
						BasicTextField(defaultText: "Run dishwasher before leaving...", text: $info.cleaningNotes)
					}
					
					OptionalInfoField(infoName: "Wifi Details") {
						BasicTextField(defaultText: "Wifi Name", text: $info.wifiName)
						BasicTextField(defaultText: "Wifi Password", text: $info.wifiPass)
					}
					
					OptionalInfoField(infoName: "Security Code") {
						BasicTextField(defaultText: "12345", text: $info.securityCode)
					}
				}
			}
		}
		.sheet(isPresented: $showPaymentPicker) {
			PaymentPickerView(info: info, showPicker: $showPaymentPicker)
		}
	}
}

//struct NewPropertyInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyInfoView()
//    }
//}

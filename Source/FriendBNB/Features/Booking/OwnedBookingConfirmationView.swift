//
//  OwnedBookingConfirmationView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct OwnedBookingConfirmationView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyStore: PropertyStore
	@Environment(\.dismiss) private var dismiss
	
	var property: Property
	var booking: Booking
	var showDismiss = true
	var sendNotification: (String) -> Void
	
	@State var selectedCalendar: PropertyBookingGroup?
	@State var error: String = ""
	@State var bookingMessage = ""
	@State var extraNotes = true
	@State var contactInfo = true
	@State var cleaningNotes = true
	@State var wifi = true
	@State var securityCode = true
	
	var body: some View {
		VStack {
			ScrollView(showsIndicators: false) {
				VStack(spacing: Constants.Spacing.medium) {
					DetailSheetTitle(title: "Booking Confirmation", showDismiss: showDismiss)
					
					ErrorView(error: error)
					
					HStack {
						Image(systemName: "person.fill")
						Text("\(booking.name) (\(booking.email))")
					}
					.styled(.body)
					.fillLeading()
					
					Divider()
					
					VStack(spacing: 8) {
						HStack {
							Image(systemName: "calendar")
							Text("Booking Dates")
								.styled(.headline)
								.fillLeading()
						}
						
						HStack {
							VStack {
								HStack {
									Text("Start: ")
									Text(booking.start, style: .date)
								}
								.styled(.body)
								.fillLeading()
								
								HStack {
									Text("End: ")
									Text(booking.end, style: .date)
								}
								.styled(.body)
								.fillLeading()
							}
							
							Button(action: {
								selectedCalendar = PropertyBookingGroup(property: property, booking: booking)
							}, label: {
								Image(systemName: "calendar")
									.resizable()
									.scaledToFit()
									.frame(height: 20)
							})
						}
					}
					
					Divider()
					
					BookingStatusIndicatorView(currentStatus: booking.status)
					
					Divider()
					
					Text("Booking Info")
						.styled(.headline)
						.fillLeading()
					
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
						if !property.info.paymentNotes.isEmpty {
							Text(property.info.paymentNotes.isEmpty ? "" : property.info.paymentNotes)
								.styled(.body)
								.fillLeading()
						}
					}
					
					Divider()
					
					VStack(spacing: Constants.Spacing.regular) {
						Text("Booking Note")
							.styled(.headline)
							.fillLeading()
						BasicTextField(defaultText: "Personalized Message (Optional)", text: $bookingMessage)
					}
					.padding(.bottom, Constants.Spacing.regular)
					
					Divider()
					
					Text("Optional Info")
						.styled(.headline)
						.fillLeading()
					
					if !property.info.notes.isEmpty {
						ToggleInfoDetail(toggle: $extraNotes, title: "Include Extra Notes", text: property.info.notes)
					}
					
					if !property.info.contactInfo.isEmpty {
						ToggleInfoDetail(toggle: $contactInfo, title: "Include Contact Info", text: property.info.contactInfo)
					}
					
					if !property.info.cleaningNotes.isEmpty {
						ToggleInfoDetail(toggle: $cleaningNotes, title: "Include Cleaning Notes", text: property.info.cleaningNotes)
					}
					
					if !property.info.wifi.isEmpty {
						ToggleInfoDetail(toggle: $wifi, title: "Include Wifi Info", text: property.info.wifi)
					}
					
					if !property.info.securityCode.isEmpty {
						ToggleInfoDetail(toggle: $securityCode, title: "Include Security Info", text: property.info.securityCode)
					}
					
					PairButtonSpacer()
				}
			}
			.padding(.horizontal, Constants.Spacing.regular)
			
			HStack(spacing: Constants.Spacing.small) {
				Button(action: {
					// NOTE IF YOU EVER UPDATE THE DECLINE ACTION UPDATE THE SWIPE ACTION ON HOME PAGE PROPERTY TILE ALSO
					if booking.status == .declined && booking.statusMessage == bookingMessage {
						return
					}
					Task {
						if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .declined, message: bookingMessage, sensitiveInfo: []) {
							self.error = error
						}
						sendNotification("Booking status updated to declined")
						await propertyStore.fetchProperties(.owned)
						dismiss()
					}
				}, label: {
					Text("Decline")
						.styled(.bodyBold)
						.padding(.horizontal, 20)
						.padding(.vertical, 8)
						.foregroundColor(.black)
						.background(booking.status == .declined && booking.statusMessage == bookingMessage ? Color.systemGray3 : BookingStatus.declined.colorBG)
						.cornerRadius(20)
				})
				
				Spacer()
			
				var didChange = getSensitiveInfoList() != booking.sensitiveInfo || bookingMessage != booking.statusMessage
				Button(action: {
					// NOTE IF YOU EVER UPDATE THE APPROVE ACTION UPDATE THE SWIPE ACTION ON HOME PAGE PROPERTY TILE ALSO
					if !didChange && (booking.status == .confirmed) {
						return
					}
					
					Task {
						if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .confirmed, message: bookingMessage, sensitiveInfo: getSensitiveInfoList()) {
							self.error = error
						}
						
						sendNotification("Booking status updated")
						await propertyStore.fetchProperties(.owned)
						dismiss()
					}
				}, label: {
					Text(didChange && booking.status == .confirmed ? "Update" : "Approve")
						.styled(.bodyBold)
						.padding(.horizontal, 20)
						.padding(.vertical, 8)
						.foregroundColor(.black)
						.background((!didChange && booking.status == .confirmed) ? Color.systemGray3 : BookingStatus.confirmed.colorBG)
						.cornerRadius(20)
				})
			}
			.padding(Constants.Spacing.small)
			.background {
				Color.white
			}
		}
		.onTapGesture {
			hideKeyboard()
		}
		.onAppear {
			bookingMessage = booking.statusMessage
			if booking.status == .confirmed {
				extraNotes = booking.sensitiveInfo.contains(SensitiveInfoType.notes.rawValue)
				contactInfo = booking.sensitiveInfo.contains(SensitiveInfoType.contactInfo.rawValue)
				cleaningNotes = booking.sensitiveInfo.contains(SensitiveInfoType.cleaningNotes.rawValue)
				wifi = booking.sensitiveInfo.contains(SensitiveInfoType.wifi.rawValue)
				securityCode = booking.sensitiveInfo.contains(SensitiveInfoType.securityCode.rawValue)
			}
		}
		.sheet(item: $selectedCalendar) { group in
			EventEditViewController(group: group) {
				selectedCalendar = nil
			}
		}
	}
	
	func getSensitiveInfoList() -> [String] {
		var sensitiveInfoNew: [String] = [SensitiveInfoType.paymentNotes.rawValue]
		if extraNotes {
			sensitiveInfoNew.append(SensitiveInfoType.notes.rawValue)
		}
		if contactInfo {
			sensitiveInfoNew.append(SensitiveInfoType.contactInfo.rawValue)
		}
		if cleaningNotes {
			sensitiveInfoNew.append(SensitiveInfoType.cleaningNotes.rawValue)
		}
		if wifi {
			sensitiveInfoNew.append(SensitiveInfoType.wifi.rawValue)
		}
		if securityCode {
			sensitiveInfoNew.append(SensitiveInfoType.securityCode.rawValue)
		}
		
		return sensitiveInfoNew
	}
}

//#Preview {
//    OwnerBookingConfirmationView()
//}

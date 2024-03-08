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
	
	@State var bookingAction: BookingStatus?
	
	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 0) {
				DetailSheetTitle(title: "Booking Confirmation", showDismiss: showDismiss)
					.padding(.leading, Constants.Spacing.medium)
					.padding(.vertical, Constants.Spacing.medium)
					.padding(.trailing, Constants.Spacing.large)
				Divider()
			}
			
			ScrollView(showsIndicators: false) {
				VStack(spacing: 50) {
					ErrorView(error: error)
					
					if booking.isRequested {
						Text("Please note that one or more of these dates are not set the availability!")
							.styled(.caption)
							.foregroundStyle(Color.systemOrange)
							.padding(.bottom, -25)
					}
					
					BookingStatusIndicatorView(currentStatus: booking.status)
					
					VStack(alignment: .leading, spacing: 8) {
						DetailHeading(title: "FRIEND")
						HStack {
							Image(systemName: "person.fill")
							Text("\(booking.name) (\(booking.email))")
						}
						.styled(.body)
						.fillLeading()
					}
										
					VStack(spacing: 8) {
						DetailHeading(title: "BOOKING DATES")
						
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
							
							if booking.status == .confirmed {
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
					}
										
					VStack(spacing: 8) {
						DetailHeading(title: "BOOKING INFO")
						
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
					}
										
					VStack(spacing: 8) {
						DetailHeading(title: "BOOKING NOTE")
						BasicTextField(defaultText: "Personalized Message (Optional)", text: $bookingMessage)
					}
										
					VStack(spacing: 8) {
						DetailHeading(title: "OPTIONAL INFO")
						
						VStack(spacing: 12) {
							if !property.info.notes.isEmpty {
								ToggleInfoDetail(toggle: $extraNotes, title: "Include Extra Notes", text: property.info.notes)
							}
							
							if !property.info.contactInfo.isEmpty {
								ToggleInfoDetail(toggle: $contactInfo, title: "Include Contact Info", text: property.info.contactInfo)
							}
							
							if !property.info.cleaningNotes.isEmpty {
								ToggleInfoDetail(toggle: $cleaningNotes, title: "Include Cleaning Notes", text: property.info.cleaningNotes)
							}
							
							if !property.info.wifiName.isEmpty {
								ToggleInfoDetail(toggle: $wifi, title: "Include Wifi Info", text: property.info.wifiName)
							}
							
							if !property.info.securityCode.isEmpty {
								ToggleInfoDetail(toggle: $securityCode, title: "Include Security Info", text: property.info.securityCode)
							}
						}
					}
				}
				.padding(.bottom, 50)
				.padding(.top, 16)
			}
			.padding(.horizontal, Constants.Spacing.regular)
			
			cta
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
	
	var cta: some View {
		VStack {
			Divider()
			if let status = bookingAction {
				let changed = booking.status == .declined && booking.statusMessage == bookingMessage
				let didChange = getSensitiveInfoList() != booking.sensitiveInfo || bookingMessage != booking.statusMessage
				
				HStack {
					Button(action: {
						withAnimation {
							bookingAction = nil
						}
					}, label: {
						Text("Cancel")
							.styled(.bodyBold)
							.padding(.horizontal, 20)
							.padding(.vertical, 8)
							.foregroundColor(.black)
							.background(Color.systemGray3)
							.cornerRadius(20)
					})
					
					Spacer()
					
					Button(action: {
						// NOTE IF YOU EVER UPDATE THE APPROVE ACTION UPDATE THE SWIPE ACTION ON HOME PAGE PROPERTY TILE ALSO
						if status == .declined {
							Task {
								if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .declined, message: bookingMessage, sensitiveInfo: []) {
									self.error = error
								}
								sendNotification("Booking status updated to declined")
								await propertyStore.fetchProperties(.owned)
								dismiss()
							}
						} else {
							Task {
								if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .confirmed, message: bookingMessage, sensitiveInfo: getSensitiveInfoList()) {
									self.error = error
								}
								
								sendNotification("Booking status updated")
								await propertyStore.fetchProperties(.owned)
								dismiss()
							}
						}
					}, label: {
						Text("Confirm")
							.styled(.bodyBold)
							.padding(.horizontal, 20)
							.padding(.vertical, 8)
							.foregroundColor(.black)
							.background(status.colorBG)
							.cornerRadius(20)
					})
				}
				.padding(Constants.Spacing.small)
				.background {
					Color.white
				}
				.transition(.asymmetric(
					insertion: .move(edge: .leading),
					removal: .move(edge: .trailing)
				))
			} else {
				HStack {
					let changed = booking.status == .declined && booking.statusMessage == bookingMessage
					let didChange = getSensitiveInfoList() != booking.sensitiveInfo || bookingMessage != booking.statusMessage
					
					Button(action: {
						if changed {
							return
						}
						withAnimation {
							bookingAction = .declined
						}
					}, label: {
						Text(!changed && booking.status == .declined ? "Update" : "Cancel booking")
							.styled(.bodyBold)
							.padding(.horizontal, 20)
							.padding(.vertical, 8)
							.foregroundColor(.black)
							.background(changed ? Color.systemGray3 : BookingStatus.declined.colorBG)
							.cornerRadius(20)
					})
					
					Spacer()
				
					Button(action: {
						if !didChange && (booking.status == .confirmed) {
							return
						}
						
						withAnimation {
							bookingAction = .confirmed
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
				.transition(.asymmetric(
					insertion: .move(edge: .leading),
					removal: .move(edge: .trailing)
				))
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

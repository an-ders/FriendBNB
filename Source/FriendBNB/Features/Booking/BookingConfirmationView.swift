//
//  BookingConfirmationView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct BookingConfirmationView<Content: View>: View {
	@EnvironmentObject var authStore: AuthenticationStore
	@EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyStore: PropertyStore
	@Environment(\.dismiss) private var dismiss
	
	@State var confirmDelete: Bool = false
	@State var selectedCalendar: PropertyBookingGroup?
	
	var property: Property
	var booking: Booking
	var showDismiss: Bool = true
	
	@ViewBuilder var bottomBar: Content
	
	var body: some View {
		VStack {
			ScrollView(showsIndicators: false) {
				VStack(spacing: Constants.Spacing.medium) {
					DetailSheetTitle(title: "Booking Details", showDismiss: showDismiss)
					
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
					
					if !booking.statusMessage.isEmpty {
						VStack(spacing: Constants.Spacing.regular) {
							Text("Booking Confirmation Note")
								.styled(.headline)
								.fillLeading()
							Text(booking.statusMessage)
								.styled(.body)
								.fillLeading()
						}
						.padding(.bottom, Constants.Spacing.regular)
						
						Divider()
					}
					
					Text("Booking Info")
						.styled(.headline)
						.fillLeading()
					
					PropertyDetailList(property: property, sensitiveInfo: booking.sensitiveInfo)
					
					if booking.status != .confirmed {
						Text("Awaiting confirmation for more details...")
							.fillLeading()
							.styled(.bodyBold)
					}
					
					PairButtonSpacer()
				}
			}
			.padding(.horizontal, Constants.Spacing.regular)

			bottomBar
		}
		.sheet(item: $selectedCalendar) { group in
			EventEditViewController(group: group) {
				selectedCalendar = nil
			}
		}
	}
}

//#Preview {
//    BookingConfirmationView()
//}

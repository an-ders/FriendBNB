//
//  OwnerBookingConfirmationView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct OwnerBookingConfirmationView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var notificationStore: NotificationStore
	@Environment(\.dismiss) private var dismiss
	
	var property: Property
	var booking: Booking
	@State var error = ""
	@State var bookingMessage = ""
	
	var body: some View {
		PairButtonWrapper(prevText: "Decline", prevAction: {
			Task {
				if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .declined, message: bookingMessage) {
					self.error = error
				}
				dismiss()
				//notificationStore.pushNotification(message: "\(booking.title)'s booking canceled")
			}
		}, nextText: "Confirm", nextAction: {
			Task {
				if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .confirmed, message: bookingMessage) {
					self.error = error
				}
				dismiss()
				//notificationStore.pushNotification(message: "\(booking.title)'s booking confirmed")
			}
		}, content: {
			ScrollView(showsIndicators: false) {
				VStack(spacing: Constants.Spacing.regular) {
					Text("Booking Detail")
						.font(.largeTitle).fontWeight(.medium)
						.frame(maxWidth: .infinity, alignment: .leading)
					
					HStack {
						Image(systemName: "person.fill")
						Text("\(booking.name) (\(booking.email))")
					}
					.body()
					.fillLeading()
					
					VStack(spacing: 8) {
						HStack {
							Image(systemName: "calendar")
							Text("Booking Dates")
								.heading()
								.fillLeading()
						}
						
						HStack {
							Text("Start: ")
							Text(booking.start, style: .date)
						}
						.body()
						.fillLeading()
						HStack {
							Text("End: ")
							Text(booking.end, style: .date)
							
						}
						.body()
						.fillLeading()
					}
					
					BookingStatusIndicatorView(status: booking.status)
						.padding(.top, Constants.Padding.regular)
					
					BasicTextField(defaultText: "Additional Notes", text: $bookingMessage)
					
					ErrorView(error: $error)
					
					PairButtonSpacer()
				}
			}
			
		})
		.padding(.horizontal, Constants.Padding.regular)
		.onAppear {
			bookingMessage = booking.statusMessage
		}
	}
}

//#Preview {
//    OwnerBookingConfirmationView()
//}

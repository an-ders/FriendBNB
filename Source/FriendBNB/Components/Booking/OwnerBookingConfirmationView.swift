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
	@State var error: String = ""
	
	var body: some View {
		PairButtonWrapper(prevText: "Decline", prevAction: {
			Task {
				if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .declined) {
					
				}
				//notificationStore.pushNotification(message: "\(booking.title)'s booking canceled")
			}
		}, nextText: "Confirm", nextAction: {
			Task {
				if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .confirmed) {
					
				}
				//notificationStore.pushNotification(message: "\(booking.title)'s booking confirmed")
			}
		}, content: {
			ScrollView {
				VStack {
					Text("Booking Confirmation")
						.font(.largeTitle).fontWeight(.medium)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, Constants.Spacing.small)
					
					Text(booking.name)
					Text(booking.email)
					Text(booking.userId)
					
					BookingStatusIndicatorView(status: booking.status)
						.padding(.top, Constants.Padding.regular)
					
					ErrorView(error: $error)
				}
			}
		})
		.padding(.horizontal, Constants.Padding.regular)
	}
}

//#Preview {
//    OwnerBookingConfirmationView()
//}

//
//  BookingConfirmationView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct FriendBookingConfirmationView: View {
	@EnvironmentObject var authStore: AuthenticationStore
	@EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	
	@State var confirmDelete: Bool = false
	var property: Property
	var booking: Booking
	
	var body: some View {
		PairButtonWrapper(prevText: "Delete", prevAction: {
			confirmDelete.toggle()
		}, nextText: "Done", nextAction: {
			dismiss()
		}, content: {
			ScrollView {
				VStack {
					Text("Booking Detail")
						.title()
						.fillLeading()
						.padding(.vertical, Constants.Spacing.regular)
					
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
					.padding(.top, Constants.Padding.regular)
					
					BookingStatusIndicatorView(status: booking.status)
						.padding(.vertical, Constants.Padding.regular)
					
					if !booking.statusMessage.isEmpty {
						VStack(spacing: Constants.Spacing.regular) {
							Text("Booking Confirmation Note")
								.heading()
								.fillLeading()
							Text(booking.statusMessage)
								.body()
								.fillLeading()
						}
						.padding(.bottom, Constants.Padding.regular)
					}
					
					Text("Booking Info")
						.heading()
						.fillLeading()
					PropertyDetailsList(property: property, hideSensitiveInfo: booking.status == .confirmed)
					if booking.status != .confirmed {
						Text("Awaiting confirmation for more details...")
							.fillLeading()
							.bodyBold()
					}
				}
			}
		})
		.padding(.horizontal, Constants.Padding.regular)
		.alert(isPresented: $confirmDelete) {
			Alert(title: Text("Are you sure you want to delete this booking?"),
				  primaryButton: .destructive(Text("Delete")) {
				Task {
					await bookingStore.deleteBooking(booking, type: .booking, property: property)
					dismiss()
				}
			},
				  secondaryButton: .default(Text("Cancel")))
		}
	}
}

//#Preview {
//    BookingConfirmationView()
//}

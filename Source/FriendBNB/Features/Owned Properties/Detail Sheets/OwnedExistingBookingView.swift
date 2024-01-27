//
//  OwnedExistingBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI
import FirebaseAuth

struct OwnedExistingBookingView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	
	var property: Property
	
	var body: some View {
		if property.bookings.current().isEmpty {
			VStack {
				Image(systemName: "house")
					.resizable()
					.scaledToFit()
					.frame(width: 50)
				Text("It's empty in here.")
					.font(.title).fontWeight(.medium)
				Text("No bookings for this property")
					.font(.headline).fontWeight(.light)
					.padding(.bottom, 8)
				
				Button(action: {
					Task {
						dismiss()
					}
				}, label: {
					Text("Close")
						.font(.headline)
						.padding(.horizontal, 16)
						.padding(.vertical, 8)
						.foregroundColor(.white)
						.background(Color.systemGray3)
						.cornerRadius(10)
				})
			}
		} else {
			NavigationView {
				PairButtonWrapper(prevText: "", prevAction: {}, nextText: "Back", nextAction: {
					dismiss()
				}, content: {
					VStack {
						Text("Boookings")
							.font(.largeTitle).fontWeight(.medium)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom, Constants.Spacing.small)
						
						ScrollView {
							VStack {
								ForEach(property.bookings.current()) { booking in
									OwnedBookingTileView(booking: booking, delete: {
										Task {
											await bookingStore.deleteBooking(booking, type: .booking, property: property)
										}
									}, content: {
										OwnerBookingConfirmationView(property: property, booking: booking)
									})
								}
							}
						}
					}
				})
				.interactiveDismissDisabled()
				.padding(.horizontal, Constants.Padding.regular)
				.padding(.top, Constants.Padding.small)
			}
		}
	}
}

//#Preview {
//	OwnedExistingBookingView()
//}

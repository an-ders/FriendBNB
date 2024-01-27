//
//  FriendExistingBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI
import FirebaseAuth

struct FriendExistingBookingView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	
	var property: Property
	
	let id = Auth.auth().currentUser?.uid ?? ""
	var body: some View {
		let bookings = property.bookings.withId(id: id).current()
		if bookings.isEmpty {
			VStack {
				Image(systemName: "house")
					.resizable()
					.scaledToFit()
					.frame(width: 50)
				Text("It's empty in here.")
					.font(.title).fontWeight(.medium)
				Text("You have no bookings for this property")
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
				PairButtonWrapper(prevText: "", prevAction: {}, nextText: "Close", nextAction: {
					dismiss()
				}, content: {
					VStack {
						Text("Boookings")
							.font(.largeTitle).fontWeight(.medium)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom, Constants.Spacing.small)
						
						ScrollView {
							VStack {
								ForEach(bookings) { booking in
									BookingTileView(booking: booking, delete: {
										Task {
											await bookingStore.deleteBooking(booking, type: .booking, property: property)
										}
									}, content: {
										FriendBookingConfirmationView(property: property, booking: booking)
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
//    FriendExistingBookingView()
//}

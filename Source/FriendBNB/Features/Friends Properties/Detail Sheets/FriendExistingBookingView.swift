//
//  FriendExistingBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI
import FirebaseAuth

struct FriendExistingBookingView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	
	let id = Auth.auth().currentUser?.uid ?? ""
	var body: some View {
		let bookings = propertyStore.friendSelectedProperty!.bookings.withId(id: id).current()
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
								ForEach(propertyStore.friendSelectedProperty!.bookings.withId(id: id).current()) { booking in
//									BookingTileView(booking: booking, delete: {
//										Task {
//											await bookingStore.deleteBooking(booking, type: .booking, property: propertyStore.selectedFriendProperty!)
//										}
//									}, content: {
//										FriendBookingConfirmationView(property: propertyStore.selectedFriendProperty!, booking: booking)
//									})
								}
							}
						}
					}
				})
				.padding(.horizontal, Constants.Spacing.regular)
				.padding(.top, Constants.Spacing.small)
			}
		}
	}
}

//#Preview {
//    FriendExistingBookingView()
//}

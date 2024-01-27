//
//  OwnedBookingTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct OwnedBookingTileView<Content: View>: View {
	@EnvironmentObject var bookingStore: BookingStore
	@State var deleteConfirm = false
	
	var booking: Booking
	var delete: () -> Void
	@ViewBuilder let content: Content
	
	var body: some View {
		NavigationLink(destination: {
			content
		}, label: {
			HStack {
				VStack {
					Text(booking.title)
					Text(booking.start, style: .date)
					Text(booking.end, style: .date)
				}
				.foregroundStyle(Color.black)
				
				Spacer()
				
				Button(action: {
					deleteConfirm = true
				}, label: {
					Image(systemName: "trash")
						.resizable()
						.scaledToFit()
						.frame(height: 25)
				})
			}
			.padding(.horizontal, Constants.Padding.regular)
			.padding(.vertical, Constants.Padding.small)
			.background(Color.systemGray3)
			.cornerRadius(20)
			.alert(isPresented: $deleteConfirm) {
				Alert(title: Text("Are you sure you want to delete this booking?"),
					  primaryButton: .destructive(Text("Delete")) {
					delete()
				},
					  secondaryButton: .default(Text("Cancel")))
			}
		})
	}
}

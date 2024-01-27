//
//  BookingConfirmationView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct FriendBookingConfirmationView: View {
	@EnvironmentObject var authStore: AuthenticationStore
	@Environment(\.dismiss) private var dismiss
	
	var property: Property
	var booking: Booking
	
	var body: some View {
		PairButtonWrapper(prevText: "", prevAction: {}, nextText: "Back", nextAction: {
			dismiss()
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
						.padding(.vertical, Constants.Padding.regular)
					
					if booking.status == .confirmed {
						Text("Extra Notes")
							.font(.largeTitle).fontWeight(.medium)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom, Constants.Spacing.small)
						Text(property.notes)
					} else {
						Text("Awaiting confirmation for extra notes")
					}
				}
			}
		})
		.padding(.horizontal, Constants.Padding.regular)
	}
}

//#Preview {
//    BookingConfirmationView()
//}

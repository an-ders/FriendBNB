//
//  BookingTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI

struct BookingTileView<Content: View>: View {
	@EnvironmentObject var bookingStore: BookingStore
	
	var booking: Booking
	var showName: Bool = true
	@ViewBuilder var button: Content
	
	var body: some View {
		HStack {
			RoundedRectangle(cornerRadius: 5)
				.frame(width: 15)
				.foregroundStyle(booking.status.colorBG)
				.padding(.vertical, 10)
			VStack(alignment: .leading) {
				if showName {
					Text("**\(booking.name)**")
				} else {
					Text("**\(booking.status.rawValue)**")
				}
				Text("\(booking.start.dayMonthString()) to \(booking.end.dayMonthString())")
			}
			.styled(.body)
			.shimmering(active: booking.status == .pending && showName)
			
			Spacer()
			
			button
		}
		.padding(.trailing, Constants.Spacing.medium)
		.background(Color.white)
	}
}

//#Preview {
//    BookingTileView()
//}

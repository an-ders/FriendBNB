//
//  BookingTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI

struct BookingTileView: View {
	@EnvironmentObject var bookingStore: BookingStore
	
	var booking: Booking
	var showName: Bool = false
	var statusIndicatorWidth: CGFloat = 20
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				if showName {
					Text("**\(booking.name)**")
					Text("\(booking.email)")
				}
				Text("**\(booking.start.dayMonthString())** to **\(booking.end.dayMonthString())**")
			}
			.styled(.body)
			.padding(.leading, statusIndicatorWidth)
			
			Spacer()
			
			Image(systemName: "arrow.up.left.and.arrow.down.right")
				.resizable()
				.scaledToFit()
				.frame(height: 20)
		}
		.padding(Constants.Spacing.small)
		.background {
			HStack(spacing: 0) {
				booking.status.colorBG
					.frame(width: statusIndicatorWidth)
				Color.systemGray6
			}
		}
		.cornerRadius(10)
	}
}

//#Preview {
//    BookingTileView()
//}

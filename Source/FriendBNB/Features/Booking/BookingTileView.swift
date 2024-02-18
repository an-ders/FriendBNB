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
			VStack {
				if showName {
					Text("\(booking.name) (\(booking.email))")
				}
				Text(booking.start, style: .date)
				Text(booking.end, style: .date)
			}
			.body()
			.padding(.leading, statusIndicatorWidth)
			
			Spacer()
			
			Image(systemName: "arrow.up.left.and.arrow.down.right")
				.resizable()
				.scaledToFit()
				.frame(height: 20)
		}
		.padding(Constants.Padding.small)
		.background {
			HStack(spacing: 0) {
				Group {
					switch booking.status {
					case .confirmed:
						Color.systemGreen
					case .declined:
						Color.systemRed
					case .pending:
						Color.systemYellow
					}
				}
				.frame(width: statusIndicatorWidth)
				Color.systemGray6
			}
		}
		.cornerRadius(20)
	}
}

//#Preview {
//    BookingTileView()
//}
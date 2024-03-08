//
//  BookingStatusIndicatorView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct BookingStatusIndicatorView: View {
	var currentStatus: BookingStatus
	
    var body: some View {
		VStack(spacing: Constants.Spacing.medium) {
			Text("BOOKING STATUS")
				.styled(.bodyBold)
				.fillLeading()
				.foregroundStyle(Color.systemGray)
			HStack {
				ForEach(BookingStatus.allCases, id: \.self) { status in
					BookingStatusIndicator(status: status, currentStatus: currentStatus)
				}
			}
		}
	}
}

struct BookingStatusIndicator: View {
	var status: BookingStatus
	var currentStatus: BookingStatus
	
	var body: some View {
		VStack(spacing: Constants.Spacing.xsmall) {
			Image(systemName: status.image)
				.scaledToFit()
				.frame(width: 40)
				.foregroundStyle(status.color.opacity(status == currentStatus ? 1 : 0.3))
			Text(status.rawValue)
				.styled(.caption, weight: .semibold)
				.foregroundStyle(Color.black.opacity(status == currentStatus ? 1 : 0.3))
		}
		.frame(maxWidth: .infinity)
	}
}

//#Preview {
//    BookingStatusIndicatorView()
//}

//
//  AvailabilityTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-21.
//

import SwiftUI

struct AvailabilityTileView: View {
	@EnvironmentObject var bookingStore: BookingStore
	var availibility: Availability
	var bgColor: Color
	var delete: () -> Void
	var statusIndicatorWidth: CGFloat = 20
	
	@State var deleteConfirm = false
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text("**\(availibility.start.dayMonthString())** to **\(availibility.end.dayMonthString())**")
			}
			.styled(.body)
			.padding(.leading, statusIndicatorWidth)
			
			Spacer()
			
			Button(action: {
				deleteConfirm = true
			}, label: {
				Image(systemName: "trash")
					.resizable()
					.scaledToFit()
					.frame(height: 20)
			})
		}
		.foregroundStyle(Color.black)
		.padding(.horizontal, Constants.Spacing.regular)
		.padding(.vertical, Constants.Spacing.small)
		.background {
			HStack(spacing: 0) {
				availibility.type.colorBG
					.frame(width: statusIndicatorWidth)
				Color.systemGray6
			}
		}
		.cornerRadius(10)
		.alert(isPresented: $deleteConfirm) {
			Alert(title: Text("Are you sure you want to delete this?"),
				  primaryButton: .destructive(Text("Delete")) {
				delete()
			},
				  secondaryButton: .default(Text("Cancel")))
		}
	}
}

//#Preview {
//    AvailabilityTileView()
//}

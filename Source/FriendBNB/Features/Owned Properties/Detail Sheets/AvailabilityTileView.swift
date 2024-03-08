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
	var delete: () -> Void
	var statusIndicatorWidth: CGFloat = 20
	
	@State var deleteConfirm = false
	
	var body: some View {
		HStack {
			RoundedRectangle(cornerRadius: 5)
				.frame(width: 15)
				.foregroundStyle(availibility.type.color)
				.padding(.vertical, 8)
			
			VStack(alignment: .leading) {
				Text("**\(availibility.start.dayMonthString())** to **\(availibility.end.dayMonthString())**")
			}
			.styled(.body)
			.foregroundStyle(Color.black)
			.padding(.leading, statusIndicatorWidth)
			.padding(.vertical, Constants.Spacing.medium)
			
			Spacer()
			
			Button(action: {
				deleteConfirm = true
			}, label: {
				Image(systemName: "trash")
					.size(height: 20)
					.foregroundStyle(Color.black)

			})
		}
		.foregroundStyle(Color.black)
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

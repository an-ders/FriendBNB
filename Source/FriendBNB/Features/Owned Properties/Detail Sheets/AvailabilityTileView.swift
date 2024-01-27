//
//  AvailabilityTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-21.
//

import SwiftUI

struct AvailabilityTileView: View {
	@EnvironmentObject var bookingStore: BookingStore
	var availibility: Booking
	var type: BookingType
	var delete: () -> Void
	
	@State var deleteConfirm = false
	
	var body: some View {
		HStack {
			VStack {
				Text(availibility.start, style: .date)
				Text(availibility.end, style: .date)
			}
			
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

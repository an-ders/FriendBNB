//
//  OwnedBookingTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct OwnedBookingTileView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@State var deleteConfirm = false
	@State var expanded = false
	
	var booking: Booking
	
	var body: some View {
		HStack {
			VStack {
				Text(booking.title)
				Text(booking.start, style: .date)
				Text(booking.end, style: .date)
			}
			.fillLeading()
			
			Image(systemName: "arrow.up.left.and.arrow.down.right")
		}
		.foregroundStyle(Color.black)
		.onTapGesture {
			withAnimation {
				self.expanded.toggle()
			}
		}
		
//		, delete: {
//			Task {
//				await bookingStore.deleteBooking(booking, type: .booking, property: property)
//			}
//		}
		
		
//		Button(action: {
//			content
//		}, label: {
//			HStack {
//				VStack {
//					Text(booking.title)
//					Text(booking.start, style: .date)
//					Text(booking.end, style: .date)
//				}
//				.foregroundStyle(Color.black)
//				
//				Spacer()
//				
//				Button(action: {
//					deleteConfirm = true
//				}, label: {
//					Image(systemName: "trash")
//						.resizable()
//						.scaledToFit()
//						.frame(height: 25)
//				})
//			}
//			.padding(.horizontal, Constants.Padding.regular)
//			.padding(.vertical, Constants.Padding.small)
//			.background(Color.systemGray3)
//			.cornerRadius(20)
//			.alert(isPresented: $deleteConfirm) {
//				Alert(title: Text("Are you sure you want to delete this booking?"),
//					  primaryButton: .destructive(Text("Delete")) {
//					delete()
//				},
//					  secondaryButton: .default(Text("Cancel")))
//			}
//		})
	}
}

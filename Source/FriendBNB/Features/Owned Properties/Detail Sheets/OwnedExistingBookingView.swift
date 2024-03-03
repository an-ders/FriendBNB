//
//  OwnedExistingBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct OwnedExistingBookingView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	
	@State var bookingNotification: CustomNotification?
	@State var bookingDetail: Booking?

	var body: some View {
		if let property = propertyStore.ownedSelectedProperty {
			if property.bookings.current().isEmpty {
				emptyView
			} else {
				NavigationStack {
					NotificationView(notification: $bookingNotification) {
						PairButtonWrapper(prevText: "", prevAction: {
							
						}, nextText: "Back", nextAction: {
							dismiss()
						}, content: {
							VStack {
								Text("Bookings")
									.font(.largeTitle).fontWeight(.medium)
									.frame(maxWidth: .infinity, alignment: .leading)
									.padding(.bottom, Constants.Spacing.small)
								
								ScrollView(showsIndicators: false) {
									VStack {
										ForEach(property.bookings.current().dateSorted()) { booking in
											Button(action: {
												bookingDetail = booking
											}, label: {
												BookingTileView(booking: booking, showName: true)
											})
										}
										
										PairButtonSpacer()
									}
								}
							}
						})
						.padding(.horizontal, Constants.Spacing.regular)
						.padding(.top, Constants.Spacing.small)
						.navigationDestination(item: $bookingDetail) { booking in
							OwnedBookingConfirmationView(property: property, booking: booking) { message in
								sendNotification(message: message)
							}
							.navigationBarBackButtonHidden()
						}
					}
				}
			}
		} else {
			NoSelectedPropertyView()
		}
	}
	
	var emptyView: some View {
		VStack {
			Image(systemName: "house")
				.resizable()
				.scaledToFit()
				.frame(width: 50)
			Text("It's empty in here.")
				.font(.title).fontWeight(.medium)
			Text("No bookings for this property")
				.font(.headline).fontWeight(.light)
				.padding(.bottom, 8)
			
			Button(action: {
				Task {
					dismiss()
				}
			}, label: {
				Text("Close")
					.font(.headline)
					.padding(.horizontal, 16)
					.padding(.vertical, 8)
					.foregroundColor(.white)
					.background(Color.systemGray3)
					.cornerRadius(10)
			})
		}
	}
	
	func sendNotification(message: String) {
		withAnimation {
			self.bookingNotification = CustomNotification(message: message, dismissable: true)
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
			withAnimation {
				self.bookingNotification = nil
			}
		}
	}
}

//#Preview {
//	OwnedExistingBookingView()
//}

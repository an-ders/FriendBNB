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
	@State var showAddToCalendar: PropertyBookingGroup?

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
							VStack(spacing: 0) {
								DetailSheetTitle(title: "YOUR BOOKING", showDismiss: true)
									.padding(.leading, Constants.Spacing.medium)
									.padding(.vertical, Constants.Spacing.large)
									.padding(.trailing, Constants.Spacing.medium)
								
								let bookings = property.bookings.current().dateSorted()
								ScrollView(showsIndicators: false) {
									VStack {
										List {
											ForEach(bookings) { booking in
												Button(action: {
													bookingDetail = booking
												}, label: {
													BookingTileView(booking: booking) {
														if booking.status == .confirmed {
															Button(action: {
																showAddToCalendar = PropertyBookingGroup(property: property, booking: booking)
															}, label: {
																Image(systemName: "calendar")
																	.resizable()
																	.scaledToFit()
																	.frame(height: 20)
															})
														}
													}
												})
											}
										}
										.environment(\.defaultMinListRowHeight, 90)
										.listStyle(.plain)
										.frame(height: 90 * CGFloat(bookings.count))
										.padding(.horizontal, -Constants.Spacing.regular)
										
										PairButtonSpacer()
									}
								}
							}
						})
						.padding(.horizontal, Constants.Spacing.regular)
						.navigationDestination(item: $bookingDetail) { booking in
							OwnedBookingConfirmationView(property: property, booking: booking) { message in
								sendNotification(message: message)
							}
							.navigationBarBackButtonHidden()
						}
					}
				}
				.sheet(item: $showAddToCalendar) { group in
					EventEditViewController(group: group) {
						showAddToCalendar = nil
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

//
//  BookingConfirmationView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct BookingConfirmationView<Content: View>: View {
	@EnvironmentObject var authStore: AuthenticationStore
	@EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyStore: PropertyStore
	@Environment(\.dismiss) private var dismiss
	
	@State var confirmDelete: Bool = false
	@State var selectedCalendar: PropertyBookingGroup?
	
	var property: Property
	var booking: Booking
	var showDismiss: Bool = true
	
	@ViewBuilder var bottomBar: Content
	
	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 0) {
				DetailSheetTitle(title: "Your Booking", showDismiss: showDismiss)
					.padding(.leading, Constants.Spacing.medium)
					.padding(.vertical, Constants.Spacing.medium)
					.padding(.trailing, Constants.Spacing.large)
				Divider()
			}

			ScrollView(showsIndicators: false) {
				VStack(spacing: 50) {
					if booking.isRequested {
						Text("Please note that one or more of these dates are not set the availability!")
							.styled(.caption)
							.foregroundStyle(Color.systemOrange)
							.padding(.bottom, -25)
					}
					
					BookingStatusIndicatorView(currentStatus: booking.status)

					Button(action: {
						if booking.status == .confirmed {
							selectedCalendar = PropertyBookingGroup(type: .friend, property: property, booking: booking)
						}
					}, label: {
						VStack(spacing: 8) {
							DetailHeading(title: "BOOKING DARES")
							HStack {
								VStack {
									HStack {
										Text("Start: ")
										Text(booking.start, style: .date)
									}
									.styled(.body)
									.fillLeading()
									
									HStack {
										Text("End: ")
										Text(booking.end, style: .date)
									}
									.styled(.body)
									.fillLeading()
								}
								.foregroundStyle(Color.black)
								
								if booking.status == .confirmed {
									Image(systemName: "calendar")
											.size(height: 20)
								}
							}
						}
						.contentShape(Rectangle())
					})
					.disabled(booking.status != .confirmed)
					
					if !booking.statusMessage.isEmpty {
						VStack(spacing: Constants.Spacing.regular) {
							DetailHeading(title: "BOOKING CONFIRMATION NOTE")
							Text(booking.statusMessage)
								.styled(.body)
								.fillLeading()
						}
						.padding(.bottom, Constants.Spacing.regular)
					}
					
					if booking.status == .confirmed {
						VStack(spacing: 4) {
							DetailHeading(title: "ADDRESS")
							Button(action: {
								if let url = URL(string: "http://maps.apple.com/?address=" + property.location.formattedAddress) {
									UIApplication.shared.open(url)
								}
							}, label: {
								HStack {
									VStack {
										Text(property.location.addressTitle)
											.styled(.body)
											.fillLeading()
										Text(property.location.addressDescription)
											.styled(.body)
											.fillLeading()
									}
									
									Image(systemName: "map.fill")
										.size(width: 20, height: 20)
								}
								.foregroundStyle(.black)
							})
						}
					}
					
					PropertyDetailList(property: property, sensitiveInfo: booking.sensitiveInfo)
					
					if booking.status != .confirmed {
						Text("Awaiting confirmation for more details...")
							.fillLeading()
							.styled(.bodyBold)
					}
				}
				.padding(.bottom, 50)
				.padding(.top, 25)
			}
			.padding(.horizontal, Constants.Spacing.regular)

			bottomBar
		}
		.sheet(item: $selectedCalendar) { group in
			EventEditViewController(group: group) {
				selectedCalendar = nil
			}
		}
	}
}

//#Preview {
//    BookingConfirmationView()
//}

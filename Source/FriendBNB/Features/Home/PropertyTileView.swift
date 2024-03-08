//
//  HomeTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-03.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
	let id = UUID()
	let name: String
	let coordinate: CLLocationCoordinate2D
}

struct PropertyTileView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var notificationStore: NotificationStore
	@EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var authStore: AuthenticationStore
	var property: Property
	var type: PropertyType
	var bookingAction: (Booking) -> Void
	
	let decimals = 3
	
	var body: some View {
		let coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
		let center =  CLLocationCoordinate2D(latitude: property.location.geo.latitude - 100 / 111111, longitude: property.location.geo.longitude)
		VStack(spacing: 0) {
			Button(action: {
				propertyStore.showProperty(property, type: type)
			}, label: {
				ZStack {
					Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
						Marker("", coordinate: coordinate)
					}
					.disabled(true)
					
					VStack {
						VStack(spacing: 0) {
							Text(property.info.nickname)
								.styled(.title, weight: .bold)
							if type == .owned {
								Text(property.id)
									.styled(.caption)
									.foregroundStyle(Color.systemGray5)
							} else {
								Text("People: \(property.info.people) | Cost: \(property.info.payment == .free ? "Free" : "$" + String(format: "%.2f", property.info.cost))")
									.styled(.caption)
									.foregroundStyle(Color.systemGray5)
							}
						}
						.padding(Constants.Spacing.medium)
						.darkWindow()
						.cornerRadius(5)
						.foregroundStyle(Color.white)
						.padding(.top, 50)
						.shadow(radius: 5)
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(.black.opacity(0.4))
				}
				.frame(height: 175)
			})
			
			let bookings = type == .owned ? property.bookings.current().dateSorted() : property.bookings.withId(id: authStore.user?.uid ?? "").current().dateSorted()
			List {
				ForEach(bookings, id: \.id) { booking in
					Button(action: {
						bookingAction(booking)
					}, label: {
						BookingTileView(booking: booking, showName: type == .owned) {
							if booking.status == .confirmed {
								Button(action: {
									propertyStore.selectedAddToCalendar = PropertyBookingGroup(type: type, property: property, booking: booking)
								}, label: {
									Image(systemName: "calendar")
										.resizable()
										.scaledToFit()
										.frame(height: 20)
								})
							}
						}
					})
					.swipeActions(edge: .trailing, allowsFullSwipe: false) {
						if type == .owned && booking.status == .pending {
							Button(action: {
								Task {
									if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .confirmed, message: "", sensitiveInfo: [SensitiveInfoType.notes.rawValue, SensitiveInfoType.contactInfo.rawValue, SensitiveInfoType.cleaningNotes.rawValue, SensitiveInfoType.wifi.rawValue, SensitiveInfoType.securityCode.rawValue, SensitiveInfoType.paymentNotes.rawValue]) {
										return
									}
									
									notificationStore.pushNotification(message: "Booking approved!")
									await propertyStore.fetchProperties(.owned)
									//propertyStore.dismissProperty()
								}
							}, label: {
								Label("Approve", systemImage: "checkmark")
									.contentShape(Rectangle())
							})
							.tint(Color.systemGreen)
							
							Button(action: {
								Task {
									if let error = await bookingStore.updateBooking(booking: booking, property: property, status: .declined, message: "", sensitiveInfo: []) {
										return
									}
									notificationStore.pushNotification(message: "Booking declined.")
									await propertyStore.fetchProperties(.owned)
									//propertyStore.dismissProperty()
								}
							}, label: {
								Label("Decline", systemImage: "xmark")
									.contentShape(Rectangle())
							})
							.tint(Color.systemRed)
						}
					}
				}
			}
			.environment(\.defaultMinListRowHeight, 90)
			.listStyle(.plain)
			.frame(height: 90 * CGFloat(bookings.count))
			.zIndex(4)
			//.padding(.bottom, Constants.Spacing.medium)
		}
		.clipShape(RoundedRectangle(cornerRadius: 10))
		.shadow(radius: 5)
		.padding(.horizontal, Constants.Spacing.regular)
	}
}

//struct HomeTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTileView(property: Property(id: "test123", data: ["title": "testtitle123", "owner": "Anders"]))
//    }
//}

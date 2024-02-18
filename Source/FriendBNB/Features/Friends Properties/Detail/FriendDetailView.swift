//
//  FriendDetailView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore
import MapKit

struct FriendDetailView: View {
    @EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyStore: PropertyStore
	@Environment(\.dismiss) private var dismiss
	
	@State var confirmDelete = false
    
    var body: some View {
		if let property = propertyStore.selectedFriendProperty {
			let coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
			let bookings = property.bookings.withId(id: property.ownerId).current().dateSorted()
			VStack {
				ScrollView(showsIndicators: false) {
					VStack(spacing: Constants.Padding.regular) {
						VStack {
							Text(property.location.addressTitle)
								.heading()
								.fillLeading()
							Text(property.location.addressDescription)
								.body()
								.fillLeading()
						}
						.padding(.top, Constants.Padding.small)
						
						Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
							Marker("", coordinate: coordinate)
						}
						.frame(height: 250)
						.cornerRadius(20)
						
						PropertyDetailsList(property: property, hideSensitiveInfo: true)
						
						if !bookings.isEmpty {
							Text("Your Bookings")
								.heading()
								.fillLeading()
							
							ForEach(property.bookings.withId(id: property.ownerId).current().dateSorted(), id: \.id) { booking in
								Button(action: {
									propertyStore.showFriendExistingBooking = booking
								}, label: {
									BookingTileView(booking: booking)
								})
							}
						}
						
						Rectangle()
							.frame(height: 40)
							.foregroundStyle(Color.clear)
					}
				}
				
				Button(action: {
					propertyStore.showFriendNewBooking.toggle()
				}, label: {
					HStack {
						Image(systemName: "calendar.badge.plus")
							.resizable()
							.scaledToFit()
							.frame(height: 30)
						Text("New Booking")
							.font(.headline).fontWeight(.medium)
						
					}
					.padding(.vertical, Constants.Padding.small)
					.frame(maxWidth: .infinity)
					.foregroundStyle(Color.white)
					.background(Color.systemBlue.opacity(0.6))
					.cornerRadius(5)
				})
			}
			.padding(.horizontal, Constants.Padding.regular)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					FriendDetailSettingsView(confirmDelete: $confirmDelete)
				}
			}
			.alert(isPresented: $confirmDelete) {
				Alert(title: Text("Are you sure you want to remove this property?"),
					  primaryButton: .destructive(Text("Delete")) {
					Task {
						await propertyStore.removeProperty(property.id, type: .friend)
						dismiss()
					}
				},
					  secondaryButton: .default(Text("Cancel")))
			}
			.sheet(item: $propertyStore.showFriendExistingBooking) { booking in
				FriendBookingConfirmationView(property: property, booking: booking)
					.interactiveDismissDisabled()
			}
//			.sheet(isPresented: $propertyStore.showFriendExistingBooking) {
//				FriendExistingBookingView()
//					.interactiveDismissDisabled()
//			}
			.sheet(isPresented: $propertyStore.showFriendNewBooking) {
				FriendNewBookingView(property: property)
					.interactiveDismissDisabled()
			}
			.onAppear {
				propertyStore.subscribe(type: .friend)
			}
			.onDisappear {
				propertyStore.unsubscribe()
			}
		} else {
			NoSelectedPropertyView()
		}
    }
}
//struct PropertyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PropertyDetail()
//    }
//}

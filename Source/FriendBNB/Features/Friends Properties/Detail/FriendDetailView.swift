//
//  FriendDetailView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import MapKit

struct FriendDetailView: View {
    @EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyStore: PropertyStore
	@Environment(\.dismiss) private var dismiss
	
	@State var deleteProperty = false
	@State var deleteBooking = false

    var body: some View {
		if let property = propertyStore.friendSelectedProperty {
			let coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
			let bookings = property.bookings.withId(id: property.ownerId).current().dateSorted()
			VStack {
				ScrollView(showsIndicators: false) {
					VStack(spacing: Constants.Spacing.regular) {
						VStack {
							Text(property.location.addressTitle)
								.styled(.headline)
								.fillLeading()
							Text(property.location.addressDescription)
								.styled(.body)
								.fillLeading()
						}
						.padding(.top, Constants.Spacing.small)
						
						Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
							Marker("", coordinate: coordinate)
						}
						.frame(height: 250)
						.cornerRadius(20)
						
						PropertyDetailList(property: property)
						
						if !bookings.isEmpty {
							Text("Your Bookings")
								.styled(.headline)
								.fillLeading()
							
							ForEach(property.bookings.withId(id: Auth.auth().currentUser?.uid ?? "").current().dateSorted(), id: \.id) { booking in
								Button(action: {
									propertyStore.friendSelectedBookingInDetail = booking
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
					propertyStore.showFriendNewBookingSheet.toggle()
				}, label: {
					HStack {
						Image(systemName: "calendar.badge.plus")
							.resizable()
							.scaledToFit()
							.frame(height: 30)
						Text("New Booking")
							.font(.headline).fontWeight(.medium)
						
					}
					.padding(.vertical, Constants.Spacing.small)
					.frame(maxWidth: .infinity)
					.foregroundStyle(Color.white)
					.background(Color.systemBlue.opacity(0.6))
					.cornerRadius(5)
				})
			}
			.navigationTitle(property.info.nickname)
			.padding(.horizontal, Constants.Spacing.regular)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					FriendDetailSettingsView(confirmDelete: $deleteProperty)
				}
			}
			.alert(isPresented: $deleteProperty) {
				Alert(title: Text("Are you sure you want to remove this property?"),
					  primaryButton: .destructive(Text("Remove")) {
					Task {
						await propertyStore.removePropertyFromUser(property.id, type: .friend)
						dismiss()
					}
				},
					  secondaryButton: .default(Text("Cancel")))
			}
			.sheet(item: $propertyStore.friendSelectedBookingInDetail) { booking in
				BookingConfirmationView(property: property, booking: booking) {
					PairButtonsView(prevText: "Delete", prevAction: {
						deleteBooking.toggle()
					}, nextText: "Done", nextCaption: "", nextAction: {
						propertyStore.friendSelectedBookingInDetail = nil
					}, includeShadow: false)
					.padding(.horizontal, Constants.Spacing.regular)
				}
				.alert(isPresented: $deleteBooking) {
					Alert(title: Text("Are you sure you want to delete this booking?"),
						  primaryButton: .destructive(Text("Delete")) {
						Task {
							await bookingStore.deleteBooking(booking, propertyId: property.id)
							propertyStore.friendSelectedBookingInDetail = nil
							await propertyStore.fetchProperties(.friend)
						}
					},
						  secondaryButton: .default(Text("Cancel")))
				}
			}
			.sheet(isPresented: $propertyStore.showFriendNewBookingSheet) {
				FriendNewBookingView(property: property)
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

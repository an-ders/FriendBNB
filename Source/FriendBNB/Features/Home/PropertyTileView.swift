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
	@EnvironmentObject var authStore: AuthenticationStore
    var property: Property
	var type: PropertyType
	var bookingAction: (Booking) -> Void
	
	let decimals = 3
    
    var body: some View {
		let coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
		let center =  CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude - 500 / 111111)
		VStack(spacing: 0) {
			ZStack {
				Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
					Marker("", coordinate: coordinate)
				}
				.disabled(true)
				//.blur(radius: 1.5)
				
				VStack(spacing: 0) {
					if property.info.nickname.isEmpty {
						Text(property.location.addressTitle)
							.styled(.title, weight: .bold)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(property.location.addressDescription)
							.styled(.caption, weight: .semibold)
							.frame(maxWidth: .infinity, alignment: .leading)
					} else {
						Text(property.info.nickname)
							.styled(.title, weight: .bold)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(property.location.addressTitle)
							.styled(.caption, weight: .semibold)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(property.location.addressDescription)
							.styled(.caption, weight: .semibold)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				.frame(maxHeight: .infinity)
				.padding(Constants.Spacing.medium)
				.foregroundStyle(Color.white)
				.background(Color.black.opacity(0.3))
			}
			.frame(height: 175)

			VStack(spacing: 0) {
				ForEach(type == .owned ? property.bookings.current().dateSorted() : property.bookings.withId(id: authStore.user?.uid ?? "").current().dateSorted(), id: \.id) { booking in
					Button(action: {
						bookingAction(booking)
					}, label: {
						VStack {
							HStack {
								RoundedRectangle(cornerRadius: 5)
									.frame(width: 15)
									.foregroundStyle(booking.status.colorBG)
								VStack(alignment: .leading) {
									Text("**\(booking.name)**")
									Text("\(booking.start.dayMonthString()) to \(booking.end.dayMonthString())")
								}
								.styled(.body)
								
								Spacer()
								
								Image(systemName: "arrow.up.left.and.arrow.down.right")
									.resizable()
									.scaledToFit()
									.frame(height: 20)
							}
							.padding(.horizontal, Constants.Spacing.medium)
							.padding(.top, Constants.Spacing.small)
							Divider()
						}
						.background(Color.white)
					})
				}
			}
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

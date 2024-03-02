//
//  NewPropertyConfirmView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI
import MapKit

struct NewPropertyConfirmView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	
	@Binding var currentTab: NewPropertyTabs
	@ObservedObject var location: Location
	@ObservedObject var info: NewPropertyInfo
	var createProperty: () -> Void
	
    var body: some View {
		let coordinate = CLLocationCoordinate2D(latitude: location.geo.latitude, longitude: location.geo.longitude)
		
			ScrollView(showsIndicators: false) {
				VStack(spacing: Constants.Spacing.regular) {
					Text(location.addressTitle)
						.styled(.title)
						.fillLeading()
						.padding(.top, Constants.Spacing.regular)
					Text(location.addressDescription)
						.styled(.body)
						.fillLeading()
					
					Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
						Marker("", coordinate: coordinate)
					}
					.frame(height: 250)
					.cornerRadius(20)
					
					NewPropertyInfoFieldsView(info: info)
					
					PairButtonsView(prevText: "Back", prevAction: {
						back()
					}, nextText: "Finish", nextCaption: "and Set Availability", nextAction: {
						next()
					})
				}
			}
			.contentShape(Rectangle())
			.onTapGesture {
				hideKeyboard()
			}
		.padding(.horizontal, Constants.Spacing.regular)
    }
	
	func next() {
		createProperty()
		withAnimation {
			propertyStore.showNewPropertySheet.toggle()
		}
	}
	
	func back() {
		withAnimation {
			currentTab = .info
		}
	}
}

//#Preview {
//    NewPropertyConfirmView()
//}

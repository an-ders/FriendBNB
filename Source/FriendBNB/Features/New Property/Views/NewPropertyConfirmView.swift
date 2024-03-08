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
		VStack(spacing: 0) {
			ScrollView(showsIndicators: false) {
				VStack(spacing: Constants.Spacing.large) {
					ZStack {
						let coordinate = CLLocationCoordinate2D(latitude: location.geo.latitude, longitude: location.geo.longitude)
						let center =  CLLocationCoordinate2D(latitude: location.geo.latitude - 150 / 111111, longitude: location.geo.longitude)
						Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
							Marker("", coordinate: coordinate)
						}
						.disabled(true)
						
						VStack(spacing: 0) {
							Spacer()
							VStack(spacing: 0) {
								if info.nickname.isEmpty {
									Text(location.addressTitle)
										.styled(.title, weight: .bold)
										.foregroundStyle(.white)
									Text(location.addressDescription)
										.styled(.bodyBold, weight: .bold)
										.foregroundStyle(.white)
								} else {
									Text(info.nickname)
										.styled(.title, weight: .bold)
										.foregroundStyle(.white)
								}
							}
							.padding(Constants.Spacing.medium)
							.background(.black.opacity(0.4))
							.cornerRadius(5)
							.padding(.top, 50)
						}
						.padding(Constants.Spacing.large)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.foregroundStyle(Color.white)
						.background(Color.black.opacity(0.4))
					}
					.frame(height: 250)
					.background(Color.white)
					
					VStack(spacing: 50) {
						VStack(spacing: 4) {
							Text("ADDRESS")
								.styled(.bodyBold)
								.fillLeading()
								.foregroundStyle(Color.systemGray)
							
							HStack {
								VStack {
									Text(location.addressTitle)
										.styled(.body)
										.fillLeading()
									Text(location.addressDescription)
										.styled(.body)
										.fillLeading()
								}
								
								Image(systemName: "map.fill")
									.size(width: 20, height: 20)
							}
							.foregroundStyle(.black)
						}
						
						let color = Color.black
						VStack(spacing: 4) {
							Text("PROPERTY INFO")
								.styled(.bodyBold)
								.fillLeading()
								.foregroundStyle(Color.systemGray)
							
							HStack {
								Image(systemName: "person.2.fill")
									.size(width: 20, height: 20)
								Text("Max number of people: ")
									.styled(.body)
								Text(String(info.people))
									.font(.headline).fontWeight(.semibold)
								Spacer()
							}
							.foregroundStyle(color)
							
							HStack {
								Image(systemName: "dollarsign.circle.fill")
									.size(width: 20, height: 20)
								Text("Cost per night: ")
									.styled(.body)
								Text(info.payment == .free ? "FREE" : "\(String(format: "%.2f", info.cost ?? 0)) \(info.payment.rawValue)")
									.styled(.bodyBold)
								Spacer()
							}
							.foregroundStyle(color)
							
							if !info.paymentNotes.isEmpty {
								Text(info.paymentNotes.isEmpty ? "" : info.paymentNotes)
									.styled(.body)
									.fillLeading()
							}
						}
						
						if !info.notes.isEmpty {
							PropertyDetailListRow(type: .notes, desciption: info.notes, color: color)
						}
						
						if !info.contactInfo.isEmpty {
							PropertyDetailListRow(type: .contactInfo, desciption: info.contactInfo, color: color)
						}
						
						if !info.cleaningNotes.isEmpty {
							PropertyDetailListRow(type: .cleaningNotes, desciption: info.cleaningNotes, color: color)
						}
						
						if !info.wifiName.isEmpty {
							VStack(spacing: 4) {
								Text(SensitiveInfoType.wifi.title)
									.styled(.bodyBold)
									.fillLeading()
									.foregroundStyle(Color.systemGray)
								
								HStack {
									Image(systemName: SensitiveInfoType.wifi.image)
										.size(width: 20, height: 20)
									
									Text(info.wifiName)
										.styled(.body)
										.fillLeading()
								}
								HStack {
									Image(systemName: "lock.fill")
										.size(width: 20, height: 20)
									
									Text(info.wifiPass)
										.styled(.body)
										.fillLeading()
								}
								.foregroundStyle(color)
							}
						}
						
						if !info.securityCode.isEmpty {
								VStack(spacing: 4) {
									Text(SensitiveInfoType.securityCode.title)
										.styled(.bodyBold)
										.fillLeading()
										.foregroundStyle(Color.systemGray)
									
									HStack {
										Image(systemName: SensitiveInfoType.securityCode.image)
											.size(width: 20, height: 20)
										
										Text(info.securityCode)
											.styled(.body)
											.fillLeading()
									}
									.foregroundStyle(color)
								}
						}
					}
					.padding(.horizontal, Constants.Spacing.regular)
					.padding(.bottom, 50)
					.padding(.top, 25)
				}
			}
			.ignoresSafeArea(.container)
			VStack(spacing: 8) {
				Divider()
				PairButtonsView(prevText: "Back", prevAction: {
					back()
				}, nextText: "Finish", nextCaption: "and Set Availability", nextAction: {
					next()
				})
				.padding(.horizontal, Constants.Spacing.medium)
			}
		}
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

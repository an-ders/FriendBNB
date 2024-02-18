//
//  PropertyDetail.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore
import MapKit

struct OwnedDetailView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var notificationStore: NotificationStore
	
	@State var confirmDelete = false
	
	var body: some View {
		if let property = propertyStore.selectedOwnedProperty {
			let coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
			VStack {
				ScrollView(showsIndicators: false) {
					VStack(spacing: Constants.Padding.regular) {
						VStack {
							Text(property.location.addressTitle)
								.font(.title).fontWeight(.medium)
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(property.location.addressDescription)
								.font(.headline).fontWeight(.light)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						.padding(.top, Constants.Padding.small)
						
						Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
							Marker("", coordinate: coordinate)
						}
						.frame(height: 250)
						.cornerRadius(20)
						
						HStack {
							Button(action: {
								propertyStore.showOwnedBooking.toggle()
							}, label: {
								VStack {
									Image(systemName: "calendar.badge.clock")
										.resizable()
										.scaledToFit()
										.frame(width: 40)
									Text("Bookings")
										.font(.headline).fontWeight(.medium)
								}
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.foregroundStyle(Color.white)
								.background(Color.systemBlue.opacity(0.6))
								.cornerRadius(5)
							})
							
							Button(action: {
								propertyStore.showOwnedAvailability.toggle()
							}, label: {
								VStack {
									Image(systemName: "calendar.badge.plus")
										.resizable()
										.scaledToFit()
										.frame(width: 40)
									Text("Set Availability")
										.font(.headline).fontWeight(.medium)
									
								}
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.foregroundStyle(Color.white)
								.background(Color.systemBlue.opacity(0.6))
								.cornerRadius(5)
							})
						}
						.frame(height: 100)
						
						PropertyDetailsList(property: property)
					}
				}
				
				// MARK: SHARE BUTTON
//				ShareLink(item: property.shareLink, message: Text(property.shareMessage)) {
//					HStack {
//						Image(systemName: "square.and.arrow.up")
//							.resizable()
//							.scaledToFit()
//							.frame(width: 20)
//						Text("Share")
//							.bodyBold()
//					}
//					.padding(.vertical, Constants.Padding.small)
//					.frame(maxWidth: .infinity)
//					.foregroundStyle(Color.white)
//					.background(property.available.current().isEmpty ? Color.systemGray3 : Color.systemBlue.opacity(0.6))
//					.cornerRadius(5)
//					.padding(.bottom, 4)
//				}
				if let url = URL(string: "FriendBNB://id=\(property.id)"), !property.available.current().isEmpty {
					ShareLink(item: url, subject: Text(""), message: Text(property.shareMessage)) {
						HStack {
							Image(systemName: "square.and.arrow.up")
								.resizable()
								.scaledToFit()
								.frame(width: 20)
							Text("Share")
								.bodyBold()
						}
						.padding(.vertical, Constants.Padding.small)
						.frame(maxWidth: .infinity)
						.foregroundStyle(Color.white)
						.background(Color.systemBlue.opacity(0.6))
						.cornerRadius(5)
						.padding(.bottom, 4)
					}
				} else {
					Button(action: {
						notificationStore.pushNotification(message: "Please set availability")
					}, label: {
						HStack {
							Image(systemName: "square.and.arrow.up")
								.resizable()
								.scaledToFit()
								.frame(width: 20)
							Text("Share")
								.bodyBold()
						}
						.padding(.vertical, Constants.Padding.small)
						.frame(maxWidth: .infinity)
						.foregroundStyle(Color.white)
						.background(Color.systemGray3)
						.cornerRadius(5)
						.padding(.bottom, 4)
					})
				}
			}
			//.navigationTitle(property.nickname)
			.padding(.horizontal, Constants.Padding.regular)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					OwnedDetailSettingsView(confirmDelete: $confirmDelete)
				}
			}
			.alert(isPresented: $confirmDelete) {
				Alert(title: Text("Are you sure you want to delete this property?"),
					  primaryButton: .destructive(Text("Delete")) {
					Task {
						await propertyStore.deleteProperty(id: property.id, type: .owned)
					}
				},
					  secondaryButton: .default(Text("Cancel")))
			}
			.sheet(isPresented: $propertyStore.showOwnedAvailability) {
				OwnedAvailabilityView(property: property)
					.interactiveDismissDisabled()
			}
			.sheet(isPresented: $propertyStore.showOwnedBooking) {
				OwnedExistingBookingView()
					.interactiveDismissDisabled()
			}
			.onAppear {
				propertyStore.subscribe(type: .owned)
			}
			.onDisappear {
				propertyStore.unsubscribe()
			}
		} else {
			NoSelectedPropertyView()
		}
	}
	
//	var propertyShareButton: some View {
//		VStack {
//			if let property = propertyStore.selectedOwnedProperty {
//				
//			}
//		}
//		
//	}
}

struct PropertyDetailsList: View {
	var property: Property
	var hideSensitiveInfo = false
	
	var body: some View {
		HStack {
			Image(systemName: "person.2.fill")
				.resizable()
				.scaledToFit()
				.frame(width: 25)
			Text("Max number of people: ")
				.body()
			Text(String(property.people))
				.font(.headline).fontWeight(.semibold)
			Spacer()
		}
		VStack {
			HStack {
				Image(systemName: "dollarsign.circle.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 25)
				Text("Cost per night: ")
					.body()
				Text(property.payment == .free ? "FREE" : "\(property.cost) \(property.payment.rawValue)")
					.font(.headline).fontWeight(.semibold)
				Spacer()
			}
			if !hideSensitiveInfo {
				Text(property.paymentNotes.isEmpty ? "" : property.paymentNotes)
					.body()
					.fillLeading()
			}
		}
		
		if !hideSensitiveInfo {
			if !property.notes.isEmpty {
				VStack {
					Text("Notes")
						.heading()
						.fillLeading()
					
					Text(property.notes)
						.body()
						.fillLeading()
				}
			}
			
			if !property.cleaningNotes.isEmpty {
				VStack {
					Text("Cleaning Notes")
						.heading()
						.fillLeading()
					
					Text(property.cleaningNotes)
						.body()
						.fillLeading()
				}
			}
			
			if !property.wifi.isEmpty {
				VStack {
					Text("Wifi")
						.heading()
						.fillLeading()
					
					Text(property.wifi)
						.body()
						.fillLeading()
				}
			}
			
			if !property.securityCode.isEmpty {
				VStack {
					Text("Security Code")
						.heading()
						.fillLeading()
					
					Text(property.securityCode)
						.body()
						.fillLeading()
				}
			}
			if !property.contactInfo.isEmpty {
				VStack {
					Text("Contact Info")
						.heading()
						.fillLeading()
					
					Text(property.contactInfo)
						.body()
						.fillLeading()
				}
			}
		}
	}
}

//struct PropertyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PropertyDetail()
//    }
//}

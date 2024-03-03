//
//  PropertyDetail.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore
import MapKit
import FirebaseDynamicLinks

struct OwnedDetailView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var notificationStore: NotificationStore
	
	@State var confirmDelete = false
	@State var url: URL?
	
	var body: some View {
		if let property = propertyStore.getSelectedProperty(.owned) {
			let coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
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
						
						Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
							Marker("", coordinate: coordinate)
						}
						.frame(height: 250)
						.cornerRadius(20)
						
						HStack {
							Button(action: {
								propertyStore.showOwnedExistingBookingsSheet.toggle()
							}, label: {
								HStack(spacing: 0) {
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
									
									VStack(spacing: 0) {
										ForEach(BookingStatus.allCases, id: \.self) { status in
											Text(String(property.bookings.current().filter {$0.status == status}.count))
												.styled(.caption, weight: .semibold)
												.frame(maxHeight: .infinity)
												.frame(width: 20)
												.background(status.colorBG)
												.foregroundStyle(Color.black)
										}
									}
								}
								.cornerRadius(5)
							})
							
							Button(action: {
								propertyStore.showOwnedAvailabilitySheet.toggle()
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
						
						PropertyDetailList(property: property, showAll: true)
					}
				}
				
				// MARK: SHARE BUTTON
				if let url = url, !property.available.current().isEmpty {
					ShareLink(item: url, subject: Text(""), message: Text(property.shareMessage)) {
						HStack {
							Image(systemName: "square.and.arrow.up")
								.resizable()
								.scaledToFit()
								.frame(width: 20)
								.offset(y: -2)
							Text("Share Property")
								.styled(.bodyBold)
						}
						.padding(.vertical, Constants.Spacing.small)
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
								.offset(y: -2)
							Text("Share")
								.styled(.bodyBold)
						}
						.padding(.vertical, Constants.Spacing.small)
						.frame(maxWidth: .infinity)
						.foregroundStyle(Color.white)
						.background(Color.systemGray3)
						.cornerRadius(5)
						.padding(.bottom, 4)
					})
				}
			}
			.navigationTitle(property.info.nickname)
			.padding(.horizontal, Constants.Spacing.regular)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					OwnedDetailSettingsView(confirmDelete: $confirmDelete)
				}
			}
			.alert(isPresented: $confirmDelete) {
				Alert(title: Text("Are you sure you want to delete this property?"),
					  primaryButton: .destructive(Text("Delete")) {
					Task {
						await propertyStore.deleteProperty(id: property.id)
					}
				},
					  secondaryButton: .default(Text("Cancel")))
			}
			.sheet(isPresented: $propertyStore.showOwnedAvailabilitySheet) {
				OwnedAvailabilityView(property: property)
			}
			.sheet(isPresented: $propertyStore.showOwnedExistingBookingsSheet) {
				OwnedExistingBookingView()
			}
			.onAppear {
				propertyStore.subscribe(type: .owned)
				generateLink(property: property)
			}
			.onDisappear {
				propertyStore.unsubscribe()
			}
		} else {
			NoSelectedPropertyView()
		}
	}
	
	func generateLink(property: Property) {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "www.friendbnb.com"
		components.path = "/property"
		components.queryItems = [URLQueryItem(name: "friendID", value: property.id)]
		
		guard let linkParam = components.url else { return }
		
		guard let shareLink = DynamicLinkComponents(link: linkParam, domainURIPrefix: "https://friendbnb.page.link") else {
			print("Cant create dynamic link")
			return
		}
		shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: Bundle.main.bundleIdentifier ?? "com.baboo.FriendBNB")
		shareLink.iOSParameters?.appStoreID = "284815942"
		
		shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
		shareLink.socialMetaTagParameters?.title = "Add \(property.info.nickname.isEmpty ? property.ownerName + "'s property" : property.info.nickname) in the FriendBNB app and book your stay!"
		shareLink.socialMetaTagParameters?.descriptionText = "If it is your first time installing the app please ALLOW paste from the browser!"
		shareLink.socialMetaTagParameters?.imageURL = URL(string: "https://i.imgur.com/hSv4Ev1.jpeg")
		shareLink.shorten { url, warnings, error in
			if let error = error {
				print("Error shortening link: \(error)")
				return
			}
			
			if let warnings = warnings {
				for warning in warnings {
					print("Dynamic Link warning: \(warning)")
				}
			}
			
			guard let url = url else {
				return
			}
			print("URLShortened")
			self.url = url
		}
	}
}

//struct PropertyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PropertyDetail()
//    }
//}

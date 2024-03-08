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
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.safeAreaInsets) private var safeAreaInsets
	
	@State var confirmDelete = false
	@State var edit = false
	@State var url: URL?
	@State var copied = false
	
	var body: some View {
		if let property = propertyStore.getSelectedProperty(.owned) {
			VStack(spacing: 0) {
				ScrollView(showsIndicators: false) {
					VStack(spacing: Constants.Spacing.large) {
						navBar
						
						VStack(spacing: 50) {
							VStack(spacing: 4) {
								Text("ADDRESS")
									.styled(.bodyBold)
									.fillLeading()
									.foregroundStyle(Color.systemGray)
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
							
							PropertyDetailList(property: property, showAll: true)
						}
						.padding(.horizontal, Constants.Spacing.regular)
						.padding(.bottom, 50)
						.padding(.top, 25)
					}
				}
				.ignoresSafeArea(.container)
				
				// MARK: SHARE BUTTON
				
				shareButton
			}
			.toolbar(.hidden, for: .navigationBar)
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
	
	var navBar: some View {
		ZStack {
			let property = propertyStore.getSelectedProperty(.owned)!
			let coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
			let center =  CLLocationCoordinate2D(latitude: property.location.geo.latitude - 250 / 111111, longitude: property.location.geo.longitude)
			Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
				Marker("", coordinate: coordinate)
			}
			.disabled(true)
			
			VStack(spacing: 0) {
				HStack {
					Button(action: {
						dismiss()
					}, label: {
						VStack {
							Image(systemName: "arrow.left")
								.resizable()
								.scaledToFit()
								.frame(width: 20, height: 20)
								.foregroundStyle(.white)
						}
						.padding(10)
						.darkWindow()
						.cornerRadius(5)
					})
					
					Spacer()
					
					Menu(content: {
						Button(action: {
							edit = true
							notificationStore.pushNotification(message: "Editing coming soon!")
						}, label: {
							Label("Edit", systemImage: "pencil")
						})
						
						Button(role: .destructive, action: {
							confirmDelete = true
						}, label: {
							Label("Delete", systemImage: "trash")
						})
					}, label: {
						VStack {
							Image(systemName: "ellipsis")
								.resizable()
								.scaledToFit()
								.frame(width: 20, height: 20)
								.foregroundStyle(.white)
						}
						.padding(10)
						.darkWindow()
						.cornerRadius(5)
					})
				}
				.zIndex(4)
				.padding(.top, safeAreaInsets.top + 10)
				
				Spacer()
				
				Button(action: {
					withAnimation {
						copied = true
					}
					UIPasteboard.general.string = property.id
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
						withAnimation {
							copied = false
						}
					}
				}, label: {
					VStack(spacing: 0) {
						Text(property.info.nickname)
							.styled(.title, weight: .bold)
							.foregroundStyle(.white)
						HStack {
							Text(!copied ? property.id : "Copied")
								.styled(.caption)
								.foregroundStyle(Color.systemGray5)
							Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
								.resizable()
								.scaledToFit()
								.frame(height: 15)
						}
					}
					.padding(Constants.Spacing.medium)
					.darkWindow()
					.cornerRadius(5)
					.padding(.bottom, 20)
				})
				
				HStack(spacing: 16) {
					Button(action: {
						propertyStore.showOwnedExistingBookingsSheet.toggle()
					}, label: {
						HStack(spacing: 0) {
							VStack {
								Image(systemName: "suitcase.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 40)
								Text("Bookings")
									.font(.headline).fontWeight(.medium)
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.foregroundStyle(Color.white)
							.darkWindow()
							
							VStack(spacing: 0) {
								ForEach(BookingStatus.allCases, id: \.self) { status in
									Text(String(property.bookings.current().filter {$0.status == status}.count))
										.styled(.caption, weight: .semibold)
										.frame(maxHeight: .infinity)
										.frame(width: 20)
										.background(status.color)
										.foregroundStyle(Color.black)
								}
							}
						}
						.cornerRadius(5)
					})
					
					Button(action: {
						propertyStore.showOwnedAvailabilitySheet.toggle()
					}, label: {
						HStack(spacing: 0) {
							VStack {
								Image(systemName: "calendar.badge.plus")
									.resizable()
									.scaledToFit()
									.frame(width: 40)
								Text("Availability")
									.font(.headline).fontWeight(.medium)
								
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.foregroundStyle(Color.white)
							.darkWindow()
							
							VStack(spacing: 0) {
								Text(String(property.available.current().daysTotal()))
									.styled(.caption, weight: .semibold)
									.frame(maxHeight: .infinity)
									.frame(width: 20)
									.background(Color.systemGreen)
									.foregroundStyle(Color.black)
								Text(String(property.unavailable.current().daysTotal()))
									.styled(.caption, weight: .semibold)
									.frame(maxHeight: .infinity)
									.frame(width: 20)
									.background(Color.systemRed)
									.foregroundStyle(Color.black)
							}
						}
						.cornerRadius(5)
					})
				}
				.frame(height: 150)
				.padding(.vertical, 20)
				.padding(.horizontal, 20)
			}
			.padding(Constants.Spacing.large)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.foregroundStyle(Color.white)
			.background(Color.black.opacity(0.4))
		}
		.frame(height: 550)
		.background(Color.white)
	}
	
	var shareButton: some View {
		VStack {
			Divider()
			let property = propertyStore.getSelectedProperty(.owned)!
			if let url = url {
				ShareLink(item: url, subject: Text("Book my place on FriendBNB!"), message: Text(property.shareMessage)) {
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
					.shimmering(gradient: Gradient(colors: [
						Color.systemBlue, // translucent
						Color.systemBlue.opacity(0.3), // opaque
						Color.systemBlue // translucent
					]))
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
		.padding(.horizontal, Constants.Spacing.regular)
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

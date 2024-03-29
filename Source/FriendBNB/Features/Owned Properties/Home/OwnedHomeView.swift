//
//  OwnedHomeView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-02.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct OwnedHomeView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var notificationStore: NotificationStore
	@State private var navPath = NavigationPath()
	
	var body: some View {
		NavigationStack {
			Group {
				if propertyStore.loading {
					LoadingView()
				} else if !propertyStore.ownedProperties.isEmpty {
					ZStack {
						Button(action: {
							propertyStore.showNewPropertySheet = true
						}, label: {
							Image(systemName: "plus.circle.fill")
								.resizable()
								.scaledToFit()
								.frame(height: 35)
								.background(.white)
								.clipShape(Circle())
								.padding(.trailing, Constants.Spacing.regular)
						})
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
						.zIndex(5)
						
						ScrollView(showsIndicators: false) {
							VStack {
								ForEach(propertyStore.ownedProperties) { property in
									PropertyTileView(property: property, type: .owned) { booking in
										propertyStore.ownedSelectedBooking = PropertyBookingGroup(property: property, booking: booking)
									}
								}
							}
							.padding(.vertical, 50)
						}
						.refreshable {
							await propertyStore.fetchProperties(.owned)
						}
					}
				} else {
					OwnedPropertiesEmptyView()
				}
			}
			.navigationDestination(item: $propertyStore.ownedSelectedProperty) { _ in
				OwnedDetailView()
					.navigationBarTitleDisplayMode(.inline)
			}
			.sheet(item: $propertyStore.ownedSelectedBooking) { group in
				OwnedBookingConfirmationView(property: group.property, booking: group.booking, showDismiss: true) { message in
					notificationStore.pushNotification(message: message)
				}
			}
		}
	}
}

//struct HomeView_Previews: PreviewProvider {
//	static var previews: some View {
//		OwnedHomeView()
//	}
//}

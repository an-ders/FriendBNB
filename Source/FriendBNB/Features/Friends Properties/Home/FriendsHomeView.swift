//
//  FriendsPropertiesView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FriendsHomeView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	@State var deleteBooking = false
	
	var body: some View {
		NavigationStack {
			Group {
				if propertyStore.loading {
					LoadingView()
				} else if !propertyStore.friendsProperties.isEmpty {
					ZStack {
						Button(action: {
							propertyStore.showAddPropertySheet = true
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
								Rectangle()
									.frame(height: 45)
									.foregroundStyle(Color.clear)
								
								ForEach(propertyStore.friendsProperties) { property in
									PropertyTileView(property: property, type: .friend) { booking in
										propertyStore.showBooking(booking: booking, property: property, type: .friend)
									}
								}
								
								Rectangle()
									.frame(height: 45)
									.foregroundStyle(Color.clear)
							}
							.padding(.top, 2)
						}
						.refreshable {
							await propertyStore.fetchProperties(.friend)
						}
					}
				} else {
					FriendHomeEmptyView()
				}
			}
			.navigationDestination(item: $propertyStore.friendSelectedProperty) { _ in
				FriendDetailView()
					.navigationBarTitleDisplayMode(.inline)
			}
			.sheet(item: $propertyStore.friendSelectedBooking) { group in
				BookingConfirmationView(property: group.property, booking: group.booking) {
					PairButtonsView(prevText: "Delete", prevAction: {
						deleteBooking.toggle()
					}, nextText: "Done", nextCaption: "", nextAction: {
						propertyStore.dismissBooking()
					})
					.padding(.horizontal, Constants.Spacing.regular)
				}
				.alert(isPresented: $deleteBooking) {
					Alert(title: Text("Are you sure you want to delete this booking?"),
						  primaryButton: .destructive(Text("Delete")) {
						Task {
							await bookingStore.deleteBooking(group.booking, propertyId: group.property.id)
							propertyStore.dismissBooking()
							await propertyStore.fetchProperties(.friend)
						}
					},
						  secondaryButton: .default(Text("Cancel")))
				}
			}
		}
	}
}

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
	
	var body: some View {
		NavigationStack {
			Group {
				if propertyStore.loading {
					EmptyView()
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
								.padding(.trailing, Constants.Padding.regular)
						})
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
						.zIndex(5)
						
						ScrollView {
							VStack {
								Rectangle()
									.frame(height: 45)
									.foregroundStyle(Color.clear)
								
								ForEach(propertyStore.friendsProperties) { property in
									Button(action: {
										propertyStore.showFriendProperty(property)
									}, label: {
										PropertyTileView(property: property)
									})
								}
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
			.navigationDestination(item: $propertyStore.selectedFriendProperty) { _ in
				FriendDetailView()
					.navigationBarTitleDisplayMode(.inline)
			}
		}
	}
}

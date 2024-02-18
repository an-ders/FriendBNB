//
//  HomeView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-02.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct OwnedPropertiesView: View {
	@EnvironmentObject var propertyStore: PropertyStore
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
								.padding(.trailing, Constants.Padding.regular)
						})
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
						.zIndex(5)
						
						ScrollView {
							VStack {
								Rectangle()
									.frame(height: 45)
									.foregroundStyle(Color.clear)
								
								ForEach(propertyStore.ownedProperties) { property in
									Button(action: {
										propertyStore.showOwnedProperty(property)
									}, label: {
										PropertyTileView(property: property)
									})
								}
							}
						}
						.refreshable {
							await propertyStore.fetchProperties(.owned)
						}
					}
//					.onChange(of: propertyStore.showOwnedProperty) { _ in
//						Task {
//							await propertyStore.fetchProperties(.owned)
//						}
//					}
				} else {
					OwnedPropertiesEmptyView()
				}
			}
			.navigationDestination(item: $propertyStore.selectedOwnedProperty) { _ in
				OwnedDetailView()
					.navigationBarTitleDisplayMode(.inline)
			}
		}
	}
}

extension OwnedPropertiesView {
	@MainActor
	class ViewModel: ObservableObject {
		
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		OwnedPropertiesView()
	}
}

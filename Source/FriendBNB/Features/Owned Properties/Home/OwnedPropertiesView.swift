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
	@State var test = false
	
	var body: some View {
		NavigationStack {
			Group {
				if propertyStore.loading {
					
				} else if !propertyStore.ownedProperties.isEmpty {
					VStack {
						ScrollView {
							VStack {
								ForEach(propertyStore.ownedProperties) { property in
									PropertyTileView(property: property) {
										propertyStore.showProperty(property)
									}
								}
							}
							.padding(.top, 2)
						}
						.refreshable {
							await propertyStore.fetchProperties(.owned)
						}
					}
					.onChange(of: propertyStore.showOwnedProperty) { _ in
						Task {
							await propertyStore.fetchProperties(.owned)
						}
					}
				} else {
					OwnedPropertiesEmptyView()
				}
			}
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button(action: {
						propertyStore.showNewPropertySheet = true
					}, label: {
						Image(systemName: "plus.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(height: 30)
							.padding(.trailing, 10)
					})
				}
			}
			.navigationDestination(isPresented: $propertyStore.showOwnedProperty) {
				OwnedDetailView()
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

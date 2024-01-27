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
	
	var body: some View {
		NavigationView {
			Group {
				if propertyStore.loading {
					
				} else if !propertyStore.ownedProperties.isEmpty {
					ScrollView {
						VStack {
							ForEach(propertyStore.ownedProperties) { property in
								PropertyTileView(property: property) {
									OwnedDetailView(property: property)
								}
							}
						}
						.padding(.top, 2)
					}
					.refreshable {
						await propertyStore.fetchProperties(.owned)
					}
				} else {
					OwnedPropertiesEmptyView()
				}
			}
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					HomeMenu()
				}
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

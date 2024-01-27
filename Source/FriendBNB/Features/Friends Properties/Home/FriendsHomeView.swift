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
        NavigationView {
            Group {
                if !propertyStore.friendsProperties.isEmpty {
                    ScrollView {
                        VStack {
                            ForEach(propertyStore.friendsProperties) { property in
                                PropertyTileView(property: property) {
                                    FriendDetailView(property: property)
                                }
                            }
                        }
                        .padding(.top, 2)
                    }
                    .refreshable {
						await propertyStore.fetchProperties(.friend)
                    }
                } else {
                    FriendHomeEmptyView()
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

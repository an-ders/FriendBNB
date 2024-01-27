//
//  RootView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-01.
//

import SwiftUI
import FirebaseAuth

enum RootTabs: String, Hashable, Equatable {
    case owned
    case friends
    case settings
}

struct RootView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var authStore: AuthenticationStore
	
    @State var loggedIn = false
    @State var showNewPropertySheet = false
    @State var showAddPropertySheet = false
	@State var selectedTab: RootTabs = .owned
    
    var body: some View {
        NotificationView {
            if loggedIn {
                TabView(selection: $selectedTab) {
                    OwnedPropertiesView()
                        .tag(RootTabs.owned)
                        .tabItem {
                            Label("Owned", systemImage: "house")
                        }
                    
                    FriendsHomeView()
                        .tag(RootTabs.friends)
                        .tabItem {
                            Label("Friends", systemImage: "person.fill")
                        }
                    
                    SettingsView()
                        .tag(RootTabs.settings)
                        .tabItem {
                            Label("You", systemImage: "person.circle")
                        }
                }
                
                .background {
                    Color.Home.grey
                        .ignoresSafeArea()
                }
            } else {
                LoginView()
            }
        }
        .sync($propertyStore.showNewPropertySheet, with: $showNewPropertySheet)
        .sheet(isPresented: $showNewPropertySheet) {
            NewPropertyView()
                .interactiveDismissDisabled()
        }
        
        .sync($propertyStore.showAddPropertySheet, with: $showAddPropertySheet)
        .sheet(isPresented: $showAddPropertySheet) {
            AddPropertyView()
                .interactiveDismissDisabled()
        }
        
        .sync($authStore.loggedIn, with: $loggedIn)
        .onChange(of: authStore.loggedIn) { _ in
            Task {
                await propertyStore.fetchProperties(.owned)
                await propertyStore.fetchProperties(.friend)
            }
        }
    }
}

extension RootView {
    class ViewModel: ObservableObject {
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

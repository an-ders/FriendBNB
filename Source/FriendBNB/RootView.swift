//
//  RootView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-01.
//

import SwiftUI
import FirebaseAuth

enum RootTabs: String, Hashable, Equatable, CaseIterable {
	case owned
	case friends
	case settings
	
	var image: String {
		switch self {
		case .owned:
			return "house"
		case .friends:
			return "person.2.fill"
		case .settings:
			return "gear"
		}
	}
	
	var name: String {
		switch self {
		case .owned:
			return "My Homes"
		case .friends:
			return "Friends Homes"
		case .settings:
			return "Settings"
		}
	}
}

struct RootView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var authStore: AuthenticationStore
	@Environment(\.dismiss) private var dismiss
	
	@State var loggedIn = false
	@State var showNewPropertySheet = false
	@State var showAddPropertySheet = false
	@State var selectedTab: RootTabs = .owned
	
	var body: some View {
		NotificationView {
			if authStore.loggedIn {
				VStack(spacing: 0) {
					TabView(selection: $propertyStore.selectedTab) {
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
					.tabViewStyle(.page)
					.toolbar(.hidden, for: .tabBar)
					
					if propertyStore.showTabBar {
						HStack {
							ForEach(RootTabs.allCases, id: \.self) { tab in
								Button(action: {
									propertyStore.selectedTab = tab
								}, label: {
									VStack {
										Image(systemName: tab.image)
											.resizable()
											.scaledToFit()
											.frame(height: 20)
										Text(tab.name)
											.caption()
									}
									.frame(maxWidth: .infinity)
									.contentShape(Rectangle())
									.foregroundStyle(propertyStore.selectedTab == tab ? Color.systemBlue : Color.systemGray2)
								})
							}
						}
						.padding(.top, Constants.Padding.small)
					}
				}
			} else {
				LoginView()
			}
		}
		.sheet(isPresented: $propertyStore.showNewPropertySheet) {
			NewPropertyView()
				.interactiveDismissDisabled()
		}
		.sheet(isPresented: $propertyStore.showAddPropertySheet) {
			AddPropertyView()
				.interactiveDismissDisabled()
		}
		.onChange(of: authStore.loggedIn) { _ in
			Task {
				await propertyStore.fetchProperties(.owned)
				await propertyStore.fetchProperties(.friend)
			}
		}
		.onOpenURL { url in
			let string = url.absoluteString.replacingOccurrences(of: "friendbnb://", with: "")
			print(string)
			let components = string.components(separatedBy: "?")
			
			for component in components {
				if component.contains("id=") {
					let idRequest = component.replacingOccurrences(of: "id=", with: "")
					Task { @MainActor in
						if let id = await propertyStore.checkValidId(idRequest) {
							await propertyStore.addProperty(id, type: .friend)
							propertyStore.showAddPropertySheet = false
							dismiss()
							if let property = await propertyStore.getProperty(id: id) {
								propertyStore.showFriendProperty(property, delay: true)
							} else {
								//ERROR
							}
						} else {
							//self.error = "No property with that ID was found."
						}
					}
				}
			}
		}
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView()
	}
}

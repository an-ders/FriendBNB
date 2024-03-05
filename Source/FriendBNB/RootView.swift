//
//  RootView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-01.
//

import SwiftUI
import FirebaseAuth
import FirebaseDynamicLinks
import FirebaseMessaging

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
	@EnvironmentObject var notificationStore: NotificationStore
	@Environment(\.dismiss) private var dismiss
	
	@State var loggedIn = false
	@State var onboarded = UserDefaults.standard.bool(forKey: "Onboarded")
	@State var showNewPropertySheet = false
	@State var showAddPropertySheet = false
	@State var selectedTab: RootTabs = .owned
	
	var body: some View {
		NotificationView(notification: $notificationStore.notification) {
			if onboarded {
				if authStore.loggedIn {
					VStack(spacing: 0) {
						switch propertyStore.selectedTab {
						case .owned:
							OwnedHomeView()
						case .friends:
							FriendsHomeView()
						case .settings:
							SettingsView()
						}
						
						if propertyStore.showTabBar {
							VStack(spacing: Constants.Spacing.small) {
								Divider()
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
													.overlay(
														NotificationCountView(
															value: propertyStore.numberPending
														)
														.opacity(tab == .owned && propertyStore.numberPending != 0 ? 1 : 0)
														.offset(y: 2)
													)
												Text(tab.name)
													.styled(.caption)
											}
											.frame(maxWidth: .infinity)
											.contentShape(Rectangle())
											.foregroundStyle(propertyStore.selectedTab == tab ? Color.systemBlue : Color.systemGray2)
										})
									}
								}
							}
						}
					}
					.onAppear {
						if let propertyID = propertyStore.addPropertyID {
							Task { @MainActor in
								if let id = await propertyStore.checkValidId(propertyID) {
									await propertyStore.addPropertyToUser(id, type: .friend)
									await propertyStore.fetchProperties(.friend)
									if let property = await propertyStore.getProperty(id: id) {
										await propertyStore.fetchProperties(.friend)
										propertyStore.showProperty(property, type: .friend)
									} else {
										//ERROR
									}
								} else {
									//self.error = "No property with that ID was found."
								}
								propertyStore.addPropertyID = nil
							}
						}
					}
				} else {
					LoginView()
				}
			} else {
				OnboardingView(onboarded: $onboarded)
			}
		}
		.sheet(isPresented: $propertyStore.showNewPropertySheet) {
			NewPropertyView()
		}
		.sheet(isPresented: $propertyStore.showAddPropertySheet) {
			AddPropertyView()
		}
		.sheet(item: $propertyStore.selectedAddToCalendar) { group in
			EventEditViewController(group: group) {
				propertyStore.selectedAddToCalendar = nil
			}
		}
		.onChange(of: authStore.loggedIn) { _ in
			Task {
				await propertyStore.fetchProperties(.owned)
				await propertyStore.fetchProperties(.friend)
			}
		}
		.onOpenURL { url in
			print("Incomming url: \(url.absoluteString)")
			propertyStore.loading = true
			
			let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
				guard error == nil else {
					print("Error with dynamic link: \(error?.localizedDescription)")
					propertyStore.loading = false
					return
				}
				
				handleDynamicLink(dynamicLink)
			}
			
			if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
				handleDynamicLink(dynamicLink)
			} else {
				propertyStore.loading = false
			}
		}
	}
	
	func handleDynamicLink(_ dynamicLink: DynamicLink?) {
		if let dynamicLink = dynamicLink {
			if let url = dynamicLink.url {
				print("Actual deeplink from dynamic link is: \(url)")
				print("Match Type: \(dynamicLink.matchType)")
				
				let string = url.absoluteString.replacingOccurrences(of: "https://friendbnb.com/", with: "")
				print(string)
				let components = string.components(separatedBy: "?")
				
				for component in components {
					if component.contains("friendID=") {
						let idRequest = component.replacingOccurrences(of: "friendID=", with: "")
						Task { @MainActor in
							if let id = await propertyStore.checkValidId(idRequest) {
								await propertyStore.addPropertyToUser(id, type: .friend)
								dismiss()
								if let property = await propertyStore.getProperty(id: id) {
									propertyStore.showProperty(property, type: .friend)
								} else {
									propertyStore.addPropertyID = idRequest
								}
							} else {
								propertyStore.addPropertyID = idRequest
							}
						}
					} else if component.contains("ownedID=") {
						let idRequest = component.replacingOccurrences(of: "ownedID=", with: "")
						Task { @MainActor in
							if let id = await propertyStore.checkValidId(idRequest) {
								if let property = await propertyStore.getProperty(id: id) {
									if property.ownerId == authStore.user?.uid {
										await propertyStore.addPropertyToUser(id, type: .owned)
										propertyStore.showProperty(property, type: .owned)
									}
								}
							}
						}
					} else if component.contains("booking=") {
						let idRequest = component.replacingOccurrences(of: "booking=", with: "")
						let ids = idRequest.components(separatedBy: "-")
						let propertyId = ids[1]
						let bookingId = ids[0]
						Task { @MainActor in
							if let id = await propertyStore.checkValidId(propertyId) {
								if let property = await propertyStore.getProperty(id: id) {
									if property.ownerId == authStore.user?.uid {
										await propertyStore.addPropertyToUser(id, type: .owned)
										propertyStore.showProperty(property, type: .owned)
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

//struct RootView_Previews: PreviewProvider {
//	static var previews: some View {
//		RootView()
//	}
//}

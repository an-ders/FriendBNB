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
	
	@State var onboarded = UserDefaults.standard.bool(forKey: "Onboarded")
	@State var selectedTab: RootTabs = .owned
	
	var body: some View {
		NotificationView(notification: $notificationStore.notification) {
			if onboarded {
				if propertyStore.loading {
					LoadingView()
				} else if authStore.isLoggedIn, authStore.isAuthenticated {
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
					.blur(radius: !UserDefaults.standard.bool(forKey: "Biometrics Onboared") ? 5 : 0)
					.overlay {
						if !UserDefaults.standard.bool(forKey: "Biometrics Onboared") {
							BiometricsOnboarding()
								.ignoresSafeArea()
						}
					}
					.onAppear {
						if let propertyID = propertyStore.addPropertyID {
							Task { @MainActor in
								if let id = await propertyStore.checkValidId(propertyID) {
									await propertyStore.addPropertyToUser(id, type: .friend)
									if let property = await propertyStore.getProperty(id: id) {
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
						.onDisappear {
							Task {
								await propertyStore.fetchProperties(.owned)
								await propertyStore.fetchProperties(.friend)
							}
						}
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
		.onOpenURL { url in
			print("Incomming url: \(url.absoluteString)")
			
			if !(authStore.isLoggedIn && authStore.isAuthenticated), authStore.isSignInLink(url) {
				Task {
					if let error = await authStore.linkAuthenticate(url: url) {
						print("CANT LOG IN")
						authStore.error = "Link sign in unsuccessfull. Please try again"
						return
					}
				}
			}
			
			if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
				handleLink(dynamicLink.url)
			}
			
			if url.absoluteString.contains("FriendBNB://") {
				handleLink(url)
			}
			
			let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
				guard error == nil else {
					print("Error with dynamic link: \(error?.localizedDescription)")
					return
				}
				
				handleLink(dynamicLink?.url)
			}
		}
	}
	
	@MainActor
	func handleLink(_ url: URL?) {
		if let url = url {
			print("Actual deeplink from dynamic link is: \(url)")
			// print("Match Type: \(dynamicLink.matchType)")
			
			var string = url.absoluteString.replacingOccurrences(of: "https://friendbnb.com/", with: "")
			string = url.absoluteString.replacingOccurrences(of: "FriendBNB://", with: "")
			print(string)
			let components = string.components(separatedBy: "?")
			for component in components {
				if component.contains("friendID=") {
					let idRequest = component.replacingOccurrences(of: "friendID=", with: "")
					Task { @MainActor in
						propertyStore.loading = true
						if let id = await propertyStore.checkValidId(idRequest) {
							await propertyStore.addPropertyToUser(id, type: .friend)
							dismiss()
							if let property = await propertyStore.getProperty(id: id) {
								propertyStore.loading = false
								propertyStore.selectedTab = .friends
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
									propertyStore.showProperty(property, type: .friend)
								}
							} else {
								propertyStore.addPropertyID = idRequest
							}
						} else {
							propertyStore.addPropertyID = idRequest
						}
						propertyStore.loading = false
					}
				} else if component.contains("ownedID=") {
					let idRequest = component.replacingOccurrences(of: "ownedID=", with: "")
					Task { @MainActor in
						propertyStore.loading = true
						if let id = await propertyStore.checkValidId(idRequest) {
							if let property = await propertyStore.getProperty(id: id) {
								if property.ownerId == authStore.user?.uid {
									await propertyStore.addPropertyToUser(id, type: .owned)
									propertyStore.loading = false
									propertyStore.selectedTab = .owned
									DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
										propertyStore.showProperty(property, type: .owned)
									}
								}
							}
						}
						propertyStore.loading = false
					}
				} else if component.contains("ownedBooking=") {
					let idRequest = component.replacingOccurrences(of: "ownedBooking=", with: "")
					let ids = idRequest.components(separatedBy: "/")
					let propertyId = ids[0]
					let bookingId = ids[1]
					Task { @MainActor in
						propertyStore.loading = true
						if let id = await propertyStore.checkValidId(propertyId), let property = await propertyStore.getProperty(id: id), property.ownerId == authStore.user?.uid {
							if let booking = property.bookings.filter({$0.id == bookingId}).first {
								propertyStore.showBooking(booking: booking, property: property, type: .owned)
							}
							
						}
						propertyStore.loading = false
					}
				} else if component.contains("friendBooking=") {
					let idRequest = component.replacingOccurrences(of: "friendBooking=", with: "")
					let ids = idRequest.components(separatedBy: "/")
					let propertyId = ids[0]
					let bookingId = ids[1]
					Task {
						propertyStore.loading = true
						if let id = await propertyStore.checkValidId(propertyId), let property = await propertyStore.getProperty(id: id) {
							if let booking = property.bookings.filter({$0.id == bookingId}).first, booking.userId == authStore.user?.uid {
								propertyStore.showBooking(booking: booking, property: property, type: .friend)
							}
						}
						propertyStore.loading = false
					}
				}
			}
			propertyStore.loading = false
		}
	}
}

//struct RootView_Previews: PreviewProvider {
//	static var previews: some View {
//		RootView()
//	}
//}

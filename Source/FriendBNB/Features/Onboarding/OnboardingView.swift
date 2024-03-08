//
//  OnboardingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-02.
//

import SwiftUI
import MapKit

enum OnboardingTabs: Int {
	case userType
	case notifications
}
struct OnboardingView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	
	@State var currentTab: OnboardingTabs = .userType
	@Binding var onboarded: Bool
	
    var body: some View {
		ZStack {
			let coordinate = CLLocationCoordinate2D(latitude: 43.866273 - 700/111111, longitude: -79.228805)
			Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
			}
			.ignoresSafeArea(.keyboard, edges: .bottom)
			.overlay {
				Color.black.opacity(0.4)
					.ignoresSafeArea()
			}
			
			TabView(selection: $currentTab) {
				VStack {
					Text("What type of user are you?")
						.styled(.title, weight: .bold)
						.fillLeading()
						.foregroundStyle(Color.white)
						.padding(Constants.Spacing.large)
						.darkWindow()
						.padding(.bottom, 10)
					VStack(spacing: 16) {
						Button(action: {
							propertyStore.selectedTab = .owned
							withAnimation {
								currentTab = .notifications
							}
						}, label: {
							OnboardingTileView(image: "house.fill", title: "Property Owner", description: "Looking to lend out your place.")
						})
						
						Button(action: {
							propertyStore.selectedTab = .friends
							withAnimation {
								currentTab = .notifications
							}
						}, label: {
							OnboardingTileView(image: "person.2.fill", title: "Friend", description: "Looking to borrow a place!")
						})
					}
					.padding(Constants.Spacing.large)
				}
				.tag(OnboardingTabs.userType)
				
				VStack {
					Image(systemName: "bell.circle")
						.resizable()
						.scaledToFit()
						.frame(height: 40)
					Text("Notifications")
						.styled(.title)
						.padding(.bottom, 10)
						.shadow(radius: 10)
					Text("We want to notify you about your property bookings and any booking updates!")
						.styled(.body)
						.shadow(radius: 10)
						.padding(.bottom, 10)
					Button {
						Task {
							do {
								try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
								UserDefaults.standard.set(true, forKey: "Onboarded")
								withAnimation {
									onboarded = true
								}
							} catch {
								UserDefaults.standard.set(true, forKey: "Onboarded")
								withAnimation {
									onboarded = true
								}
							}
						}
					} label: {
						Text("Grant notification permission")
							.styled(.body)
							.shadow(radius: 3)
					}
					.padding(.vertical, 8)
					.padding(.horizontal, 12)
					.background(Color.black.opacity(0.4))
					.cornerRadius(10)
				}
				.foregroundStyle(Color.white)
				.padding(Constants.Spacing.large)
				.darkWindow()
				.cornerRadius(20)
				.shadow(radius: 10)
				.tag(OnboardingTabs.notifications)
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
		}
	}
}

struct OnboardingTileView: View {
	var image: String
	var title: String
	var description: String
	
	var body: some View {
		VStack {
			Image(systemName: image)
				.size(height: 30)
				.padding(.bottom, 12)
			VStack(spacing: 0) {
				Text(title)
					.styled(.title2)
				Text(description)
					.styled(.body)
			}
		}
		.foregroundStyle(Color.white)
		.frame(maxWidth: .infinity)
		.padding(.vertical, 30)
		.padding(.horizontal, 20)
		.darkWindow()
		.contentShape(Rectangle())
		.cornerRadius(20)
		.shadow(radius: 4)
	}
}

//#Preview {
//    OnboardingView()
//}

//
//  OnboardingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-02.
//

import SwiftUI

enum OnboardingTabs: Int {
	case userType
	case notifications
}
struct OnboardingView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	
	@State var currentTab: OnboardingTabs = .userType
	@Binding var onboarded: Bool
	
    var body: some View {
		TabView(selection: $currentTab) {
			VStack {
				Text("What type of user are you?")
					.styled(.title)
					.fillLeading()
				VStack {
					Button(action: {
						propertyStore.selectedTab = .owned
						withAnimation {
							currentTab = .notifications
						}
					}, label: {
						VStack {
							Image(systemName: "house.fill")
								.resizable()
								.scaledToFit()
								.frame(height: 30)
							Text("Property Owner")
								.styled(.headline)
								.padding(.bottom, 10)
								.foregroundStyle(Color.black)
							Text("Mostly looking to lend out your place.")
								.styled(.body)
								.foregroundStyle(Color.black)
						}
					})
					.frame(maxWidth: .infinity)
					.padding(.vertical, 30)
					.padding(.horizontal, 20)
					.background(.white)
					.contentShape(Rectangle())
					.cornerRadius(20)
					.shadow(radius: 4)
					
					Button(action: {
						propertyStore.selectedTab = .friends
						withAnimation {
							currentTab = .notifications
						}
					}, label: {
						VStack {
							Image(systemName: "person.2.fill")
								.resizable()
								.scaledToFit()
								.frame(height: 30)
							Text("Property Renter")
								.styled(.headline)
								.padding(.bottom, 10)
								.foregroundStyle(Color.black)
							Text("Mostly looking to lend out properties.")
								.styled(.body)
								.foregroundStyle(Color.black)
						}
						.frame(maxWidth: .infinity)
						.padding(.vertical, 30)
						.padding(.horizontal, 20)
						.background(.white)
						.contentShape(Rectangle())
						.cornerRadius(20)
						.shadow(radius: 4)
					})
				}
			}
			.padding(Constants.Spacing.large)
			.tag(OnboardingTabs.userType)
			
			VStack {
				Image(systemName: "bell.circle")
					.resizable()
					.scaledToFit()
					.frame(height: 40)
				Text("Notifications")
					.styled(.title)
					.padding(.bottom, 10)
				Text("We want to notify you about your property bookings and any booking updates!")
					.styled(.body)
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
				}
				.padding()
				.buttonStyle(.bordered)
			}
			.padding(Constants.Spacing.large)
			.tag(OnboardingTabs.notifications)
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
		.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
	}
}

//#Preview {
//    OnboardingView()
//}

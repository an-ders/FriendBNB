//
//  FriendBNBApp.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-09-05.
//

import SwiftUI
import FirebaseCore

@main
struct FriendBNBApp: App {
	@ObservedObject var propertyStore: PropertyStore
	@ObservedObject var authStore: AuthenticationStore
	@ObservedObject var notificationStore: NotificationStore
	@ObservedObject var bookingStore: BookingStore
	
	init() {
		FirebaseApp.configure()
		self.propertyStore = PropertyStore()
		self.authStore = AuthenticationStore()
		self.notificationStore = NotificationStore()
		self.bookingStore = BookingStore()
	}
	
	var body: some Scene {
		WindowGroup {
			RootView()
				.environmentObject(propertyStore)
				.environmentObject(authStore)
				.environmentObject(notificationStore)
				.environmentObject(bookingStore)
		}
	}
}

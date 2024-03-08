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
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	init() {
		FirebaseApp.configure()
	}
	
	var body: some Scene {
		WindowGroup {
			RootView()
				.environmentObject(appDelegate.propertyStore)
				.environmentObject(appDelegate.authStore)
				.environmentObject(appDelegate.notificationStore)
				.environmentObject(appDelegate.bookingStore)
				.environmentObject(appDelegate.permissionStore)
		}
	}
}

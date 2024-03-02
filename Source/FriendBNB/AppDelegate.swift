//
//  AppDelegate.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-27.
//

import Foundation
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
	let gcmMessageIDKey = "gcm.message_id"
	@ObservedObject var propertyStore: PropertyStore = PropertyStore()
	@ObservedObject var authStore: AuthenticationStore = AuthenticationStore()
	@ObservedObject var notificationStore: NotificationStore = NotificationStore()
	@ObservedObject var bookingStore: BookingStore = BookingStore()
	@ObservedObject var permissionStore: PermissionStore = PermissionStore()
	
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		// Config push notification
		application.registerForRemoteNotifications()
		Messaging.messaging().delegate = self
		UNUserNotificationCenter.current().delegate = self
		
		return true
	}
}

//extension AppDelegate : UNUserNotificationCenterDelegate {
//	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//		Messaging.messaging().apnsToken = deviceToken
//	}
//}

extension AppDelegate: UNUserNotificationCenterDelegate {
	// Receive displayed notifications for iOS 10 devices.
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification) async
	-> UNNotificationPresentationOptions {
		let userInfo = notification.request.content.userInfo
		
		// With swizzling disabled you must let Messaging know about the message, for Analytics
		// Messaging.messaging().appDidReceiveMessage(userInfo)
		
		// ...
		
		// Print full message.
		print("HERE")
		
		print(userInfo)
		
		// Change this to your preferred presentation option
		return [[.alert, .sound]]
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse) async {
		let userInfo = response.notification.request.content.userInfo
		
		// ...
		
		// With swizzling disabled you must let Messaging know about the message, for Analytics
		// Messaging.messaging().appDidReceiveMessage(userInfo)
		
		// Print full message.
		propertyStore.readNotification(userInfo)
		print("HERE1")
		print(userInfo)
	}
}

extension AppDelegate: MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		
		if let fcm = Messaging.messaging().fcmToken {
			print("fcm", fcm)
		}
	}
}

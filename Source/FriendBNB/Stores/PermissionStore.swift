//
//  PermissionStore.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-27.
//

import Foundation
import UserNotifications
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging

@MainActor final
class PermissionStore: ObservableObject {
	@Published private(set) var hasPermission = false
		
	init() {
		Task {
			await getAuthStatus()
			await writeFCMtoFS()
		}
	}
	
	func getAuthStatus() async {
		let status = await UNUserNotificationCenter.current().notificationSettings()
		switch status.authorizationStatus {
		case .authorized, .ephemeral, .provisional:
			hasPermission = true
		default:
			hasPermission = false
		}
	}
	
	func writeFCMtoFS() async {
		let db = Firestore.firestore()
		guard let userId = Auth.auth().currentUser?.uid else {
			return
		}
		guard let fcm = Messaging.messaging().fcmToken else {
			print("NO FCM")
			return
		}
		do {
			let document = try await db.collection("Accounts").document(userId).getDocument()
			
			guard let data = document.data() else {
				return
			}
			
			var fcms: [String] = data["devices"] as? [String] ?? [String]()
			if !fcms.contains(fcm) {
				fcms.append(fcm)
				try await db.collection("Accounts").document(userId).updateData(["devices": fcms])
			}
		} catch {
			
		}
	}
}

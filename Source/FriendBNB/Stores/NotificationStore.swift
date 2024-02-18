//
//  NotificationStore.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-25.
//

import Foundation
import SwiftUI

struct Notification {
	var message: String
	var backgroundColor: Color
	var dismissable: Bool
}

class NotificationStore: ObservableObject {
	@Published var notification: Notification?
	
	func pushNotification(message: String, backgroundColor: Color = .gray, dismissable: Bool = true) {
		withAnimation {
			self.notification = nil
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			withAnimation {
				self.notification = Notification(message: message, backgroundColor: backgroundColor, dismissable: dismissable)
			}
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
			self.dismissNotification()
		}
	}
	
	func dismissNotification() {
		withAnimation {
			self.notification = nil
		}
	}
}

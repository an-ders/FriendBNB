//
//  NotificationStore.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-25.
//

import Foundation
import SwiftUI

struct CustomNotification {
	var message: String
	var dismissable: Bool
}

class NotificationStore: ObservableObject {
	@Published var notification: CustomNotification?
	
	func pushNotification(message: String, dismissable: Bool = true) {
		withAnimation {
			self.notification = nil
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			withAnimation {
				self.notification = CustomNotification(message: message, dismissable: dismissable)
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

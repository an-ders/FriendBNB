//
//  NotificationView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-25.
//

import SwiftUI

struct NotificationView<Content: View>: View {
	@ViewBuilder let content: Content
	@EnvironmentObject var notificationStore: NotificationStore
	
	var body: some View {
		ZStack(alignment: .top) {
			content
			
			if let notification = notificationStore.notification {
				HStack(alignment: .center) {
					Text(notification.message)
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundStyle(Color.white)
						.padding(.leading, Constants.Padding.regular)
						.padding(.vertical, Constants.Padding.regular)
					
					if notification.dismissable {
						Button(action: {
							notificationStore.dismissNotification()
						}, label: {
							Image(systemName: "x.circle")
								.resizable()
								.scaledToFit()
								.frame(width: 20)
								.foregroundStyle(Color.systemRed)
						})
						.padding(.trailing, Constants.Padding.regular)
					}
				}
				.zIndex(5)
				.background {
					RoundedRectangle(cornerRadius: 5)
						.fill(notification.backgroundColor)
						
				}
				.transition(.asymmetric(
					insertion: .move(edge: .leading),
					removal: .move(edge: .trailing)
				))
				.padding(.horizontal, Constants.Padding.regular)
			}
		}
	}
}
	
#Preview {
	NotificationView {
		Color.white
	}
}

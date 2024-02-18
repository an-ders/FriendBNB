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
				HStack(alignment: .top) {
					Text(notification.message)
						.caption()
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundStyle(Color.black)
						.padding(.leading, Constants.Padding.regular)
						.padding(.vertical, Constants.Padding.regular)
					
					if notification.dismissable {
						Button(action: {
							notificationStore.dismissNotification()
						}, label: {
							Image(systemName: "x.circle")
								.resizable()
								.scaledToFit()
								.frame(width: 16)
								.foregroundStyle(Color.black)
						})
						.padding(.horizontal, Constants.Padding.regular)
						.padding(.vertical, Constants.Padding.regular)
						.contentShape(Rectangle())
					}
				}
				.background(Rectangle().fill(Color(red: 1, green: 0.8, blue: 0)))
				.zIndex(5)
				.transition(.asymmetric(
					insertion: .move(edge: .leading),
					removal: .move(edge: .trailing)
				))
			}
		}
	}
}
	
#Preview {
	NotificationView {
		Color.white
	}
}

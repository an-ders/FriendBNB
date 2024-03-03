//
//  NotificationView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-25.
//

import SwiftUI

struct NotificationView<Content: View>: View {
	@Binding var notification: CustomNotification?
	@ViewBuilder let content: Content
	
	var body: some View {
		ZStack(alignment: .top) {
			content
			
			if let notification = notification {
				HStack(alignment: .top) {
					Text(notification.message)
						.styled(.caption)
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundStyle(Color.black)
						.padding(.leading, Constants.Spacing.regular)
						.padding(.vertical, Constants.Spacing.regular)
					
					if notification.dismissable {
						Button(action: {
							withAnimation {
								self.notification = nil
							}
						}, label: {
							Image(systemName: "x.circle")
								.resizable()
								.scaledToFit()
								.frame(width: 16)
								.foregroundStyle(Color.black)
						})
						.padding(.horizontal, Constants.Spacing.regular)
						.padding(.vertical, Constants.Spacing.regular)
						.contentShape(Rectangle())
					}
				}
				.background(Rectangle().fill(Color(red: 1, green: 0.8, blue: 0)))
				.zIndex(5)
				.transition(.asymmetric(
					insertion: .move(edge: .leading),
					removal: .move(edge: .trailing)
				))
				.onTapGesture {
					withAnimation {
						self.notification = nil
					}
				}
			}
		}
	}
}
	
//#Preview {
//	NotificationView {
//		Color.white
//	}
//}

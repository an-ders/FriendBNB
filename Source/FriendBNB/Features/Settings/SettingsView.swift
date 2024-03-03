//
//  SettingsView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var authStore: AuthenticationStore
	@EnvironmentObject var notificationStore: NotificationStore
	@EnvironmentObject var permissionStore: PermissionStore
    
    var body: some View {
        VStack {
			Spacer()
			if let user = authStore.user {
				HStack {
					Image(systemName: "person.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 25)
					Text("\(user.displayName ?? "MISSING DISPLAY NAME")")
						.styled(.body)
				}
				HStack {
					Image(systemName: "envelope.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 25)
					Text(user.email ?? "NO EMAIL")
						.styled(.body)
				}
				Text(user.uid)
					.styled(.body)
			}
			Spacer()
			
            Button(action: {
				Task {
					await authStore.signOut()
				}
			}, label: {
				Text("Sign Out")
					.styled(.body)
					.padding()
					.background(Color.systemGray3)
					.cornerRadius(5)
			})
//            Text("Clear properties")
//                .onTapGesture {
//                    Task {
//                        await propertyStore.resetProperty(.friend)
//                        await propertyStore.resetProperty(.owned)
//                    }
//                }
			
//			Text("Test Notification")
//				.styled(.body)
//				.onTapGesture {
//					notificationStore.pushNotification(message: "test123")
//				}
			
			

			Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

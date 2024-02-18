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
						.body()
				}
				HStack {
					Image(systemName: "envelope.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 25)
					Text(user.email ?? "NO EMAIL")
						.body()
				}
				Text(user.uid)
					.body()
			}
			Spacer()
			
            Text("Sign Out")
				.body()
                .onTapGesture {
					Task {
						await authStore.signOut()
					}
                }
			
//            Text("Clear properties")
//                .onTapGesture {
//                    Task {
//                        await propertyStore.resetProperty(.friend)
//                        await propertyStore.resetProperty(.owned)
//                    }
//                }
			
			Text("Test Notification")
				.body()
				.onTapGesture {
					notificationStore.pushNotification(message: "test123")
				}
			
			Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

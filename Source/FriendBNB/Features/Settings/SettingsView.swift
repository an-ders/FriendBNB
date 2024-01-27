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
				Text(user.email ?? "")
			}
			Spacer()
			
            Text("Sign Out")
                .onTapGesture {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("Error while signing out!")
                    }
                }
            Text("Clear properties")
                .onTapGesture {
                    Task {
                        await propertyStore.resetProperty(.friend)
                        await propertyStore.resetProperty(.owned)
                    }
                }
			
			Text("notif")
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

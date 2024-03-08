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
		VStack(spacing: 0) {
			VStack {
				Text("SETTINGS")
					.styled(.title2)
					.fillLeading()
				Divider()
			}
			
			ScrollView(showsIndicators: false) {
				VStack(spacing: 50) {
					if let user = authStore.user {
						VStack(alignment: .leading) {
							Text("NAME")
								.styled(.bodyBold)
								.fillLeading()
								.foregroundStyle(Color.systemGray)
							
							HStack {
								Image(systemName: "person.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 25)
								Text("\(user.displayName ?? "MISSING DISPLAY NAME")")
									.styled(.body)
							}
						}
						VStack(alignment: .leading) {
							Text("EMAIL")
								.styled(.bodyBold)
								.fillLeading()
								.foregroundStyle(Color.systemGray)
							
							HStack {
								Image(systemName: "envelope.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 25)
								Text(user.email ?? "NO EMAIL")
									.styled(.body)
							}
						}
						
						VStack(alignment: .leading) {
							Text("USER ID")
								.styled(.bodyBold)
								.fillLeading()
								.foregroundStyle(Color.systemGray)
							
							HStack {
								Image(systemName: "envelope.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 25)
								Text(user.uid)
									.styled(.body)
							}
						}
					}
					
					VStack(alignment: .leading) {
						Text("BIOMETRIC UNLOCK")
							.styled(.bodyBold)
							.fillLeading()
							.foregroundStyle(Color.systemGray)
						
						HStack(spacing: Constants.Spacing.large) {
							Button(action: {
								UserDefaults.standard.set(false, forKey: "Biometrics")
								notificationStore.pushNotification(message: "Biometrics disabled!")
							}, label: {
								Text("Disable")
									.styled(.bodyBold)
									.foregroundStyle(Color.white)
									.padding(.horizontal, Constants.Spacing.medium)
									.padding(.vertical, Constants.Spacing.small)
									.darkWindow()
									.cornerRadius(10)
							})
							.disabled(!UserDefaults.standard.bool(forKey: "Biometrics"))
							.overlay {
								Color.white.opacity(!UserDefaults.standard.bool(forKey: "Biometrics") ? 0.6 : 0)
							}
							Button(action: {
								Task {
									if await authStore.bioAuthenticate() {
										UserDefaults.standard.set(true, forKey: "Biometrics")
										notificationStore.pushNotification(message: "Biometrics enabled!")
									} else {
										notificationStore.pushNotification(message: "Error enabling biometrics")
									}
								}
							}, label: {
								Text("Enable")
									.styled(.bodyBold)
									.foregroundStyle(Color.white)
									.padding(.horizontal, Constants.Spacing.medium)
									.padding(.vertical, Constants.Spacing.small)
									.darkWindow()
									.cornerRadius(10)
							})
							.disabled(UserDefaults.standard.bool(forKey: "Biometrics"))
							.overlay {
								Color.white.opacity(UserDefaults.standard.bool(forKey: "Biometrics") ? 0.6 : 0)
							}
							Spacer()
						}
					}
					
					Divider()
					
					Button(action: {
						Task {
							await authStore.signOut()
						}
					}, label: {
						Text("SIGN OUT")
							.styled(.bodyBold)
							.foregroundStyle(Color.white)
							.padding(.horizontal, Constants.Spacing.medium)
							.padding(.vertical, Constants.Spacing.small)
							.darkWindow()
							.cornerRadius(10)
					})
				}
				.padding(.top, 25)
			}
		}
		.padding(Constants.Spacing.large)
		
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

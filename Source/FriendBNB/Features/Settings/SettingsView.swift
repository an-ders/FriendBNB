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
				DetailTitle(title: "SETTINGS")
				Divider()
			}
			
			ScrollView(showsIndicators: false) {
				VStack(spacing: 50) {
					if let user = authStore.user {
						DetailParagraph(title: "NAME", image: "person.fill", description: "\(user.displayName ?? "MISSING DISPLAY NAME")")
						
						DetailParagraph(title: "EMAIL", image: "envelope.fill", description: user.email ?? "NO EMAIL")
						
						DetailParagraph(title: "USER ID", image: "person.circle.fill", description: user.uid)
					}
					
					VStack(alignment: .leading) {
						DetailHeading(title: "BIOMETRIC UNLOCK")
						
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

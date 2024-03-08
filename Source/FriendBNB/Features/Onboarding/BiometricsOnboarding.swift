//
//  BiometricsOnboarding.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-07.
//

import SwiftUI

struct BiometricsOnboarding: View {
	@EnvironmentObject var authStore: AuthenticationStore
	
    var body: some View {
		VStack {
			VStack {
				Text("Biometric Unlock")
					.styled(.title2)
					.foregroundStyle(Color.white)
				Text("Would you like to enable biometric unlock for FriendBNB?")
					.styled(.body)
					.multilineTextAlignment(.center)
					.foregroundStyle(Color.white)
				
				Button(action: {
					Task {
						if await authStore.bioAuthenticate() {
							UserDefaults.standard.set(true, forKey: "Biometrics")
						}
						UserDefaults.standard.set(true, forKey: "Biometrics Onboared")
					}
				}, label: {
					Text("Use FaceID")
						.styled(.title2)
						.padding(.vertical, Constants.Spacing.medium)
						.padding(.horizontal, Constants.Spacing.large)
						.background(Color.black.opacity(0.4))
						.cornerRadius(5)
						.foregroundStyle(Color.white)
				})
				
				Button(action: {
					UserDefaults.standard.set(false, forKey: "Biometrics")
					UserDefaults.standard.set(true, forKey: "Biometrics Onboared")
				}, label: {
					Text("Later")
						.styled(.bodyBold)
						.foregroundStyle(Color.white)
				})
			}
			.padding(Constants.Spacing.large)
			.darkWindow()
			.cornerRadius(10)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.ignoresSafeArea()
		.background(Color.black.opacity(0.4))
    }
}

//#Preview {
//    BiometricsOnboarding()
//}

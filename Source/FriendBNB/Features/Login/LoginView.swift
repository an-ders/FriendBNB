//
//  ContentView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-09-05.
//

import SwiftUI
import FirebaseAuth
import MapKit

enum LoginTabs: String {
	case login
	case email
}

struct LoginView: View {
	@EnvironmentObject var authStore: AuthenticationStore
	@EnvironmentObject var notificationStore: NotificationStore
	
	@State var currentTab: LoginTabs = .login
	@State var name = ""
	@State var email = ""
	@State var password = ""
	@State var passwordConfirm = ""
	@State var showPasswordResetSheet = false
	@State var error: String = ""
	@State var hidden: Bool = false
	@State var isSignup = !UserDefaults.standard.bool(forKey: "Onboarded")
	@State var showEmailAuth = false
	
	var body: some View {
		ZStack {
			let coordinate = CLLocationCoordinate2D(latitude: 43.866273 - 700/111111, longitude: -79.228805)
			Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
			}
			.ignoresSafeArea(.keyboard, edges: .bottom)
			.overlay {
				Color.black.opacity(hidden ? 0 : 0.4)
					.ignoresSafeArea()
			}
			//.frame(height: UIScreen.screenHeight + 50)
			
			if authStore.loading {
				LoadingView()
			} else if !authStore.isLoggedIn {
				VStack {
					Spacer()
					Button(action: {
						withAnimation {
							hidden.toggle()
						}
					}, label: {
						VStack(spacing: 0) {
							Text("FriendBNB")
								.font(.system(size: 36, weight: .bold))
							if hidden {
								Text("Where it all started")
									.styled(.caption)
									.foregroundStyle(Color.white)
							}
						}
						.padding(Constants.Spacing.medium)
						.darkWindow()
						.foregroundStyle(Color.white)
						.cornerRadius(5)
					})
					Spacer()
					if !hidden {
						VStack {
							if isSignup {
								StyledFloatingTextField(text: $name, prompt: "Name")
									.foregroundStyle(Color.black)
									.disableAutocorrection(true)
									.textContentType(.name)
							}
							
							StyledFloatingTextField(text: $email, prompt: "Email")
								.foregroundStyle(Color.black)
								.keyboardType(.twitter)
								.disableAutocorrection(true)
								.textContentType(.oneTimeCode)
							
							SecureStyledFloatingTextField(text: $password, prompt: "Password")
								.foregroundStyle(Color.black)
								.textContentType(isSignup ? .newPassword : .password)
							
							if !isSignup {
								Button(action: {
									showPasswordResetSheet = true
								}, label: {
									Text("Forgot password?")
										.underline()
										.font(.caption).fontWeight(.light)
										.frame(maxWidth: .infinity, alignment: .leading)
								})
								.padding(.top, Constants.Spacing.xsmall)
							}
							
							if isSignup {
								SecureStyledFloatingTextField(text: $passwordConfirm, prompt: "Confirm Password")
									.foregroundStyle(Color.black)
									.textContentType(.newPassword)
							}
							
							ErrorView(error: error)
							
							Button(action: {
								sendEmail()
							}, label: {
								Text(isSignup ? "Sign Up" : "Log In")
									.styled(.title2)
									.padding(.vertical, Constants.Spacing.medium)
									.padding(.horizontal, Constants.Spacing.large)
									.darkWindow()
									.cornerRadius(5)
							})
							.padding(.vertical, 30)
							
							Button(action: {
								withAnimation {
									isSignup.toggle()
									error = ""
								}
							}, label: {
								Text(isSignup ? "Already have an account? Log In" : "Dont have an account? Sign Up")
									.styled(.body)
									.underline()
							})
						}
						.padding(Constants.Spacing.medium)
						.darkWindow()
						.foregroundStyle(Color.white)
						.cornerRadius(10)
						Spacer()
					}
				}
				.padding(25)
				.sheet(isPresented: $showPasswordResetSheet) {
					ResetPasswordView(showSheet: $showPasswordResetSheet)
				}
				.contentShape(Rectangle())
				.onTapGesture {
					hideKeyboard()
				} // end of login view
			} else if !authStore.isAuthenticated {
				VStack {
					Button(action: {
						Task {
							await authStore.signOut()
						}
					}, label: {
						Image(systemName: "arrow.left")
							.size(height: 25)
							.padding(Constants.Spacing.medium)
							.darkWindow()
							.cornerRadius(5)
							.foregroundStyle(.white)
					})
					.padding(.leading, Constants.Spacing.large)
					.frame(maxWidth: .infinity, alignment: .leading)
					
					Spacer()
					
					if showEmailAuth {
						VStack {
							Text("Email Authentication")
								.styled(.title2)
								.foregroundStyle(Color.white)
							Text("Please open the link in the email we just sent you on this device.")
								.styled(.body)
								.multilineTextAlignment(.center)
								.foregroundStyle(Color.white)
							
							ErrorView(error: authStore.error)
							
							Button(action: {
								self.error = ""
								Task {
									if let error = await authStore.sendAuthenticationLink() {
										self.error = error
									} else {
										notificationStore.pushNotification(message: "Email successfully sent", dismissable: true)
									}
								}
							}, label: {
								Text("Resend Email")
									.styled(.bodyBold)
									.foregroundStyle(Color.white)
									.padding(Constants.Spacing.medium)
									.darkWindow()
									.cornerRadius(5)
							})
						}
						.padding(Constants.Spacing.large)
						.darkWindow()
						.cornerRadius(10)
						.padding(Constants.Spacing.large)
					}
					
					Spacer()
				}
				.onAppear {
					showEmailAuth = !(authStore.isEmailVerified && authStore.isBiometricsEnabled)
					Task {
						if authStore.isEmailVerified && authStore.isBiometricsEnabled {
							if await authStore.bioAuthenticate() {
								self.authStore.isAuthenticated = true
							} else {
								showEmailAuth = true
								if let error = await authStore.sendAuthenticationLink() {
									self.error = error
									return
								}
							}
						} else {
							if let error = await authStore.sendAuthenticationLink() {
								self.error = error
								return
							}
						}
					}
				} // end of authentication view
			}
		} // end of z stack map background
		.onChange(of: authStore.error) { error in
			self.error = error
		}
	}
	
	func sendEmail() {
		Task {
			if isSignup {
				if let error = await authStore.register(name: name, username: email, password: password, passwordConfirm: passwordConfirm) {
					self.error = error
					return
				}
				
			} else {
				if let error = await authStore.login(username: email, password: password) {
					self.error = error
					return
				}
			}
			
			self.error = ""
			self.password = ""
			self.passwordConfirm = ""
			self.email = ""
		}
	}
	
	func cta() {
	}
}

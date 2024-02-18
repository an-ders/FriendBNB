//
//  ContentView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-09-05.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
	@EnvironmentObject var authStore: AuthenticationStore
	@State var name = ""
	@State var email = ""
	@State var password = ""
	
	@State var isSignup = true
	@State var passwordConfirm = ""
	
	@State var showPasswordResetSheet = false
	
	@State var error: String = ""
	
	var body: some View {
		VStack {
			Spacer()
			Text("FriendBNB")
				.font(.system(size: 36, weight: .bold))
			Spacer()
			
			if isSignup {
				StyledFloatingTextField(text: $name, prompt: "Name")
			}
			
			StyledFloatingTextField(text: $email, prompt: "Email")
			
			SecureStyledFloatingTextField(text: $password, prompt: "Password")
			
			if !isSignup {
				Button(action: {
					showPasswordResetSheet = true
				}, label: {
					Text("Forgot password?")
						.font(.caption).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
				})
				.padding(.top, Constants.Spacing.xsmall)
			}
			
			if isSignup {
				SecureStyledFloatingTextField(text: $passwordConfirm, prompt: "Confirm Password")
			}
			
			ErrorView(error: $error)
			
			Spacer()
			
			Button(action: {
				cta()
			}, label: {
				Text(isSignup ? "Sign Up" : "Log In")
					.font(.title3).fontWeight(.bold)
			})
			
			Button(action: {
				withAnimation {
					isSignup.toggle()
					error = ""
				}
			}, label: {
				Text(isSignup ? "Already have an account? Log In" : "Dont have an account? Sign Up")
					.body()
					.underline()
			})
			.padding(.top, Constants.Spacing.large)
			Spacer()
		}
		.padding(25)
		.preferredColorScheme(.light)
		.sheet(isPresented: $showPasswordResetSheet) {
			ResetPasswordView(showSheet: $showPasswordResetSheet)
		}
		.contentShape(Rectangle())
		.onTapGesture {
			hideKeyboard()
		}
	}
	
	func cta() {
		Task {
			if isSignup {
				guard let error = await authStore.register(name: name, username: email, password: password, passwordConfirm: passwordConfirm) else {
					self.error = ""
					return
				}
				self.error = error
			} else {
				guard let error = await authStore.login(username: email, password: password) else {
					self.error = ""
					return
				}
				self.error = error
			}
		}
	}
	
}

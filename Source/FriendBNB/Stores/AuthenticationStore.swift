//
//  LoginManager.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-19.
//

import Foundation
import FirebaseAuth
import SwiftUI
import LocalAuthentication

@MainActor
class AuthenticationStore: ObservableObject {
	@Published var loading = false
    @Published var isLoggedIn = false
	@Published var isAuthenticated = false
	@Published var error = ""
	
	var isBiometricsEnabled = UserDefaults.standard.bool(forKey: "Biometrics")
	//var isBiometricsEnabled = true
	
	var user: User? {
		return Auth.auth().currentUser
    }
	
	var isEmailVerified: Bool {
		if let emailVerified = user?.isEmailVerified {
			return emailVerified
		}
		return false
	}
    
    init() {
		isLoggedIn = Auth.auth().currentUser != nil
    }
    
	func login(username: String, password: String) async -> String? {
		self.loading = true
        print("Attempting a login")
        do {
            try await Auth.auth().signIn(withEmail: username,
                                         password: password)
			withAnimation {
				isLoggedIn = true
			}
            print("Sucessfully logged in")
			self.loading = false
			return nil
        } catch {
            print("Error logging in: \(error.localizedDescription)")
			self.loading = false
			return error.localizedDescription
        }
	}
	
	func signOut() async -> String? {
		do {
			try Auth.auth().signOut()
			isLoggedIn = false
			isAuthenticated = false
			self.loading = false
			return nil

		} catch {
			print("Error while signing out!")
			self.loading = false
			return "Error while signing out!"
		}
	}
    
	func register(name: String, username: String, password: String, passwordConfirm: String) async -> String? {
        print("Attempting a register")
        
        guard !username.isEmpty else {
            return "Please enter a valid email"
        }
        
        guard !password.isEmpty else {
            return "Please enter a password"
        }
        
        guard password == passwordConfirm else {
            return "Passwords must match"
        }
        
        do {
			self.loading = true
            try await Auth.auth().createUser(withEmail: username,
                                             password: password)
			withAnimation {
				isLoggedIn = true
			}
            print("Successfully registered")
			
			guard let error = await updateUser(displayName: name) else {
				self.loading = false
				return nil
			}
			self.loading = false
			return error
        } catch {
            print(error.localizedDescription)
			self.loading = false
			return error.localizedDescription
        }
	}
	
	func sendAuthenticationLink() async -> String? {
		if let user = self.user, let email = user.email {
			let actionCodeSettings = ActionCodeSettings()
			actionCodeSettings.url = URL(string: String(format: "https://www.friendbnb.com/?email=%@", email))
			actionCodeSettings.handleCodeInApp = true
			actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
			
			do {
				try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
				return nil
			} catch {
				print("EMAIL AUTH ERROR: \(error.localizedDescription)")
				return"EMAIL AUTH ERROR: \(error.localizedDescription)"
			}
		} else {
			return "NO USER FOUND"
		}
	}
	
	func isSignInLink(_ url: URL) -> Bool {
		return Auth.auth().isSignIn(withEmailLink: url.absoluteString)
	}
	
	func linkAuthenticate(url: URL) async -> String? {
		let url = url.absoluteString
		do {
			if Auth.auth().isSignIn(withEmailLink: url), let user = self.user, let email = user.email {
				try await Auth.auth().signIn(withEmail: email, link: url)
				print("Sucessfully logged in with link")
				isAuthenticated = true
				return nil
			}
			return "LINK NOT AUTH DEEPLINK"
		} catch {
			print("EMAIL LOGIN LINK ERROR: \(error.localizedDescription)")
			return "EMAIL LOGIN LINK ERROR: \(error.localizedDescription)"
		}
	}
	
	func bioAuthenticate() async -> Bool {
		let context = LAContext()
		var error: NSError?

		// check whether biometric authentication is possible
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			// it's possible, so go ahead and use it
			let reason = "We need to unlock your data."

			do {
				let result = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
				return result
			} catch {
				return false
			}
		} else {
			return false
		}
	}
	
	func bioAuthUser() {
		Task {
			self.isAuthenticated = await bioAuthenticate()
		}
	}
	
	func updateUser(displayName: String = "") async -> String? {
		guard let user = Auth.auth().currentUser else {
			return "Not currently logged in"
		}
		
		let changeRequest = user.createProfileChangeRequest()
		changeRequest.displayName = displayName
		
		do {
			try await changeRequest.commitChanges()
		} catch {
			return error.localizedDescription
		}
		return nil
	}
    
    func sendVerificationEmail() async {
        print("Attempting sending a verification email")
        if self.user != nil && !self.user!.isEmailVerified {
            do {
                try await self.user!.sendEmailVerification()
            } catch {
                print("Error sending email verification: \(error.localizedDescription)")
            }
        }
    }
    
	func resetPassword(email: String) async -> String? {
        print("Attempting sending a password reset email")
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("Sucessfully sent reset email")
			return nil
        } catch {
			print("Error sending email \(error.localizedDescription)")
            return error.localizedDescription
        }
    }
}

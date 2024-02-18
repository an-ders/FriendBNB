//
//  LoginManager.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-19.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthenticationStore: ObservableObject {
    @Published var loggedIn = false
	
	var user: User? {
		return Auth.auth().currentUser
    }
    
    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.loggedIn = user != nil
        }
    }
    
	func login(username: String, password: String) async -> String? {
        print("Attempting a login")
        do {
            try await Auth.auth().signIn(withEmail: username,
                                         password: password)
            print("Sucessfully logged in")
			return nil
        } catch {
            print("Error logging in: \(error.localizedDescription)")
			return error.localizedDescription
        }
	}
	
	func signOut() async -> String? {
		do {
			try Auth.auth().signOut()
		} catch {
			print("Error while signing out!")
			return "Error while signing out!"
		}
		return nil
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
            try await Auth.auth().createUser(withEmail: username,
                                             password: password)
            print("Successfully registered")
			
			guard let error = await updateUser(displayName: name) else {
				return nil
			}
			return error
        } catch {
            print(error.localizedDescription)
			return error.localizedDescription
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

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
    
	func register(username: String, password: String, passwordConfirm: String) async -> String? {
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
			return nil
        } catch {
            print(error.localizedDescription)
			return error.localizedDescription
        }
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

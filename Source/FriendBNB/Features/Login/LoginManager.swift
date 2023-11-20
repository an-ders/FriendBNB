//
//  LoginManager.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-19.
//

import Foundation
import FirebaseAuth

@MainActor
class LoginManager: ObservableObject {
    @Published var loggedIn = false
    
    @Published var newUser = false
    @Published var username = ""
    @Published var usernameError = ""
    
    @Published var hidePassword = true
    @Published var password = ""
    @Published var passwordError = ""
    
    @Published var hideConfirmPassword = true
    @Published var confirmPassword = ""
    @Published var confirmPasswordError = ""
    
    @Published var showResetPassword = false
    @Published var resetPasswordEmail = ""
    @Published var resetPasswordEmailError = ""
    
    private var authUser: User? {
        return Auth.auth().currentUser
    }
    
    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.loggedIn = user != nil
        }
    }
    
    func resetAll() {
        self.newUser = false
        self.username = ""
        self.usernameError = ""
        
        self.hidePassword = true
        self.password = ""
        self.passwordError = ""
        
        self.hideConfirmPassword = true
        self.confirmPassword = ""
        self.confirmPasswordError = ""
        
        self.showResetPassword = false
        self.resetPasswordEmail = ""
        self.resetPasswordEmailError = ""
    }
    
    func resetErrors() {
        self.usernameError = ""
        self.passwordError = ""
        self.confirmPasswordError = ""
        self.resetPasswordEmailError = ""
    }
    
    func login() async {
        print("Attempting a login")
        do {
            try await Auth.auth().signIn(withEmail: self.username,
                                         password: self.password)
            print("Sucessfully logged in")
            self.resetAll()
        } catch {
            self.passwordError = error.localizedDescription
            print("Error logging in: \(error.localizedDescription)")
        }
    }
    
    func register() async {
        print("Attempting a register")
        
        self.resetErrors()
        guard !username.isEmpty else {
            usernameError = "Please enter a valid email"
            return
        }
        
        guard !password.isEmpty else {
            passwordError = "Please enter a password"
            return
        }
        
        guard password == confirmPassword else {
            confirmPasswordError = "Passwords must match"
            return
        }
        
        do {
            try await Auth.auth().createUser(withEmail: self.username,
                                             password: self.password)
            self.resetAll()
            print("Successfully registered")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendVerificationEmail() async {
        print("Attempting sending a verification email")
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            do {
                try await self.authUser!.sendEmailVerification()
            } catch {
                print("Error sending email verification: \(error.localizedDescription)")
            }
        }
    }
    
    func resetPassword() async {
        print("Attempting sending a password reset email")
        self.resetPasswordEmailError = ""
        do {
            try await Auth.auth().sendPasswordReset(withEmail: resetPasswordEmail)
            print("Sucessfully sent reset email")
            self.showResetPassword = false
            self.resetPasswordEmail = ""
        } catch {
            self.resetPasswordEmailError = error.localizedDescription
            print("Error sending email \(error.localizedDescription)")
        }
    }
}

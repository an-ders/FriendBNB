//
//  ContentView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-09-05.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var loginManager: LoginManager
    @State var showResetPassword = false
    var body: some View {
        VStack {
            Spacer()
            Text("Login.Title".localized)
                .font(.system(size: 36, weight: .bold))
            Spacer()

            StyledFloatingTextField(text: $loginManager.username, prompt: "Login.UsernameField.Title".localized, error: $loginManager.usernameError)
            
            SecureStyledFloatingTextField(text: $loginManager.password, prompt: "Login.PasswordField.Title".localized, error: $loginManager.passwordError)
                
            if !loginManager.newUser {
                Button(action: {
                    loginManager.showResetPassword = true
                }, label: {
                    Text("Forgot password?")
                        .font(.caption).fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                .padding(.top, Constants.Spacing.xsmall)
            }
            
            if loginManager.newUser {
                    SecureStyledFloatingTextField(text: $loginManager.confirmPassword, prompt: "Login.PasswordConfirmField.Title".localized, error: $loginManager.confirmPasswordError)
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    if loginManager.newUser {
                        await loginManager.register()
                    } else {
                        await loginManager.login()
                    }
                }
            }, label: {
                Text(loginManager.newUser ? "Login.SignupButton.Title".localized : "Login.LoginButton.Title".localized)
                    .font(.title3).fontWeight(.bold)
            })
            
            Button(action: {
                withAnimation {
                    loginManager.newUser.toggle()
                }
            }, label: {
                Text(loginManager.newUser ? "Login.SignupButton.Description".localized : "Login.LoginButton.Description".localized)
                    .font(.headline).fontWeight(.light)
            })
            .padding(.top, Constants.Spacing.large)
            Spacer()
        }
        .padding(25)
        
        .sheet(isPresented: $showResetPassword) {
            ResetPasswordView()
        }
        .sync($loginManager.showResetPassword, with: $showResetPassword)
    }
    
}

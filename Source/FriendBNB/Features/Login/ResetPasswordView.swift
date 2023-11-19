//
//  ResetPasswordView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-19.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        VStack {
            Text("Reset your password")
                .font(.largeTitle).fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Constants.Spacing.small)
            Text("Enter email below:")
                .font(.title3).fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
            //.padding(.bottom, Constants.Spacing.small)
            
            StyledFloatingTextField(text: $loginManager.resetPasswordEmail, prompt: "Email", error: $loginManager.resetPasswordEmailError)
            
            Spacer()
            
            PairButtonsView(prevText: "Close", prevAction: {
                loginManager.showResetPassword = false
                loginManager.resetPasswordEmail = ""
            }, nextText: "Send Email", nextAction: {
                Task {
                    await loginManager.resetPassword()
                }
            })
        }
        .padding(.top, Constants.Padding.regular)
        .padding(.horizontal, Constants.Padding.regular)
    }
}

#Preview {
    ResetPasswordView()
}

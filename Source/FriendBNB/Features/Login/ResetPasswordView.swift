//
//  ResetPasswordView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-19.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var authStore: AuthenticationStore
	@Binding var showSheet: Bool
	@State var resetEmail = ""
	@State var error = ""
	
    var body: some View {
		PairButtonWrapper(prevText: "Close", prevAction: {
			showSheet.toggle()
		}, nextText: "Send Email", nextAction: {
			resetPassword(resetEmail)
		}, content: {
			VStack {
				Text("Reset your password")
					.font(.largeTitle).fontWeight(.medium)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom, Constants.Spacing.small)
				Text("Enter email below:")
					.font(.title3).fontWeight(.light)
					.frame(maxWidth: .infinity, alignment: .leading)
				//.padding(.bottom, Constants.Spacing.small)
				
				StyledFloatingTextField(text: $resetEmail, prompt: "Email")
				
				ErrorView(error: $error)
				
				Spacer()
			}
		})
        .padding(.top, Constants.Padding.regular)
        .padding(.horizontal, Constants.Padding.regular)
    }
	
	func resetPassword(_ email: String) {
		Task {
			if let error = await authStore.resetPassword(email: email) {
				self.error = error
			} else {
				showSheet.toggle()
			}
		}
	}
}

#Preview {
	ResetPasswordView(showSheet: .constant(false))
}

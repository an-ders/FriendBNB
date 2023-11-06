//
//  ContentView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-09-05.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text("FriendBNB")
                .font(.system(size: 36, weight: .bold))
            Spacer()
            TextField("Login.UsernameField.Title".localized, text: $viewModel.username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Divider()
            SecureField("Login.PasswordField.Title".localized, text: $viewModel.password)
            Divider()
            Spacer()
            
            Button(action: {
                viewModel.login()
            }, label: {
                Text("Login.LoginButton.Title".localized)
                    .font(.system(size: 20, weight: .bold))
            })
            Spacer()
        }
        .padding(25)
    }
    
}

extension LoginView {
    class ViewModel: ObservableObject {
        @Published var username: String = ""
        @Published var password: String = ""
        @Published var error: String?
        
        func login() {
            Auth.auth().signIn(withEmail: self.username,
                               password: self.password) { (result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                } else {
                    print("success")
                }
            }
        }
    }
}

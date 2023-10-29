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
            Spacer()
            TextField("Login.UsernameField.Title".localized, text: $viewModel.username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Divider()
            SecureField("Password", text: $viewModel.password)
            Divider()
            Spacer()
            
            Button(action: {
                viewModel.login()
            }) {
                Text("Sign In")
            }
            Spacer()
        }
        .padding()
    }
    
    
}

extension LoginView {
    class ViewModel: ObservableObject {
        @Published var username = ""
        @Published var password = ""
        
        func login() {
            Auth.auth().signIn(withEmail: self.username, password: self.password) { (result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                } else {
                    print("success")
                }
            }
        }
    }
}

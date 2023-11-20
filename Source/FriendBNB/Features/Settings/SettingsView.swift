//
//  SettingsView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var yourPropertyManager: YourPropertyManager
    
    var body: some View {
        VStack {
            Text("Sign Out")
                .onTapGesture {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("Error while signing out!")
                    }
                }
            Text("Clear properties")
                .onTapGesture {
                    Task {
                        await yourPropertyManager.resetProperty()
                    }
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

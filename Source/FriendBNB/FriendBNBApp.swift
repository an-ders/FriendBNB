//
//  FriendBNBApp.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-09-05.
//

import SwiftUI
import FirebaseCore

@main
struct FriendBNBApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

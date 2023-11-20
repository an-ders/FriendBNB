//
//  RootView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-01.
//

import SwiftUI
import FirebaseAuth

enum RootTabs: String, Hashable, Equatable {
    case your
    case friend
    case settings
}

struct RootView: View {
    @ObservedObject var yourPropertyManager: YourPropertyManager = YourPropertyManager()
    @ObservedObject var loginManager: LoginManager = LoginManager()
    @State var loggedIn = false
    
    var body: some View {
        Group {
            if loggedIn {
                TabView(selection: $yourPropertyManager.selectedTab) {
                    YourPropertiesView()
                        .tag(RootTabs.your)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    
                    
                    SettingsView()
                        .tag(RootTabs.settings)
                        .tabItem {
                            Label("You", systemImage: "person.circle")
                        }
                }
                .environmentObject(yourPropertyManager)
                .background {
                    Color.Home.grey
                        .ignoresSafeArea()
                }
            } else {
                LoginView()
                    .environmentObject(loginManager)
                    .onAppear {
                        yourPropertyManager.selectedTab = .your
                    }
            }
        }
        .sync($loginManager.loggedIn, with: $loggedIn)
        .onChange(of: loginManager.loggedIn) { _ in
            Task {
                await yourPropertyManager.fetchProperties()
            }
        }
    }
}

extension RootView {
    class ViewModel: ObservableObject {
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

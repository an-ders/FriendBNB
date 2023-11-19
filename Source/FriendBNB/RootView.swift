//
//  RootView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-01.
//

import SwiftUI
import FirebaseAuth

enum RootTabs: String, Hashable, Equatable {
    case home
    case settings
}

struct RootView: View {
    @ObservedObject var homeManager: HomeManager = HomeManager()
    @ObservedObject var loginManager: LoginManager = LoginManager()
    @State var loggedIn = false
    
    var body: some View {
        Group {
            if loggedIn {
                TabView(selection: $homeManager.selectedTab) {
                    HomeView()
                        .tag(RootTabs.home)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    SettingsView()
                        .tag(RootTabs.settings)
                        .tabItem {
                            Label("You", systemImage: "person.circle")
                        }

                }
                .environmentObject(homeManager)
                .background {
                    Color.Home.grey
                        .ignoresSafeArea()
                }
            } else {
                LoginView()
                    .environmentObject(loginManager)
            }
        }
        .sync($loginManager.loggedIn, with: $loggedIn)
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

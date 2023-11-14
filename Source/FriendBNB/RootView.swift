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
    @StateObject var viewModel: ViewModel = ViewModel()
    @StateObject var homeManager: HomeManager = HomeManager()
    
    var body: some View {
        Group {
            if viewModel.loggedIn {
                TabView(selection: $viewModel.selectedTab) {
                    HomeView()
                        .environmentObject(homeManager)
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
                .background {
                    Color.Home.grey
                        .ignoresSafeArea()

                }
            } else {
                LoginView()
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                viewModel.loggedIn = user != nil
            }
        }
    }
}

extension RootView {
    class ViewModel: ObservableObject {
        @Published var loggedIn: Bool = false
        @Published var selectedTab: RootTabs = .home
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

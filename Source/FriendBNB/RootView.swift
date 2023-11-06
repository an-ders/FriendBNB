//
//  RootView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-01.
//

import SwiftUI
import FirebaseAuth

enum Tabs: String, Hashable, Equatable {
    case home
    case settings
}

struct RootView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        Group {
            if viewModel.loggedIn {
                TabView(selection: $viewModel.selectedTab) {
                    HomeView()
                        .tag(Tabs.home)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    SettingsView()
                        .tag(Tabs.settings)
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
        @Published var selectedTab: Tabs = .home
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

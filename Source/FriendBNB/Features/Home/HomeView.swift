//
//  HomeView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-02.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    @EnvironmentObject var homeManager: HomeManager
    
    var body: some View {
        NavigationView {
            Group {
                if !homeManager.properties.isEmpty || homeManager.loading {
                    ScrollView {
                        VStack {
                            ForEach(homeManager.properties) { property in
                                HomeTileView(property: property)
                            }
                        }
                        .padding(.top, 2)
                    }
                    .refreshable {
                        Task {
                            await homeManager.fetchProperties()
                        }
                    }
                    .if(homeManager.loading) { view in
                        view.blur(radius: 20)
                    }
                    .overlay {
                        if homeManager.loading {
                            Text("LOADING...")
                                .fontWeight(.bold)
                        }
                    }
                } else {
                    HomeEmptyView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HomeMenuButtonView()
                }
            }
        }
        .sheet(isPresented: $homeManager.showNewPropertySheet) {
            NewPropertyView()
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $homeManager.showAddPropertySheet) {
            AddPropertyView()
                .interactiveDismissDisabled()
        }
    }
}

extension HomeView {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var userID: String?
        @Published var error: Error?
        @Published var properties: [Property] = []
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

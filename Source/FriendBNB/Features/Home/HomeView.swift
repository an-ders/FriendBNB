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
    @EnvironmentObject var homeManager: HomeManager
    @State var showNewPropertySheet = false
    @State var showAddPropertySheet = false
    
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
                        .onAppear {
                            Task {
                                await homeManager.fetchProperties()
                            }
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HomeMenuButtonView()
                }
            }
        }
        
        .sync($homeManager.showNewPropertySheet, with: $showNewPropertySheet)
        .sheet(isPresented: $showNewPropertySheet) {
            NewPropertyView()
                .interactiveDismissDisabled()
        }
        
        .sync($homeManager.showAddPropertySheet, with: $showAddPropertySheet)
        .sheet(isPresented: $showAddPropertySheet) {
            AddPropertyView()
                .interactiveDismissDisabled()
        }
    }
}

extension HomeView {
    @MainActor
    class ViewModel: ObservableObject {
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

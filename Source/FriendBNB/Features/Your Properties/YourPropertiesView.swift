//
//  HomeView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-02.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct YourPropertiesView: View {
    @EnvironmentObject var yourPropertiesManager: YourPropertiesManager
    @State var showNewPropertySheet = false
    @State var showAddPropertySheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if !yourPropertiesManager.properties.isEmpty || yourPropertiesManager.loading {
                    ScrollView {
                        VStack {
                            ForEach(yourPropertiesManager.properties) { property in
                                PropertyTileView(property: property)
                            }
                        }
                        .padding(.top, 2)
                    }
                    .refreshable {
                        Task {
                            await yourPropertiesManager.fetchProperties()
                        }
                    }
                    .if(yourPropertiesManager.loading) { view in
                        view.blur(radius: 20)
                    }
                    .overlay {
                        if yourPropertiesManager.loading {
                            Text("LOADING...")
                                .fontWeight(.bold)
                        }
                    }
                } else {
                    YourPropertiesEmptyView()
                        
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    YourPropertiesMenuView()
                }
            }
        }
        
        .sync($yourPropertiesManager.showNewPropertySheet, with: $showNewPropertySheet)
        .sheet(isPresented: $showNewPropertySheet) {
            NewPropertyView()
                .interactiveDismissDisabled()
        }
        
        .sync($yourPropertiesManager.showAddPropertySheet, with: $showAddPropertySheet)
        .sheet(isPresented: $showAddPropertySheet) {
            AddPropertyView()
                .interactiveDismissDisabled()
        }
    }
}

extension YourPropertiesView {
    @MainActor
    class ViewModel: ObservableObject {
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        YourPropertiesView()
    }
}

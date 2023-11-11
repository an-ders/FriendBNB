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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.properties) { property in
                        HomeTileView(property: property)
                    }
                }
                .padding(.top, 2)
                .onAppear {
                    viewModel.fetchProperties()
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HomeActionButtonView(viewModel: viewModel)
                }
            }
        }
        .sheet(isPresented: $viewModel.newProperty) {
            NewPropertyView(sheetToggle: $viewModel.newProperty)
                .interactiveDismissDisabled()
        }
        
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var selectedTab: RootTabs = .home
        @Published var userID: String?
        @Published var error: Error?
        @Published var properties: [Property] = []
        
        @Published var newProperty = false
        
        init() {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    self.userID = user.uid
                } else {
                    self.userID = nil
                }
            }
            
            fetchProperties()
        }
        
        func fetchProperties() {
            let db = Firestore.firestore()
            let ref = db.collection("Properties")
            ref.getDocuments { snapshot, error in
                guard error == nil else {
                    print(error?.localizedDescription)
                    self.error = error
                    return
                }
                var properties: [Property] = []
                
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        
                        properties.append(Property(id: document.documentID, data: data))
                    }
                }
                
                self.properties = properties
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

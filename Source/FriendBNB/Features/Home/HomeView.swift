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
            Group {
                if viewModel.loading {
                    
                } else if !viewModel.properties.isEmpty {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.properties) { property in
                                HomeTileView(property: property)
                            }
                        }
                        .padding(.top, 2)
                    }
                } else {
                    emptyView
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HomeActionButtonView(viewModel: viewModel)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchProperties()
            }
        }
        .sheet(isPresented: $viewModel.showNewPropertySheet) {
            NewPropertyView(showSheet: $viewModel.showNewPropertySheet)
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $viewModel.showAddPropertySheet) {
            AddPropertyView(showSheet: $viewModel.showAddPropertySheet, properties: $viewModel.properties, loading: $viewModel.loading)
                .interactiveDismissDisabled()
        }
        
    }
    
    var emptyView: some View {
        VStack {
            Image(systemName: "house")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            Text("It's empty in here.")
                .font(.title).fontWeight(.medium)
            Text("Add an existing or create a new property")
                .font(.headline).fontWeight(.light)
                .padding(.bottom, 8)
            
            Button(action: {
                viewModel.showAddPropertySheet = true
            }, label: {
                Text("Add Existing Property")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(Color.systemGray3)
                    .cornerRadius(10)
            })
            
            Button(action: {
                viewModel.showNewPropertySheet = true
            }, label: {
                Text("New Property")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(Color.systemGray3)
                    .cornerRadius(10)
            })
            
        }
    }
}

extension HomeView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var selectedTab: RootTabs = .home
        @Published var userID: String?
        @Published var error: Error?
        @Published var properties: [Property] = []
        @Published var loading: Bool = true
        
        @Published var showNewPropertySheet = false
        @Published var showAddPropertySheet = false
        
        init() {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    self.userID = user.uid
                } else {
                    self.userID = nil
                }
            }
        }
        
        func fetchProperties() async {
            self.loading = true
            
            let db = Firestore.firestore()
            let ref = db.collection("Properties")
            
            var propertyIDs = UserDefaults.standard.object(forKey: "PropertyIDs") as? [String] ?? [String]()
            //propertyIDs = ["cPEMy165u45mDG1pO12k"]
            
            var newProperties: [Property] = []
            
            for propertyID in propertyIDs {
                do {
                    let snapshot = try await ref.whereField(FirebaseFirestore.FieldPath.documentID(), isEqualTo: propertyID).getDocuments()
                    
                    for document in snapshot.documents {
                        let data = document.data()
                        newProperties.append(Property(id: document.documentID, data: data))
                    }
                } catch {
                    self.error = error
                    return
                }
            }
            
            self.properties = newProperties
            self.loading = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

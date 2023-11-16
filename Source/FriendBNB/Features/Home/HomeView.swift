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
                if !viewModel.properties.isEmpty || homeManager.loading {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.properties) { property in
                                HomeTileView(property: property)
                            }
                        }
                        .padding(.top, 2)
                    }
                    .refreshable {
                        Task {
                            await viewModel.fetchProperties()
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
        init() {
            Task {
                await fetchProperties()
            }
        }
        
        func fetchProperties() async {
            let db = Firestore.firestore()
            let ref = db.collection("Properties")
            
            let propertyIds = UserDefaults.standard.object(forKey: "PropertyIDs") as? [String] ?? [String]()
            print("Fetching properties: \(propertyIds)")
            
            self.properties = []
            try? await Task.sleep(nanoseconds: 500000000)
            
            for propertyId in propertyIds {
                //let property = await Property(asyncId: propertyId)
                do {
                    let snapshot = try await ref.whereField(FirebaseFirestore.FieldPath.documentID(), isEqualTo: propertyId).getDocuments()
                    
                    for document in snapshot.documents {
                        let data = document.data()
                        print(data)
                        self.properties.append(Property(id: document.documentID, data: data))
                    }
                } catch {
                    return
                }
            }
            
            //self.properties = newProperties
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

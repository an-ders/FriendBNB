//
//  PropertyManager.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-13.
//

import Foundation
import FirebaseFirestore

@MainActor
class HomeManager: ObservableObject {
    @Published var selectedTab: RootTabs = .home
    @Published var properties: [Property] = []
    @Published var showNewPropertySheet = false
    @Published var showAddPropertySheet = false
    @Published var loading: Bool = true
    
    init() {
        Task {
            await fetchProperties()
        }
    }
    
    func fetchProperties() async {
        self.loading = true
        let db = Firestore.firestore()
        let ref = db.collection("Properties")
        
        let propertyIDs = UserDefaults.standard.object(forKey: "PropertyIDs") as? [String] ?? [String]()
        print("Fetching properties: \(propertyIDs)")

        
        var newProperties: [Property] = []
        var newPropertyIDs: [String] = []
        
        for propertyID in propertyIDs {
            do {
                try await Task.sleep(nanoseconds: 500000000)
                let snapshot = try await ref.whereField(FirebaseFirestore.FieldPath.documentID(), isEqualTo: propertyID).getDocuments()
                
                for document in snapshot.documents {
                    let data = document.data()
                    newProperties.append(Property(id: document.documentID, data: data))
                    newPropertyIDs.append(document.documentID)
                }
            } catch {
                //self.error = error
                return
            }
        }
        
        UserDefaults.standard.set(newPropertyIDs, forKey: "PropertyIDs")
        self.properties = newProperties
        self.loading = false
    }
    
    func addProperty(_ id: String) {
        var oldIDs = UserDefaults.standard.object(forKey: "PropertyIDs")  as? [String] ?? [String]()
        oldIDs.append(id)
        UserDefaults.standard.set(oldIDs, forKey: "PropertyIDs")
        
        showAddPropertySheet = false
        Task {
            await fetchProperties()
        }
    }
    
    func deleteProperty(id: String) async {
        let db = Firestore.firestore()
        do {
            try await db.collection("Properties").document(id).delete()
            print("Document successfully removed \(id)!")
        } catch {
            print("Error removing document: \(error)")
        }
    }
}

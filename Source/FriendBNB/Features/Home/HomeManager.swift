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
    @Published var selectedProperty: Property?
    @Published var showNewPropertySheet = false
    @Published var showAddPropertySheet = false
    @Published var loading: Bool = false
    
    init() {
//        Task {
//            await fetchProperties()
//        }
    }
    
    func fetchProperties() async {
        self.loading = true
        let db = Firestore.firestore()
        let ref = db.collection("Properties")
        
        let propertyIds = UserDefaults.standard.object(forKey: "PropertyIDs") as? [String] ?? [String]()
        print("Fetching properties: \(propertyIds)")

        var newProperties: [Property] = []
        try? await Task.sleep(nanoseconds: 500000000)

        for propertyId in propertyIds {
            //let property = await Property(asyncId: propertyId)
            do {
                let snapshot = try await ref.whereField(FirebaseFirestore.FieldPath.documentID(), isEqualTo: propertyId).getDocuments()
                
                for document in snapshot.documents {
                    let data = document.data()
                    newProperties.append(Property(id: document.documentID, data: data))
                }
            } catch {
                return
            }
        }
        
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
    
    func removeProperty(_ id: String) {
        let ids = UserDefaults.standard.object(forKey: "PropertyIDs")  as? [String] ?? [String]()
        let filteredIds = ids.filter({$0 != id})
        UserDefaults.standard.set(filteredIds, forKey: "PropertyIDs")
        
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
        removeProperty(id)
    }
}

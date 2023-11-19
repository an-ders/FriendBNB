//
//  PropertyManager.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-13.
//

import Foundation
import FirebaseAuth
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
        
        guard Auth.auth().currentUser != nil else {
            print("User not found")
            return
        }
        
        //let propertyIds = UserDefaults.standard.object(forKey: "PropertyIDs") as? [String] ?? [String]()
        var propertyIds = [String]()
        print("Attempting to fetch property Ids")
        do {
            let document = try await db.collection("Accounts").document(Auth.auth().currentUser!.uid).getDocument()
            let data = document.data() ?? [:]
            propertyIds = data["properties"] as? [String] ?? [String]()
            
            print("Successfully fetched Ids")
        } catch {
            print("Error getting Ids \(error.localizedDescription)")
        }
        
        print("Fetching properties: \(propertyIds)")
        var newProperties: [Property] = []
        //try? await Task.sleep(nanoseconds: 500000000)

        for propertyId in propertyIds {
            do {
                let snapshot = try await db.collection("Properties").whereField(FirebaseFirestore.FieldPath.documentID(), isEqualTo: propertyId).getDocuments()
                
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
    
    func addProperty(_ id: String) async {
//        var oldIDs = UserDefaults.standard.object(forKey: "PropertyIDs")  as? [String] ?? [String]()
//        oldIDs.append(id)
//        UserDefaults.standard.set(oldIDs, forKey: "PropertyIDs")
//        
        let db = Firestore.firestore()
        let ref = db.collection("Accounts")
        
        guard Auth.auth().currentUser != nil else {
            print("User not found")
            return
        }
        
        print("Attempting to add Id: \(id) to user \(Auth.auth().currentUser!.uid)")
        do {
            try await ref.document(Auth.auth().currentUser!.uid).updateData([
                "properties": FieldValue.arrayUnion([id])
            ])
            print("Successfully added Id")
        } catch {
            print("Error adding Id: \(error.localizedDescription)")
        }
        
        Task {
            await fetchProperties()
        }
    }
    
    func removeProperty(_ id: String) async {
        let db = Firestore.firestore()
        let ref = db.collection("Accounts")
        
        guard Auth.auth().currentUser != nil else {
            print("User not found")
            return
        }
        
        print("Attempting to remove Id \(id) from user \(Auth.auth().currentUser!.uid)")
        do {
            try await ref.document(Auth.auth().currentUser!.uid).updateData([
                "properties": FieldValue.arrayRemove([id])
            ])
            print("Successfully removed Id")
        } catch {
            print("Error removing Id: \(error.localizedDescription)")
        }
        
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
        await removeProperty(id)
    }
    
    func resetProperty() async {
        let db = Firestore.firestore()
        let ref = db.collection("Accounts")
        
        guard Auth.auth().currentUser != nil else {
            print("User not found")
            return
        }
        
        print("Attempting to reset \(Auth.auth().currentUser!) properties")
        do {
            try await ref.document(Auth.auth().currentUser!.uid).setData([
                "properties": []
            ])
            print("Successfully reset Ids")
        } catch {
            print("Error resetting Ids: \(error.localizedDescription)")
        }
    }
}

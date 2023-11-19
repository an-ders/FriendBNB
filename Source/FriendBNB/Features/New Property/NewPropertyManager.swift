//
//  NewPropertyManager.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-13.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewPropertyManager: ObservableObject {
    @Published var currentTab: NewPropertyTabs = .info
    
    var location: Location = Location()
    var info: NewPropertyInfo?
    
    func addDocument() async -> String {
        var newDict = location.dictonary.merging(info?.dictonary ?? [:]) { (_, new) in new }
        if let user = Auth.auth().currentUser {
            newDict = newDict.merging([
                "owner": user.uid
            ]) { (_, new) in new }
        }
        
        let db = Firestore.firestore()
        let id = db.collection("Properties").document().documentID
        do {
            try await db.collection("Properties").document(id).setData(newDict)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
        
        return id
    }
}

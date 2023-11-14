//
//  AddPropertyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FloatingPromptTextField
import FirebaseFirestore

struct AddPropertyView: View {
    @EnvironmentObject var homeManager: HomeManager
    @EnvironmentObject var newPropertyManager: NewPropertyManager
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Add an existing property")
                .font(.largeTitle).fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Constants.Spacing.small)
            Text("Enter the property ID below:")
                .font(.title3).fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
                //.padding(.bottom, Constants.Spacing.small)
            
            StyledFloatingTextField(text: $viewModel.propertyID, prompt: "Property ID", error: $viewModel.error)
            
            Spacer()
            PairButtonsView(prevText: "Close", prevAction: {
                homeManager.showAddPropertySheet = false
            }, nextText: "Add", nextAction: {
                Task {
                    if let id = await viewModel.checkValidID() {
                        homeManager.addProperty(id)
                    }
                }
            })
        }
        .padding(.top, Constants.Padding.regular)
        .padding(.horizontal, Constants.Padding.regular)
    }
}

extension AddPropertyView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var propertyID: String = ""
        @Published var error: String = ""
        
//        func queryID() async -> Property? {
//            var returnProperty: Property?
//
//            guard !propertyID.isEmpty else {
//                self.error = "Please enter a property ID."
//                return returnProperty
//            }
//
//            let db = Firestore.firestore()
//            let ref = db.collection("Properties")
//            do {
//                try await Task.sleep(nanoseconds: 500000000)
//                let snapshot = try await ref.whereField(FirebaseFirestore.FieldPath.documentID(), isEqualTo: propertyID).getDocuments()
//                for document in snapshot.documents {
//                    let data = document.data()
//                    returnProperty =  Property(id: document.documentID, data: data)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//            
//            self.error = returnProperty != nil ? "" : "No property with that ID was found."
//            self.propertyID = ""
//            return returnProperty
//        }
        
        func checkValidID() async -> String? {
            var id: String?
            guard !propertyID.isEmpty else {
                self.error = "Please enter a property ID."
                return id
            }
            
            let db = Firestore.firestore()
            let ref = db.collection("Properties").document(propertyID)
            do {
                try await Task.sleep(nanoseconds: 500000000)
                let document = try await ref.getDocument()
                if document.exists {
                    id = document.documentID
                }
            } catch {
                print(error.localizedDescription)
            }
            
            self.error = id != nil ? "" : "No property with that ID was found."
            self.propertyID = ""
            return id
        }
    }
}

//struct AddPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPropertyView()
//    }
//}

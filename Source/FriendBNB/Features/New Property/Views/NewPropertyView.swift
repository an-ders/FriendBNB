//
//  NewPropertyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum NewPropertyTabs {
    case info
    case search
    case address
}

struct NewPropertyView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    @Binding var showSheet: Bool
    
    var body: some View {
        TabView(selection: $viewModel.currentTab) {
            NewPropertyInfoView(showSheet: $showSheet,
                                currentTab: $viewModel.currentTab,
                                info: $viewModel.info)
            
            NewPropertySearchView(currentTab: $viewModel.currentTab,
                                  location: $viewModel.location)
                .tag(NewPropertyTabs.search)
            
            NewPropertyAddressView(showSheet: $showSheet,
                                   currentTab: $viewModel.currentTab,
                                   location: $viewModel.location) {
                viewModel.addDocument()
            }
                .tag(NewPropertyTabs.address)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
}

extension NewPropertyView {
    class ViewModel: ObservableObject {
        @Published var currentTab: NewPropertyTabs = .info
        
        var location: Location = Location()
        var info: NewPropertyInfo?
        
        func addDocument() {
            let db = Firestore.firestore()
            var newDict = location.dictonary.merging(info?.dictonary ?? [:]) { (_, new) in new }
            if let user = Auth.auth().currentUser {
                newDict = newDict.merging([
                    "owner": user.uid
                ]) { (_, new) in new }
            }
            
            db.collection("Properties").document().setData(
                newDict
            ) { err in
              if let err = err {
                print("Error writing document: \(err)")
              } else {
                print("Document successfully written!")
              }
            }
        }
    }
}

//struct NewPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyView()
//    }
//}

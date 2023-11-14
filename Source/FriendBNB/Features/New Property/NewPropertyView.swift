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
    @StateObject var newPropertyManager: NewPropertyManager = NewPropertyManager()
    @EnvironmentObject var homeManager: HomeManager
    
    var body: some View {
        TabView(selection: $newPropertyManager.currentTab) {
            NewPropertyInfoView()
            
            NewPropertySearchView()
                .tag(NewPropertyTabs.search)
            
            NewPropertyAddressView()
                .tag(NewPropertyTabs.address)
        }
        .environmentObject(newPropertyManager)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
}


//struct NewPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyView()
//    }
//}
//
//  HomeMenu.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI

struct HomeMenu: View {
    @EnvironmentObject var rootManager: PropertyStore
    
    var body: some View {
        Menu(content: {
            Button(action: {
                rootManager.showNewPropertySheet = true
            }, label: {
                Label("Create a property", systemImage: "plus.circle")
            })
            
            Button(action: {
                rootManager.showAddPropertySheet = true
            }, label: {
                Label("Add a property", systemImage: "house.fill")
            })
        }, label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .padding(.trailing, 10)
            
        })
    }
}

//struct HomeActionButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeMenuButtonView()
//    }
//}

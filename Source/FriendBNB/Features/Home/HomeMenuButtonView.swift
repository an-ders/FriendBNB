//
//  HomeMenuButtonView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI

struct HomeMenuButtonView: View {
    @EnvironmentObject var homeManager: HomeManager
    
    var body: some View {
        Menu(content: {
            Button(action: {
                homeManager.showNewPropertySheet = true
            }, label: {
                Label("Create a property", systemImage: "plus.circle")
            })
            
            Button(action: {
                homeManager.showAddPropertySheet = true
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

//
//  HomeMenuButtonView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI

struct YourPropertiesMenuView: View {
    @EnvironmentObject var yourPropertiesManager: YourPropertiesManager
    
    var body: some View {
        Menu(content: {
            Button(action: {
                yourPropertiesManager.showNewPropertySheet = true
            }, label: {
                Label("Create a property", systemImage: "plus.circle")
            })
            
            Button(action: {
                yourPropertiesManager.showAddPropertySheet = true
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

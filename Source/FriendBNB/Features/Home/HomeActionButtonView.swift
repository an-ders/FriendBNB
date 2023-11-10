//
//  HomeActionButtonView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI

struct HomeActionButtonView: View {
    @ObservedObject var viewModel: HomeView.ViewModel
    
    var body: some View {
        Menu(content: {
            Button(action: {
                viewModel.newProperty = true
            }, label: {
                Label("Create a property", systemImage: "plus.circle")
            })
            
            Button(action: {
                
            }, label: {
                Label("Rent a property", systemImage: "house.fill")
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
//        HomeActionButtonView()
//    }
//}

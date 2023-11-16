//
//  HomeEmptyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore

struct HomeEmptyView: View {
    @EnvironmentObject var homeManager: HomeManager
    
    var body: some View {
        VStack {
            Image(systemName: "house")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            Text("It's empty in here.")
                .font(.title).fontWeight(.medium)
            Text("Add an existing or create a new property")
                .font(.headline).fontWeight(.light)
                .padding(.bottom, 8)
            
            Button(action: {
                homeManager.showAddPropertySheet = true
            }, label: {
                Text("Add Existing Property")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(Color.systemGray3)
                    .cornerRadius(10)
            })
            
            Button(action: {
                homeManager.showNewPropertySheet = true
            }, label: {
                Text("New Property")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(Color.systemGray3)
                    .cornerRadius(10)
            })
            
        }
    }
}

//struct HomeEmptyView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeEmptyView()
//    }
//}

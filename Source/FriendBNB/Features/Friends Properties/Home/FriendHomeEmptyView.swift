//
//  FriendPropertiesEmptyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore

struct FriendHomeEmptyView: View {
    @EnvironmentObject var propertyStore: PropertyStore
    
    var body: some View {
        VStack {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            Text("It's empty in here.")
                .font(.title).fontWeight(.medium)
            Text("Add a friends property")
                .font(.headline).fontWeight(.light)
                .padding(.bottom, 8)
            
            Button(action: {
				propertyStore.showAddPropertySheet = true
            }, label: {
                Text("Find friends property")
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
//        YourPropertiesEmptyView()
//    }
//}

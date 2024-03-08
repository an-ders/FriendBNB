//
//  OwnedPropertiesEmptyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore

struct OwnedPropertiesEmptyView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	
	var body: some View {
		VStack {
			Image(systemName: "house")
				.resizable()
				.scaledToFit()
				.frame(width: 50)
			Text("It's empty in here.")
				.font(.title).fontWeight(.medium)
			Text("Create a new property")
				.font(.headline).fontWeight(.light)
				.padding(.bottom, 8)
			
			Button(action: {
				propertyStore.showNewPropertySheet = true
			}, label: {
				Text("Add your home")
					.font(.headline)
					.padding(.horizontal, 16)
					.padding(.vertical, 8)
					.foregroundColor(.white)
					.background(Color.systemGray3)
					.cornerRadius(10)
					.shimmering()
			})
			
		}
	}
}

//struct HomeEmptyView_Previews: PreviewProvider {
//    static var previews: some View {
//        YourPropertiesEmptyView()
//    }
//}

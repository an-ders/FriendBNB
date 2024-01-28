//
//  AddPropertyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore

struct AddPropertyView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	
	@State var propertyId: String = ""
	@State var error: String = ""
	var body: some View {
		PairButtonWrapper(prevText: "Close", prevAction: {
			Task { @MainActor in
				propertyStore.showAddPropertySheet = false
			}
		}, nextText: "Add", nextAction: {
			guard !propertyId.isEmpty else {
				self.error = "Please enter a property ID."
				return
			}
			
			Task {
				if let id = await propertyStore.checkValidId(propertyId) {
					await propertyStore.addProperty(id, type: .friend)
					propertyStore.showAddPropertySheet = false
					self.propertyId = ""
				} else {
					self.error = "No property with that ID was found."
				}
			}
		}, content: {
			VStack {
				Text("Add an existing property")
					.title()
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom, Constants.Spacing.small)
				Text("Enter the property ID below:")
					.body()
					.frame(maxWidth: .infinity, alignment: .leading)
				
				StyledFloatingTextField(text: $propertyId, prompt: "Property ID")
				
				Spacer()
				
			}
		})
		.padding(.top, Constants.Padding.regular)
		.padding(.horizontal, Constants.Padding.regular)
	}
}

//struct AddPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPropertyView()
//    }
//}

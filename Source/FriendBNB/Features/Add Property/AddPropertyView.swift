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
	@Environment(\.dismiss) private var dismiss

	@State var propertyId: String = ""
	@State var error: String = ""
	var body: some View {
		PairButtonWrapper(prevText: "Close", prevAction: {
			dismiss()
		}, nextText: "Add", nextAction: {
			guard !propertyId.isEmpty else {
				self.error = "Please enter a property ID."
				return
			}
			
			Task {
				if let id = await propertyStore.checkValidId(propertyId) {
					await propertyStore.addPropertyToUser(id, type: .friend)
					propertyStore.showAddPropertySheet = false
					self.propertyId = ""
				} else {
					self.error = "No property with that ID was found."
				}
			}
		}, content: {
			VStack {
				VStack(spacing: 0) {
					DetailSheetTitle(title: "ADD PROPERTY", showDismiss: true)
						.padding(.leading, Constants.Spacing.medium)
						.padding(.vertical, Constants.Spacing.large)
						.padding(.trailing, Constants.Spacing.large)
					Divider()
				}
				Text("Enter the property code below:")
					.styled(.body)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.top, Constants.Spacing.large)
				
				StyledFloatingTextField(text: $propertyId, prompt: "Property Code")
				
				Spacer()
				
			}
		})
		.padding(.top, Constants.Spacing.regular)
		.padding(.horizontal, Constants.Spacing.regular)
	}
}

//struct AddPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPropertyView()
//    }
//}

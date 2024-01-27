//
//  NewPropertyAddressView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-09.
//

import SwiftUI

struct NewPropertyAddressView: View {
	@Binding var currentTab: NewPropertyTabs
	@ObservedObject var location: Location
	
	var body: some View {
		PairButtonWrapper(prevText: "Back", prevAction: {
			back()
		}, nextText: "Next", nextAction: {
			next()
		}, content: {
			VStack(spacing: 4) {
				Text("Confirm the address")
					.font(.largeTitle).fontWeight(.medium)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom, Constants.Spacing.regular)
				
				StyledFloatingTextField(text: $location.streetName, prompt: "Street Name")
				StyledFloatingTextField(text: $location.streetNumber, prompt: "Street Number")
				StyledFloatingTextField(text: $location.city, prompt: "City")
				StyledFloatingTextField(text: $location.state, prompt: "State")
				StyledFloatingTextField(text: $location.zipCode, prompt: "Zip Code")
				StyledFloatingTextField(text: $location.country, prompt: "Country")
				
				ErrorView(error: $location.error)
				
				Spacer()
			}
		})
		.padding(.horizontal, Constants.Padding.regular)
		.padding(.top, Constants.Padding.regular)
	}
	
	func back() {
		withAnimation {
			currentTab = .search
		}
	}
	
	func next() {
		if location.checkAddress() {
			currentTab = .info
		}
	}
}

fileprivate struct Country {
	var id: String
	var name: String
}

//struct NewPropertyAddressView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyAddressView()
//    }
//}
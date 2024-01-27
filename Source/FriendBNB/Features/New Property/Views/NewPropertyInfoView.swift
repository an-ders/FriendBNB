//
//  NewPropertyInfoView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-08.
//

import SwiftUI

struct NewPropertyInfoView: View {
	@EnvironmentObject var rootManager: PropertyStore
	
	@Binding var currentTab: NewPropertyTabs
	@ObservedObject var info: NewPropertyInfo
	var createProperty: () -> Void
	
	var body: some View {
		PairButtonWrapper(prevText: "Back", prevAction: {
			back()
		}, nextText: "Next", nextAction: {
			next()
		}, content: {
			VStack {
				ScrollView(.vertical) {
					VStack(spacing: Constants.Spacing.regular) {
						Text("Some basic details about your place")
							.font(.largeTitle).fontWeight(.medium)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom, Constants.Spacing.small)
						
						CustomStepperView(text: "Rooms", value: $info.rooms, min: 1)
						Divider()
						CustomStepperView(text: "People", value: $info.people, min: 1)
						Divider()
						
						Text("Extra notes")
							.font(.largeTitle).fontWeight(.medium)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text("Leave details about how to contact you, access the place, any fees, and any notes about the property")
							.font(.headline).fontWeight(.regular)
							.frame(maxWidth: .infinity, alignment: .leading)
						TextField("Extra notes", text: $info.notes, axis: .vertical)
									.textFieldStyle(.roundedBorder)
						Spacer()
						
					}
					.padding(.top, Constants.Padding.regular)
				}
			}
		})
		.padding(.horizontal, Constants.Padding.regular)
	}
	
	func next() {
		createProperty()
		withAnimation {
			rootManager.showNewPropertySheet.toggle()
		}
	}
	
	func back() {
		currentTab = .address
	}
}

//struct NewPropertyInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyInfoView()
//    }
//}

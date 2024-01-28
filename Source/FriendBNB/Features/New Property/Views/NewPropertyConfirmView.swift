//
//  NewPropertyConfirmView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct NewPropertyConfirmView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	
	@Binding var currentTab: NewPropertyTabs
	@ObservedObject var location: Location
	@ObservedObject var info: NewPropertyInfo
	var createProperty: () -> Void
	
    var body: some View {
		PairButtonWrapper(prevText: "Back", prevAction: {
			back()
		}, nextText: "Finish and Set Availability", nextAction: {
			next()
		}, content: {
			ScrollView(showsIndicators: false) {
				VStack(spacing: Constants.Spacing.regular) {
					Text(location.addressTitle)
						.title()
						.fillLeading()
						.padding(.top, Constants.Padding.regular)
					Text(location.addressDescription)
						.body()
						.fillLeading()
					
					TabView {
						Image(systemName: "house")
							.resizable()
							.scaledToFill()
							.background(Color.systemGray5)
						Image(systemName: "house")
							.resizable()
							.scaledToFill()
							.background(Color.systemGray5)
					}
					.frame(height: 250)
					.cornerRadius(20)
					.tabViewStyle(.page(indexDisplayMode: .always))
					.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
					
					NewPropertyInfoFieldsView(info: info)
					
					PairButtonSpacer()
				}
			}
		})
		.padding(.horizontal, Constants.Padding.regular)
    }
	
	func next() {
		createProperty()
		withAnimation {
			propertyStore.showNewPropertySheet.toggle()
		}
	}
	
	func back() {
		withAnimation {
			currentTab = .info
		}
	}
}

//#Preview {
//    NewPropertyConfirmView()
//}

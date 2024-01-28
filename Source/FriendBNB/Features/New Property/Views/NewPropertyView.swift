//
//  NewPropertyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum NewPropertyTabs {
	case search
	case address
	case info
	case confirm
}

struct NewPropertyView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	
	@State var currentTab: NewPropertyTabs = .search
	@StateObject var location = Location()
	@StateObject var info = NewPropertyInfo()
	
	var body: some View {
		TabView(selection: $currentTab) {
			NewPropertySearchView(currentTab: $currentTab, location: location)
				.tag(NewPropertyTabs.search)
			
			NewPropertyAddressView(currentTab: $currentTab, location: location)
				.tag(NewPropertyTabs.address)
			
			NewPropertyInfoView(currentTab: $currentTab, info: info)
				.tag(NewPropertyTabs.info)
			
			NewPropertyConfirmView(currentTab: $currentTab, location: location, info: info) {
				createProperty()
			}
			.tag(NewPropertyTabs.confirm)
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
		.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
	}
		
	func createProperty() {
		Task {
			let newId = await propertyStore.createProperty(location: location, info: info)
			await propertyStore.addProperty(newId, type: .owned)
			propertyStore.showNewPropertySheet = false
			if let property = await propertyStore.getProperty(id: newId) {
				propertyStore.showProperty(property, showAvailability: true)
			}
		}
	}
}

//struct NewPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyView()
//    }
//}

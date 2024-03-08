//
//  TabBar.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-06.
//

import SwiftUI

struct TabBar<Content: View>: View {
	@EnvironmentObject var propertyStore: PropertyStore
	
	@ViewBuilder var content: Content
    var body: some View {
		ZStack {
			content
			
			VStack {
				Spacer()
				
				HStack {
					ForEach(RootTabs.allCases, id: \.self) { tab in
						Button(action: {
							propertyStore.selectedTab = tab
						}, label: {
							Label(tab.name, systemImage: tab.image)
								.frame(maxWidth: .infinity, alignment: .center)
								.foregroundStyle(propertyStore.selectedTab == tab ? Color.systemBlue.opacity(0.6) : Color.systemGray2)
						})
					}
				}
			}
		}
    }
}

//#Preview {
//    TabBar()
//}

//
//  FriendDetailSettingsView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-16.
//

import SwiftUI

struct FriendDetailSettingsView: View {
	@Binding var confirmDelete: Bool
	
    var body: some View {
        Menu(content: {
			Button(role: .destructive, action: {
				confirmDelete = true
			}, label: {
				Label("Remove", systemImage: "trash")
			})
		}, label: {
			Image(systemName: "ellipsis.circle")
				.resizable()
				.scaledToFit()
				.frame(height: 30)
				.padding(.trailing, 10)
			
		})
    }
}

//#Preview {
//    FriendDetailSettingsView()
//}

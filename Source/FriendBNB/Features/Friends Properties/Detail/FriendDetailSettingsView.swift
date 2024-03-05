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
			VStack {
				Image(systemName: "ellipsis")
					.resizable()
					.scaledToFit()
					.frame(width: 20, height: 20)
					.foregroundStyle(.white)
			}
			.padding(10)
			.background(Color.black.opacity(0.4))
			.cornerRadius(5)
		})
    }
}

//#Preview {
//    FriendDetailSettingsView()
//}

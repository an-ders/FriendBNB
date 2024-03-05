//
//  PropertyDetailSettingsView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-13.
//

import Foundation
import SwiftUI

struct OwnedDetailSettingsView: View {
	@Binding var confirmDelete: Bool
	@Binding var edit: Bool
		
	var body: some View {
		Menu(content: {
			Button(action: {
				edit = true
			}, label: {
				Label("Edit", systemImage: "pencil")
			})
			
			Button(role: .destructive, action: {
				confirmDelete = true
			}, label: {
				Label("Delete", systemImage: "trash")
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

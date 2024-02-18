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
		
	var body: some View {
		Menu(content: {
			Button(role: .destructive, action: {
				confirmDelete = true
			}, label: {
				Label("Delete", systemImage: "trash")
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

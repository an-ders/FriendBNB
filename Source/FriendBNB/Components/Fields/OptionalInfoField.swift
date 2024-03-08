//
//  OptionalInfoField.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct OptionalInfoField<Content: View>: View {
	@State var showField: Bool = false
	var infoName: String
	@ViewBuilder var enabledField: Content
	
    var body: some View {
		VStack(spacing: 8) {
			if !showField {
				Button(action: {
					withAnimation {
						showField = true
					}
				}, label: {
					HStack {
						Image(systemName: "plus")
							.size(height: 20)
						Text(infoName)
							.styled(.bodyBold)
							.fillLeading()
					}
				})
			}
			if showField {
				Text(infoName)
					.styled(.body)
					.fillLeading()
				enabledField
			}
		}
    }
}

//#Preview {
//    OptionalInfoField()
//}

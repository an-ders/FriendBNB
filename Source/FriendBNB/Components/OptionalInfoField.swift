//
//  OptionalInfoField.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct OptionalInfoField: View {
	@State var showField: Bool
	@Binding var text: String
	var infoName: String
	var defaultText: String
	
	init(infoName: String, defaultText: String, text: Binding<String>) {
		self.infoName = infoName
		self.defaultText = defaultText
		self._text = text
		
		self._showField = State(initialValue: !text.wrappedValue.isEmpty)
	}
	
    var body: some View {
		if !showField {
			Button(action: {
				withAnimation {
					showField = true
				}
			}, label: {
				HStack(alignment: .center) {
					Image(systemName: "plus.circle")
					Text("Add " + infoName)
				}
				.fillLeading()
				.foregroundStyle(Color.systemBlue.opacity(0.8))
				.contentShape(Rectangle())
			})
		} else {
			VStack(spacing: 4) {
				HStack(alignment: .center) {
					Text(infoName)
						.body()
						.fillLeading()
					
					Button(action: {
						withAnimation {
							showField = false
							text = ""
						}
					}, label: {
						Image(systemName: "x.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 15)
							.foregroundStyle(Color.systemRed.opacity(0.8))
					})
				}
				BasicTextField(defaultText: defaultText, text: $text)
			}
		}
    }
}

//#Preview {
//    OptionalInfoField()
//}

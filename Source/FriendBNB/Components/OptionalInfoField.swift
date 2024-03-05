//
//  OptionalInfoField.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct OptionalInfoField: View {
	@State var showField: Bool = false
	@Binding var text: String
	var infoName: String
	var defaultText: String
	
	init(infoName: String, defaultText: String, text: Binding<String>) {
		self.infoName = infoName
		self.defaultText = defaultText
		self._text = text
	}
	
    var body: some View {
		VStack(spacing: 8) {
			Toggle(isOn: $showField) {
				Text(infoName)
					.styled(.body)
			}
			.padding(.trailing, 4)
			if showField {
				BasicTextField(defaultText: defaultText, text: $text)
			}
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				if !text.isEmpty {
					showField = true
				}
			}
		}
    }
}

//#Preview {
//    OptionalInfoField()
//}

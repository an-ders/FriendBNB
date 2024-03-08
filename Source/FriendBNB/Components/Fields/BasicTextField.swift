//
//  BasicTextField.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct BasicTextField: View {
	var title: String = ""
	var defaultText: String
	@Binding var text: String
	
    var body: some View {
		VStack(spacing: 0) {
			if !title.isEmpty {
				Text(title)
					.styled(.bodyBold)
					.fillLeading()
			}
			TextField(defaultText, text: $text, axis: .vertical)
				.padding(.vertical, 8)
				.padding(.horizontal, 8)
				.overlay(
					RoundedRectangle(cornerRadius: 5)
						.stroke(lineWidth: 1.0)
						.foregroundStyle(Color.systemGray3)
				)
				.contentShape(Rectangle())
		}
    }
}

//#Preview {
//    BasicTextField()
//}

//
//  BasicTextField.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct BasicTextField: View {
	var defaultText: String
	@Binding var text: String
	var color: Color = Color.systemGray3
	
    var body: some View {
		TextField(defaultText, text: $text, axis: .vertical)
			.padding(.vertical, 8)
			.padding(.horizontal, 8)
			.overlay(
				RoundedRectangle(cornerRadius: 5)
					.stroke(lineWidth: 1.0)
					.foregroundStyle(color)
			)
    }
}

//#Preview {
//    BasicTextField()
//}

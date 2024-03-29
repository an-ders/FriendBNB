//
//  StyledFloatingTextField.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI

struct StyledFloatingTextField: View {
    @Binding var text: String
    var prompt: String
	
    var textColor: Color = .systemGray
    var cornerRadius: CGFloat = 5
    var lineWidth: CGFloat = 1
    var borderColor: Color = .systemGray5
    
    var body: some View {
		FloatingPromptTextField(text: $text, prompt: {
			Text(prompt)
				.padding(.horizontal, 4)
				.background(.white)
				.foregroundColor(textColor)
				.cornerRadius(3)
		})
		.disableAutocorrection(true)
		.autocapitalization(.none)
		.padding(.horizontal, 8)
		.padding(.vertical, 4)
		.background {
			RoundedRectangle(cornerRadius: cornerRadius)
				.strokeBorder(borderColor, lineWidth: lineWidth)
				.background(RoundedRectangle(cornerRadius: cornerRadius).foregroundColor(.white))
				.frame(height: 46)
				.frame(maxHeight: .infinity, alignment: .bottom)
				.offset(y: 8)
		}
	
    }
}

//struct StyledFloatingTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        StyledFloatingTextField()
//    }
//}

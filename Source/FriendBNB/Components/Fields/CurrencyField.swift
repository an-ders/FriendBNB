//
//  CurrencyField.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct CurrencyField: View {
	var title: String
	let defaultText: String
	@Binding var value: Int
	let numberFormatter: NumberFormatter
		
	init(title: String, defaultText: String, value: Binding<Int>) {
		self.title = title
		self.defaultText = defaultText
		self._value = value
		numberFormatter = NumberFormatter()
		numberFormatter.maximumFractionDigits = 2
		numberFormatter.minimumIntegerDigits = 0
	}

    var body: some View {
		HStack {
			Text(title)
				.styled(.body)
			Spacer()
			HStack {
				Text("$")
					.styled(.body)
				TextField(defaultText, value: $value, formatter: numberFormatter)
					.keyboardType(.numberPad)
					.styled(.body)
			}
		}
    }
}

//#Preview {
//    CurrencyField()
//}

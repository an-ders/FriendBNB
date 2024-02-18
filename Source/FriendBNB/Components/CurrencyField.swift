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
		numberFormatter.numberStyle = .currency
		numberFormatter.maximumFractionDigits = 0
		numberFormatter.locale = Locale(identifier: "en_US")
	}

    var body: some View {
		HStack {
			Text(title)
				.body()
			Spacer()
			HStack {
				Button(action: {
					value = value > 0 ? value - 1 : value
				}, label: {
					ZStack {
						Circle()
							.strokeBorder(value == 0 ? Color.systemGray5 : Color.systemGray2, lineWidth: 1)
							.background(Circle().foregroundColor(.white))
							.scaledToFit()
						
						Text("-")
							.font(.system(size: 25)).fontWeight(.light)
							.offset(x: 0, y: -1)
							.foregroundColor(.systemGray2)
					}
					.frame(height: 20)
				})
				
				TextField(defaultText, value: $value, formatter: numberFormatter)
					.keyboardType(.numberPad)
					.body()
					.frame(width: 45, alignment: .center)
					.multilineTextAlignment(.center)
				
				Button(action: {
					value += 1
				}, label: {
					ZStack {
						Circle()
							.strokeBorder(Color.systemGray2, lineWidth: 1)
							.background(Circle().foregroundColor(.white))
							.scaledToFit()
						
						Text("+")
							.font(.system(size: 25)).fontWeight(.light)
							.offset(x: 0, y: -1)
							.foregroundColor(.systemGray2)
					}
					.frame(height: 20)
				})
			}
		}
    }
}

//#Preview {
//    CurrencyField()
//}

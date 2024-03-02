//
//  Font.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import Foundation
import SwiftUI

enum FontType {
	case title
	case headline
	case body
	case bodyBold
	case caption
	
	var font: Font {
		switch self {
		case .title: .largeTitle
		case .headline: .title
		case .body: .headline
		case .bodyBold: .headline
		case .caption: .caption
			
		}
	}
	
	var weight: Font.Weight {
		switch self {
		case .title: .medium
		case .headline: .regular
		case .body: .light
		case .bodyBold: .semibold
		case .caption: .regular
		}
	}
}

struct StyledText: ViewModifier {
	var type: FontType
	var weight: Font.Weight?
	
	func body(content: Content) -> some View {
		content
			.font(type.font).fontWeight(weight != nil ? weight : type.weight)
	}
}

struct FillLeading: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(maxWidth: .infinity, alignment: .leading)
	}
}

extension View {
	func styled(_ font: FontType, weight: Font.Weight? = nil) -> some View {
		modifier(StyledText(type: font, weight: weight))
	}
	
	func fillLeading() -> some View {
		modifier(FillLeading())
	}
}

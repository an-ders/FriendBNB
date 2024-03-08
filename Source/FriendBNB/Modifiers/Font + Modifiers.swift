//
//  Font.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import Foundation
import SwiftUI

enum FontType {
	case bigTitle
	case title
	case title2
	case headline
	case body
	case bodyBold
	case caption
	
	var font: Font {
		switch self {
		case .bigTitle: .system(size: 42)
		case .title: .largeTitle
		case .title2: .title2
		case .headline: .title
		case .body: .headline
		case .bodyBold: .headline
		case .caption: .caption
			
		}
	}
	
	var weight: Font.Weight {
		switch self {
		case .bigTitle: .bold
		case .title: .medium
		case .title2: .bold
		case .headline: .regular
		case .body: .regular
		case .bodyBold: .bold
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

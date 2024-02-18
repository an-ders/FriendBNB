//
//  Font.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import Foundation
import SwiftUI

struct Title: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.largeTitle).fontWeight(.medium)
	}
}

struct Heading: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.title).fontWeight(.regular)
	}
}

struct BodyLight: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.headline).fontWeight(.light)
	}
}

struct BodyBold: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.headline).fontWeight(.semibold)
	}
}

struct Caption: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.caption).fontWeight(.regular)
	}
}

extension View {
	func title() -> some View {
		modifier(Title())
	}
	
	func heading() -> some View {
		modifier(Heading())
	}
	
	func body() -> some View {
		modifier(BodyLight())
	}
	
	func bodyBold() -> some View {
		modifier(BodyBold())
	}
	
	func caption() -> some View {
		modifier(Caption())
	}
}

struct FillLeading: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(maxWidth: .infinity, alignment: .leading)
	}
}

extension View {
	func fillLeading() -> some View {
		modifier(FillLeading())
	}
}

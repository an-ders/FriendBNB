//
//  SafeAreaInsets.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-04.
//

import Foundation
import SwiftUI

private struct SafeAreaInsetsKey: EnvironmentKey {
	static var defaultValue: EdgeInsets {
		(UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
	}
}

extension EnvironmentValues {
	
	var safeAreaInsets: EdgeInsets {
		self[SafeAreaInsetsKey.self]
	}
}

private extension UIEdgeInsets {
	
	var insets: EdgeInsets {
		EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
	}
}

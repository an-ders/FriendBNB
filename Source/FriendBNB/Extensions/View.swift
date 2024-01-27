//
//  View.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import Foundation
import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
  func sync(_ published: Binding<Bool>, with binding: Binding<Bool>) -> some View {
    self
      .onChange(of: published.wrappedValue) { newValue in
        binding.wrappedValue = newValue
      }
      .onChange(of: binding.wrappedValue) { newValue in
        published.wrappedValue = newValue
      }
  }
}

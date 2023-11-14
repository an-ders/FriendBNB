//
//  PropertyDetailSettingsView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-13.
//

import Foundation
import SwiftUI

struct PropertyDetailSettingsView: View {
    @Binding var confirmDelete: Bool
    var body: some View {
        Menu(content: {
            Button(action: {
                
            }, label: {
                Label("Edit", systemImage: "pencil")
            })
            
            Button(role: .destructive, action: {
                confirmDelete = true
            }, label: {
                Label("Delete", systemImage: "trash")
            })
        }, label: {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .padding(.trailing, 10)
            
        })
    }
}

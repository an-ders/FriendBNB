//
//  PropertyDetailManager.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import Foundation

@MainActor
class PropertyDetailManager: ObservableObject {
    @Published var selectedTab: RootTabs = .home
    @Published var properties: [Property] = []
    @Published var showNewPropertySheet = false
    @Published var showAddPropertySheet = false
    @Published var loading: Bool = true
    
}

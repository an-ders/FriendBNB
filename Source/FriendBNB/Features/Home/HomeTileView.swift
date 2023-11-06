//
//  HomeTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-03.
//

import SwiftUI

struct HomeTileView: View {
    var property: Property
    
    var body: some View {
        NavigationLink(destination: {
            Text(property.owner)
                .navigationTitle(property.title + "'s Property")
        }, label: {
            VStack {
                Text(property.title)
                Text(property.owner)
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.mint)
            }
            .padding(.horizontal, 10)
        })
    }
}

extension HomeTileView {
    class ViewModel: ObservableObject {
        
    }
}

struct HomeTileView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTileView(property: Property(id: "test123", data: ["title": "testtitle123", "owner": "Anders"]))
    }
}

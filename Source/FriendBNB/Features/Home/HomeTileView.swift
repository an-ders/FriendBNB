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
            PropertyDetailView(property: property)
        }, label: {
            VStack(alignment: .leading) {
                Spacer()
                VStack(spacing: 0) {
                    Text(property.location.addressTitle)
                        .font(.title).fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(property.location.addressDescription)
                        .font(.caption).fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .foregroundColor(.white)
                .padding(Constants.Padding.small)
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.systemGray2)
            }
            .padding(.horizontal, 10)
//            .onTapGesture {
//                print("Tpped")
//            }
        })
    }
}

extension HomeTileView {
    class ViewModel: ObservableObject {

    }
}

//struct HomeTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTileView(property: Property(id: "test123", data: ["title": "testtitle123", "owner": "Anders"]))
//    }
//}

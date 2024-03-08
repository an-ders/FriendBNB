//
//  CustomStepperView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-10.
//

import SwiftUI

struct CustomStepperView: View {
    var text: String
    @Binding var value: Int
    var min: Int?
    var max: Int?
    
    var body: some View {
        HStack {
            Text(text)
                .styled(.body)
            Spacer()
            HStack {
                Button(action: {
                    if let min = min {
                        value = value > min ? value - 1 : value
                    } else {
                        value = value > 0 ? value - 1 : value
                    }
                }, label: {
                    CustomStepperIconView(text: "-", limit: min, value: $value)
                })
                
                Text(String(value))
                    .styled(.body)
                    .frame(width: 45, alignment: .center)
                
                Button(action: {
                    if let max = max {
                        value = value < max ? value + 1 : value
                    } else {
                        value += 1
                    }
                }, label: {
                    CustomStepperIconView(text: "+", limit: max, value: $value)
                })
            }
        }
    }
}

struct CustomStepperIconView: View {
    var text: String
    var limit: Int?
    @Binding var value: Int
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(limit ?? value + 1 == value ? Color.systemGray5 : Color.systemGray2, lineWidth: 1)
                .background(Circle().foregroundColor(.white))
                .scaledToFit()
            
            Text(text)
                .font(.system(size: 25)).fontWeight(.light)
                .offset(x: 0, y: -1)
                .foregroundColor(limit ?? value + 1 == value ? .systemGray5 : .systemGray2)
        }
        .frame(height: 20)
    }
}

//struct CustomStepperView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomStepperView()
//    }
//}

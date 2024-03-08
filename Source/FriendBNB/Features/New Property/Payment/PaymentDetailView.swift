//
//  PaymentDetailView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-05.
//

import SwiftUI

struct PaymentDetailView: View {
	@Environment(\.dismiss) private var dismiss

	@ObservedObject var info: NewPropertyInfo
	var type: PaymentType
	@Binding var showPicker: Bool
	
	@State var error = ""
	@State var cost: Double?
	@State var instructions = ""
	
    var body: some View {
		VStack {
			VStack(spacing: 0) {
				HStack {
					Button(action: {
						dismiss()
					}, label: {
						VStack {
							Image(systemName: "arrow.left")
								.size(width: 20, height: 20)
								.foregroundStyle(Color.systemGray)
						}
						.padding(10)
						.contentShape(Rectangle())
						.cornerRadius(5)
					})
					
					DetailSheetTitle(title: "PAYMENT DETAILS", showDismiss: false)
						.padding(.horizontal, Constants.Spacing.medium)
						.padding(.vertical, Constants.Spacing.large)
				}

				Divider()
					.padding(.horizontal, -Constants.Spacing.regular)
			}
			
			ScrollView(showsIndicators: false) {
				VStack(spacing: 50) {
					VStack(spacing: 2) {
						Text("PAYMENT INSTRUCTIONS")
							.styled(.bodyBold)
							.fillLeading()
							.foregroundStyle(Color.systemGray)
						BasicTextField(defaultText: "Email, Venmo, Paypal...", text: $instructions)
						Text("Please note we do not handle payments")
							.styled(.caption)
							.fillLeading()
							.foregroundStyle(Color.systemGray3)
					}
					
					VStack {
						Text("RATE PER NIGHT")
							.styled(.bodyBold)
							.fillLeading()
							.foregroundStyle(Color.systemGray)
						
						CurrencyTextField("$12", value: $cost)
							.styled(.bodyBold)
							.padding(.horizontal, Constants.Spacing.medium)
							.padding(.vertical, Constants.Spacing.small)
							.overlay(
								RoundedRectangle(cornerRadius: 5)
									.stroke(lineWidth: 1.0)
									.foregroundStyle(Color.systemGray3)
							)
							.frame(maxWidth: .infinity, alignment: .trailing)
					}
					
					ErrorView(error: error)
				}
				.padding(.vertical, Constants.Spacing.medium)
			}
			
			VStack {
				PairButtonsView(prevText: "", prevAction: {
					
				}, nextText: "Set", nextCaption: "", nextAction: {
					guard !(cost == nil) else {
						error = "Please include a rate per night!"
						return
					}
					
					guard !instructions.isEmpty else {
						error = "Please include instructions for payment!"
						return
					}
					info.payment = type
					info.paymentNotes = instructions
					info.cost = cost
					showPicker = false
				})
			}
		}
		.padding(.horizontal, Constants.Spacing.regular)
		.toolbar(.hidden, for: .navigationBar)
		.contentShape(Rectangle())
		.onTapGesture {
			hideKeyboard()
		}
    }
}

//#Preview {
//    PaymentDetailView()
//}

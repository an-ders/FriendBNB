//
//  PaymentPickerView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-05.
//

import SwiftUI

struct PaymentPickerView: View {
	@Environment(\.dismiss) private var dismiss

	@ObservedObject var info: NewPropertyInfo
	@Binding var showPicker: Bool
	@State var showPaymentDetail: PaymentType?
	
    var body: some View {
		NavigationStack {
			VStack {
				VStack(spacing: 0) {
					DetailSheetTitle(title: "PAYMENT TYPES")
						.padding(.horizontal, Constants.Spacing.medium)
						.padding(.vertical, Constants.Spacing.large)

					Divider()
						.padding(.horizontal, -Constants.Spacing.regular)
				}
				
				ScrollView(showsIndicators: false) {
					List {
						ForEach(PaymentType.allCases, id: \.self) { type in
							Button(action: {
								if type == .free {
									dismiss()
								} else {
									showPaymentDetail = type
								}
							}, label: {
								HStack {
									Image(systemName: type.image)
										.size(height: 30)
									Text(type.rawValue)
										.styled(.bodyBold)
										.fillLeading()
								}
								.foregroundStyle(Color.black)
								.padding(.horizontal, Constants.Spacing.large)
								.padding(.vertical, Constants.Spacing.medium)
								.contentShape(Rectangle())
							})
						}
					}
					.listStyle(PlainListStyle())
					.environment(\.defaultMinListRowHeight, 90)
					.frame(height: 90 * CGFloat(PaymentType.allCases.count))
					.padding(.horizontal, -Constants.Spacing.regular)
				}
			}
			.padding(.horizontal, Constants.Spacing.regular)
			.navigationDestination(item: $showPaymentDetail) { type in
				PaymentDetailView(info: info, type: type, showPicker: $showPicker)
			}
		}
    }
}

//#Preview {
//    PaymentPickerView()
//}

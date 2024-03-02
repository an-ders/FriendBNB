//
//  CalendarOwnedCellView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import SwiftUI

struct CalendarCellView: View {
	@EnvironmentObject var calendarViewModel: CalendarViewModel
	
	var type: PropertyType
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Button(action: {
			calendarViewModel.dateClicked(viewModel.date)
		}, label: {
			Group {
				if type == .friend {
					friendCell
				} else {
					ownedCell
				}
			}
			.onChange(of: calendarViewModel.startDate) { _ in
				viewModel.update(calendarViewModel: calendarViewModel)
			}
			.onChange(of: calendarViewModel.endDate) { _ in
				viewModel.update(calendarViewModel: calendarViewModel)
			}
			.onChange(of: calendarViewModel.date) { _ in
				viewModel.update(calendarViewModel: calendarViewModel)
			}
			.onChange(of: calendarViewModel.property.bookings) { _ in
				viewModel.update(calendarViewModel: calendarViewModel)
			}
			.onChange(of: calendarViewModel.property.available) { _ in
				viewModel.update(calendarViewModel: calendarViewModel)
			}
			.onChange(of: calendarViewModel.property.unavailable) { _ in
				viewModel.update(calendarViewModel: calendarViewModel)
			}
		})
	}
	
	var textColor: Color {
		if viewModel.isHighlighted {
			return Color.black
		} else if viewModel.isAvailable && calendarViewModel.mode == .available && !viewModel.isUnavailable {
			return Color.black
		} else if viewModel.isUnavailable && calendarViewModel.mode == .unavailable {
			return Color.black
		} else if viewModel.isCurrentMonth {
			return Color.black
		}
		
		return Color.systemGray
	}
	
	var ownedCell: some View {
		Text(String(viewModel.day))
			.strikethrough(viewModel.isUnavailable)
			.padding(Constants.Spacing.xsmall)
			.foregroundColor(textColor)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background {
				if viewModel.isHighlighted && calendarViewModel.endDate == nil {
					Color.blue.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: 20,
								bottomLeadingRadius: 20,
								bottomTrailingRadius: 20,
								topTrailingRadius: 20
							)
						)
				} else if viewModel.isHighlighted {
					Color.blue.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: viewModel.isStartDate ? 20 : 0,
								bottomLeadingRadius: viewModel.isStartDate ? 20 : 0,
								bottomTrailingRadius: viewModel.isEndDate ? 20 : 0,
								topTrailingRadius: viewModel.isEndDate ? 20 : 0
							)
						)
				} else if viewModel.isUnavailable && calendarViewModel.mode == .unavailable {
					Color.systemRed.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: 20,
								bottomLeadingRadius: 20,
								bottomTrailingRadius: 20,
								topTrailingRadius: 20
							)
						)
				} else if viewModel.isAvailable && calendarViewModel.mode == .available && !viewModel.isUnavailable {
					Color.green.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: 20,
								bottomLeadingRadius: 20,
								bottomTrailingRadius: 20,
								topTrailingRadius: 20
							)
						)
				}
			}
	}
	
	var friendCell: some View {
		Text(String(viewModel.day))
			.strikethrough(viewModel.isBooked || viewModel.isUnavailable)
			.padding(Constants.Spacing.xsmall)
			.foregroundColor(viewModel.isCurrentMonth ? viewModel.isBooked || viewModel.isUnavailable ? Color.systemGray : Color.black : Color.systemGray4)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background {
				if viewModel.isHighlighted && calendarViewModel.endDate == nil {
					Color.blue.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: 20,
								bottomLeadingRadius: 20,
								bottomTrailingRadius: 20,
								topTrailingRadius: 20
							)
						)
				} else if viewModel.isHighlighted {
					Color.blue.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: viewModel.isStartDate ? 20 : 0,
								bottomLeadingRadius: viewModel.isStartDate ? 20 : 0,
								bottomTrailingRadius: viewModel.isEndDate ? 20 : 0,
								topTrailingRadius: viewModel.isEndDate ? 20 : 0
							)
						)
				} else if viewModel.isUnavailable {
					Color.systemRed.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: 20,
								bottomLeadingRadius: 20,
								bottomTrailingRadius: 20,
								topTrailingRadius: 20
							)
						)
				} else if viewModel.isBooked {
					Color.systemYellow.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: 20,
								bottomLeadingRadius: 20,
								bottomTrailingRadius: 20,
								topTrailingRadius: 20
							)
						)
				} else if viewModel.isAvailable {
					Color.green.opacity(0.5)
						.clipShape(
							.rect(
								topLeadingRadius: 20,
								bottomLeadingRadius: 20,
								bottomTrailingRadius: 20,
								topTrailingRadius: 20
							)
						)
				}
			}
	}
}

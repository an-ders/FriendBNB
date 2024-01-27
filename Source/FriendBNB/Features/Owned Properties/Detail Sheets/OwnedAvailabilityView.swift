//
//  OwnedAvailabilityView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import SwiftUI

struct OwnedAvailabilityView: View {
    @EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	
	@StateObject var calendarViewModel: CalendarViewModel
	init(property: Property) {
		self._calendarViewModel = StateObject(wrappedValue: CalendarViewModel(property: property))
	}
	
    var body: some View {
		PairButtonWrapper(prevText: "Done", prevAction: {
			dismiss()
		}, nextText: "Confirm", nextAction: {
			Task {
				if let error = await bookingStore.addSchedule(
					startDate: calendarViewModel.startDate,
					endDate: calendarViewModel.endDate,
					property: calendarViewModel.property,
					type: calendarViewModel.isAvailableMode ? .available : .unavailable) {
					calendarViewModel.error = error
				} else {
					
				}
				calendarViewModel.resetDates()
			}
		}, content: {
			ScrollView {
				VStack {
					Text("Set Availability")
						.font(.largeTitle).fontWeight(.medium)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, Constants.Spacing.small)
					
					CalendarView(type: .owned)
						.environmentObject(calendarViewModel)
						.padding(.horizontal, Constants.Padding.regular)
						.frame(maxHeight: 300)
					
					Text(calendarViewModel.error)
						.font(.headline).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color.systemRed)
					
					HStack {
						Spacer()
						Button(action: {
							calendarViewModel.isAvailableMode = true
						}, label: {
							Text("Available")
								.font(.title3).fontWeight(.medium)
								.padding(.horizontal, 20)
								.padding(.vertical, 8)
								.foregroundColor(.white)
								.background(calendarViewModel.isAvailableMode ? Color.systemBlue : Color.systemGray4)
								.cornerRadius(20)
						})
						Spacer()
						Button(action: {
							calendarViewModel.isAvailableMode = false
						}, label: {
							Text("Unavailable")
								.font(.title3).fontWeight(.medium)
								.padding(.horizontal, 20)
								.padding(.vertical, 8)
								.foregroundColor(.white)
								.background(!calendarViewModel.isAvailableMode ? Color.systemBlue : Color.systemGray4)
								.cornerRadius(20)
						})
						Spacer()
					}
					
					VStack {
						if calendarViewModel.isAvailableMode {
							ForEach(calendarViewModel.property.available.dict()[calendarViewModel.date.monthYearString()]?.sorted { $0.start < $1.end } ?? []) { availability in
								AvailabilityTileView(availibility: availability, type: .available) {
									Task {
										await bookingStore.deleteBooking(availability, type: .available, property: calendarViewModel.property)
									}
								}
							}
						} else {
							ForEach(calendarViewModel.property.unavailable.dict()[calendarViewModel.date.monthYearString()]?.sorted { $0.start < $1.end } ?? []) { availability in
								AvailabilityTileView(availibility: availability, type: .unavailable) {
									Task {
										await bookingStore.deleteBooking(availability, type: .unavailable, property: calendarViewModel.property)
									}
								}
							}
						}
						
						Rectangle()
							.fill(
								.white
							)
							.frame(maxWidth: .infinity)
							.frame(height: 70)
					}
				}
			}
		})
        .padding(.horizontal, Constants.Padding.regular)
        .padding(.top, Constants.Padding.small)
        
        .onTapGesture {
			calendarViewModel.resetDates()
        }
        
        .onAppear {
            calendarViewModel.subscribe()
        }
        .onDisappear {
            calendarViewModel.unsubscribe()
        }
    }
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView()
//    }
//}
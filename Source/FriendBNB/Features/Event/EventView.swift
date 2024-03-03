//
//  EventView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-02.
//

import SwiftUI
import EventKitUI

struct EventEditViewController: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var notificationStore: NotificationStore
	@EnvironmentObject var propertyStore: PropertyStore

	typealias UIViewControllerType = EKEventEditViewController
	
	let group: PropertyBookingGroup
	var onDismiss: () -> Void
	
	private let store = EKEventStore()
	private var event: EKEvent {
		let event = EKEvent(eventStore: store)
		event.title = "FriendBNB Booking"
		event.startDate = group.booking.start
		event.endDate = group.booking.end
		event.location = group.property.location.formattedAddress
		// event.notes = "NOTES"
		// event.url = URL(string: "FriendBNB://booking=\(group.booking.id)-\(group.property.id)")!
		return event
	}
	
	func makeUIViewController(context: Context) -> EKEventEditViewController {
		let eventEditViewController = EKEventEditViewController()
		eventEditViewController.event = event
		eventEditViewController.eventStore = store
		eventEditViewController.editViewDelegate = context.coordinator
		return eventEditViewController
	}
	
	func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}
	
	class Coordinator: NSObject, EKEventEditViewDelegate {
		var parent: EventEditViewController
		
		init(_ controller: EventEditViewController) {
			self.parent = controller
		}
		
		@MainActor func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
			if action == .saved {
				parent.notificationStore.pushNotification(message: "Added to calendar", dismissable: true)
			}
			parent.onDismiss()
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}

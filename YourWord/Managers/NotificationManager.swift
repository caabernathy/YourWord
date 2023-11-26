//
//  NotificationManager.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/25/23.
//

import Foundation
import UserNotifications

class NotificationManager {
  enum NotificationConstants {
    static let dailyNotificationName = "memorizeDay"
  }

  static let shared = NotificationManager()

  private init() {}

  func requestAuthorization() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        self.scheduleDailyNotifications()
      }
    }
  }

  private func scheduleDailyNotifications() {
    for day in 1...7 { // 1 for Sunday, 2 for Monday, ..., 7 for Saturday
      scheduleNotification(for: day)
    }
  }

  private func scheduleNotification(for day: Int) {
    let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    // Guard to check if the day index is within the valid range
    guard day >= 1 && day <= 7 else {
      print("Invalid day value: \(day). Day must be between 1 and 7.")
      return
    }

    let center = UNUserNotificationCenter.current()

    // Configure the recurring date.
    var dateComponents = DateComponents()
    dateComponents.weekday = day // 1 for Sunday, 2 for Monday, etc.
    dateComponents.hour = 9  // 9 am
//    dateComponents.minute = 11

    // Create the trigger as a repeating event.
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    // Create the content for the notification
    let content = UNMutableNotificationContent()
    content.title = "Your Daily Word"
    content.body = "Check out the memorization passage for \(weekdays[day - 1])."
    content.userInfo = ["day": day]

    // Create the request
    let request = UNNotificationRequest(identifier: "\(NotificationConstants.dailyNotificationName)-\(day)", content: content, trigger: trigger)

    // Schedule the request with the system.
    center.add(request) { (error) in
      if let error = error {
        // Handle any errors.
        print("Error scheduling notification: \(error)")
      }
    }
  }
}

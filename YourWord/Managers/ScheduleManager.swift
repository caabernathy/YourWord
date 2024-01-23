/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@Observable class ScheduleManager {
  enum ScheduleConstants {
    static let contentRefreshDate = "contentRefreshDate"
  }

  var currentDayOfWeek = Calendar.current.component(.weekday, from: Date())
  private var contentRefreshDate: Date?

  static let shared = ScheduleManager()

  private init() {
    load()
  }

  private func load() {
    contentRefreshDate = UserDefaults.standard.object(forKey: ScheduleConstants.contentRefreshDate) as? Date ?? ScheduleManager.calculateStartOfNextWeek(from: Date())
  }

  private static func calculateStartOfNextWeek(from date: Date) -> Date {
    let calendar = Calendar.current
    let dayOfWeek = calendar.component(.weekday, from: date)

    // Calculate days until next week's Sunday
    let daysTillNextWeek = dayOfWeek == 1 ? 7 : (8 - dayOfWeek) // If today is Sunday, set 7 days, else calculate remaining days
    let nextWeekSunday = calendar.date(byAdding: .day, value: daysTillNextWeek, to: date)!

    // Adjust the date to start at midnight
    let startOfNextWeek = calendar.startOfDay(for: nextWeekSunday)
    UserDefaults.standard.set(startOfNextWeek, forKey: ScheduleConstants.contentRefreshDate)
    return startOfNextWeek
  }

  func updateCheck() -> Bool {
    let today = Date()
    let newDayOfWeek = Calendar.current.component(.weekday, from: today)

    // Check if the day of the week has changed
    if newDayOfWeek != currentDayOfWeek {
      currentDayOfWeek = newDayOfWeek
    }

    // Check if today's date is the same as or after the content refresh date
    if let refreshDate = contentRefreshDate,
       today >= refreshDate {
      contentRefreshDate = ScheduleManager.calculateStartOfNextWeek(from: today)
      return true
    }
    return false
  }
}

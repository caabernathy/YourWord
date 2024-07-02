/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@Observable class SettingsManager {
  enum SettingsKeys: String {
    case notificationTime, bibleVersion, dailyRevealOverride
  }

  var preferredNotificationTime: Date?

  var preferredBibleVersion: BibleVersion?

  var dailyRevealOverride: Bool?

  static let shared = SettingsManager()

  private init() {
    load()
  }

  func load() {
    preferredNotificationTime = UserDefaults.standard.object(forKey: SettingsKeys.notificationTime.rawValue) as? Date ?? defaultDate()
    preferredBibleVersion = BibleVersion(rawValue: UserDefaults.standard.string(forKey: SettingsKeys.bibleVersion.rawValue) ?? BibleVersion.NIV.rawValue) ?? .NIV
    dailyRevealOverride = UserDefaults.standard.object(forKey: SettingsKeys.dailyRevealOverride.rawValue) as? Bool ?? false
  }

  func updateBibleVersion(_ version: BibleVersion) {
    preferredBibleVersion = version
  }

  func updateNotificationTime(_ date: Date) {
    preferredNotificationTime = date
  }

  func updateDailyRevealOverride(_ value: Bool) {
    dailyRevealOverride = value
  }

  func defaultDate() -> Date {
    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    components.hour = 9
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
  }
}

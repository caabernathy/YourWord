//
//  Settings.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/26/23.
//

import Foundation

@Observable class SettingsManager {
  enum SettingsKeys: String {
    case notificationTime, bibleTranslation
  }

  enum BibleTranslation: String, CaseIterable, Identifiable {
    case NIV, KJV, ESV, NRSV

    var id: Self { self }
  }

  var preferredNotificationTime: Date?

  var preferredBibleTranslation: BibleTranslation?

  static let shared = SettingsManager()

  private init() {}

  func load() {
    preferredNotificationTime = UserDefaults.standard.object(forKey: SettingsKeys.notificationTime.rawValue) as? Date ?? Date()
    preferredBibleTranslation = BibleTranslation(rawValue: UserDefaults.standard.string(forKey: SettingsKeys.bibleTranslation.rawValue) ?? BibleTranslation.NIV.rawValue) ?? .NIV
  }

  func defaultDate() -> Date {
    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    components.hour = 9
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
  }
}

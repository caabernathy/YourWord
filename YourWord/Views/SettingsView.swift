/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct SettingsView: View {
  @AppStorage(SettingsManager.SettingsKeys.notificationTime.rawValue) private var preferredNotificationTime: Date = SettingsManager.shared.defaultDate()
  @AppStorage(SettingsManager.SettingsKeys.bibleVersion.rawValue) var preferredBibleVersion: BibleVersion = .NIV
  @AppStorage(SettingsManager.SettingsKeys.dailyRevealOverride.rawValue) var dailyRevealOverride: Bool = false

  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("Notifications")) {
          DatePicker("Daily Notification Time", selection: $preferredNotificationTime, displayedComponents: .hourAndMinute)
            .onChange(of: preferredNotificationTime) {
              updateNotification()
            }
        }

        Section(header: Text("Bible Version")) {
          Picker("Select Version", selection: $preferredBibleVersion) {
            ForEach(BibleVersion.allCases, id: \.self) { version in
              Text(version.rawValue)
                .tag(version)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
          .onChange(of: preferredBibleVersion) {
            updateBibleVersion()
          }
        }

        Section(header: Text("Daily Memorization")) {
          Toggle("Show All Days", isOn: $dailyRevealOverride)
            .onChange(of: dailyRevealOverride) {
              updateDailyRevealOverride()
            }
          Text("Controls your memorization experience. Gives you the option to view the entire week's Bible verses or discover them daily.")
            .font(.caption)
        }
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Settings")
            .font(.headline)
            .foregroundColor(.primary)
        }
      }
    }
  }

  private func updateNotification() {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: preferredNotificationTime)
    if let hour = components.hour,
       let minute = components.minute {
      NotificationManager.shared.configureUserNotifications(hour: hour, minute: minute)
    }
  }

  private func updateBibleVersion() {
    SettingsManager.shared.updateBibleVersion(preferredBibleVersion)
  }

  private func updateDailyRevealOverride() {
    SettingsManager.shared.updateDailyRevealOverride(dailyRevealOverride)
  }
}

#Preview {
  SettingsView()
}

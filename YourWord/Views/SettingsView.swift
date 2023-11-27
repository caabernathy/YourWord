/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct SettingsView: View {
  @AppStorage(SettingsManager.SettingsKeys.notificationTime.rawValue) private var preferredNotificationTime: Date = SettingsManager.shared.defaultDate()
  @AppStorage(SettingsManager.SettingsKeys.bibleTranslation.rawValue) var preferredBibleTranslation: BibleTranslation = .NIV

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Notifications")) {
          DatePicker("Daily Notification Time", selection: $preferredNotificationTime, displayedComponents: .hourAndMinute)
            .onChange(of: preferredNotificationTime) {
              updateNotification()
            }
        }

        Section(header: Text("Bible Translation")) {
          Picker("Select Translation", selection: $preferredBibleTranslation) {
            ForEach(BibleTranslation.allCases, id: \.self) { translation in
              Text(translation.rawValue)
                .tag(translation)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
          .onChange(of: preferredBibleTranslation) {
            updateBibleTranslation()
          }
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

  private func updateBibleTranslation() {
    SettingsManager.shared.updateBibleTranslation(preferredBibleTranslation)
  }
}

#Preview {
  SettingsView()
}

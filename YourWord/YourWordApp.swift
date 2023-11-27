/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import SwiftData

@main
struct YourWordApp: App {
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  let notificationManager = NotificationManager.shared

  var body: some Scene {
    WindowGroup {
      MainTabView()
        .onAppear {
          notificationManager.configureUserNotifications()
        }
    }
    .modelContainer(sharedModelContainer)
  }
}

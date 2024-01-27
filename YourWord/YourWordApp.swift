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
  @State private var onboardingManager = OnboardingManager()
  let notificationManager = NotificationManager.shared

  var body: some Scene {
    WindowGroup {
      if onboardingManager.hasCompletedOnboarding {
        MainTabView()
          .onAppear {
            notificationManager.configureUserNotifications()
          }
      } else {
        OnboardingView()
          .environment(onboardingManager)
      }
    }
    .modelContainer(sharedModelContainer)
  }
}

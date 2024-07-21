/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import SwiftData

struct MainTabView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.scenePhase) private var scenePhase

  @Query(ScriptureManager.currentScriptureFetchDescriptor) private var currentScriptures: [Scripture]
  var currentSystemScripture: Scripture? {
    return currentScriptures.first { $0.source == .system || $0.source == nil }
  }

  @SceneStorage("MainTabView.SelectedTab") private var selectedTab: Int = 1
  let shouldSwitchToHomeTab = NotificationManager.shared.shouldSwitchToHomeTab

  var body: some View {
    TabView(selection: $selectedTab) {

      ScripturesListView()
        .tabItem {
          Label("Review", systemImage: "checkmark.rectangle.stack.fill")
        }
        .tag(0)

      ScriptureRevealView()
        .tabItem {
          Label("Memorize", systemImage: "book.fill")
        }
        .tag(1)

      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gearshape.fill")
        }
        .tag(2)
    }
    .onChange(of: shouldSwitchToHomeTab) {
      if shouldSwitchToHomeTab {
        selectedTab = 1
      }
    }
    .onChange(of: scenePhase) { oldPhase, newPhase in
      switch newPhase {
      case .active:
        // Set up the closure that is run whenever
        // a new day starts
        ScheduleManager.shared.onMidnightRefresh = {
          self.markScriptureAsCompleted()
        }
        // Check if the day of week and new week needs updating
        let refreshScripture = ScheduleManager.shared.checkDailyRefresh()
        if refreshScripture {
          self.markScriptureAsCompleted()
        }
        // Start the midnight refresh chack
        ScheduleManager.shared.scheduleMidnightRefresh()
      case .inactive, .background:
        // Stop the midnight refresh check
        ScheduleManager.shared.cancelScheduledRefresh()
      @unknown default:
        break
      }
    }
  }

  private func markScriptureAsCompleted() {
    if let systemScripture = currentSystemScripture {
      withAnimation(.smooth) {
        systemScripture.completed = true
      }
    }
  }
}

#Preview("No Scriptures") {
  MainTabView()
    .modelContainer(emptyPreviewContainer)
}

#Preview("Scriptures") {
  MainTabView()
    .modelContainer(previewContainer)
}

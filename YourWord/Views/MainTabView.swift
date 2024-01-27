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

  static var currentScriptureFetchDescriptor: FetchDescriptor<Scripture> {
    var descriptor = FetchDescriptor<Scripture>(
      predicate: #Predicate<Scripture> { !$0.completed },
      sortBy: [SortDescriptor(\Scripture.createdAt, order: .forward)])
    descriptor.fetchLimit = 1
    return descriptor
  }

  @Query(currentScriptureFetchDescriptor) private var currentScripture: [Scripture]

  @Query(filter: #Predicate<Scripture> { $0.completed },
         sort: \Scripture.createdAt, order: .forward) private var completedScriptures: [Scripture]

  @SceneStorage("MainTabView.SelectedTab") private var selectedTab: Int = 1
  @State private var savedScriptures: [Scripture] = []
  let shouldSwitchToHomeTab = NotificationManager.shared.shouldSwitchToHomeTab

  var body: some View {
    TabView(selection: $selectedTab) {

      ScripturesListView(scriptures: completedScriptures)
        .tabItem {
          Label("Review", systemImage: "checkmark.rectangle.stack.fill")
        }
        .tag(0)

      ScriptureRevealView(scriptures: currentScripture)
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
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
      handleScriptureSchedule()
    }
  }

  private func handleScriptureSchedule() {
    // Check if the day and scripture needs to be updated
    let refrshScripture = ScheduleManager.shared.updateCheck()
    if refrshScripture && currentScripture.count > 0 {
      // Mark the scripture as complete
      withAnimation(.smooth) {
        currentScripture[0].completed = true
      }
    }
  }
}

#Preview {
  MainTabView()
}

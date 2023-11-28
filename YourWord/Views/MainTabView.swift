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
  @Query(sort: \Scripture.createdDate, order: .forward) private var scriptures: [Scripture]

  @SceneStorage("MainTabView.SelectedTab") private var selectedTab: Int = 1
  @State private var savedScriptures: [Scripture] = []

  var body: some View {
    TabView(selection: $selectedTab) {

      ScripturesListView(scriptures: Array(scriptures.dropFirst()))
        .tabItem {
          Label("Favorites", systemImage: "heart.fill")
        }
        .tag(0)

      ScriptureRevealView(scriptures: scriptures)
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
  }
}

#Preview {
  MainTabView()
}

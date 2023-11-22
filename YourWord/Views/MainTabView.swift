//
//  ContentView.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/21/23.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Scripture.createdDate, order: .forward) private var scriptures: [Scripture]

  @State private var selectedTab: Int = 1 // Default to the MemorizeView tab
  @State private var savedScriptures: [Scripture] = []

  var body: some View {
    TabView(selection: $selectedTab) {

      ScripturesListView(scriptures: Array(scriptures.dropFirst()))
        .tabItem {
          Label("Favorites", systemImage: "heart.fill")
        }
        .tag(0)

      Group {
        if scriptures.count > 0 {
          MemorizeView(scripture: scriptures[0], isDailyReveal: true)
        } else {
          Text("There are no scriptures to memorize at this time")
            .padding()
        }
      }
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

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

  @SceneStorage("MainTabView.SelectedTab") private var selectedTab: Int = 1
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
          NavigationView {
            MemorizeView(scripture: scriptures[0], isDailyReveal: true)
              .toolbar {
                ToolbarItem(placement: .principal) {
                  Text("Your Daily Word")
                    .font(.headline)
                    .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                  Button(action: shareAction) {
                    Image(systemName: "square.and.arrow.up")
                  }
                }
              }
          }
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

  private func shareAction() {
    // Define the share action here
    print("Share button tapped")
  }
}

#Preview {
  MainTabView()
}

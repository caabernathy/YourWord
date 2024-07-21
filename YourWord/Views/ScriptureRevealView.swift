/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureRevealView: View {
  let shareURL = URL(string: "https://app.malachidaily.com/")!

  @State private var isDailyReveal = true
  @State private var currentView: ScriptureSource = .system

  var body: some View {
    NavigationStack {
      Group {
        if currentView == .system {
          PresetMemorizeView()
        } else {
          CustomMemorizeView()
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarLeading) {
          ToolbarLinkView(
            text: "Daily Word",
            isSelected: currentView == .system) {
              linkTapped(for: .system)
            }
          ToolbarLinkView(
            text: "Your Verses",
            isSelected: currentView == .userDefined) {
              linkTapped(for: .userDefined)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          ShareLink("Share", item: shareURL)
        }
      }
    }
  }

  private func linkTapped(for view: ScriptureSource) {
    withAnimation(.easeInOut(duration: 0.2)) {
      currentView = view
    }
  }
}

#Preview("No Scripture") {
  ScriptureRevealView()
    .emptyPreviewContainer()
}

#Preview("Scripture") {
  ScriptureRevealView()
    .previewContainer()
}

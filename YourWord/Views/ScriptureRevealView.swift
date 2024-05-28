/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureRevealView: View {
  enum LinkViews {
    case preset
    case custom
  }

  var scriptures: [Scripture]
//  @ViewBuilder var dailyView: () -> Group<Any>

  let shareURL = URL(string: "https://app.malachidaily.com/")!

  @State private var isDailyReveal = true
  @State private var currentView: LinkViews = .preset


//  init(scriptures: [Scripture]) {
//    self.scriptures = scriptures
//  }

  var body: some View {
    NavigationStack {
      Group {
        if currentView == .preset {
          Group {
            if scriptures.count > 0 {
              MemorizeView(scripture: scriptures[0], isDailyReveal: true)
            } else {
              Text("There are no scriptures to memorize at this time")
                .padding()
            }
          }
        } else {
          CustomMemorizeView()
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarLeading) {
          ToolbarLinkView(
            text: "Daily Word",
            isSelected: currentView == .preset) {
              linkTapped(for: .preset)
            }
          ToolbarLinkView(
            text: "Your Verses",
            isSelected: currentView == .custom) {
              linkTapped(for: .custom)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          ShareLink("Share", item: shareURL)
        }
      }
    }
  }

  private func linkTapped(for view: LinkViews) {
    withAnimation(.easeInOut(duration: 0.2)) {
      currentView = view
    }
  }
}

#Preview {
  ScriptureRevealView(scriptures: []) //PreviewData.scriptures
}

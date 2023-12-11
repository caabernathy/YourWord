/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureRevealView: View {
  var scriptures: [Scripture]

  let shareURL = URL(string: "https://app.malachidaily.com/")!

  var body: some View {
    Group {
      if scriptures.count > 0 {
        NavigationStack {
          MemorizeView(scripture: scriptures[0], isDailyReveal: true)
            .toolbar {
              ToolbarItem(placement: .principal) {
                Text("Your Daily Word")
                  .font(.headline)
                  .foregroundColor(.primary)
              }
              ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink("Share", item: shareURL)
              }
            }
        }
      } else {
        Text("There are no scriptures to memorize at this time")
          .padding()
      }
    }
  }
}

#Preview {
  ScriptureRevealView(scriptures: [])
}

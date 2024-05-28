/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct CustomMemorizeView: View {
  @State private var showScriptureSelector = false
  @State private var scripture: Scripture?

  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV

  var body: some View {
    VStack {
      if let scripture = scripture,
         let scriptureVersion = scripture.version(for: bibleVersion) {
        Text(scriptureVersion.text)
          .font(.headline)
      } else {
        Text("No scripture selected")
          .font(.title)
      }

      Button(action: {
        showScriptureSelector = true
      }) {
        Text("Select Scripture")
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
    }
    .sheet(isPresented: $showScriptureSelector) {
      ScriptureSelectorView(scripture: $scripture, showScriptureSelector: $showScriptureSelector)
    }
  }
}

#Preview {
  CustomMemorizeView()
}

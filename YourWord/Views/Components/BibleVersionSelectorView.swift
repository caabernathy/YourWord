/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct BibleVersionSelectorView: View {
  @AppStorage(SettingsManager.SettingsKeys.bibleVersion.rawValue) var selectedVersion: BibleVersion = .NIV

  var body: some View {
    Picker("Select Version", selection: $selectedVersion) {
      ForEach(BibleVersion.allCases, id: \.self) { version in
        Text(version.rawValue)
          .tag(version)
      }
    }
    .pickerStyle(SegmentedPickerStyle())
    .onChange(of: selectedVersion) {
      onChange()
    }
  }

  private func onChange() {
    SettingsManager.shared.updateBibleVersion(selectedVersion)
  }
}

#Preview {
  BibleVersionSelectorView()
}

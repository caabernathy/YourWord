/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct PresetMemorizeView: View {
  var scripture: Scripture?
  @State private var showToast = false
  @State private var memorizePageIndex: Int = 0

  let pageViewCount = 7

  var body: some View {
    ZStack {
      if let scripture = scripture {
        MemorizeView(scripture: scripture, isDailyReveal: true)
          .onPreferenceChange(PageIndexKey.self) { value in
            memorizePageIndex = value
          }
      } else {
        Text("There are no scriptures to memorize at this time")
          .padding()
      }
      VStack {
        Spacer()
        HStack {
          Spacer()
          if let _ = scripture {
            if memorizePageIndex == (pageViewCount - 1) {
              SaveButtonView() {
                markMemorizationAsCompleted()
              }
            }
          }
        }
      }
    }
    .toast(isPresented: $showToast, message: "New scripture available on Sunday!")
  }

  private func markMemorizationAsCompleted() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      withAnimation {
        showToast.toggle()
      }
    }
  }

}

#Preview("No Scripture") {
  PresetMemorizeView(scripture: nil)
}

#Preview("Scripture") {
  let _ = previewContainer
  let scripture = PreviewData.scriptures[3]
  return PresetMemorizeView(scripture: scripture)
}

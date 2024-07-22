/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import SwiftData

struct PresetMemorizeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(ScriptureManager.currentScriptureFetchDescriptor) private var scriptures: [Scripture]

  var scripture: Scripture? {
    return scriptures.first { $0.source == .system || $0.source == nil }
  }

  @State private var showToast = false
  @State private var toastMessage = ""
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
        Text("There are no scriptures to memorize at this time. Check out previous scriptures in the Review tab.")
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
    .onChange(of: scripture) {
      if scripture != nil {
        toastMessage = "New scripture added! Previous scripture available in the Review tab."
        showToast.toggle()
      }
    }
    .toast(isPresented: $showToast, message: toastMessage)
  }

  private func markMemorizationAsCompleted() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      withAnimation {
        toastMessage = "New scripture available on Sunday!"
        showToast.toggle()
      }
    }
  }

}

#Preview("No Scripture"){
  PresetMemorizeView()
    .emptyPreviewContainer()
}

#Preview("Scripture"){
  PresetMemorizeView()
    .previewContainer()
}

/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureRowView: View {
  @Environment(\.colorScheme) var colorScheme

  let scripture: SearchResultScripture
  let isTapped: Bool

  var highlightColor: Color {
    colorScheme == .dark ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1)
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("\(scripture.passage) \(scripture.translations.first?.name.rawValue ?? "")")
          .font(.headline)
        Text(scripture.translations.first?.text ?? "")
          .font(.subheadline)
          .lineLimit(3)
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      Spacer()
    }
    .background(isTapped ? highlightColor : Color.clear)
    .animation(.easeInOut(duration: 0.3), value: isTapped)
  }
}

#Preview("Off") {
  let _ = previewContainer
  let scriptures = PreviewData.searchResultScriptures
  return ScriptureRowView(scripture: scriptures[0], isTapped: false)
}

#Preview("On") {
  let _ = previewContainer
  let scriptures = PreviewData.searchResultScriptures
  return ScriptureRowView(scripture: scriptures[0], isTapped: true)
}

#Preview("On Long Scripture") {
  let _ = previewContainer
  let scriptures = PreviewData.searchResultScriptures
  return ScriptureRowView(scripture: scriptures[3], isTapped: true)
}

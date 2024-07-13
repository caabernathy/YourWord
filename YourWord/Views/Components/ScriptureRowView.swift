/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureRowView: View {
  let scripture: SearchResultScripture
  let isTapped: Bool
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("\(scripture.passage) \(scripture.translations.first?.name.rawValue ?? "")")
        .font(.headline)
      Text(scripture.translations.first?.text ?? "")
        .font(.subheadline)
        .lineLimit(2)
    }
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(isTapped ? Color.blue.opacity(0.1) : Color.clear)
    )
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


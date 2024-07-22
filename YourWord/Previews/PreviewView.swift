/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct PreviewContainer: ViewModifier {
  func body(content: Content) -> some View {
    content
      .modelContainer(previewContainer)
  }
}

extension View {
  func previewContainer() -> some View {
    self.modifier(PreviewContainer())
  }
}

struct EmptyPreviewContainer: ViewModifier {
  func body(content: Content) -> some View {
    content
      .modelContainer(emptyPreviewContainer)
  }
}

extension View {
  func emptyPreviewContainer() -> some View {
    self.modifier(EmptyPreviewContainer())
  }
}

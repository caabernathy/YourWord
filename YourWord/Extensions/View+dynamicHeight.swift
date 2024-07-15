/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct DynamicHeightModifier: ViewModifier {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass

  var portraitHeight: CGFloat
  var landscapeHeight: CGFloat

  func body(content: Content) -> some View {
    content
      .frame(height: dynamicHeight)
  }

  var dynamicHeight: CGFloat {
    switch (horizontalSizeClass, verticalSizeClass) {
    case (.regular, .regular), (.compact, .regular):
      return portraitHeight
    case (.regular, .compact), (.compact, .compact):
      return landscapeHeight
    case (.none, _):
      return portraitHeight
    case (_, .none):
      return portraitHeight
    @unknown default:
      return portraitHeight
    }
  }
}

extension View {
  func dynamicHeight(portrait: CGFloat, landscape: CGFloat) -> some View {
    self.modifier(DynamicHeightModifier(portraitHeight: portrait, landscapeHeight: landscape))
  }
}

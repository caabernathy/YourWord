/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ToolbarLinkView: View {
  var text: String
  var isSelected: Bool
  var action: () -> Void
  var body: some View {
    Group {
      if isSelected {
        VStack {
          Text(text)
            .font(.system(size: 20, weight: .medium, design: .default))
            .foregroundColor(.primary)
            .padding(.bottom, 5)
        }
        .overlay(Rectangle().frame(height: 2).foregroundColor(.red),
                 alignment: .bottom)
      } else {
        Button(action: action) {
          Text(text)
            .font(.system(size: 16, weight: .medium, design: .default))
            .foregroundColor(.primary)
            .opacity(0.7)
        }
      }
    }
  }
}

#Preview {
  ToolbarLinkView(text: "Click Me", isSelected: false, action: {})
}

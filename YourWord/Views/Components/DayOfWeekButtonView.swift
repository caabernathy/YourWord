/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct DayOfWeekButtonView: View {
  var text: String
  var isActive: Bool
  var buttonAction: () -> Void
  var body: some View {
    Button(action: buttonAction) {
      ZStack {
        Circle()
          .fill(isActive ? Color.blue : Color.gray)
          .frame(width: 30, height: 30)
        Text(text)
          .foregroundColor(.white)
      }
    }
  }
}

#Preview {
  DayOfWeekButtonView(text: "S", isActive: true, buttonAction: {})
}

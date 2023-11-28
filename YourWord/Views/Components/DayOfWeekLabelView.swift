/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct DayOfWeekLabelView: View {
  var text: String
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.white.opacity(0))
        .frame(width: 30, height: 30)
      Text(text)
    }
  }
}

#Preview {
  DayOfWeekLabelView(text: "S")
}

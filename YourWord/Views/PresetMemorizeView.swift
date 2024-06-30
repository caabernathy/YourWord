/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct PresetMemorizeView: View {
  var scripture: Scripture?
  var body: some View {
    Group {
      if let scripture = scripture {
        MemorizeView(scripture: scripture, isDailyReveal: true)
      } else {
        Text("There are no scriptures to memorize at this time")
          .padding()
      }
    }
  }
}

#Preview {
  PresetMemorizeView(scripture: nil)
}

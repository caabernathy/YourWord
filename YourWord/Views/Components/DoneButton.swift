/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
import SwiftUI
import ConfettiSwiftUI

struct DoneButton: View {
  var doneAction: () -> Void
  @State private var counter = 0

  var body: some View {
    Button(action: doneButtonTapped) {
      Text("Mark as Done")
        .font(.system(size: 18, weight: .medium, design: .default))
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .padding()
    }
    .confettiCannon(counter: $counter)
  }

  private func doneButtonTapped() {
    counter += 1
    doneAction()
  }
}

#Preview {
  DoneButton(doneAction: {})
}

/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import ConfettiSwiftUI

struct SaveButtonView: View {
  var saveAction: () -> Void
  @State private var counter = 0
  
  var body: some View {
    Button(action: saveButtonTapped) {
      Image(systemName: "checkmark")
        .font(.title)
        .frame(width: 50, height: 50)
        .background(Color.green)
        .foregroundColor(.white)
        .clipShape(Circle())
        .shadow(radius: 5)
    }
    .padding()
    .confettiCannon(
      counter: $counter,
      confettiSize: 15,
      rainHeight: 800,
      openingAngle: Angle.degrees(90),
      closingAngle: Angle.degrees(150),
      radius: 600.0,
      repetitions: 2,
      repetitionInterval: 0.2
    )
  }

  private func saveButtonTapped() {
    counter += 1
    saveAction()
  }
}

#Preview {
  SaveButtonView(saveAction: {})
}

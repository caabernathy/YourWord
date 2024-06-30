/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct SaveButtonView: View {
  var saveAction: () -> Void
  var body: some View {
    Button(action: saveButtonTapped) {
      Image(systemName: "checkmark")
        .font(.title)
        .frame(width: 60, height: 60)
        .background(Color.green)
        .foregroundColor(.white)
        .clipShape(Circle())
        .shadow(radius: 5)
    }
    .padding()
  }

  private func saveButtonTapped() {
    saveAction()
  }
}

#Preview {
  SaveButtonView(saveAction: {})
}

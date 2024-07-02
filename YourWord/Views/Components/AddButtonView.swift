/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct AddButtonView: View {
  var addAction: () -> Void
  var body: some View {
    Button(action: addButtonTapped) {
      Image(systemName: "plus")
        .font(.title)
        .frame(width: 60, height: 60)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Circle())
        .shadow(radius: 5)
    }
    .padding()
  }

  private func addButtonTapped() {
    addAction()
  }
}

#Preview {
  AddButtonView(addAction: {})
}

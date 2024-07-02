/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct DeleteButtonView: View {
  var deleteAction: () -> Void
  var body: some View {
    Button(action: deleteButtonTapped) {
      Image(systemName: "trash")
        .font(.title)
        .frame(width: 60, height: 60)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .shadow(radius: 5)
    }
    .padding()
  }

  private func deleteButtonTapped() {
    deleteAction()
  }
}

#Preview {
  DeleteButtonView(deleteAction: {})
}

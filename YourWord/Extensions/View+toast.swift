/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

extension View {
  func toast(isPresented: Binding<Bool>, message: String) -> some View {
    self.overlay(
      Group {
        if isPresented.wrappedValue {
          Text(message)
            .padding()
            .background(Color("OverlayBackgroundColor"))
            .foregroundColor(Color("OverlayForegroundColor"))
            .cornerRadius(10)
            .padding()
            .transition(.opacity)
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                  isPresented.wrappedValue = false
                }
              }
            }
        }
      },
      alignment: .bottom
    )
  }
}

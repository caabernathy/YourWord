/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScripturesListView: View {
  var scriptures: [Scripture]
  var body: some View {
    Group {
      if scriptures.isEmpty {
        VStack {
          Spacer()
          Text("No saved scriptures to display.")
            .padding()
          Spacer()
        }
      } else {
        NavigationStack {
          List(scriptures) { scripture in
            NavigationLink(value: scripture) {
              Text(String(describing: scripture.passage))
                .lineLimit(1)
                .truncationMode(.tail)
            }
            .padding()
          }
          .navigationDestination(for: Scripture.self) { scripture in
            MemorizeView(scripture: scripture, isDailyReveal: false)
              .toolbar {
                ToolbarItem(placement: .principal) {
                  Text("Scripture")
                    .font(.headline)
                    .foregroundColor(.primary)
                }
              }
          }
          .navigationTitle("")
          .toolbar {
            ToolbarItem(placement: .principal) {
              Text("Scriptures")
                .font(.headline)
                .foregroundColor(.primary)
            }
          }
        }
      }
    }
  }
}

#Preview {
  ScripturesListView(scriptures: [])
}

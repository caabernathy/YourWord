/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import SwiftData

struct ScripturesListView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(filter: #Predicate<Scripture> { $0.completed },
         sort: \Scripture.createdAt, order: .reverse) private var scriptures: [Scripture]

  var body: some View {
    Group {
      if scriptures.isEmpty {
        VStack {
          Spacer()
          Text("No completed scriptures to display.")
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

#Preview("No Scriptures") {
  ScripturesListView()
    .emptyPreviewContainer()
}

#Preview("Scriptures") {
  ScripturesListView()
    .previewContainer()
}

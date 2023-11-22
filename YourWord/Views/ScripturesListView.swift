//
//  ScripturesListView.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/21/23.
//

import SwiftUI

struct ScripturesListView: View {
  var scriptures: [Scripture]
  var body: some View {
    Group {
      if scriptures.isEmpty {
        VStack {
          Spacer()
          if scriptures.isEmpty {
            Text("No saved scriptures to display.")
              .padding()
          }
          Spacer()
        }
      } else {
        NavigationStack {
          List(scriptures) { scripture in
            NavigationLink(value: scripture) {
              Text(scripture.text)
                .lineLimit(1)
                .truncationMode(.tail)
            }
          }
          .navigationDestination(for: Scripture.self) { scripture in
            MemorizeView(scripture: scripture, isDailyReveal: false)
          }
          .navigationTitle("Scriptures")
        }
      }
    }
  }
}

#Preview {
  ScripturesListView(scriptures: [])
}

//
//  ScriptureView.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import SwiftUI

struct ScriptureView: View {
  var text: String
  var source: String

  var body: some View {
    VStack(alignment: .leading) {
      Text(text)
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        .padding()
      Text(source)
        .padding()
    }
    .padding()
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.gray, lineWidth: 1)
    )
  }
}

#Preview {
  ScriptureView(text: "Thy word is a lamp unto my feet, and a light unto my path.", source: "Psalm 119:105 KJV")
}

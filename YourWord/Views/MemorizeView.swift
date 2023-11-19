//
//  MemorizeView.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import SwiftUI
import NotificationCenter

struct MemorizeView: View {
  let viewModel: ScriptureViewModel
  @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void

  @State private var dragOffset: CGFloat = 0

  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()

        // Content
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 0) {
            ForEach(0..<viewModel.memoryTexts.count, id: \.self) { index in
              ScriptureView(text: viewModel.memoryTexts[index], source: viewModel.memorySources[index])
                .padding()
                .frame(width: geometry.size.width)
            }
          }
        }
        .content.offset(x: (CGFloat(viewModel.currentIndex) * -geometry.size.width) + dragOffset)
        .frame(width: geometry.size.width, alignment: .leading)
        .gesture(
          DragGesture().onChanged { value in
            dragOffset = value.translation.width
          }
            .onEnded { value in
              withAnimation(.smooth) {
                let offset = value.translation.width
                let newIndex = (CGFloat(viewModel.currentIndex) - (offset / geometry.size.width)).rounded()
                let nextIndex = min(max(Int(newIndex), 0), viewModel.memoryTexts.count - 1)
                viewModel.updateView(index: nextIndex)
                dragOffset = 0
              }
            }
        )
        .animation(.spring(), value: dragOffset)

        // Pagination
        HStack(spacing: 8) {
          ForEach(0..<viewModel.memoryTexts.count, id: \.self) { index in
            ZStack {
              Circle()
                .fill(viewModel.currentIndex == index ? Color.blue : Color.gray)
                .frame(width: 30, height: 30)
              Text(viewModel.paginationLabel(for: index))
                .foregroundColor(.white)
            }
          }
          ForEach(viewModel.memoryTexts.count..<viewModel.pageViewCount, id: \.self) { index in
            ZStack {
              Circle()
                .fill(Color.white.opacity(0))
                .frame(width: 30, height: 30)
              Text(viewModel.paginationLabel(for: index))
            }
          }
        }
        .padding(.top, 10)

        Spacer()
      }
    }
    .onChange(of: scenePhase) {
      if scenePhase == .inactive { saveAction() }
    }
  }
}

//
//  HorizontalScrollView.swift
//  SwiftUIStylebook
//
//  Created by shun uematsu on 2024/07/19.
//

import SwiftUI

struct HorizontalScrollView<Data, ID, Content, Header, Footer>: View
where
  Data: RandomAccessCollection,
  ID: Hashable,
  Content: View,
  Header: View,
  Footer: View
{
  private let data: Data
  private let id: KeyPath<Data.Element, ID>
  private let content: (Data.Element) -> Content
  private let header: (() -> Header)?
  private let footer: (() -> Footer)?

  init(
    data: Data,
    id: KeyPath<Data.Element, ID>,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) where Header == EmptyView, Footer == EmptyView {
    self.data = data
    self.id = id
    self.content = content
    self.header = nil
    self.footer = nil
  }

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 16) {
        header?()
        ForEach(data, id: id) { content($0) }
        footer?()
      }
      .padding(.horizontal, 16)
    }
  }
}

extension HorizontalScrollView {
  init(
    data: Data,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) where Data.Element: Identifiable, ID == Data.Element.ID, Header == EmptyView, Footer == EmptyView {
    self.data = data
    self.id = \.id
    self.content = content
    self.header = nil
    self.footer = nil
  }

  init(
    data: Data,
    id: KeyPath<Data.Element, ID>,
    @ViewBuilder content: @escaping (Data.Element) -> Content,
    @ViewBuilder header: @escaping () -> Header
  ) where Footer == EmptyView {
    self.data = data
    self.id = id
    self.content = content
    self.header = header
    self.footer = nil
  }

  init(
    data: Data,
    @ViewBuilder content: @escaping (Data.Element) -> Content,
    @ViewBuilder header: @escaping () -> Header
  ) where Data.Element: Identifiable, ID == Data.Element.ID, Footer == EmptyView {
    self.data = data
    self.id = \.id
    self.content = content
    self.header = header
    self.footer = nil
  }

  init(
    data: Data,
    id: KeyPath<Data.Element, ID>,
    @ViewBuilder content: @escaping (Data.Element) -> Content,
    @ViewBuilder footer: @escaping () -> Footer
  ) where Header == EmptyView {
    self.data = data
    self.id = id
    self.content = content
    self.header = nil
    self.footer = footer
  }

  init(
    data: Data,
    @ViewBuilder content: @escaping (Data.Element) -> Content,
    @ViewBuilder footer: @escaping () -> Footer
  ) where Data.Element: Identifiable, ID == Data.Element.ID, Header == EmptyView {
    self.data = data
    self.id = \.id
    self.content = content
    self.header = nil
    self.footer = footer
  }

  init(
    data: Data,
    id: KeyPath<Data.Element, ID>,
    @ViewBuilder content: @escaping (Data.Element) -> Content,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder footer: @escaping () -> Footer
  ) {
    self.data = data
    self.id = id
    self.content = content
    self.header = header
    self.footer = footer
  }

  init(
    data: Data,
    @ViewBuilder content: @escaping (Data.Element) -> Content,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder footer: @escaping () -> Footer
  ) where Data.Element: Identifiable, ID == Data.Element.ID {
    self.data = data
    self.id = \.id
    self.content = content
    self.header = header
    self.footer = footer
  }
}

// MARK: - Preview

#Preview {
  ScrollView {
    VStack(spacing: 24) {
      HorizontalScrollView(data: HorizontalItem.fakes) {
        Text($0.id)
      }

      HorizontalScrollView(data: horizontalImages, id: \.self) {
        Image(systemName: $0)
      } header: {
        Button {

        } label: {
          Image(systemName: "photo.artframe")
        }
      } footer: {
        Button {

        } label: {
          Image(systemName: "plus.circle")
        }
      }
    }
  }
}

// MARK: - Sample data

struct HorizontalItem: Identifiable {
  var id: String
}

extension HorizontalItem {
  static let fakes: [Self] = [
    .init(id: "AAAAA"),
    .init(id: "BBBBB"),
    .init(id: "CCCCC"),
    .init(id: "DDDDD"),
  ]
}

let horizontalImages: [String] = [
  "flag.checkered",
  "flag.2.crossed.fill",
  "arcade.stick.console",
  "arcade.stick",
  "arcade.stick.and.arrow.left.and.arrow.right",
  "arcade.stick.and.arrow.left",
  "arcade.stick.and.arrow.right",
  "arcade.stick.and.arrow.up.and.arrow.down",
  "arcade.stick.and.arrow.up",
  "gamecontroller",
  "house",
]

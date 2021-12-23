import SwiftUI

fileprivate struct Padding {
  static var small: CGFloat = 8
}

fileprivate extension Image {
  static let chevronDown = Self(systemName: "chevron.down")
  static let chevronUp = Self(systemName: "chevron.up")
}

struct Keyword: Identifiable, Hashable {
  var id: String { name }
  var name: String
  var children: [Keyword]?

  static let samples: [Keyword] = [
    .init(name: "1", children: [.init(name: "1-1", children: [.init(name: "1-1-1", children: nil), .init(name: "1-1-2", children: nil), .init(name: "1-1-3", children: nil)]), .init(name: "1-2", children: [.init(name: "1-2-1", children: nil)])]),
    .init(name: "2", children: [.init(name: "2-1", children: nil)]),
    .init(name: "3", children: [.init(name: "3-1", children: nil)]),
  ]
}

struct AccordionView<Data, RowContent>: View where
  Data : RandomAccessCollection,
  Data.Element: Identifiable,
  Data.Element: Equatable,
  RowContent: View
{
  @State private var openedNodes: [Data.Element] = []

  var data: Data
  var children: KeyPath<Data.Element, Data?>
  var leadingPadding: CGFloat
  var selection: (Data.Element) -> ()
  var rawContent: (Data.Element) -> RowContent

  init(
    _ data: Data,
    children: KeyPath<Data.Element, Data?>,
    leadingPadding: CGFloat = Padding.small,
    selection: @escaping (Data.Element) -> (),
    @ViewBuilder rawContent: @escaping (Data.Element) -> RowContent
  ) {
    self.data = data
    self.children = children
    self.leadingPadding = leadingPadding
    self.selection = selection
    self.rawContent = rawContent
  }

  var body: some View {
    VStack(spacing: Padding.small) {
      ForEach(data) { item in
        HStack {
          rawContent(item)
            .onTapGesture {
              selection(item)
            }
            .padding(.leading, leadingPadding)
            .frame(maxWidth: .infinity, alignment: .leading)

          if let _ = item[keyPath: children] {
            Button {
              withAnimation {
                if openedNodes.contains(item) {
                  if let index = openedNodes.firstIndex(of: item) {
                    openedNodes.remove(at: index)
                  }
                } else {
                  openedNodes.append(item)
                }
              }
            } label: {
              openedNodes.contains(item)
                ? Image.chevronUp.padding(.trailing, Padding.small)
                : Image.chevronDown.padding(.trailing, Padding.small)
            }
            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)))
          }
        }
        .padding(.bottom, item[keyPath: children] == nil ? Padding.small : 0)

        if let _ = item[keyPath: children] {
          Divider()
            .padding(.leading, leadingPadding)
        }

        if let child = item[keyPath: children], openedNodes.contains(item)
        {
          AccordionView(
            child,
            children: children,
            leadingPadding: self.leadingPadding + Padding.small,
            selection: { self.selection($0) }
          ) { item in
            rawContent(item)
          }
        }
      }
    }
  }
}

struct AccordionView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AccordionView(
        Keyword.samples,
        children: \.children,
        selection: { _ in }
      ) { item in
        Text(item.name)
      }
    }
  }
}

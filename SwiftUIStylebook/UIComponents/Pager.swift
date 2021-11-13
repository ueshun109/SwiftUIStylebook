import SwiftUI

struct Pager: View {
  @State var currentPageIndex = 0
  
  let itemNames = [
    "Yesterday",
    "Today",
    "Tomorrow",
    "Day after tomorrow",
  ]
  
  var body: some View {
    VStack {
      TabLayout(
        currentIndex: $currentPageIndex,
        itemNames: itemNames
      ) { index in
        currentPageIndex = index
      }
      
      TabView(selection: $currentPageIndex) {
        ForEach(itemNames.indices) { index in
          Text("Index is \(index)")
        }
      }
      .tabViewStyle(.page)
      .animation(.default, value: currentPageIndex)
    }
  }
}

struct TabLayout: View {
  private struct Const {
    static var tabHeight: CGFloat = 48
    static var indicatorHeight: CGFloat = 3
    static var indicatorOffset: CGFloat { tabHeight / 2 - indicatorHeight }
    static var dividerHeight: CGFloat = 0.5
    static var dividerOffset: CGFloat { tabHeight / 2 - dividerHeight }
  }
  
  @Binding var selectedIndex: Int
  @State var names: [String]
  @State private var frames: [CGRect]
  var tappedTab: (Int) -> Void
  
  init(
    currentIndex: Binding<Int>,
    itemNames: [String],
    tappedTab: @escaping (Int) -> Void
  ) {
    self.names = itemNames
    self.tappedTab = tappedTab
    self.frames = Array<CGRect>(repeating: .zero, count: itemNames.count)
    self._selectedIndex = currentIndex
  }
    
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      ScrollViewReader { proxy in
        HStack(spacing: 24) {
          ForEach(names.indices, id: \.self) { index in
            PageTabItem(
              name: names[index],
              index: index,
              selectedIndex: $selectedIndex
            ) { index in
              selectedIndex = index
              tappedTab(index)
              
              withAnimation {
                proxy.scrollTo(selectedIndex, anchor: .trailing)
              }
            }
            .frame(height: Const.tabHeight)
            .background(
              GeometryReader { reader in
                Color.clear.onAppear {
                  frames[index] = reader.frame(in: .global)
                }
              }
            )
          }
        }
        .onChange(of: selectedIndex) { target in
          withAnimation {
            proxy.scrollTo(target, anchor: .trailing)
          }
        }
        .background(
          RoundedRectangle(cornerRadius: 1, style: .continuous)
            .foregroundColor(.gray)
            .frame(
              width: frames[selectedIndex].width,
              height: Const.indicatorHeight,
              alignment: .topLeading
            )
            .offset(
              x: frames[selectedIndex].minX - frames.first!.minX,
              y: Const.indicatorOffset
            ),
          alignment: .leading
        )
        .padding(.horizontal, 32)
        .background(
          RoundedRectangle(cornerRadius: 1, style: .continuous)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
            .frame(
              height: Const.dividerHeight
            )
            .offset(
              y: Const.dividerOffset
            ),
          alignment: .leading
        )
      }
    }
    .animation(.default, value: selectedIndex)
    .padding(.horizontal, -16)
  }
}

struct PageTabItem: View {
  var name: String
  var index: Int
  @Binding var selectedIndex: Int
  var tappedTab: (Int) -> Void
  
  var body: some View {
    Button {
      tappedTab(index)
    } label: {
      Text(name)
    }
    .foregroundColor(index == selectedIndex ? .black : .gray)
  }
}

struct Pager_Previews: PreviewProvider {
  @State static var currentIndex = 1
  static var previews: some View {
    Pager()
  }
}

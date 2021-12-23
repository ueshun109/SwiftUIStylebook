import SwiftUI

struct OffsetYPreferenceKey: PreferenceKey {
  typealias Value = [CGFloat]
  
  static var defaultValue: [CGFloat] = []
  
  static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
    value.append(contentsOf: nextValue())
  }
}

struct CoordinatorLayout: View {
  @State private var height: CGFloat = 100
  private var header: some View {
    Rectangle()
      .fill(Color.blue.opacity(height / 100))
      .frame(height: 50)
  }
  
  var body: some View {
    VStack {
      Rectangle()
        .fill(Color.red.opacity(height / 100))
        .frame(height: self.height)
      
      ScrollView {
        GeometryReader { proxy in
          Color.clear
            .preference(
              key: OffsetYPreferenceKey.self,
              value: [proxy.frame(in: .named("scroll")).minY]
            )
        }
        LazyVStack {
          Color.clear
            .onAppear {

            }
          ForEach(0..<100) { index in
            Text("index is \(index)")
          }
          Color.clear
            .onAppear {
            }
        }
      }
      .coordinateSpace(name: "scroll")
      .onPreferenceChange(OffsetYPreferenceKey.self) { value in
        if value.first ?? 0 < -10 {
          withAnimation {
            height = 0
          }
        }
        if value.first ?? 0 > 0 {
          withAnimation {
            height = 100
          }
        }
        print(value.first ?? 0)
//        if value.first ?? 0 < 200 {
//          if self.height > 0 {
//            self.height -= 1
//          }
//        } else {
//          if self.height <= 100 {
//            self.height += 1
//          }
//        }
        
      }
      Slider(value: $height, in: CGFloat(0)...CGFloat(100))
    }
  }
}

struct CoordinatorLayout_Previews: PreviewProvider {
  static var previews: some View {
    CoordinatorLayout()
  }
}

//import SwiftUI
//
//struct AnchorPreferenceDataAnchor {
//  let idx: Int
//  let bounds2: Anchor<CGRect>
//}
//
//struct MyPreferenceKey: PreferenceKey {
//  typealias Value = [AnchorPreferenceDataAnchor]
//
//  static var defaultValue: [AnchorPreferenceDataAnchor] = []
//
//  static func reduce(value: inout [AnchorPreferenceDataAnchor], nextValue: () -> [AnchorPreferenceDataAnchor]) {
//    value.append(contentsOf: nextValue())
//  }
//}
//
//struct PreferenceData: Equatable {
//  let idx: Int
//  var rect: CGRect
//}
//
//struct CirclePreferenceKey: PreferenceKey {
//  typealias Value = [PreferenceData]
//
//  static var defaultValue: [PreferenceData] = []
//
//  static func reduce(value: inout [PreferenceData], nextValue: () -> [PreferenceData]) {
//    value.append(contentsOf: nextValue())
//  }
//}
//
//struct CirclePreferenceView: View {
//
//  @State private var activeIdx: Int = 0
////  @State private var rects: [CGRect] = Array<CGRect>(repeating: CGRect(), count: 2)
//  @State var isStarted:Bool = false
//
//  var body: some View {
//
//    ZStack(alignment: .topLeading) {
//      HStack {
//        Circle()
//          .fill(Color.green)
//          .frame(width: 100, height: 100)
//          .anchorPreference(key: MyPreferenceKey.self, value: .bounds) {
//            [AnchorPreferenceDataAnchor(idx: 0, bounds2: $0)]
//          }
//          .gesture(
//            TapGesture()
//              .onEnded {
//                self.isStarted = true
//                self.activeIdx = 0
//              }
//          )
//          .padding()
//        Circle()
//          .fill(Color.pink)
//          .frame(width: 150, height: 150)
//          .anchorPreference(key: MyPreferenceKey.self, value: .bounds) {
//            [AnchorPreferenceDataAnchor(idx: 1, bounds2: $0)]
//          }
//          .gesture(
//            TapGesture()
//              .onEnded {
//                self.isStarted = true
//                self.activeIdx = 1
//              }
//          )
//          .padding()
//      }
//      .backgroundPreferenceValue(MyPreferenceKey.self) { preferences in
//        GeometryReader { geometry in
//          ZStack(alignment: .topLeading) {
////            self.createBorder(geometry, preferences)
//
//            let p = preferences.first { $0.idx == self.activeIdx }
//            let bounds = p != nil ? geometry[p!.bounds2] : .zero
//            Circle()
//              .stroke(Color.blue, lineWidth: 10)
//              .frame(width: bounds.size.width, height: bounds.size.height)
//              .offset(x: bounds.minX , y: bounds.minY)
//              .animation(.linear(duration: isStarted ? 0.5 : 0))
//
////            HStack { Spacer() } // makes the ZStack to expand horizontally
////            VStack { Spacer() } // makes the ZStack to expand vertically
//          }.frame(alignment: .topLeading)
//        }
//      }
//    }
//  }
//}

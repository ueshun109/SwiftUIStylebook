import SwiftUI

struct ContentView: View {
  @State var isShowHalfModal = false

  var body: some View {
    List {
      Button("show half modal") {
        isShowHalfModal.toggle()
      }
      NavigationLink("show photo picker with half modal") {
        PhotoPickerView()
      }
      NavigationLink("show pager trip") {
        Pager()
      }
      NavigationLink("show accordion") {
        VStack {
          AccordionView(
            Keyword.samples,
            children: \.children,
            selection: { print($0.name) }
          ) { item in
            Text(item.name)
              .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)))
          }
          Spacer()
        }
      }
      NavigationLink("dummy") {
        CoordinatorLayout()
      }
    }
    .listStyle(.plain)
    .navigationTitle("Style Guide")
    .navigationBarTitleDisplayMode(.inline)
    .halfModal(isShow: $isShowHalfModal) {
      VStack {
        Text("Shown half modal!")
          .font(.title.bold())
          .foregroundColor(.black)
        Button("Close") {
          isShowHalfModal.toggle()
        }
      }
    } onEnd: {
      print("Dismiss half modal")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

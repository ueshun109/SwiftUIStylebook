import SwiftUI

struct SpotlightExample: View {
  @State private var enable: Bool = true
  @State private var spotlightingID: Int = 1
  var body: some View {
    VStack(spacing: 32) {
      Label {
        Text("Example1")
      } icon: {
        Image(systemName: "lightbulb.circle.fill")
      }
      .padding()
      .background {
        RoundedRectangle(cornerRadius: 8)
          .foregroundStyle(Color.black.opacity(0.2))
      }
      .spotlightAnchor(at: 2)

      Label {
        Text("Example2")
      } icon: {
        Image(systemName: "bitcoinsign.circle.fill")
      }
      .padding()
      .background {
        RoundedRectangle(cornerRadius: 8)
          .foregroundStyle(Color.black.opacity(0.2))
      }
      .spotlightAnchor(at: 3)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Image(systemName: "plus.circle.fill")
          .spotlightAnchor(at: 1)
      }
    }
    .spotlight(enable: $enable, spotlightingID: $spotlightingID)
  }
}

// MARK: - SpotlightBoundsModifier

struct SpotlightModifier: ViewModifier {
  @Binding var enable: Bool
  @Binding var spotlightingID: SpotlightBoundsKey.ID

  func body(content: Content) -> some View {
    content
      .overlayPreferenceValue(SpotlightBoundsKey.self) { values in
        GeometryReader { proxy in
          let preference = values.first(where: { $0.key == spotlightingID })
          if let preference {
            let rect = proxy[preference.value]
            Rectangle()
              .fill(.ultraThinMaterial)
              .environment(\.colorScheme, .dark)
              .opacity(enable ? 1 : 0)
              .reverseMask(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                  .frame(width: rect.width, height: rect.height)
                  .offset(x: rect.minX, y: rect.minY)
              }
              .onTapGesture {
                if spotlightingID <= values.count {
                  spotlightingID += 1
                } else {
                  enable = false
                }
              }
          }
        }
        .ignoresSafeArea()
        .animation(.easeInOut, value: enable)
        .animation(.easeInOut, value: spotlightingID)
      }
  }
}

// MARK: - SpotlightBoundsKey

public struct SpotlightBoundsKey: PreferenceKey {
  public typealias ID = Int

  public static var defaultValue: [ID: Anchor<CGRect>] = [:]

  public static func reduce(
    value: inout [ID: Anchor<CGRect>],
    nextValue: () -> [ID: Anchor<CGRect>]
  ) {
    value.merge(nextValue()) { $1 }
  }
}

// MARK: - View

public extension View {
  func spotlightAnchor(at id: SpotlightBoundsKey.ID) -> some View {
    self.anchorPreference(key: SpotlightBoundsKey.self, value: .bounds) { [id: $0] }
  }

  func spotlight(
    enable: Binding<Bool>,
    spotlightingID: Binding<SpotlightBoundsKey.ID>
  ) -> some View {
    self.modifier(
      SpotlightModifier(
        enable: enable,
        spotlightingID: spotlightingID
      )
    )
  }

  func reverseMask<Content: View>(
    alignment: Alignment = .center,
    _ content: () -> Content
  ) -> some View {
    self.mask {
      Rectangle()
        .overlay(alignment: alignment) {
          content()
            .blendMode(.destinationOut)
        }
    }
  }
}

#Preview {
  @State var id = 1
  @State var enable = true

  return HStack(spacing: 24) {
    Spacer()
    Image(systemName: "lightbulb.fill")
      .resizable()
      .scaledToFit()
      .frame(width: 100, height: 100)
      .padding()
      .spotlightAnchor(at: 1)

    Image(systemName: "lightbulb.max.fill")
      .resizable()
      .scaledToFit()
      .frame(width: 100, height: 100)
      .padding()
      .spotlightAnchor(at: 2)

    Spacer()
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .spotlight(enable: $enable, spotlightingID: $id)
}

import SwiftUI

extension View {
  func halfModal<Sheet: View>(
    isShow: Binding<Bool>,
    @ViewBuilder sheet: @escaping () -> Sheet,
    onEnd: @escaping () -> ()
  ) -> some View {
    return self
      .background(
        HalfModalSheet(
          sheet: sheet(),
          isShow: isShow,
          onClose: onEnd
        )
      )
  }
}

struct HalfModalSheet<Sheet: View>: UIViewControllerRepresentable {
  var sheet: Sheet
  @Binding var isShow: Bool
  var onClose: () -> Void

  func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }

  func updateUIViewController(
    _ viewController: UIViewController,
    context: Context
  ) {
    if isShow {
      let sheetController = CustomHostingController(rootView: sheet)
      sheetController.presentationController!.delegate = context.coordinator
      viewController.present(sheetController, animated: true)
    } else {
      viewController.dismiss(animated: true) { onClose() }
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }

  final class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
      super.viewDidLoad()

      if let sheet = self.sheetPresentationController {
        sheet.detents = [.medium(),]
        sheet.prefersGrabberVisible = true
      }
    }
  }

  final class Coordinator: NSObject, UISheetPresentationControllerDelegate {
    var parent: HalfModalSheet

    init(parent: HalfModalSheet) {
      self.parent = parent
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
      parent.isShow = false
    }
  }
}

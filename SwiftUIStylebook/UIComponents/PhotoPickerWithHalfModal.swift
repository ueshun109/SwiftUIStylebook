import PhotosUI
import SwiftUI

struct PhotoPickerView: View {
  @State var photo: UIImage = .init(systemName: "photo.on.rectangle.angled")!
  @State var isShowPhotoPicker = false

  var body: some View {
    VStack {
      Button {
        isShowPhotoPicker = true
      } label: {
        Image(uiImage: photo)
          .resizable()
          .scaledToFit()
      }
      Spacer()
    }
    .photoPickerWithHalfModal(
      isShow: $isShowPhotoPicker,
      filter: .any(of: [.images]),
      limit: 1
    ) { results in
      results.forEach {
        if $0.itemProvider.canLoadObject(ofClass: UIImage.self) {
          $0.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let image = object as? UIImage {
              photo = image
            }
          }
        }
      }
    }
  }
}

extension View {
  /// Display photo picker with half modal. Currently only supports images.
  /// - Parameters:
  ///   - isShow: Whether to display half modal.
  ///   - filter: The filter you apply to restrict the asset types the picker displays.
  ///   - limit: The maximum number of selections the user can make. Setting the value to 0 sets the selection limit to the maximum that the system supports.
  ///   - selectedResults: Callback of the selected image.
  func photoPickerWithHalfModal(
    isShow: Binding<Bool>,
    filter: PHPickerFilter,
    limit: Int = 1,
    selectedResults: @escaping ([PHPickerResult]) -> ()
  ) -> some View {
    return self
      .background(
        PhotoPickerWithHalfModal(
          isShow: isShow,
          filter: filter,
          limit: limit,
          selectedResults: selectedResults
        )
      )
  }
}

struct PhotoPickerWithHalfModal: UIViewControllerRepresentable {
  @Binding var isShow: Bool
  var filter: PHPickerFilter
  var limit: Int
  var selectedResults: ([PHPickerResult]) -> ()

  func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }

  func updateUIViewController(
    _ viewController: UIViewController,
    context: Context
  ) {
    if isShow {
      var configuration = PHPickerConfiguration()
      configuration.selectionLimit = 1
      configuration.filter = .any(of: [.images])
      let picker = PHPickerViewController(configuration: configuration)
      picker.delegate = context.coordinator
      if let sheet = picker.sheetPresentationController {
        sheet.detents = [.medium(), .large()]
        sheet.prefersGrabberVisible = true
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
      }
      viewController.presentationController!.delegate = context.coordinator
      viewController.present(picker, animated: true)
    } else {
      viewController.dismiss(animated: true)
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }

  class Coordinator:
    NSObject,
    PHPickerViewControllerDelegate,
    UISheetPresentationControllerDelegate
{
    var parent: PhotoPickerWithHalfModal

    init(parent: PhotoPickerWithHalfModal) {
      self.parent = parent
    }

    // MARK: - PHPickerViewControllerDelegate
    func picker(
      _ picker: PHPickerViewController,
      didFinishPicking results: [PHPickerResult]
    ) {
      parent.selectedResults(results)
      parent.isShow = false
    }

    // MARK: - UISheetPresentationControllerDelegate
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    }
  }
}

//
//  ProfilesViewController.swift
//  eInfoSys
//
//  Created by Pat Chang  (XN-188Asia) on 2025/2/25.
//

import UIKit

enum ImageSource {
  case photoLibrary
  case camera
}

class ProfilesViewController: UIViewController, UINavigationControllerDelegate,
  UIImagePickerControllerDelegate
{

  @IBOutlet weak var userImageView: UIImageView!
  var imagePicker: UIImagePickerController!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let image = getSavedImage(named: "user") {
      self.userImageView.image = image
    }

    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logout))

    // 應用統一按鈕樣式
    if let changePhotoButton = self.view.viewWithTag(100) as? UIButton {
      changePhotoButton.applyStyle(.primary)
    }
  }

  @objc func logout() {

    UIHelper.showDialog(
      title: "Log out",
      message: "Are you sure you want to log out?？",
      okTitle: "logout",
      cancelTitle: "cancel",
      onOK: {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first
        {
          window.rootViewController = CompanyAppLoginVC()
          UIView.transition(
            with: window, duration: 0.3, options: [.transitionFlipFromLeft], animations: nil)
        }
      },
      onCancel: {

      }
    )
  }

  @IBAction func changePhotoButtonClicked(_ sender: UIButton) {

    let controller = UIAlertController(title: "choose", message: nil, preferredStyle: .actionSheet)

    let action1 = UIAlertAction(title: "camera", style: .default) { (action) in
      self.selectImageFrom(.camera)
    }
    controller.addAction(action1)

    let action2 = UIAlertAction(title: "photoLibrary", style: .default) { (action) in
      self.selectImageFrom(.photoLibrary)
    }
    controller.addAction(action2)

    let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
    controller.addAction(cancelAction)
    present(controller, animated: true, completion: nil)

  }

  func selectImageFrom(_ source: ImageSource) {
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    switch source {
    case .camera:
      imagePicker.sourceType = .camera
    case .photoLibrary:
      imagePicker.sourceType = .photoLibrary
    }
    present(imagePicker, animated: true, completion: nil)
  }

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    imagePicker.dismiss(animated: true, completion: nil)
    guard let selectedImage = info[.originalImage] as? UIImage else {
      print("Image not found!")
      return
    }

    self.userImageView.image = selectedImage
    let saveStatus = self.saveImage(image: selectedImage)

    UIHelper.showDialog(
      title: "Success",
      message: "Image updated successfully.",
      okTitle: "OK",
      onOK: {

      }
    )

    //        let parameters: [String: Any] = ["type" : "1", "data" : "userImage", "token": CompanyAppManager.shared.token ?? ""]
    //        CompanyAppManager.shared.companyApiFire(apiKey: .documentUpload, body: parameters) { isSuccess, response in
    //            DispatchQueue.main.async {
    //                if isSuccess {
    //                    self.userImageView.image = selectedImage
    //                    let saveStatus = self.saveImage(image: selectedImage)
    //
    //                    UIHelper.showDialog(
    //                        title: "Success",
    //                        message: "Image updated successfully.",
    //                        okTitle: "OK",
    //                        onOK: {
    //
    //                        }
    //                    )
    //                } else {
    //                    UIHelper.showDialog(
    //                        title: "Fail",
    //                        message: "Image upload failed!",
    //                        okTitle: "OK",
    //                        onOK: {
    //
    //                        }
    //                    )
    //                }
    //            }
    //        }
  }

  func saveImage(image: UIImage) -> Bool {
    guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
      return false
    }
    guard
      let directory = try? FileManager.default.url(
        for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
    else {
      return false
    }
    do {
      try data.write(to: directory.appendingPathComponent("user.png")!)
      return true
    } catch {
      print(error.localizedDescription)
      return false
    }
  }

  func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(
      for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    {
      return UIImage(
        contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
  }

}

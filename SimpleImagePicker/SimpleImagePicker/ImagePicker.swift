//
//  ImagePicker.swift
//  SimpleImagePicker
//
//  Created by Eslam Ali  on 17/09/2022.
//

import Foundation
import UIKit
import PhotosUI

class SimpleImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let shared = SimpleImagePicker()
    
    var picker = UIImagePickerController()
    
    var alert = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?
    
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallary", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        if alert.actions.count < 3 {
            alert.addAction(cameraAction)
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
        }
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            print("Sorry your device not support camera ")
        }
    }
    func openGallery(){
//        if #available(iOS 14, *) {
//            var configuration = PHPickerConfiguration()
//            configuration.selectionLimit = 1
//            configuration.filter = .images
//            configuration.filter = .any(of: [.images])
//            let PHPicker = PHPickerViewController(configuration: configuration)
//            PHPicker.delegate = self
//            self.viewController!.present(PHPicker, animated: true, completion: nil)
//        } else {
            alert.dismiss(animated: true, completion: nil)
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.viewController!.present(picker, animated: true, completion: nil)
//        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}

extension SimpleImagePicker: PHPickerViewControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }
        guard let provider = results.first?.itemProvider else {return}
        guard  provider.canLoadObject(ofClass: UIImage.self) else {return}
        provider.loadObject(ofClass: UIImage.self) { (image, error) in
            DispatchQueue.main.async { [self] in
                if let image = image as? UIImage {
                    self.pickImageCallback?(image)
                }
            }
        }
    }
}


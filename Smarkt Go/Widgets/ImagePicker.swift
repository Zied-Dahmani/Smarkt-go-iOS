//
//  ImagePicker.swift
//  Smarkt Go
//
//  Created by user235448 on 4/4/23.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable
{
    @Binding var selectedImage: UIImage?
    @Binding var isPicker: Bool
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
     let imagePicker=UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        return imagePicker
        
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
class Coordinator : NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var parent: ImagePicker
    
    init (_ picker: ImagePicker)
    {
        self.parent = picker
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage
        {
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        parent.isPicker = false
    }
    
    
    
    
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.isPicker = false

    }
    
  
    
    
}

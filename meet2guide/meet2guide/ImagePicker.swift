//
//  ImagePicker.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 07.05.2022.
//

import Foundation
import UIKit

protocol ImagePickerProtocol: AnyObject {
    func didSelect(image: UIImage?)
}

final class ImagePicker: UIImagePickerController {
    weak var output: ImagePickerProtocol?
    
    override func viewDidLoad() {
        self.delegate = self
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        output?.didSelect(image: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}

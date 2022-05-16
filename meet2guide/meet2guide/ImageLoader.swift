//
//  ImageLoader.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 07.05.2022.
//

import Foundation
import UIKit
import FirebaseStorage

protocol ImageLoaderProtocol {
    func load(image: UIImage?, completion: @escaping (Result<String, Error>) -> Void)
    func get(name: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class ImageLoader {
    static let shared = ImageLoader()
    
    private init() {}
    
    let storageReference = Storage.storage().reference()
    
}

enum NetworkError: Error {
    case unexpected
    case emptyData
}


extension ImageLoader: ImageLoaderProtocol {
    func load(image: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = image else {
            completion(.success(""))
            return
        }
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NetworkError.unexpected))
                return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let name = UUID().uuidString
        
        storageReference.child(name).putData(data, metadata: metadata) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(name))
            }
        }
    }
    
    func get(name: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        storageReference.child(name).getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NetworkError.emptyData))
            }
        }
    }
}

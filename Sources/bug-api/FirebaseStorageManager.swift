//
//  File.swift
//
//
//  Created by Dania Alogla on 25/09/1445 AH.
//

import Foundation
import FirebaseStorage

public class FirebaseStorageManager {
    
    static public let shared = FirebaseStorageManager()
    
    private let storageRef = Storage.storage().reference()

    private init() {}
    
    public func getImageURL(for imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storageRef.child("images/\(imageName)")
        
        putData(in: imageRef, imageData: imageData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.downloadURL(from: imageRef) { result in
                    switch result {
                    case let .success(url):
                        completion(.success(url))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
        
    private func putData(in imageRef: StorageReference ,imageData: Data, completion: @escaping (Error?) -> Void){
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                if let error = error {
                    print("Error in put data proccess: \(error)")
                    completion(error)
                } else {
                    completion(NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
                return
            }
            completion(nil)
        }
    }
    
    private func downloadURL(from imageRef: StorageReference, completion: @escaping (Result<URL, Error>) -> Void) {
        imageRef.downloadURL { (url, error) in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            } else {
                completion(.failure(NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
            }
        }
    }
    
}

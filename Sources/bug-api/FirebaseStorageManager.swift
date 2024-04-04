//
//  File.swift
//  
//
//  Created by Dania Alogla on 25/09/1445 AH.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    
    private init() {}
    
    // MARK: - Helpers
    
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
    
}

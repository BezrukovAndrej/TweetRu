//
//  StorageManager.swift
//  TweetRu
//
//  Created by Andrey Bezrukov on 08.11.2023.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FirestoreError: Error {
    case invalidImageID
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    let storage = Storage.storage().reference()
    
    func updateProfilePhoto(
        with randomID: String,
        image: Data,
        metaData: StorageMetadata
    ) -> AnyPublisher<StorageMetadata, Error> {
        return storage
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error>  {
        guard let id else {
            return Fail(error: FirestoreError.invalidImageID)
                .eraseToAnyPublisher()
        }
        return storage
            .storage.reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
}

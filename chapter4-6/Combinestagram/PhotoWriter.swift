//
//  PhotoWriter.swift
//  Combinestagram
//
//  Created by fahreddin on 6.02.2021.
//  Copyright © 2021 fahreddin. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotoWriter {
    enum Errors: Error {
        case couldNotSavePhoto
    }
    
    static func save(_ image: UIImage) -> Single<String> {
        // challenge 1
        return Single.create { (single) -> Disposable in
            var savedAssetId: String?
            
            PHPhotoLibrary.shared().performChanges({
                 let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
            }, completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success, let id = savedAssetId {
                        single(.success(id))
                    } else {
                        single(.error(error ?? Errors.couldNotSavePhoto))
                    }
                }
            })
            
            return Disposables.create()
        }
    }
}

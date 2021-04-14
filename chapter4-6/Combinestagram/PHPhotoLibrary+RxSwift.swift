//
//  PHPhotoLibrary+RxSwift.swift
//  Combinestagram
//
//  Created by fahreddin on 11.02.2021.
//  Copyright © 2021 fahreddin. All rights reserved.
//

import Foundation
import RxSwift
import Photos

extension PHPhotoLibrary {
    
    static var authorized: Observable<Bool> {
        return Observable.create { (observer) -> Disposable in
            DispatchQueue.main.async {
                if authorizationStatus() == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    requestAuthorization { (newStatus) in
                        observer.onNext(newStatus == .authorized)
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
}

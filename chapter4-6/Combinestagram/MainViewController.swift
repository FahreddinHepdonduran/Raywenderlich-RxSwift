//
//  ViewController.swift
//  Combinestagram
//
//  Created by fahreddin on 6.02.2021.
//  Copyright © 2021 fahreddin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class MainViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let images = Variable<[UIImage]>([])
    private var imageCache = [Int]()

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!

    override func viewDidLoad() {
      super.viewDidLoad()
        let images = self.images.asObservable().share()
        
        images.asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (photos) in
            guard let self = self else {return}
            
            guard let preview = self.imagePreview else { return }
            preview.image = photos.collage(size: preview.frame.size)
        })
        .disposed(by: disposeBag)
        
        images.asObservable().subscribe(onNext: { [weak self] (photos) in
            guard let self = self else {return}
            
            self.updateUI(photos: photos)
        })
        .disposed(by: disposeBag)
        
    }
    
    @IBAction func actionClear() {
        images.value = []
        imageCache = []
        navigationItem.leftBarButtonItem = nil
    }

    @IBAction func actionSave() {
        guard let image = imagePreview.image else { return }
        PhotoWriter.save(image)
        .subscribe(onSuccess: { [weak self] id in
            self?.showMessage("Saved with id: \(id)")
            self?.actionClear()
        }, onError: { [weak self] error in
            self?.showMessage("Error", description: error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    @IBAction func actionAdd() {
//        images.value.append(UIImage(named: "IMG_1907.jpg")!)
        
        let photosViewController = storyboard!.instantiateViewController( withIdentifier: "PhotosViewController") as! PhotosViewController
        
        let newPhotos = photosViewController.selectedPhotos.share()
        
        newPhotos.ignoreElements()
            .subscribe(onCompleted: { [weak self] in
                self?.updateNavigationIcon()
            }).disposed(by: disposeBag)
            
        newPhotos
            .takeWhile({ [weak self](newImage) -> Bool in
                return (self?.images.value.count ?? 0) < 6
            })
            .filter({ (newImage) -> Bool in
                return newImage.size.width > newImage.size.height
            })
            .filter({ [weak self] (newImage) -> Bool in
                let length = newImage.pngData()?.count ?? 0
                
                guard self?.imageCache.contains(length) == false else { return false}
                
                self?.imageCache.append(length)
                return true
            })
            .subscribe(onNext: { [weak self] (newImage) in
                guard let images = self?.images else {return}
                images.value.append(newImage)
            }, onDisposed: {
                print("completed photo selection")
            }).disposed(by: disposeBag)
        
        navigationController?.pushViewController(photosViewController, animated: true)
    }

    func showMessage(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
            .subscribe(onCompleted: {
                print("alert completed")
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(photos: [UIImage]) {
        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        buttonClear.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }
    
    private func updateNavigationIcon() {
        let icon = imagePreview.image?
            .scaled(CGSize(width: 22, height: 22))
            .withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .done, target: nil, action: nil)
    }
}

extension UIViewController {
    // challenge 2
    func alert(title: String, text: String?=nil) -> Completable {
        return Completable.create { [weak self] (completable) -> Disposable in
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
              completable(.completed)
            }))
            self?.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                print("dissmising")
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

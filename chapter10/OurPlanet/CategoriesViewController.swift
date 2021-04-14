//
//  ViewController.swift
//  OurPlanet
//
//  Created by fahreddin on 16.02.2021.
//  Copyright © 2021 fahreddin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   @IBOutlet var tableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView!
    let download = DownloadView()
    
    let categories = BehaviorRelay<[EOCategory]>(value: [])
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
      super.viewDidLoad()
        // CHALLENGE 1
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        
        // CHALLENGE 2
        view.addSubview(download)
        view.layoutIfNeeded()
        
        categories
        .asObservable()
        .subscribe(onNext: { [weak self] _ in
          DispatchQueue.main.async {
            self?.tableView?.reloadData()
          }
        })
        .disposed(by: disposeBag)
        
      startDownload()
    }

    func startDownload() {
        download.progress.progress = 0.0
        download.label.text = "Download: 0%"
        
        let eoCategories = EONET.categories
        let downloadedEvents = eoCategories
          .flatMap { categories in
            return Observable.from(categories.map { category in
              EONET.events(forLast: 360, category: category)
            })
          }
          .merge(maxConcurrent: 2)
        
        // challenge 2-2
//        let updatedCategories = eoCategories.flatMap { categories in
//        downloadedEvents.scan(categories) { updated, events in
//          return updated.map { category in
//            let eventsForCategory = EONET.filteredEvents(events: events, forCategory: category)
//            if !eventsForCategory.isEmpty {
//              var cat = category
//              cat.events = cat.events + eventsForCategory
//              return cat
//            }
//            return category
//          }
//        }
//        }
        
        let updatedCategories = eoCategories.flatMap { categories in
          // CHALLENGE 2
               downloadedEvents.scan((0,categories)) { tuple, events in
                 return (tuple.0 + 1, tuple.1.map { category in
                   let eventsForCategory = EONET.filteredEvents(events: events, forCategory: category)
                   if !eventsForCategory.isEmpty {
                     var cat = category
                     cat.events = cat.events + eventsForCategory
                     return cat
                   }
                   return category
                 })
               }
               }
        // CHALLENGE 1
             
         .do(onCompleted: { [weak self] in
           DispatchQueue.main.async {
             self?.activityIndicator.stopAnimating()
            // CHALLENGE 2-2
//            self?.download.isHidden = true
           }
         })
        
        // CHALLENGE 2
        .do(onNext: { [weak self] tuple in
          DispatchQueue.main.async {
            let progress = Float(tuple.0) / Float(tuple.1.count)
            self?.download.progress.progress = progress
            let percent = Int(progress * 100.0)
            self?.download.label.text = "Download: \(percent)%"
          }
        })

        
        // CHALLENGE 2-2
//        eoCategories.flatMap { categories in
//          return updatedCategories.scan(0) { count, _ in
//            return count + 1
//            }
//            .startWith(0)
//            .map { ($0, categories.count) }
//          }
//          .subscribe(onNext: { tuple in
//            DispatchQueue.main.async { [weak self] in
//              let progress = Float(tuple.0) / Float(tuple.1)
//              self?.download.progress.progress = progress
//              let percent = Int(progress * 100.0)
//              self?.download.label.text = "Download: \(percent)%"
//            }
//          })
//          .disposed(by: disposeBag)
        
        eoCategories
            .concat(updatedCategories.map(\.1)) // CHALLENGE 2
          .bind(to: categories)
          .disposed(by: disposeBag)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        let category = categories.value[indexPath.row]
        cell.textLabel?.text = "\(category.name) (\(category.events.count))"
        cell.accessoryType = (category.events.count > 0) ? .disclosureIndicator : .none
        cell.detailTextLabel?.text = category.description
      return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories.value[indexPath.row]
          tableView.deselectRow(at: indexPath, animated: true)

          guard !category.events.isEmpty else { return }

          let eventsController = storyboard!.instantiateViewController(withIdentifier: "events") as! EventsViewController
          eventsController.title = category.name
          eventsController.events.accept(category.events)
          navigationController!.pushViewController(eventsController, animated: true)
    }
}


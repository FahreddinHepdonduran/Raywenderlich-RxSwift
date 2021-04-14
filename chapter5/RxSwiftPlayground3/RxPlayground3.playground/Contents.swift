import UIKit
import RxSwift

//example("ignore elements") {
//    let strikes = PublishSubject<String>()
//    let disposeBag = DisposeBag()
//
//    strikes.ignoreElements()
//        .subscribe { _ in
//            print("you are out!")
//        }
//        .disposed(by: disposeBag)
//
//    strikes.onNext("X")
//    strikes.onNext("X")
//    strikes.onNext("X")
//    strikes.onCompleted()
//}

//example("elementAt") {
//  // 1
//  let strikes = PublishSubject<String>()
//  let disposeBag = DisposeBag()
//// 2
//    strikes.elementAt(2)
//        .subscribe(onNext: { _ in
//          print("You're out!")
//        })
//    .disposed(by: disposeBag)
//
//    strikes.onNext("X")
//    strikes.onNext("X")
//    strikes.onNext("X")
//}

//example("filter") {
//  let disposeBag = DisposeBag()
//// 1
//    Observable.of(1, 2, 3, 4, 5, 6) // 2
//    .filter { integer in
//          integer % 2 == 0
//        }
//    // 3
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
//}

//example("skip") {
//  let disposeBag = DisposeBag()
//// 1
//    Observable.of("A", "B", "C", "D", "E", "F") // 2
//    .skip(3)
//        .subscribe(onNext: {
//            print($0)
//
//        })
//    .disposed(by: disposeBag)
//
//}

//example("skipWhile") {
//  let disposeBag = DisposeBag()
//// 1
//Observable.of(2, 2, 3, 4, 4) // 2
//.skipWhile { integer in
//      integer % 2 == 0
//    }
//.subscribe(onNext: { print($0)
//    }).disposed(by: disposeBag)
//}

//example("skipUntil") {
//  let disposeBag = DisposeBag()
//// 1
//  let subject = PublishSubject<String>()
//  let trigger = PublishSubject<String>()
//// 2
//    subject.skipUntil(trigger)
//        .subscribe(onNext: {
//        print($0)
//
//    })
//.disposed(by: disposeBag)
//
//    subject.onNext("A")
//    subject.onNext("B")
//    trigger.onNext("X")
//    subject.onNext("C")
//}

//example(of: "take") {
//  let disposeBag = DisposeBag()
//// 1
//Observable.of(1, 2, 3, 4, 5, 6) // 2
//.take(3) .subscribe(onNext: {
//print($0) })
//.disposed(by: disposeBag)
//
//}

//example(of: "takeWhile") {
//  let disposeBag = DisposeBag()
//// 1
//Observable.of(2, 2, 4, 4, 6, 6) // 2
//.enumerated()
//// 3
//.takeWhile { index, integer in // 4
//      integer % 2 == 0 && index < 3
//    }
//// 5
//.map { $0.element } // 6
//    .subscribe(onNext: {
//print($0) })
//.disposed(by: disposeBag) }

//example(of: "takeUntil") {
//  let disposeBag = DisposeBag()
//// 1
//  let subject = PublishSubject<String>()
//  let trigger = PublishSubject<String>()
//// 2
//subject
//.takeUntil(trigger) .subscribe(onNext: {
//print($0) })
//.disposed(by: disposeBag)
//// 3
//subject.onNext("1")
//subject.onNext("2")
//    trigger.onNext("X")
//    subject.onNext("3")
//
//}

//example(of: "distinctUntilChanged") {
//  let disposeBag = DisposeBag()
//// 1
//Observable.of("A", "A", "B", "B", "A") // 2
//.distinctUntilChanged() .subscribe(onNext: {
//print($0) })
//.disposed(by: disposeBag) }

//example(of: "distinctUntilChanged(_:)") {
//    let disposeBag = DisposeBag()
//// 1
//let formatter = NumberFormatter()
//    formatter.numberStyle = .spellOut
//// 2
//Observable<NSNumber>.of(10, 110, 20, 200, 210, 310) // 3
//.distinctUntilChanged { a, b in // 4
//guard let aWords = formatter.string(from:a)?.components(separatedBy: " "),
//let bWords = formatter.string(from: b)?.components(separatedBy: " ")
//else {
//return false
//      }
//      var containsMatch = false
//// 5
//      for aWord in aWords {
//        for bWord in bWords {
//          if aWord == bWord {
//            containsMatch = true
//break
//} }
//}
//      return containsMatch
//    }
//// 4
//.subscribe(onNext: { print($0)
//})
//.disposed(by: disposeBag)
//}

example(of: "challenge1") {
    let disposeBag = DisposeBag()
    
    let contacts = [
      "603-555-1212": "Florent",
      "212-555-1212": "Shai",
      "408-555-1212": "Marin",
      "617-555-1212": "Scott"
    ]
    
    func phoneNumber(from inputs: [Int]) -> String {
      var phone = inputs.map(String.init).joined()
      
      phone.insert("-", at: phone.index(
        phone.startIndex,
        offsetBy: 3)
      )
      
      phone.insert("-", at: phone.index(
        phone.startIndex,
        offsetBy: 7)
      )
      
      return phone
    }
    
    let input = PublishSubject<Int>()
    
    // Add your code here
      input
          .skipWhile { (integer) -> Bool in
              integer == 0
      }.filter { (integer) -> Bool in
          integer < 10
          }.take(10).toArray()
          .subscribe(onNext: {
              let phone = phoneNumber(from: $0)
              
              if let contact = contacts[phone] {
                print("Dialing \(contact) (\(phone))...")
              } else {
                print("Contact not found")
              }
          }).disposed(by: disposeBag)
    
    
    input.onNext(0)
    input.onNext(603)
    
    input.onNext(2)
    input.onNext(1)
    
    // Confirm that 7 results in "Contact not found",
    // and then change to 2 and confirm that Shai is found
    input.onNext(2)
    
    "5551212".forEach {
      if let number = (Int("\($0)")) {
        input.onNext(number)
      }
    }
    
    input.onNext(9)
}

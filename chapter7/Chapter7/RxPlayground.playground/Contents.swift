import UIKit
import RxSwift

//example(of: "toArray") {
//    let disposeBag = DisposeBag()
//
//    Observable.of("A", "B", "C")
//        .toArray()
//        .subscribe(onNext: {
//            print($0)
//        })
//        .disposed(by: disposeBag)
//}

//example(of: "map") {
//    let disposeBag = DisposeBag()
//
//    let formatter = NumberFormatter()
//    formatter.numberStyle = .spellOut
//
//    Observable<NSNumber>.of(123, 4, 56)
//        .map({ formatter.string(from: $0) ?? "" })
//        .subscribe(onNext: {
//            print($0)
//        })
//        .disposed(by: disposeBag)
//}

//example(of: "enumerated and map") {
//  let disposeBag = DisposeBag()
//
//  // 1
//  Observable.of(1, 2, 3, 4, 5, 6)
//    // 2
//    .enumerated()
//    // 3
//    .map { index, integer in
//      index > 2 ? integer * 2 : integer
//    }
//    // 4
//    .subscribe(onNext: {
//      print($0)
//    })
//    .disposed(by: disposeBag)
//}

struct Student {
  let score: BehaviorSubject<Int>
}

//example(of: "flatMap") {
//  let disposeBag = DisposeBag()
//
//  // 1
//  let ryan = Student(score: BehaviorSubject(value: 80))
//  let charlotte = Student(score: BehaviorSubject(value: 90))
//
//  // 2
//  let student = PublishSubject<Student>()
//
//  // 3
//  student
//    .flatMap {
//      $0.score
//    }
//    // 4
//    .subscribe(onNext: {
//      print($0)
//    })
//    .disposed(by: disposeBag)
//
//    student.onNext(ryan)
//    ryan.score.onNext(85)
//    student.onNext(charlotte)
//    ryan.score.onNext(95)
//    charlotte.score.onNext(100)
//}

//example(of: "flatMapLatest") {
//  let disposeBag = DisposeBag()
//
//  let laura = Student(score: BehaviorSubject(value: 80))
//  let charlotte = Student(score: BehaviorSubject(value: 90))
//
//  let student = PublishSubject<Student>()
//
//  student
//    .flatMapLatest {
//      $0.score
//    }
//    .subscribe(onNext: {
//      print($0)
//    })
//    .disposed(by: disposeBag)
//
//    student.onNext(laura)
//    laura.score.onNext(85)
//    student.onNext(charlotte)
//    laura.score.onNext(95)
//    charlotte.score.onNext(100)
//}

//example(of: "materialize and dematerialize") {
//  // 1
//  enum MyError: Error {
//    case anError
//  }
//
//  let disposeBag = DisposeBag()
//
//  // 2
//  let laura = Student(score: BehaviorSubject(value: 80))
//  let charlotte = Student(score: BehaviorSubject(value: 100))
//
//  let student = BehaviorSubject(value: laura)
//
//  // 1
//  let studentScore = student
//    .flatMapLatest {
//        $0.score.materialize()
//  }
//
//  // 2
//  studentScore
//   // 1
//    .filter {
//      guard $0.error == nil else {
//        print($0.error!)
//        return false
//      }
//
//      return true
//    }
//    // 2
//    .dematerialize()
//    .subscribe(onNext: {
//      print($0)
//    })
//    .disposed(by: disposeBag)
//
//  // 3
//  laura.score.onNext(85)
//
//  laura.score.onError(MyError.anError)
//
//  laura.score.onNext(90)
//
//  // 4
//  student.onNext(charlotte)
//}

example(of: "Challenge 1") {
  let disposeBag = DisposeBag()
  
  let contacts = [
    "603-555-1212": "Florent",
    "212-555-1212": "Shai",
    "408-555-1212": "Marin",
    "617-555-1212": "Scott"
  ]
  
  let convert: (String) -> UInt? = { value in
    if let number = UInt(value),
       number < 10 {
      return number
    }
    
    let keyMap: [String: UInt] = [
      "abc": 2, "def": 3, "ghi": 4,
      "jkl": 5, "mno": 6, "pqrs": 7,
      "tuv": 8, "wxyz": 9
    ]
    
    let converted = keyMap
      .filter { $0.key.contains(value.lowercased()) }
      .map(\.value)
      .first
    
    return converted
  }
  
  let format: ([UInt]) -> String = {
    var phone = $0.map(String.init).joined()
    
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
  
  let dial: (String) -> String = {
    if let contact = contacts[$0] {
      return "Dialing \(contact) (\($0))..."
    } else {
      return "Contact not found"
    }
  }
  
  let input = PublishSubject<String>()
  
  // Add your code here
    input
      .map(convert)
      .flatMap { x in
           return x.map(Observable.just) ?? Observable.empty()
      }
      .skipWhile { $0 == 0 }
      .take(10)
      .toArray()
      .map(format)
      .map(dial)
    .subscribe(onNext: {
        print($0)
    })
      .disposed(by: disposeBag)
  
  input.onNext("")
  input.onNext("0")
  input.onNext("408")
  
  input.onNext("6")
  input.onNext("")
  input.onNext("0")
  input.onNext("3")
  
  "JKL1A1B".forEach {
    input.onNext("\($0)")
  }
  
  input.onNext("9")
}

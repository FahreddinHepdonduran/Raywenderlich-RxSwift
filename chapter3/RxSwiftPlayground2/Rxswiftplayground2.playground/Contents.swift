import UIKit
import RxSwift
import RxCocoa

//example("publissubject") {
//    let subject = PublishSubject<String>()
//
//    subject.onNext("is anyone listening?")
//
//    let subscriptionOne = subject.subscribe(onNext: { (string) in
//        print(string)
//    })
//
//    subject.on(.next("1"))
//    subject.onNext("2")
//
//    let subscriptionTwo = subject.subscribe { event in
//    print("2)", event.element ?? event) }
//
//    subject.onNext("3")
//
//    subscriptionOne.dispose()
//
//    subject.onNext("4")
//
//    // 1
//    subject.onCompleted()
//    // 2
//    subject.onNext("5") // 3
//
//    subscriptionTwo.dispose()
//
//    let disposeBag = DisposeBag()
//    // 4
//    subject.subscribe {
//        print("3)", $0.element ?? $0)
//    }
//    .disposed(by: disposeBag)
//
//    subject.onNext("?")
//}

//// 1
//enum MyError: Error {
//  case anError
//}
////// 2
//func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
//    print(label, event.element ?? event.error ?? event)
//}
//// 3
//example("BehaviorSubject") {
//  // 4
//    let subject = BehaviorSubject(value: "Initial value")
//    let disposeBag = DisposeBag()
//
//    subject.onNext("A")
//
//    subject.subscribe {
//        print(label: "1)", event: $0)
//    }
//    .disposed(by: disposeBag)
//
//    // 1
//    subject.onError(MyError.anError)
//    // 2
//    subject .subscribe {
//        print(label: "2)", event: $0)
//      }
//    .disposed(by: disposeBag)
//}

//example("ReplaySubject") {
//  // 1
//    let subject = ReplaySubject<String>.create(bufferSize: 2)
//    let disposeBag = DisposeBag()
//    // 2
//    subject.onNext("1")
//    subject.onNext("2")
//    subject.onNext("3")
//    // 3
//    subject.subscribe {
//        print(label: "1)", event: $0)
//    }
//    .disposed(by: disposeBag)
//
//    subject.subscribe {
//        print(label: "2)", event: $0)
//    }
//    .disposed(by: disposeBag)
//
//    subject.onNext("4")
//
//    subject.onError(MyError.anError)
//
//    subject.dispose()
//
//    subject .subscribe {
//        print(label: "3)", event: $0)
//    }
//    .disposed(by: disposeBag)
//}

//example("Variable") {
//  // 1
//    let variable = Variable("Initial value")
//    let disposeBag = DisposeBag()
//// 2
//    variable.value = "New initial value"
//// 3
//    variable.asObservable()
//        .subscribe {
//      print(label: "1)", event: $0)
//    }
//    .disposed(by: disposeBag)
//
//    // 1
//    variable.value = "1"
//    // 2
//    variable.asObservable()
//        .subscribe {
//        print(label: "2)", event: $0)
//      }
//    .disposed(by: disposeBag)
//    // 3
//    variable.value = "2"
//}

// challenge1

//example("Challenge-1") {
//
//  let disposeBag = DisposeBag()
//
//  let dealtHand = PublishSubject<[(String, Int)]>()
//
//  func deal(_ cardCount: UInt) {
//    var deck = cards
//    var cardsRemaining = deck.count
//    var hand = [(String, Int)]()
//
//    for _ in 0..<cardCount {
//      let randomIndex = Int.random(in: 0..<cardsRemaining)
//      hand.append(deck[randomIndex])
//      deck.remove(at: randomIndex)
//      cardsRemaining -= 1
//    }
//
//    // Add code to update dealtHand here
//    let handPoints = points(for: hand)
//    if handPoints > 21 {
//      dealtHand.onError(HandError.busted(points: handPoints))
//    } else {
//      dealtHand.onNext(hand)
//    }
//  }
//
//  // Add subscription to handSubject here
//  dealtHand
//    .subscribe(
//      onNext: {
//        print(cardString(for: $0), "for", points(for: $0), "points")
//    },
//      onError: {
//        print(String(describing: $0).capitalized)
//    })
//    .disposed(by: disposeBag)
//
//  deal(3)
//}

// challenge2

example("challenge-2") {
    enum UserSession {
        case loggedIn, loggedOut
    }

    enum LoginError: Error {
        case invalidCredentials
    }

    let disposeBag = DisposeBag()

    // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
    let userSession = BehaviorRelay(value: UserSession.loggedOut)
    // Subscribe to receive next events from userSession
    userSession.subscribe(onNext: {
         print("userSession changed:", $0)
        }).disposed(by: disposeBag)
    
    func logInWith(username: String, password: String, completion: (Error?) -> Void) {
        guard username == "johnny@appleseed.com",
              password == "appleseed" else {
          completion(LoginError.invalidCredentials)
          return
        }

        // Update userSession
        userSession.accept(.loggedIn)
    }

    func logOut() {
        // Update userSession
        userSession.accept(.loggedOut)
    }

    func performActionRequiringLoggedInUser(_ action: () -> Void) {
        // Ensure that userSession is loggedIn and then execute action()
        guard userSession.value == .loggedIn else {
          print("You can't do that!")
          return
        }
        
        action()
    }

    for i in 1...2 {
        let password = i % 2 == 0 ? "appleseed" : "password"

        logInWith(username: "johnny@appleseed.com", password: password) { error in
          guard error == nil else {
            print(error!)
            return
          }
          
          print("User logged in.")
        }

        performActionRequiringLoggedInUser {
          print("Successfully did something only a logged in user can do.")
        }
    }
}

import Foundation
import RxSwift

enum UserEvent {
    case updateUserName(String)
}

protocol UserServiceProtocol {
    var event: PublishSubject<UserEvent> { get }
    func updateUserName(to name: String) -> Observable<String>
}

class UserService: UserServiceProtocol {
    let event = PublishSubject<UserEvent>()
    
    func updateUserName(to name: String) -> Observable<String> {
        // UserDefaults에 저장하는 등의 작업을 진행할 수 있을 것.
        event.onNext(.updateUserName(name))
        return .just(name)
    }
}

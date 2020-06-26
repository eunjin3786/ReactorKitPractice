import RxSwift
import ReactorKit

class SettingViewReactor: Reactor {
    enum Action {
        case saveUserName(String)
        case cancel
    }
    
    enum Mutation {
        case saveUserName(String)
        case dismiss
    }

    struct State {
        var userName: String
        var shouldDismissed: Bool

        init(userName: String) {
            self.userName = userName
            self.shouldDismissed = false
        }
    }
    
    let initialState: State
    let provider: ServiceProviderProtocol
    
    init(provider: ServiceProviderProtocol, userName: String) {
        self.initialState = State(userName: userName)
        self.provider = provider
    }
    
    func mutate(action: SettingViewReactor.Action) -> Observable<SettingViewReactor.Mutation> {
        switch action {
        case .saveUserName(let name):
            return provider.userService.updateUserName(to: name)
                .map { _ in .dismiss }
        case .cancel:
            return Observable.just(.dismiss)
        }
    }
    
    func reduce(state: SettingViewReactor.State, mutation: SettingViewReactor.Mutation) -> SettingViewReactor.State {
        var newState = state
        switch mutation {
        case .saveUserName(let name):
            newState.userName = name
        case .dismiss:
            newState.shouldDismissed = true
        }
        return newState
    }
}

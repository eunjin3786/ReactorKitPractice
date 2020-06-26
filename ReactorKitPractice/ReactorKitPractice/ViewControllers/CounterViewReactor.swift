import RxSwift
import RxCocoa
import ReactorKit

class CounterViewReactor: Reactor {
    enum Action {
        case increase
        case decrease
    }
    
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
        case updateUserName(String)
    }
    
    struct State {
        var value: Int = 0
        var isLoading: Bool = false
        var userName: String = ""
    }
    
    let initialState: State
    let provider: ServiceProviderProtocol
    
    init(provider: ServiceProviderProtocol) {
        self.initialState = State()
        self.provider = provider
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.userService.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateUserName(let name):
                return .just(.updateUserName(name))
            }
        }
        return Observable.merge(mutation, eventMutation)
        
    }
    
    func mutate(action: CounterViewReactor.Action) -> Observable<CounterViewReactor.Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: CounterViewReactor.State, mutation: CounterViewReactor.Mutation) -> CounterViewReactor.State {
        var newState = state
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .updateUserName(let name):
            newState.userName = name
        }
        return newState
    }
    
    func reactorForSetting() -> SettingViewReactor {
        return SettingViewReactor(provider: provider,
                                  userName: currentState.userName)
    }
}

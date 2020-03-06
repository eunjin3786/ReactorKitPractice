import RxSwift
import RxCocoa
import ReactorKit
import UIKit

class CounterViewController: UIViewController, StoryboardView {
    
    var disposeBag: DisposeBag = DisposeBag()

    @IBOutlet var increaseButton: UIButton!
    @IBOutlet var decreaseButton: UIButton!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var userGreetingLabel: UILabel!
    
    @IBAction func showSettingVC(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SettingViewController") as? SettingViewController
        if let vc = vc, let reactor = reactor?.reactorForSetting() {
            vc.reactor = reactor
            present(vc, animated: true, completion: nil)
        }
    }
    
    func bind(reactor: CounterViewReactor) {
        // Action 바인딩
        increaseButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State 바인딩
        reactor.state
            .map { $0.value }
            .distinctUntilChanged()
            .map { "\($0)" }
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.userName }
            .distinctUntilChanged()
            .map { $0.isEmpty ? $0 : $0 + "님 안녕하세요 ☺️" }
            .bind(to: userGreetingLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

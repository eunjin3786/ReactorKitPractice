import UIKit
import ReactorKit
import RxSwift

class SettingViewController: UIViewController, StoryboardView {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: SettingViewReactor) {
        // Action 바인딩
        saveButton.rx.tap
            .map { [weak self] in self?.userNameTextField.text ?? "" }
            .map { Reactor.Action.saveUserName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .map { Reactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State 바인딩
        reactor.state.map { $0.shouldDismissed }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
              self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

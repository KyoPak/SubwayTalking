//
//  SignIntent.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/27/24.
//

import RxSwift

protocol SignIntent {
    func bind<V: SignViewUpdatable>(to view: V)
    func viewDidLoad()
    func appleSignInButtonTapped(delegate: AppleSignViewPresentable)
    func kakaoSignInButtonTapped()
}

final class DefaultSignIntent: SignIntent {
    
    // MARK: Property
    
    private let state: StateRelay<SignState>
    private let disposeBag = DisposeBag()
    private let signUseCase: SignUseCase
    
    init(signUseCase: SignUseCase) {
        self.signUseCase = signUseCase
        
        state = StateRelay<SignState>()
    }
    
    // MARK: SignIntent
    
    func bind<V: SignViewUpdatable>(to view: V) {
        state.bind(to: view)
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        signUseCase.authResult
            .withUnretained(self)
            .subscribe { (owner, result) in
                switch result {
                case .success(let id):
                    let newState = SignState(userId: id)
                    owner.state.accept(newState)
                case .failure(let error):
                    [error, nil].forEach {
                        let newState = SignState(error: $0)
                        owner.state.accept(newState)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func appleSignInButtonTapped(delegate: AppleSignViewPresentable) {
        signUseCase.signAuth(type: .apple, presentDelegate: delegate)
    }
    
    func kakaoSignInButtonTapped() {
        signUseCase.signAuth(type: .kakao, presentDelegate: nil)
    }
}

//
//  StateRelay.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/10/24.
//

import RxCocoa
import RxSwift

final class StateRelay<S: State> {
    private let relay: BehaviorRelay<S>
    
    var value: S {
        return relay.value
    }
    
    init() {
        relay = BehaviorRelay<S>(value: S.initialState)
    }
    
    func accept(_ event: S) {
        relay.accept(event)
    }
    
    func bind<V: View>(to view: V) -> Disposable where V.AssociatedState == S {
        return relay
            .withPrevious()
            .asDriver(onErrorJustReturn: (prevState: nil, state: S.initialState))
            .drive(onNext: { [weak view] prevState, currentState in
                view?.update(with: currentState, prev: prevState)
            })
    }
}

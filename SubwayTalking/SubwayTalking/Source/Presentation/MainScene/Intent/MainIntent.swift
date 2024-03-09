//
//  MainIntent.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import RxSwift
import RxRelay

protocol MainIntent { 
    func bind<V: MainViewUpdatable>(to view: V)
    func viewDidLoad()
}

final class DefaultMainIntent: MainIntent {
    
    // MARK: Property
    
    private let state: BehaviorRelay<MainState>
    private let addMarkerUseCase: AddMarkerUseCase
    private let disposeBag = DisposeBag()
    
    init(addMarkerUseCase: AddMarkerUseCase) {
        self.addMarkerUseCase = addMarkerUseCase
        
        state = BehaviorRelay(value: MainState.initialState)
    }
    
    // MARK: MainIntent

    func bind<V: MainViewUpdatable>(to view: V) {
        state.subscribe { [weak view] event in
            guard let state = event.element else { return }
            view?.update(with: state)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: Inputs
    
    func viewDidLoad() {
        let backGroundQueue = ConcurrentDispatchQueueScheduler(queue: .global())
        
        addMarkerUseCase.fetchMarkerData()
            .subscribe(on: backGroundQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, datas in
                let newState = MainState(subwayInfos: datas)
                owner.state.accept(newState)
            })
            .disposed(by: disposeBag)
    }
}

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
    
    private let state: StateRelay<MainState>
    private let addMarkerUseCase: AddMarkerUseCase
    private let disposeBag = DisposeBag()
    
    init(addMarkerUseCase: AddMarkerUseCase) {
        self.addMarkerUseCase = addMarkerUseCase
        
        state = StateRelay<MainState>()
    }
    
    // MARK: MainIntent
    
    func bind<V: MainViewUpdatable>(to view: V) {
        state.bind(to: view)
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

//
//  MapIntent.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import CoreLocation

import RxSwift

protocol MapIntent {
    func bind<V: MapViewUpdatable>(to view: V)
    func viewDidLoad()
    func userLocationButtonTapped()
    func cameraMove(latitide: Double, longitude: Double)
}

final class DefaultMapIntent: MapIntent {
    
    // MARK: Property
    
    private let state: StateRelay<MapState>
    private let disposeBag = DisposeBag()
    private let addMarkerUseCase: AddMarkerUseCase
    private let locationManager: LocationManager
    
    init(addMarkerUseCase: AddMarkerUseCase, locationManager: LocationManager) {
        self.addMarkerUseCase = addMarkerUseCase
        self.locationManager = locationManager
        
        state = StateRelay<MapState>()
        locationManager.delegate = self
    }
    
    // MARK: MainIntent
    
    func bind<V: MapViewUpdatable>(to view: V) {
        state.bind(to: view)
            .disposed(by: disposeBag)
    }
    
    // MARK: Inputs
    
    func viewDidLoad() {
        locationManager.startUpdatingLocation()
        
        let backGroundQueue = ConcurrentDispatchQueueScheduler(queue: .global())
        locationManager.getAddress(location: state.value.location)
            .subscribe(on: backGroundQueue)
            .withUnretained(self)
            .map { (owner, address) in
                return MapState(prevState: owner.state.value, userLocationMoveFlag: true)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, newState in
                owner.state.accept(newState)
            })
            .disposed(by: disposeBag)
        
        addMarkerUseCase.fetchMarkerData()
            .subscribe(on: backGroundQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onSuccess: { owner, datas in
                let newState = MapState(prevState: owner.state.value, subwayInfos: datas)
                owner.state.accept(newState)
            }, onFailure: { owner, error in
                [error, nil].forEach {
                    let newState = MapState(prevState: owner.state.value, error: $0)
                    owner.state.accept(newState)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func userLocationButtonTapped() {
        [true, false].forEach { flag in
            let newState = MapState(prevState: state.value, userLocationMoveFlag: flag)
            state.accept(newState)
        }
    }
    
    func cameraMove(latitide: Double, longitude: Double) {
        locationManager.getAddress(location: CLLocation(latitude: latitide, longitude: longitude))
            .subscribe(with: self, onNext: { owner, address in
                let newState = MapState(prevState: owner.state.value, cameraLocationAddress: address)
                owner.state.accept(newState)
            })
            .disposed(by: disposeBag)
    }
}

extension DefaultMapIntent: LocationAccessable {
    func requestLocationAuthorization() {
        [true, false].forEach { flag in
            let newState = MapState(prevState: state.value, authRequestFlag: flag)
            state.accept(newState)
        }
    }
    
    func updateLocation(latitude: Double, longitude: Double) {
        let newState = MapState(prevState: state.value, location: CLLocation(latitude: latitude, longitude: longitude))
        state.accept(newState)
    }
}

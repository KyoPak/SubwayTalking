//
//  MainViewController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/5/24.
//

import UIKit

import NMapsMap
import RxCocoa
import RxSwift

class StartViewController: UIViewController {
    
    let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveView), for: .touchUpInside)
        return button
    }()
    
    @objc func moveView() {
        let mainIntent = DefaultMainIntent(
            addMarkerUseCase: DefaultAddMarkerUseCase(markerDataRepository: DefaultMarkerDataRepository()),
            locationManager: LocationManager()
        )
        
        let mainVC = MainViewController(intent: mainIntent)
        present(mainVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

protocol MainViewUpdatable: View where AssociatedState == MainState { }

final class MainViewController: UIViewController, MainViewUpdatable {
    
    // MARK: Property
    
    private var intent: MainIntent?
    private let disposeBag = DisposeBag()
    
    // MARK: UI Property
    
    private let naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.mapType = .basic
        mapView.minZoomLevel = 5
        return mapView
    }()
    
    private lazy var locationOverlay: NMFLocationOverlay = {
        let locationOverlay = self.naverMapView.locationOverlay
        locationOverlay.hidden = false

        return locationOverlay
    }()
    
    // MARK: Initialize & LifeCycle
    
    init(intent: MainIntent) {
        super.init(nibName: nil, bundle: nil)
        
        self.intent = intent
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureLayout()
    }
    
    // MARK: MainViewUpdatable
    
    func update(with state: MainState?, prev: MainState?) {
        guard let state = state, let prev = prev else { return }
        
        if state.subwayInfos != prev.subwayInfos {
            state.subwayInfos.forEach { info in
                configureMarker(info.latitude, info.longitude)
            }
        }
        
        if state.location != prev.location {
            configureUserOverlay(location: state.location)
        }
    }
}

// MARK: Bind Intent
extension MainViewController {
    private func bind() {
        bindView()
        bindIntent()
    }
    
    private func bindView() {
        intent?.bind(to: self)
    }
    
    private func bindIntent() {
        rx.methodInvoked(#selector(viewDidLoad))
            .bind { [weak self] _ in
                self?.intent?.viewDidLoad()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Configure Map Components
extension MainViewController {
    private func configureMarker(_ latitude: Double, _ longitude: Double) {
        let marker = NMFMarker()
        let subwayMarkerImage = Constant.Image.subwayMarker
        
        marker.iconTintColor = UIColor.blue
        marker.iconImage = NMFOverlayImage(image: subwayMarkerImage)
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.mapView = naverMapView
    }
    
    private func configureUserOverlay(location: CLLocation) {
        locationOverlay.location = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        locationOverlay.circleRadius = 50
    }
}

// MARK: UI Configure
extension MainViewController {
    private func configureHierachy() {
        view.addSubview(naverMapView)
    }
    
    private func configureLayout() {
        naverMapView.frame = view.frame
    }
}

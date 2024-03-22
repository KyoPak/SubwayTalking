//
//  MapViewController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/5/24.
//

import UIKit

import NMapsMap
import RxCocoa
import RxSwift
import SnapKit

class StartViewController: UIViewController {
    
    let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveView), for: .touchUpInside)
        return button
    }()
    
    @objc func moveView() {
        let controllers = TabBarItem.allCases.map { $0.viewController }
        
        let tabbarController = TabBarController()
        tabbarController.setViewControllers(controllers, animated: true)
        
        tabbarController.modalPresentationStyle = .fullScreen
        present(tabbarController, animated: true)
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

protocol MapViewUpdatable: View where AssociatedState == MapState { }

final class MapViewController: UIViewController, MapViewUpdatable {
    
    // MARK: Property
    
    private var intent: MapIntent?
    private let disposeBag = DisposeBag()
    private let cameraMovingEvent = PublishRelay<(latitude: Double, longitude: Double)>()
    
    // MARK: UI Property
    
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.mapType = .basic
        mapView.addCameraDelegate(delegate: self)
        mapView.minZoomLevel = 5
        return mapView
    }()
    
    private lazy var locationOverlay: NMFLocationOverlay = {
        let locationOverlay = self.naverMapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.circleColor = Constant.Color.overlay
        locationOverlay.circleRadius = Constant.Value.distance / naverMapView.projection.metersPerPixel()
        return locationOverlay
    }()
    
    private let userLocationButton: UIButton = {
        let button = UIButton()
        button.layer.shadowColor = UIColor.black.cgColor
        button.setImage(Constant.Image.userLocationButton, for: .normal)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .pretendard(size: 20, wight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let addressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.addressMarker
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    // MARK: Initialize & LifeCycle
    
    init(intent: MapIntent) {
        super.init(nibName: nil, bundle: nil)
        
        self.intent = intent
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIComponents()
        configureHierachy()
        configureLayout()
    }
    
    // MARK: MainViewUpdatable
    
    func update(with state: MapState?, prev: MapState?) {
        guard let state = state, let prev = prev else { return }
        
        if state.subwayInfos != prev.subwayInfos {
            state.subwayInfos.forEach { info in
                configureMarker(info.latitude, info.longitude)
            }
        }
        
        if state.location != prev.location {
            configureUserOverlay(location: state.location)
        }
        
        if state.authRequestFlag {
            requestLocationAuthorization()
        }
        
        if state.userLocationMoveFlag {
            moveCameraToCurrentLocation(location: state.location)
        }
        
        if state.cameraLocationAddress != prev.cameraLocationAddress {
            addressLabel.text = state.cameraLocationAddress
        }
         
        if state.error != nil {
            showAlert(title: Constant.Text.alertErrorTitle, message: state.error?.localizedDescription ?? "")
        }
    }
}

// MARK: Bind Intent
extension MapViewController {
    private func bind() {
        bindView()
        bindIntent()
    }
    
    private func bindView() {
        intent?.bind(to: self)
    }
    
    private func bindIntent() {
        rx.methodInvoked(#selector(viewDidLoad))
            .bind(with: self, onNext: { owner, _ in
                owner.intent?.viewDidLoad()
            })
            .disposed(by: disposeBag)
        
        userLocationButton.rx.tap
            .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.intent?.userLocationButtonTapped()
            })
            .disposed(by: disposeBag)
        
        cameraMovingEvent
            .bind(with: self) { owner, location in
                owner.intent?.cameraMove(latitide: location.latitude, longitude: location.longitude)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Configure Map Components
extension MapViewController {
    private func configureMarker(_ latitude: Double, _ longitude: Double) {
        let marker = NMFMarker()
        let subwayMarkerImage = Constant.Image.subwayMarker
        marker.iconImage = NMFOverlayImage(image: subwayMarkerImage)
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.mapView = naverMapView
    }
    
    private func configureUserOverlay(location: CLLocation) {
        locationOverlay.location = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
    }
    
    func moveCameraToCurrentLocation(location: CLLocation) {
        let currentNMGLatLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        naverMapView.moveCamera(NMFCameraUpdate(zoomTo: 14))
        naverMapView.moveCamera(NMFCameraUpdate(scrollTo: currentNMGLatLng))
        locationOverlay.circleRadius = Constant.Value.distance / naverMapView.projection.metersPerPixel()
    }
}

// MARK: - NaverMap Camera Delegate
extension MapViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        cameraMovingEvent.accept((mapView.latitude, mapView.longitude))
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        locationOverlay.circleRadius = Constant.Value.distance / naverMapView.projection.metersPerPixel()
    }
}

extension MapViewController: Alertable {
    func requestLocationAuthorization() {
        showLocationAuthorizationAlert()
    }
}

// MARK: UI Configure
extension MapViewController {
    private func configureUIComponents() {
        [addressImageView, addressLabel].forEach(addressStackView.addArrangedSubview(_:))
    }
    
    private func configureHierachy() {
        [naverMapView, addressStackView, userLocationButton].forEach(view.addSubview(_:))
    }
    
    private func configureLayout() {
        naverMapView.frame = view.frame
        
        addressStackView.snp.makeConstraints { component in
            component.centerX.equalToSuperview()
            component.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        userLocationButton.snp.makeConstraints { component in
            component.bottom.equalToSuperview().offset(-150)
            component.trailing.equalToSuperview().offset(-20)
        }
    }
}

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
    
    func update(with state: MainState) {
        print(state.subwayInfos.count)
    }
    
    // MARK: Bind
    
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

// MARK: UI Configure
extension MainViewController {
    private func configureHierachy() {
        view.addSubview(naverMapView)
    }
    
    private func configureLayout() {
        naverMapView.frame = view.frame
    }
}

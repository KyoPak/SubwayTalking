//
//  MainViewController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/5/24.
//

import UIKit

import NMapsMap

final class MainViewController: UIViewController {

    // MARK: UI
    
    private let naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.mapType = .basic
        mapView.minZoomLevel = 5
        return mapView
    }()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureLayout()
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

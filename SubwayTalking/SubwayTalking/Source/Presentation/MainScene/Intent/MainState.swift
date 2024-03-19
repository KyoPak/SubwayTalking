//
//  MainState.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import CoreLocation

struct MainState: State {
    static let initialState = MainState(subwayInfos: [], location: CLLocation(), cameraLocationAddress: "")
    
    let subwayInfos: [SubwayInformation]
    let authRequestFlag: Bool
    let location: CLLocation
    let userLocationMoveFlag: Bool
    let cameraLocationAddress: String
    let error: Error?
    
    init(
        prevState: MainState? = nil,
        subwayInfos: [SubwayInformation] = [],
        authRequestFlag: Bool? = false,
        location: CLLocation? = nil,
        userLocationMoveFlag: Bool? = false,
        cameraLocationAddress: String? = nil,
        error: Error? = nil
    ) {
        self.subwayInfos = subwayInfos.isEmpty ? (prevState?.subwayInfos ?? []) : subwayInfos
        self.authRequestFlag = authRequestFlag ?? prevState?.authRequestFlag ?? false
        self.location = location ?? prevState?.location ?? CLLocation()
        self.userLocationMoveFlag = userLocationMoveFlag ?? prevState?.userLocationMoveFlag ?? false
        self.cameraLocationAddress = cameraLocationAddress ?? prevState?.cameraLocationAddress ?? ""
        self.error = error
    }
}

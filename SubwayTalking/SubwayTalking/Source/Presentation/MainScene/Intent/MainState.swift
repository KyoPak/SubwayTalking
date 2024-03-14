//
//  MainState.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import CoreLocation

struct MainState: State {
    static let initialState = MainState(subwayInfos: [], location: CLLocation())
    
    let subwayInfos: [SubwayInformation]
    let authRequestFlag: Bool
    let location: CLLocation
    let userLocationMoveFlag: Bool
    
    init(
        prevState: MainState? = nil,
        subwayInfos: [SubwayInformation] = [],
        authRequestFlag: Bool? = false,
        location: CLLocation? = nil,
        userLocationMoveFlag: Bool? = false
    ) {
        self.subwayInfos = subwayInfos.isEmpty ? (prevState?.subwayInfos ?? []) : subwayInfos
        self.authRequestFlag = authRequestFlag ?? prevState?.authRequestFlag ?? false
        self.location = location ?? prevState?.location ?? CLLocation()
        self.userLocationMoveFlag = userLocationMoveFlag ?? prevState?.userLocationMoveFlag ?? false
    }
}

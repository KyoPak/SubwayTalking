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
    let location: CLLocation
    
    init(
        prevState: MainState? = nil,
        subwayInfos: [SubwayInformation] = [],
        location: CLLocation? = nil
    ) {
        self.subwayInfos = subwayInfos.isEmpty ? (prevState?.subwayInfos ?? []) : subwayInfos
        self.location = location ?? prevState?.location ?? CLLocation()
    }
}

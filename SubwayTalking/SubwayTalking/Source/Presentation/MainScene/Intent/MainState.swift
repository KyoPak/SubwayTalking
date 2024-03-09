//
//  MainState.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import Foundation

struct MainState: State {
    static let initialState: MainState = MainState(subwayInfos: [])
    
    let subwayInfos: [SubwayInformation]
    
    init(prevState: MainState? = nil, subwayInfos: [SubwayInformation]? = nil) {
        self.subwayInfos = subwayInfos ?? (prevState?.subwayInfos ?? [])
    }
}

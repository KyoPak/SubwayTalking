//
//  SignState.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/27/24.
//

import Foundation

struct SignState: State {
    static let initialState = SignState()
    
    let userId: String
    let error: Error?
    
    init(prevState: SignState? = nil, userId: String? = nil, error: Error? = nil) {
        self.userId = userId ?? prevState?.userId ?? ""
        self.error = error
    }
}

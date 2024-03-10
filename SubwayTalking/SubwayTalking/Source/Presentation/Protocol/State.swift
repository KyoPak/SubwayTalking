//
//  State.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/9/24.
//

import Foundation

protocol State {
    static var initialState: Self { get }
}

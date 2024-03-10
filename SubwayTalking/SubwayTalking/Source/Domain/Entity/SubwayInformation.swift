//
//  SubwayInformation.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import Foundation

struct SubwayInformation {
    let number: String
    let name: String
    let latitude: Double
    let longitude: Double
}

extension SubwayInformation: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.number == rhs.number && lhs.name == rhs.name && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

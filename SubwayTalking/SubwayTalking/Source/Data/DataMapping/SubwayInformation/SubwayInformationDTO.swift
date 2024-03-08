//
//  SubwayInformationDTO.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/6/24.
//

import Foundation

struct SubwayInformationDTO: Decodable {
    let number: String
    let name: String
    let englishName: String?
    let latitude, longitude: Double?
    
    private enum CodingKeys: String, CodingKey {
        case number, name, englishName, latitude, longitude
    }
}

extension SubwayInformationDTO {
    func toEntity() -> SubwayInformation {
        return .init(number: number, name: name, latitude: latitude, longitude: longitude)
    }
}

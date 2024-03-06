//
//  SubwayInformationDTO.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/6/24.
//

import Foundation

struct SubwayInformationDTO: Decodable {
    let subwayNumber: String
    let name: String
    let englishName: String
    let latitude, longitude: Double
    let phoneNumber: String
    
    private enum CodingKeys: String, CodingKey {
        case subwayNumber, name, latitude, longitude, phoneNumber
        case englishName = "engName"
    }
}

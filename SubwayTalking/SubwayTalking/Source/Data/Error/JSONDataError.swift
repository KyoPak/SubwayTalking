//
//  JSONDataError.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import Foundation

enum JSONDataError: Error {
    case dataSetError
    case decodingError
}

extension JSONDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataSetError:
            return Constant.Error.dataSetError
        case .decodingError:
            return Constant.Error.decodingError
        }
    }
}

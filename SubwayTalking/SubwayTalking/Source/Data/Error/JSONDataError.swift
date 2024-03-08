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
            return "데이터 파일이 올바르지 않습니다."
        case .decodingError:
            return "데이터를 불러오는 과정에서 오류가 발생하였습니다."
        }
    }
}

//
//  SignUpStep.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/28/24.
//

import Foundation

enum SignUpStep {
    case agreement
    case nickName
    case useExplain
    case back
    case confirm
    
    var titile: String {
        switch self {
        case .agreement:
            return "만나서 반가워요!\n우선 가입약관을 꼭 확인해주세요."
        case .nickName:
            return "신규 사용자님만의\n멋진 닉네임을 설정해주세요."
        case .useExplain:
            return "마지막으로,\n서비스 이용방법에 대해서 설명드릴게요."
        default:
            return ""
        }
    }
    
    var next: Self {
        switch self {
        case .agreement:                return .nickName
        case .nickName:                 return .useExplain
        case .useExplain, .confirm:     return .confirm
        case .back:                     return .agreement
        }
    }

    var previous: Self {
        switch self {
        case .agreement:                return .back
        case .nickName:                 return .agreement
        case .useExplain, .confirm:     return .nickName
        case .back:                     return .agreement
        }
    }
}

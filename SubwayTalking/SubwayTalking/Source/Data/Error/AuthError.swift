//
//  AuthError.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/23/24.
//

import Foundation

enum AuthError: Error {
    case credentialMissing
    case tokenMissing
    case unknown
}

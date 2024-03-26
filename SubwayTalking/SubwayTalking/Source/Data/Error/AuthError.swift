//
//  AuthError.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/23/24.
//

import Foundation

// MARK: Apple Error
enum AppleAuthError: Error {
    case credentialMissing
    case tokenMissing
    case unknown
}

extension AppleAuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .credentialMissing:
            return Constant.Error.credentialMissing
        case .tokenMissing:
            return Constant.Error.appleTokenMissing
        case .unknown:
            return Constant.Error.retry
        }
    }
}

// MARK: Firebase Error
enum FirebaseAuthError: Error {
    case logInError
    case createUserFail
    case nonceMissing
    case userIDMissing
    case authResultMissing
}

extension FirebaseAuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .logInError:
            return Constant.Error.firebaseLogInFail
        case .createUserFail:
            return Constant.Error.firebaseCreateFail
        case .nonceMissing:
            return Constant.Error.retry
        case .userIDMissing:
            return Constant.Error.firebaseUserMissing
        case .authResultMissing:
            return Constant.Error.retry
        }
    }
}

// MARK: Kakao Error
enum KakaoAuthError: Error {
    case logInError
    case userInfoMissing
}

extension KakaoAuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .logInError:
            return Constant.Error.kakaoLogInFail
        case .userInfoMissing:
            return Constant.Error.kakaoUserMissing
        }
    }
}

// MARK: Extension Constant Error Description Text
private extension Constant.Error {
    
    static let retry = "다시 시도해주세요."
    
    // MARK: AppleAuthError
    
    static let credentialMissing = "계정 자격 획득에 실패하였습니다."
    static let appleTokenMissing = "애플 로그인에 실패하였습니다."
    
    // MARK: FirebaseAuthError
    
    static let firebaseLogInFail = "로그인에 실패하였습니다."
    static let firebaseCreateFail = "계정 생성에 실패하였습니다."
    static let firebaseUserMissing = "유저 정보가 존재하지 않습니다."
    
    // MARK: KakaoAuthError
    
    static let kakaoLogInFail = "로그인에 실패하였습니다."
    static let kakaoUserMissing = "카카오 유저 정보가 존재하지 않습니다."   
}

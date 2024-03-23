//
//  AuthController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/23/24.
//

import Foundation
import AuthenticationServices

import RxSwift

protocol AuthController {
    var authResult: PublishSubject<Result<String, Error>> { get }
    func requestAppleAuth(presentDelegate: ASAuthorizationControllerPresentationContextProviding)
}

final class DefaultAuthController: NSObject, AuthController {
    
    typealias AuthPresentDelegate = ASAuthorizationControllerPresentationContextProviding
    
    var authResult =  PublishSubject<Result<String, Error>>()
    
    func requestAppleAuth(presentDelegate: AuthPresentDelegate) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = presentDelegate
        authorizationController.performRequests()
    }
}

extension DefaultAuthController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            authResult.onNext(.failure(AuthError.credentialMissing))
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let token = String(data: identityTokenData, encoding: .utf8) else {
            authResult.onNext(.failure(AuthError.tokenMissing))
            return
        }
        
        authResult.onNext(.success(token))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authResult.onNext(.failure(AuthError.unknown))
    }
}

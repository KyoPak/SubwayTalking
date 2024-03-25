//
//  UserAuthController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/23/24.
//

import Foundation
import AuthenticationServices

import CryptoKit
import FirebaseAuth
import RxSwift

protocol UserAuthController {
    var authResult: PublishSubject<Result<String, Error>> { get }
    func requestAppleAuth(presentDelegate: ASAuthorizationControllerPresentationContextProviding)
}

final class DefaultUserAuthController: NSObject, UserAuthController {
    
    typealias AuthPresentDelegate = ASAuthorizationControllerPresentationContextProviding
    
    var authResult =  PublishSubject<Result<String, Error>>()
    private var currentNonce: String?
    
    func requestAppleAuth(presentDelegate: AuthPresentDelegate) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = presentDelegate
        authorizationController.performRequests()
    }
}

// MARK: Apple LogIn with FirebaseAuth
extension DefaultUserAuthController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            authResult.onNext(.failure(AuthError.credentialMissing))
            return
        }
        
        guard let nonce = currentNonce else {
            authResult.onNext(.failure(FirebaseAuthError.nonceMissing))
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let token = String(data: identityTokenData, encoding: .utf8) else {
            authResult.onNext(.failure(AuthError.tokenMissing))
            return
        }
        
        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: token,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        Auth.auth().signIn(with: firebaseCredential) { [weak self] (authData, error) in
            if let error = error {
                self?.authResult.onNext(.failure(FirebaseAuthError.authResultMissing))
                return
            }
            
            guard let uid = authData?.user.uid else {
                self?.authResult.onNext(.failure(FirebaseAuthError.userIDMissing))
                return
            }
            
            self?.authResult.onNext(.success(uid))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authResult.onNext(.failure(AuthError.unknown))
    }
}

// MARK: FirebaseAuth Generate Crypto Nonce
extension DefaultUserAuthController {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

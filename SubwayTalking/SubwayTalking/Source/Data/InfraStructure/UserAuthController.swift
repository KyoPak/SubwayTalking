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
import KakaoSDKAuth
import KakaoSDKUser
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
    
    func requestKakaoAuth() {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { [weak self] accessTokenInfo, error in
                if error != nil {
                    self?.kakaoOpen()
                } else {
                    self?.directHandleKakaoToken()
                }
            }
        } else {
            kakaoOpen()
        }
    }
}

// MARK: Kakao LogIn with FirebaseAuth
extension DefaultUserAuthController {
    private func directHandleKakaoToken() {
        UserApi.shared.me { [weak self] user, error in
            if error != nil {
                self?.authResult.onNext(.failure(KakaoAuthError.userInfoMissing))
            } else {
                guard let email = user?.kakaoAccount?.email else { return }
                let password = "\(String(describing: user?.id))"
                
                self?.signInFirebase(email: email, password: password)
            }
        }
    }
    
    private func kakaoOpen() {
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginInApp()
        } else {
            kakaoLoginInWeb()
        }
    }
    
    private func kakaoLoginInApp() {
        UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
            if error != nil {
                self?.authResult.onNext(.failure(KakaoAuthError.logInError))
            } else {
                if let token = oauthToken {
                    self?.createInFirebase()
                }
            }
        }
    }
    
    private func kakaoLoginInWeb() {
        UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
            if error != nil {
                self?.authResult.onNext(.failure(KakaoAuthError.logInError))
            } else {
                if let token = oauthToken {
                    self?.createInFirebase()
                }
            }
        }
    }
    
    private func createInFirebase() {
        UserApi.shared.me { [weak self] user, error in
            if error != nil {
                self?.authResult.onNext(.failure(KakaoAuthError.userInfoMissing))
            } else {
                guard let email = user?.kakaoAccount?.email else { return }
                let password = "\(String(describing: user?.id))"
                
                Auth.auth().createUser(withEmail: email, password: password) { result, _ in
                    self?.signInFirebase(email: email, password: password)
                }
            }
        }
    }
    
    private func signInFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                self?.authResult.onNext(.failure(FirebaseAuthError.logInError))
            } else if let authData = authResult?.user {
                let uid = authData.uid
                self?.authResult.onNext(.success(uid))
            }
        }
    }
}

// MARK: Apple LogIn with FirebaseAuth
extension DefaultUserAuthController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            authResult.onNext(.failure(AppleAuthError.credentialMissing))
            return
        }
        
        guard let nonce = currentNonce else {
            authResult.onNext(.failure(FirebaseAuthError.nonceMissing))
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let token = String(data: identityTokenData, encoding: .utf8) else {
            authResult.onNext(.failure(AppleAuthError.tokenMissing))
            return
        }
        
        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: token,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        Auth.auth().signIn(with: firebaseCredential) { [weak self] (authData, error) in
            if error != nil {
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
        authResult.onNext(.failure(AppleAuthError.unknown))
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

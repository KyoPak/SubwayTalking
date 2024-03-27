//
//  SignUseCase.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/27/24.
//

import RxSwift

protocol SignUseCase {
    var authResult: PublishSubject<Result<String, Error>> { get }
    func signAuth(type: AuthProvider, presentDelegate: AppleSignViewPresentable?)
}

final class DefaultSignUseCase: SignUseCase {
    private let authController: UserAuthController
    var authResult: PublishSubject<Result<String, Error>> {
        return authController.authResult
    }
    
    init(authController: UserAuthController) {
        self.authController = authController
    }
    
    func signAuth(type: AuthProvider, presentDelegate: AppleSignViewPresentable?) {
        switch type {
        case .apple:
            guard let delegate = presentDelegate else { return }
            authController.requestAppleAuth(presentDelegate: delegate)
            
        case .kakao:
            authController.requestKakaoAuth()
        }
    }
}

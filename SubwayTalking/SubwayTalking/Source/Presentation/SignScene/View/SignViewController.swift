//
//  SignViewController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/21/24.
//

import UIKit
import AuthenticationServices

import SnapKit
import RxCocoa
import RxSwift

protocol AppleSignViewPresentable: ASAuthorizationControllerPresentationContextProviding { }
protocol SignViewUpdatable: View where AssociatedState == SignState { }

final class SignViewController: UIViewController, SignViewUpdatable {
    
    // MARK: Property
    
    private var intent: SignIntent?
    private let disposeBag = DisposeBag()
    
    // MARK: UI Property
    
    private let logoImageView = UIImageView()
    private let commentLabel = UILabel()
    
    private let kakaoSignButton: UIButton = {
        var configuration = UIButton.Configuration.basicStyle(
            backgroundColor: Constant.Color.kakaoYellow,
            foregroundColor: .black
        )
        configuration.applyFont(
            title: Constant.Text.kakaoSign,
            font: .pretendard(size: 15, wight: .semiBold)
        )
        configuration.imagePadding = 10
        configuration.cornerStyle = .medium
        configuration.image = Constant.Image.kakaoLogo
        
        return UIButton(configuration: configuration)
    }()
    
    private let appleSignButton: UIButton = {
        var configuration = UIButton.Configuration.basicStyle(
            backgroundColor: .black,
            foregroundColor: .white
        )
        configuration.applyFont(
            title: Constant.Text.appleSign,
            font: .pretendard(size: 15, wight: .semiBold)
        )
        configuration.imagePadding = 10
        configuration.cornerStyle = .medium
        configuration.image = Constant.Image.appleLogo
        
        return UIButton(configuration: configuration)
    }()
    
    private let buttonStackView = UIStackView()
    
    // MARK: Initialize & LifeCycle
    
    init(intent: SignIntent) {
        super.init(nibName: nil, bundle: nil)
        
        self.intent = intent
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIComponents()
        configureHierachy()
        configureLayout()
    }
    
    // MARK: SignViewUpdatable
    
    func update(with state: SignState?, prev: SignState?) {
        guard let state = state, let prev = prev else { return }
        
        debugPrint(state.userId)
        debugPrint(state.error)
    }
}

// MARK: Bind Intent
extension SignViewController {
    private func bind() {
        bindView()
        bindIntent()
    }
    
    private func bindView() {
        intent?.bind(to: self)
    }
    
    private func bindIntent() {
        rx.methodInvoked(#selector(viewDidLoad))
            .bind(with: self, onNext: { owner, _ in
                owner.intent?.viewDidLoad()
            })
            .disposed(by: disposeBag)
        
        appleSignButton.rx.tap
            .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.intent?.appleSignInButtonTapped(delegate: owner)
            }
            .disposed(by: disposeBag)
        
        kakaoSignButton.rx.tap
            .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.intent?.kakaoSignInButtonTapped()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Apple Log-In Present
extension SignViewController: AppleSignViewPresentable {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.view.window else { return UIWindow() }
        return window
    }
}

// MARK: UI Configure
extension SignViewController {
    private func configureUIComponents() {
        view.backgroundColor = .white
        
        logoImageView.image = Constant.Image.signLogo
        logoImageView.contentMode = .scaleAspectFit
        
        commentLabel.numberOfLines = 0
        commentLabel.textColor = Constant.Color.subTalkBlue
        commentLabel.textAlignment = .left
        
        commentLabel.text = Constant.Text.loginComment
        commentLabel.font = .pretendard(size: 25, wight: .bold)
        
        commentLabel.setMutableText(
            part: Constant.Text.emphasizeComment,
            font: .pretendard(size: 20, wight: .regular), color: .black,
            line: 8
        )
        
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 10
    }
    
    private func configureHierachy() {
        [kakaoSignButton, appleSignButton].forEach(buttonStackView.addArrangedSubview(_:))
        [logoImageView, commentLabel, commentLabel, buttonStackView].forEach(view.addSubview(_:))
    }
    
    private func configureLayout() {
        logoImageView.snp.makeConstraints { component in
            component.height.width.equalTo(view.bounds.width/2.5)
            component.centerX.equalToSuperview()
            component.centerY.equalToSuperview().offset(-150)
        }
        
        commentLabel.snp.makeConstraints { component in
            component.leading.trailing.equalToSuperview().inset(40)
            component.bottom.equalTo(buttonStackView.snp.top).offset(-20)
        }
        
        buttonStackView.snp.makeConstraints { component in
            component.centerX.equalToSuperview()
            component.leading.trailing.equalToSuperview().inset(30)
            component.bottom.equalToSuperview().offset(-120)
        }
        
        [appleSignButton, kakaoSignButton].forEach { button in
            button.snp.makeConstraints { $0.height.equalTo(50) }
        }
    }
}

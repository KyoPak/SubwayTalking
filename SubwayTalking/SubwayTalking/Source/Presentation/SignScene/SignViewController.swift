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

final class SignViewController: UIViewController {
    
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
        configuration.cornerStyle = .capsule
        configuration.image = Constant.Image.kakaoLogo
        
        return UIButton(configuration: configuration)
    }()
    
    private let naverSignButton: UIButton = {
        var configuration = UIButton.Configuration.basicStyle(
            backgroundColor: Constant.Color.naverGreen,
            foregroundColor: .white
        )
        configuration.applyFont(
            title: Constant.Text.naverSign,
            font: .pretendard(size: 15, wight: .semiBold)
        )
        configuration.cornerStyle = .capsule
        configuration.image = Constant.Image.naverLogo
        
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
        configuration.cornerStyle = .capsule
        
        configuration.image = Constant.Image.appleLogo
        
        return UIButton(configuration: configuration)
    }()
    
    private let buttonStackView = UIStackView()
    
    // MARK: Initialize & LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
}

// MARK: Apple Log-In Present
extension SignViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
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
        commentLabel.textColor = .black
        commentLabel.textAlignment = .left
        commentLabel.text = Constant.Text.loginComment
        commentLabel.font = .pretendard(size: 20, wight: .medium)
        commentLabel.setMutableFontColor(
            part: Constant.Text.emphasizeComment,
            font: .pretendard(size: 20, wight: .bold),
            color: Constant.Color.subTalkBlue
        )
        
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 10
    }
    
    private func configureHierachy() {
        [kakaoSignButton, naverSignButton, appleSignButton].forEach(buttonStackView.addArrangedSubview(_:))
        [logoImageView, commentLabel, commentLabel, buttonStackView].forEach(view.addSubview(_:))
    }
    
    private func configureLayout() {
        logoImageView.snp.makeConstraints { component in
            component.height.width.equalTo(170)
            component.centerX.equalToSuperview()
            component.top.equalToSuperview().offset(150)
        }
        
        commentLabel.snp.makeConstraints { component in
            component.leading.equalToSuperview().offset(50)
            component.top.equalTo(logoImageView.snp.bottom).offset(100)
        }
        
        buttonStackView.snp.makeConstraints { component in
            component.centerX.equalToSuperview()
            component.top.equalTo(commentLabel.snp.bottom).offset(30)
            component.leading.trailing.equalToSuperview().inset(40)
        }
    }
}

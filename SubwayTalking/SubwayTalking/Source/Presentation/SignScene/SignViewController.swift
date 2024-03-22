//
//  SignViewController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/21/24.
//

import UIKit

import SnapKit

final class SignViewController: UIViewController {
    
    // MARK: UI Property
    
    private let logoImageView = UIImageView()
    private let logoLabel = UILabel()
    private let logoStackView = UIStackView()
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
            foregroundColor: .black
        )
        configuration.applyFont(
            title: Constant.Text.naverSign,
            font: .pretendard(size: 15, wight: .semiBold)
        )
        configuration.imagePadding = 10
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

// MARK: UI Configure
extension SignViewController {
    private func configureUIComponents() {
        view.backgroundColor = .white
        
        logoImageView.image = Constant.Image.logo
        logoImageView.contentMode = .scaleAspectFit
        
        logoLabel.text = Constant.Text.appName
        logoLabel.textColor = Constant.Color.subTalkBlue
        logoLabel.font = .pretendard(size: 25, wight: .bold)
        
        logoStackView.spacing = 10
        logoStackView.alignment = .fill
        logoStackView.axis = .horizontal
        logoStackView.distribution = .fill
        
        commentLabel.numberOfLines = 2
        commentLabel.textColor = .black
        commentLabel.textAlignment = .center
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
        buttonStackView.spacing = 15
    }
    
    private func configureHierachy() {
        [logoImageView, logoLabel].forEach(logoStackView.addArrangedSubview(_:))
        [kakaoSignButton, naverSignButton, appleSignButton].forEach(buttonStackView.addArrangedSubview(_:))
        [logoStackView, commentLabel, commentLabel, buttonStackView].forEach(view.addSubview(_:))
    }
    
    private func configureLayout() {
        logoImageView.snp.makeConstraints { component in
            component.height.width.equalTo(50)
        }
        
        logoStackView.snp.makeConstraints { component in
            component.centerX.equalToSuperview()
            component.top.equalToSuperview().offset(170)
        }
        
        commentLabel.snp.makeConstraints { component in
            component.centerX.equalToSuperview()
            component.top.equalTo(logoStackView.snp.bottom).offset(30)
        }
        
        buttonStackView.snp.makeConstraints { component in
            component.centerX.equalToSuperview()
            component.leading.trailing.equalToSuperview().inset(20)
            component.top.equalTo(commentLabel.snp.bottom).offset(30)
        }
    }
}

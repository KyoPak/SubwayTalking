//
//  SignUpViewController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/28/24.
//

import UIKit

import SnapKit

final class SignUpViewController: UIViewController {

    // MARK: Property
    
    // MARK: UI Property
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let stepView = StepView()
    
    private let backButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .black
        configuration.applyFont(title: "뒤로", font: .pretendard(size: 16, wight: .medium))
        
        return UIButton(configuration: configuration)
    }()
    
    private let confirmButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .lightGray
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = .zero
        configuration.applyFont(title: "다음", font: .pretendard(size: 20, wight: .semiBold))

        return UIButton(configuration: configuration)
    }()
    
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
extension SignUpViewController {
    private func configureUIComponents() {
        view.backgroundColor = .white
    }
    
    private func configureHierachy() {
        [stepView, pageViewController.view, backButton, confirmButton].forEach(view.addSubview(_:))
    }
    
    private func configureLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().inset(10)
        }
        
        stepView.snp.makeConstraints { component in
            component.top.equalTo(backButton.snp.bottom).offset(10)
            component.leading.trailing.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints { component in
            component.top.equalTo(stepView.snp.bottom).offset(10)
            component.leading.trailing.equalToSuperview().inset(10)
        }
        
        confirmButton.snp.makeConstraints { component in
            component.leading.trailing.bottom.equalToSuperview()
            component.height.equalTo(60)
        }
    }
}

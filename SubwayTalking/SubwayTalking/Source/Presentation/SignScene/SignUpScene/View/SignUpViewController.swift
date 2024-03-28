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
    private let stepView = UIView()
    private let confirmButton = UIButton()
    
    // MARK: Initialize & LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UI Configure
extension SignUpViewController {
    private func configureUIComponents() {
        view.backgroundColor = .white
    }
    
    private func configureHierachy() {
        [stepView, pageViewController.view, confirmButton].forEach(view.addSubview(_:))
    }
    
    private func configureLayout() {
        stepView.snp.makeConstraints { component in
            component.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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

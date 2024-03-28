//
//  StepView.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/28/24.
//

import UIKit

import SnapKit

final class StepView: UIView {
    
    // MARK: UI Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .pretendard(size: 25, wight: .semiBold)
        label.textColor = .black
        
        return label
    }()
    
    private let stepStackView: UIStackView = {
        let childViews = (0...2).map { _ in
            let view: UIView = {
                let view = UIView()
                view.layer.cornerRadius = 10
                view.backgroundColor = .lightGray
                return view
            }()
            return view
        }
        
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        childViews.forEach(stackView.addArrangedSubview)
        return stackView
    }()
    
    // MARK: Initialize

    init() {
        super.init(frame: .zero)
        
        configureUIComponents()
        configureHierachy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Configure
extension StepView {
    func configureUI(step: SignUpStep) {
        stepStackView.arrangedSubviews.enumerated().forEach { index, view in
            let backgroundColor = (index <= step.rawValue) ? Constant.Color.subTalkBlue : .lightGray
            
            UIView.animate(withDuration: 0.25) {
                view.backgroundColor = backgroundColor
            }
        }
        
        titleLabel.text = step.title
    }
    
    private func configureUIComponents() {
        backgroundColor = .white
    }
    
    private func configureHierachy() {
        [titleLabel, stepStackView].forEach(addSubview(_:))
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { component in
            component.top.equalToSuperview()
            component.leading.trailing.equalToSuperview().inset(10)
        }
        
        stepStackView.snp.makeConstraints { component in
            component.top.equalTo(titleLabel.snp.bottom).offset(-10)
            component.height.equalTo(20)
            component.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

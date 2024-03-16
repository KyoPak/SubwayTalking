//
//  TabBarItemView.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/15/24.
//

import UIKit

import SnapKit

final class TabBarItemView: UIView {
    
    // MARK: Property
    
    private let item: TabBarItem
    var index: Int
    
    var isSelected = false {
        didSet {
            animateItems()
        }
    }
    
    // MARK: UI Property
    
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    private let containerView = UIView()
    
    // MARK: Initializer
    
    init(item: TabBarItem) {
        self.item = item
        index = item.rawValue
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Animation
extension TabBarItemView {
    func animateClick(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            } completion: { _ in completion() }
        }
    }
    
    private func animateItems() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.titleLabel.isHidden = isSelected
        }
        
        UIView.transition(
            with: iconImageView,
            duration: 0.3,
            options: .transitionCrossDissolve
        ) { [weak self] in
            guard let self = self else { return }
            self.iconImageView.image = self.isSelected ? self.item.selectedIcon : self.item.defaultIcon
        }
    }
}

// MARK: UI Configure
extension TabBarItemView {
    private func configureUIComponents() { 
        titleLabel.text = item.name
        titleLabel.textColor = .label.withAlphaComponent(0.4)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: Constant.Font.lineFontBold, size: 11)
        
        iconImageView.image = isSelected ? item.selectedIcon : item.defaultIcon
    }
    
    private func configureHierachy() {
        [iconImageView, titleLabel].forEach(containerView.addSubview(_:))
        addSubview(containerView)
    }
    
    private func configureLayout() { 
        iconImageView.snp.makeConstraints { component in
            component.top.leading.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { component in
            component.leading.equalTo(iconImageView).offset(10)
            component.centerY.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { component in
            component.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

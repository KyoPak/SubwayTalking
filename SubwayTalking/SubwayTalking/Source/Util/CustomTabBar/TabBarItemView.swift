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
    private let containerView = UIStackView()
    
    // MARK: Initializer
    
    init(item: TabBarItem) {
        self.item = item
        index = item.rawValue
        
        super.init(frame: .zero)
        configureUIComponents()
        configureHierachy()
        configureBasicLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Animation
extension TabBarItemView {
    private func animateItems() {
        titleLabel.isHidden = !isSelected
        iconImageView.image = isSelected ? item.selectedIcon : item.defaultIcon
        containerView.backgroundColor = isSelected ? Constant.Color.overlay : .white
        
        if isSelected { configureSelectLayout() }
        if !isSelected { configureBasicLayout() }
    }
}

// MARK: UI Configure
extension TabBarItemView {
    private func configureUIComponents() {
        titleLabel.text = item.name
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: Constant.Font.pretendardSemibold, size: 17)
        
        iconImageView.tintColor = .black
        iconImageView.contentMode = .right
        iconImageView.image = isSelected ? item.selectedIcon : item.defaultIcon
        
        containerView.layer.cornerRadius = 10
        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.distribution = .fillProportionally
    }
    
    private func configureHierachy() {
        addSubview(containerView)
        [iconImageView, titleLabel].forEach(containerView.addArrangedSubview(_:))
    }
    
    private func configureBasicLayout() {
        iconImageView.contentMode = .scaleAspectFit
        containerView.alignment = .fill
        
        containerView.snp.updateConstraints { component in
            component.top.leading.trailing.bottom.equalToSuperview().inset(25)
        }
    }
    
    private func configureSelectLayout() {
        iconImageView.contentMode = .right
        containerView.alignment = .center
        
        containerView.snp.updateConstraints { component in
            component.leading.trailing.equalToSuperview().inset(5)
            component.top.bottom.equalToSuperview().inset(10)
        }
    }
}

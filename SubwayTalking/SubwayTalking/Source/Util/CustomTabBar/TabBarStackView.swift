//
//  TabBarStackView.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/15/24.
//

import UIKit

final class TabBarStackView: UIStackView {
    
    // MARK: Property
    
    // MARK: UI Property
    
    private let mapItem = TabBarItemView(item: .map)
    private let chatItem = TabBarItemView(item: .chat)
    private let settingItem = TabBarItemView(item: .setting)
    private lazy var customItemViews: [TabBarItemView] = [chatItem, mapItem, settingItem]
        
    init() {
        super.init(frame: .zero)
        
        configureHierachy()
        configureUIComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Configure
extension TabBarStackView {
    private func configureUIComponents() {
        backgroundColor = .label
        distribution = .fillEqually
        alignment = .center
        layer.cornerRadius = 20
    }

    private func configureHierachy() {
        [chatItem, mapItem, settingItem].forEach(addArrangedSubview(_:))
    }
}

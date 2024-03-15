//
//  TabBarItemView.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/15/24.
//

import UIKit

final class TabBarItemView: UIView {
    
    // MARK: Property
    
    private let item: TabBarItem
    
    // MARK: UI Property
    
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    private let containerView = UIView()
    
    // MARK: Initializer
    
    init(item: TabBarItem) {
        self.item = item
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Configure
extension TabBarItemView {
    private func configureUIComponents() { }
    
    private func configureHierachy() { }
    
    private func configureLayout() { }
}

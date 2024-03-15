//
//  TabBarItem.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/15/24.
//

import UIKit

enum TabBarItem: String, CaseIterable {
    case chat
    case map
    case setting
}
 
extension TabBarItem {
    var name: String {
        switch self {
        case .chat:
            return Constant.Text.chat
        case .map:
            return Constant.Text.map
        case .setting:
            return Constant.Text.setting
        }
    }
    
    var defaultIcon: UIImage {
        switch self {
        case .chat:
            return Constant.Image.chat.withTintColor(.label.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .map:
            return Constant.Image.map.withTintColor(.label.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .setting:
            return Constant.Image.setting.withTintColor(.label.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .chat:
            return Constant.Image.chatSelected.withTintColor(.label, renderingMode: .alwaysOriginal)
        case .map:
            return Constant.Image.mapSelected.withTintColor(.label, renderingMode: .alwaysOriginal)
        case .setting:
            return Constant.Image.settingSelected.withTintColor(.label, renderingMode: .alwaysOriginal)
        }
    }
}

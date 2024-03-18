//
//  TabBarItem.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/15/24.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
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
            return Constant.Image.chat.withTintColor(.black.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .map:
            return Constant.Image.map.withTintColor(.black.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .setting:
            return Constant.Image.setting.withTintColor(.black.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .chat:
            return Constant.Image.chatSelected.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .map:
            return Constant.Image.mapSelected.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .setting:
            return Constant.Image.settingSelected.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
    
    var viewController: UIViewController {
        let mainIntent = DefaultMainIntent(
            addMarkerUseCase: DefaultAddMarkerUseCase(markerDataRepository: DefaultMarkerDataRepository()),
            locationManager: LocationManager()
        )
        let mainVC = MainViewController(intent: mainIntent)
           switch self {
           case .chat:
               return mainVC
           case .map:
               return mainVC
           case .setting:
               return mainVC
           }
       }
}

//
//  UIButton+Configuration.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/22/24.
//

import UIKit

extension UIButton.Configuration {
    mutating func applyFont(title: String, font: UIFont?) {
        var titleAttribute = AttributedString(title)
        titleAttribute.font = font
        attributedTitle = titleAttribute
    }
    
    static func basicStyle(backgroundColor: UIColor, foregroundColor: UIColor) -> Self {
        var configuration = Self.filled()
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = foregroundColor
        return configuration
    }
}

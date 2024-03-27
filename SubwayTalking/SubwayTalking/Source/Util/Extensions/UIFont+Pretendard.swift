//
//  UIFont+Pretendard.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/22/24.
//

import UIKit.UIFont

extension UIFont {
    static func pretendard(size: CGFloat, wight: PretendardFontWeight) -> UIFont {
        let defaultFont = UIFont.systemFont(ofSize: size, weight: .regular)
        return UIFont(name: "Pretendard-\(wight.rawValue)", size: size) ?? defaultFont
    }
}

enum PretendardFontWeight: String {
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case semiBold = "SemiBold"
    case bold = "Bold"
}

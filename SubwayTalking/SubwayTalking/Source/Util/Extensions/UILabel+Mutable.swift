//
//  UILabel+Mutable.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/22/24.
//

import UIKit

extension UILabel {
    func setMutableFontColor(part: String, font: UIFont?, color: UIColor?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: part)
        attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        attributedText = attributedString
    }
}

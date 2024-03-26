//
//  UILabel+Mutable.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/22/24.
//

import UIKit

extension UILabel {
    func setMutableText(part: String, font: UIFont?, color: UIColor?, line: Int?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(integerLiteral: line ?? .zero)
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: (fullText as NSString).range(of: fullText)
        )

        let range = (fullText as NSString).range(of: part)
        attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        attributedText = attributedString
    }
}

//
//  MyColor.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/20/24.
//

import UIKit

enum MyColor: Int64 {
    case first = 1
    case second = 2
    case third = 3
    
    var colors: UIColor {
        switch self {
        case .first :
            return firstColor
        case .second:
            return secondColor
        case .third:
            return thirdColor
        }
    }
}

extension UIColor {
    // HEX 코드를 UIColor 객체로 변환
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt32 = 0
        Scanner(string: hexSanitized).scanHexInt32(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    // 명도 조절 함수
    func adjustedBrightness(_ factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self
        }
    }
}

// 주어진 HEX 코드로 UIColor 객체 생성
let originalColor = UIColor(hex: "#FA7268")

// 명도를 조절한 색상 생성
let thirdColor = originalColor.adjustedBrightness(1.5) // 150% 밝게
let secondColor = originalColor // 100% (원본 색상)
let firstColor = originalColor.adjustedBrightness(0.5) // 50% 어둡게

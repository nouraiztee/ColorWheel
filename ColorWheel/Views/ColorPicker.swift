//
//  ColorPicker.swift
//  ColorWheel
//
//  Created by Nouraiz Taimour on 13/08/2024.
//

import Foundation
import UIKit


//Manages the color wheel
class ColorPicker: UIView {

    private let colorWheelView = ColorWheelView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(colorWheelView)
        colorWheelView.frame = bounds
        colorWheelView.backgroundColor = .clear
    }

    private func getColor(at point: CGPoint) -> UIColor {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        let distance = hypot(dx, dy)
        let radius = min(bounds.width, bounds.height) / 2

        // Ensure the point is within the color wheel's radius
        guard distance <= radius else {
            return UIColor.clear
        }

        var angle = atan2(dy, dx)
        if angle < 0 {
            angle += 2 * .pi
        }
        let hue = angle / (2 * .pi)
        let saturation = distance / radius

        return UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
    }
}

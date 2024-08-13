//
//  ColorPicker.swift
//  ColorWheel
//
//  Created by Nouraiz Taimour on 13/08/2024.
//

import Foundation
import UIKit

protocol ColorPickerDelegate: AnyObject {
    func colorPicked(_ color: UIColor)
}

// Manages the color wheel and draggable picker
class ColorPicker: UIView {

    weak var delegate: ColorPickerDelegate?
    private let colorWheelView = ColorWheelView()
    private let pickerView = UIView()
    private let pickerRadius: CGFloat = 17.5 // Half of 35pt

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

        // Set up pickerView
        pickerView.frame = CGRect(x: 0, y: 0, width: pickerRadius * 2, height: pickerRadius * 2)
        pickerView.layer.cornerRadius = pickerRadius
        pickerView.layer.borderWidth = 2.0
        pickerView.layer.borderColor = UIColor.white.cgColor // White border color
        pickerView.backgroundColor = .clear // Default background color

        // Set up drop shadow
        pickerView.layer.shadowColor = UIColor.black.cgColor
        pickerView.layer.shadowOpacity = 0.5 // 50% opacity
        pickerView.layer.shadowOffset = CGSize(width: 0, height: 4) // 4pt offset to the bottom
        pickerView.layer.shadowRadius = 23 // 23pt shadow radius
        
        addSubview(pickerView)

        // Start picker in the center
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        pickerView.center = center
    }

    private func getColor(at point: CGPoint) -> UIColor {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        let distance = hypot(dx, dy)
        let radius = min(bounds.width, bounds.height) / 2

        // make sure the point is within the color wheel's radius
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

    private func updatePickerPosition(at point: CGPoint) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        let distance = hypot(dx, dy)
        let radius = min(bounds.width, bounds.height) / 2

        // make sure the picker stays within the boundry of the color wheel
        let limitedDistance = min(distance, radius)

        let angle = atan2(dy, dx)
        let pickerX = center.x + cos(angle) * limitedDistance
        let pickerY = center.y + sin(angle) * limitedDistance
        pickerView.center = CGPoint(x: pickerX, y: pickerY)

        let color = getColor(at: pickerView.center)
        pickerView.backgroundColor = color // Set the picker view's background to the selected color
        delegate?.colorPicked(color)
    }
    
    func setColor(_ color: UIColor) {
           let hue = color.hsba.hue
        _ = color.hsba.brightness
           
           // Update picker position
           let radius = min(bounds.width, bounds.height) / 2
           let angle = hue * 2 * .pi
           let distance = radius * color.hsba.saturation
           
           let pickerX = bounds.width / 2 + cos(angle) * distance
           let pickerY = bounds.height / 2 + sin(angle) * distance
           pickerView.center = CGPoint(x: pickerX, y: pickerY)
           
           // Update color of pickerView
           pickerView.backgroundColor = color
       }

    private func isPointInsideWheel(_ point: CGPoint) -> Bool {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let distance = hypot(point.x - center.x, point.y - center.y)
        let radius = min(bounds.width, bounds.height) / 2
        return distance <= radius
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isPointInsideWheel(touch.location(in: self)) else { return }
        updatePickerPosition(at: touch.location(in: self))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isPointInsideWheel(touch.location(in: self)) else { return }
        updatePickerPosition(at: touch.location(in: self))
    }
}

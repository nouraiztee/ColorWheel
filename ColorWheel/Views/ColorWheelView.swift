//
//  ColorWheelView.swift
//  ColorWheel
//
//  Created by Nouraiz Taimour on 13/08/2024.
//

import Foundation
import UIKit


// MARK: - Drawable Protocol
protocol Drawable {
    func draw(in context: CGContext, rect: CGRect)
}

//Handles the drawing of the color wheel
class ColorWheelView: UIView, Drawable {
    
    private var brightness: CGFloat = 1.0
    
    func draw(in context: CGContext, rect: CGRect) {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        for angle in stride(from: 0.0, to: 360.0, by: 1.0) {
            let startAngle = CGFloat(angle) * .pi / 180
            let endAngle = startAngle + .pi / 180
            context.saveGState()
            
            context.move(to: center)
            let color = UIColor(hue: CGFloat(angle) / 360.0, saturation: 1.0, brightness: brightness, alpha: 1.0).cgColor
            context.setFillColor(color)
            
            context.beginPath()
            context.move(to: center)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.closePath()
            context.fillPath()
            
            context.restoreGState()
        }
        
        let gradient = CGGradient(colorsSpace: nil, colors: [UIColor.white.cgColor, UIColor.clear.cgColor] as CFArray, locations: [0.0, 1.0])!
        context.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: .drawsAfterEndLocation)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        draw(in: context, rect: rect)
    }
    
    // TODO: Implement Brightness Slider.
    func setBrightness(_ brightness: CGFloat) {
        self.brightness = brightness
        setNeedsDisplay()
    }
}

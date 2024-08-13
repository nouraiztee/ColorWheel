//
//  UIColor+HSBA.swift
//  ColorWheel
//
//  Created by Nouraiz Taimour on 13/08/2024.
//

import UIKit

//to access hue, saturation, brightness, and alpha of color properties without having to repeatedly call getHue
extension UIColor {
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue, saturation, brightness, alpha)
    }
}

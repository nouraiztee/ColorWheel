//
//  ViewController.swift
//  ColorWheel
//
//  Created by Nouraiz Taimour on 13/08/2024.
//

import UIKit

class ColorWheelViewController: UIViewController {

    private var colorPicker = ColorPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .black
        
        let leadingSpace = 24
        let trailingSpace = leadingSpace
        let width = view.bounds.width - CGFloat(leadingSpace + trailingSpace) //picker width excluding leading and trailing
        let height = width
        
        colorPicker = ColorPicker(frame: CGRect(x: 0, y: 0, width: width, height: height))
        colorPicker.center = view.center
        
        view.addSubview(colorPicker)
    }


}


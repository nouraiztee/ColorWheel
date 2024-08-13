//
//  ViewController.swift
//  ColorWheel
//
//  Created by Nouraiz Taimour on 13/08/2024.
//

import UIKit

class ColorWheelViewController: UIViewController {

    private var colorPicker = ColorPicker()
    private let colorSegmentedControlView = ColorSegmentedControlView()
    private var selectedSegmentIndex = 0 // to keep track of the selected segment index
    
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
        colorPicker.delegate = self
        view.addSubview(colorPicker)
        
        // Setup Color Segmented Control
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let bottomSpaceWithControlHeight = bottomPadding + 60
        colorSegmentedControlView.frame = CGRect(x: CGFloat(leadingSpace), y: view.frame.maxY - bottomSpaceWithControlHeight, width: width, height: 60)
                colorSegmentedControlView.delegate = self
                view.addSubview(colorSegmentedControlView)
    }
}

// MARK: - ColorSegmentedControlDelegate
extension ColorWheelViewController: ColorSegmentedControlDelegate {
    func colorSegmentChanged(to color: UIColor, at index: Int) {
        selectedSegmentIndex = index
        if color != .clear {
            // If the segment already has a color, update the color wheel to show this color
            colorPicker.delegate?.colorPicked(color)
            
            // Update color wheel to show this color
            colorPicker.setColor(color)
        }
    }
}

// MARK: - ColorPickerDelegate
extension ColorWheelViewController: ColorPickerDelegate {
    func colorPicked(_ color: UIColor) {
        selectedSegmentIndex = colorSegmentedControlView.selectedSegmentIndex()
        colorSegmentedControlView.updateColor(color, at: selectedSegmentIndex)
    }
}

